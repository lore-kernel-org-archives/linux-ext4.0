From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: fix fs->blocksize dereference after fs has been freed
Date: Wed,  8 Oct 2014 12:11:01 -0400
Message-ID: <1412784661-24793-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42775 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbaJHQLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Oct 2014 12:11:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 77255cf36944b introduced a use after free bug.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 resize/main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index c107028..983d8c2 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -181,6 +181,7 @@ int main (int argc, char ** argv)
 	ext2fs_struct_stat st_buf;
 	__s64		new_file_size;
 	unsigned int	sys_page_size = 4096;
+	unsigned int	blocksize;
 	long		sysval;
 	int		len, mount_flags;
 	char		*mtpt;
@@ -366,7 +367,8 @@ int main (int argc, char ** argv)
 	 * defaults and for making sure the new filesystem doesn't
 	 * exceed the partition size.
 	 */
-	retval = ext2fs_get_device_size2(device_name, fs->blocksize,
+	blocksize = fs->blocksize;
+	retval = ext2fs_get_device_size2(device_name, blocksize,
 					 &max_size);
 	if (retval) {
 		com_err(program_name, retval, "%s",
@@ -386,8 +388,8 @@ int main (int argc, char ** argv)
 	} else {
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
-		if (sys_page_size > fs->blocksize)
-			new_size &= ~((sys_page_size / fs->blocksize)-1);
+		if (sys_page_size > blocksize)
+			new_size &= ~((sys_page_size / blocksize)-1);
 	}
 	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_INCOMPAT_64BIT)) {
@@ -423,7 +425,7 @@ int main (int argc, char ** argv)
 	 * automatically extend it in a sparse fashion by writing the
 	 * last requested block.
 	 */
-	new_file_size = ((__u64) new_size) * fs->blocksize;
+	new_file_size = ((__u64) new_size) * blocksize;
 	if ((__u64) new_file_size >
 	    (((__u64) 1) << (sizeof(st_buf.st_size)*8 - 1)) - 1)
 		fd = -1;
@@ -437,13 +439,13 @@ int main (int argc, char ** argv)
 		fprintf(stderr, _("The containing partition (or device)"
 			" is only %llu (%dk) blocks.\nYou requested a new size"
 			" of %llu blocks.\n\n"), max_size,
-			fs->blocksize / 1024, new_size);
+			blocksize / 1024, new_size);
 		exit(1);
 	}
 	if (new_size == ext2fs_blocks_count(fs->super)) {
 		fprintf(stderr, _("The filesystem is already %llu (%dk) "
 			"blocks long.  Nothing to do!\n\n"), new_size,
-			fs->blocksize / 1024);
+			blocksize / 1024);
 		exit(0);
 	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
@@ -453,7 +455,7 @@ int main (int argc, char ** argv)
 		bigalloc_check(fs, force);
 		printf(_("Resizing the filesystem on "
 			 "%s to %llu (%dk) blocks.\n"),
-		       device_name, new_size, fs->blocksize / 1024);
+		       device_name, new_size, blocksize / 1024);
 		retval = resize_fs(fs, &new_size, flags,
 				   ((flags & RESIZE_PERCENT_COMPLETE) ?
 				    resize_progress_func : 0));
@@ -470,7 +472,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	printf(_("The filesystem on %s is now %llu (%dk) blocks long.\n\n"),
-	       device_name, new_size, fs->blocksize / 1024);
+	       device_name, new_size, blocksize / 1024);
 
 	if ((st_buf.st_size > new_file_size) &&
 	    (fd > 0)) {
-- 
2.1.0

