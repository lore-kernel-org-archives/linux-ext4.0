From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 10/11] e4defrag: Fix the method of progress output
Date: Mon, 14 Nov 2011 15:25:30 +0900
Message-ID: <4EC0B45A.7060409@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:51597 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1KNGiT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:38:19 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id pAE6cHie024505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Nov 2011 15:38:17 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e4defrag outputs the percentage of its progress. However, e4defrag updates
not only the percentage of progress, but also a file name and so on that are
the unchanged information. So, if you redirect the output of e4defrag
to the file, the file size will be increased due to useless data.

This patch fixes the issue by updating only the percentage of the progress.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 9938c12..0b4873d 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -146,10 +146,12 @@ struct move_extent {
 };
 
 char	lost_found_dir[PATH_MAX + 1];
+char	backspaces[5];
 int	block_size;
 int	extents_before_defrag;
 int	extents_after_defrag;
 int	mode_flag;
+int	current_progress;
 unsigned int	threshold;
 unsigned int	defraged_file_count;
 unsigned int	frag_files_before_defrag;
@@ -797,20 +799,36 @@ static void free_exts_group(struct fiemap_extent_group *ext_group_head)
 }
 
 /*
- * print_progress -	Print defrag progress
+ * progress_init -	Print defrag progress for the first time
  *
  * @file:		file name.
+ * @init_percent:	initial percentage of the progress
+ */
+static void progress_init(const char *file, int init_percent)
+{
+	current_progress = init_percent;
+	printf("%s:\t%3d%%", file, init_percent);
+	fflush(stdout);
+}
+
+/*
+ * progress_update -	Update defrag progress
+ *
  * @start:		logical offset for defrag target file
  * @file_size:		defrag target filesize
  */
-static void print_progress(const char *file, loff_t start, loff_t file_size)
+static void progress_update(loff_t start, loff_t file_size)
 {
 	int percent = (start * 100) / file_size;
-	printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
-		defraged_file_count, total_count, file, min(percent, 100));
-	fflush(stdout);
 
-	return;
+	/* Need not to update the progress */
+	if (percent == current_progress)
+		return;
+
+	current_progress = percent;
+	fprintf(stdout, "%.4s", backspaces);
+	printf("%3d%%", min(percent, 100));
+	fflush(stdout);
 }
 
 /*
@@ -837,7 +855,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 	move_data.donor_fd = donor_fd;
 
 	/* Print defrag progress */
-	print_progress(file, start, buf->st_size);
+	progress_init(file, 0);
 
 	ext_list_tmp = ext_list_head;
 	do {
@@ -901,7 +919,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 		start = move_data.orig_start * buf->st_blksize;
 
 		/* Print defrag progress */
-		print_progress(file, start, buf->st_size);
+		progress_update(start, buf->st_size);
 
 		/* End of file */
 		if (start >= buf->st_size)
@@ -1124,8 +1142,7 @@ check_improvement:
 
 	if (orig_score == 0 || (donor_score > 0 && !(mode_flag & FORCE)) ||
 			(orig_score <= donor_score && (mode_flag & FORCE))) {
-		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
-			defraged_file_count, total_count, file, 100);
+		progress_init(file, 100);
 		if (mode_flag & DETAIL)
 			printf("  extents: %d -> %d",
 				file_frags_start, file_frags_start);
@@ -1220,6 +1237,8 @@ int main(int argc, char *argv[])
 		goto out;
 
 	threshold = (mode_flag & FORCE) ? ~0U : DEFAULT_THRESHOLD;
+	memset(backspaces, '\b', sizeof(backspaces)-1);
+	backspaces[sizeof(backspaces)-1] = 0;
 
 	/* Main process */
 	for (i = optind; i < argc; i++) {
