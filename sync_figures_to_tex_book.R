# Synchronize Bookdown-generated PDF figures with the TeX book.



# Default behavior is a dry run. The function copies every PDF produced by
# Bookdown into the TeX book's author/Figures folder when the file is new or has
# changed. Existing TeX-only figures are left untouched.

# Usage (in the console): sync_figures_to_tex(dry_run = FALSE)

sync_figures_to_tex <- function(
  dry_run = TRUE,
  source_dir = file.path(getwd(), "_main_files", "figure-latex"),
  target_dir = "/Users/jrenne/Library/CloudStorage/Dropbox/Research/Overleaf/MPRR/author/Figures",
  backup = TRUE
) {
  if (!dir.exists(source_dir)) {
    stop("Source directory does not exist: ", source_dir)
  }
  if (!dir.exists(target_dir)) {
    stop("Target directory does not exist: ", target_dir)
  }

  source_files <- list.files(source_dir, pattern = "[.]pdf$", full.names = TRUE)
  target_files <- list.files(target_dir, pattern = "[.]pdf$", full.names = TRUE)

  source_names <- basename(source_files)
  target_names <- basename(target_files)

  common <- sort(intersect(source_names, target_names))
  missing_source <- sort(setdiff(target_names, source_names))
  new_files <- sort(setdiff(source_names, target_names))

  is_changed <- vapply(common, function(file_name) {
    source_path <- file.path(source_dir, file_name)
    target_path <- file.path(target_dir, file_name)
    !identical(unname(tools::md5sum(source_path)), unname(tools::md5sum(target_path)))
  }, logical(1))

  changed_files <- common[is_changed]
  unchanged <- common[!is_changed]
  to_copy <- sort(c(changed_files, new_files))

  report <- list(
    to_copy = to_copy,
    changed_files = changed_files,
    new_files = new_files,
    unchanged = unchanged,
    missing_source = missing_source,
    source_dir = normalizePath(source_dir, winslash = "/", mustWork = TRUE),
    target_dir = normalizePath(target_dir, winslash = "/", mustWork = TRUE),
    dry_run = dry_run
  )

  cat("Figure sync report\n")
  cat("  Source: ", report$source_dir, "\n", sep = "")
  cat("  Target: ", report$target_dir, "\n", sep = "")
  cat("  Dry run: ", dry_run, "\n", sep = "")
  cat("  PDFs in source: ", length(source_names), "\n", sep = "")
  cat("  PDFs in target: ", length(target_names), "\n", sep = "")
  cat("  Matched PDFs: ", length(common), "\n", sep = "")
  cat("  Changed matched PDFs: ", length(changed_files), "\n", sep = "")
  cat("  New Bookdown PDFs to copy: ", length(new_files), "\n", sep = "")
  cat("  Total PDFs to copy: ", length(to_copy), "\n", sep = "")
  cat("  Unchanged: ", length(unchanged), "\n", sep = "")
  cat("  Target PDFs without Bookdown source: ", length(missing_source), "\n", sep = "")

  if (length(changed_files) > 0) {
    cat("\nChanged files to overwrite:\n")
    cat(paste0("  - ", changed_files), sep = "\n")
    cat("\n")
  }

  if (length(new_files) > 0) {
    cat("\nNew files to add:\n")
    cat(paste0("  - ", new_files), sep = "\n")
    cat("\n")
  }

  if (dry_run) {
    cat("\nDry run only. Re-run with dry_run = FALSE to copy new and changed figures.\n")
    return(invisible(report))
  }

  if (length(to_copy) == 0) {
    cat("\nNothing to copy.\n")
    return(invisible(report))
  }

  backup_dir <- NULL
  if (backup && length(changed_files) > 0) {
    backup_dir <- file.path(
      dirname(target_dir),
      paste0("Figures_backup_", format(Sys.time(), "%Y%m%d_%H%M%S"))
    )
    dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)
    ok_backup <- file.copy(
      from = file.path(target_dir, changed_files),
      to = file.path(backup_dir, changed_files),
      overwrite = TRUE
    )
    if (!all(ok_backup)) {
      stop("Backup failed for: ", paste(changed_files[!ok_backup], collapse = ", "))
    }
    report$backup_dir <- normalizePath(backup_dir, winslash = "/", mustWork = TRUE)
    cat("\nBackup written to: ", report$backup_dir, "\n", sep = "")
  }

  ok_copy <- file.copy(
    from = file.path(source_dir, to_copy),
    to = file.path(target_dir, to_copy),
    overwrite = TRUE
  )
  if (!all(ok_copy)) {
    stop("Copy failed for: ", paste(to_copy[!ok_copy], collapse = ", "))
  }

  cat("\nCopied ", length(to_copy), " figure(s).\n", sep = "")
  invisible(report)
}
