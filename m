From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 06/11 RESEND] e4defrag: Allow user who has read+write access
 to defrag
Date: Wed, 15 Jun 2011 15:36:40 +0900
Message-ID: <4DF852F8.2020208@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64731 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1FOGmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 02:42:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Anyone who has read+write access can defrag the file for this fix.
Currently, non-root user needs owner authority to defrag the file. But non-root
user who is not owner might have read+write access.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.8.in |    3 +--
 misc/e4defrag.c    |   25 ++++---------------------
 2 files changed, 5 insertions(+), 23 deletions(-)
diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 81adc29..1159fd6 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -43,9 +43,8 @@ is a device or a mount point,
 .B e4defrag
 doesn't defragment files in mount point of other device.
 .PP
-Non-privileged users can execute
 .B e4defrag
-to their own file.
+can be called for the file only if read and write access are allowed.
 .SH AUTHOR
 Written by Akira Fujita <a-fujita@rs.jp.nec.com> and Takashi Sato
 <t-sato@yk.jp.nec.com>.
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 417639d..f4ced9a 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -148,7 +148,6 @@ int	block_size;
 int	extents_before_defrag;
 int	extents_after_defrag;
 int	mode_flag;
-unsigned int	current_uid;
 unsigned int	defraged_file_count;
 unsigned int	frag_files_before_defrag;
 unsigned int	frag_files_after_defrag;
@@ -466,6 +465,7 @@ static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
 {
 	ext4_fsblk_t	free_blk_count;
 	struct statfs64	fsbuf;
+	uid_t		current_uid = getuid();
 
 	if (fstatfs64(fd, &fsbuf) < 0) {
 		if (mode_flag & DETAIL) {
@@ -517,13 +517,12 @@ static int file_frag_count(int fd)
  * file_check() -	Check file's attributes.
  *
  * @fd:			defrag target file's descriptor.
- * @buf:		a pointer of the struct stat64.
  * @file:		file name.
  * @extents:		file extents.
  * @blk_count:		file blocks.
  */
-static int file_check(int fd, const struct stat64 *buf, const char *file,
-		int extents, ext4_fsblk_t blk_count)
+static int file_check(int fd, const char *file, int extents,
+					ext4_fsblk_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -547,20 +546,6 @@ static int file_check(int fd, const struct stat64 *buf, const char *file,
 		return -1;
 	}
 
-	/* Access authority */
-	if (current_uid != ROOT_UID &&
-		buf->st_uid != current_uid) {
-		if (mode_flag & DETAIL) {
-			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
-				"  extents: %d -> %d\n", defraged_file_count,
-				total_count, file, extents, extents);
-			IN_FTW_PRINT_ERR_MSG(
-				"File is not current user's file"
-				" or current user is not root");
-		}
-		return -1;
-	}
-
 	/* Lock status */
 	if (fcntl(fd, F_GETLK, &lock) < 0) {
 		if (mode_flag & DETAIL) {
@@ -1040,7 +1025,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	file_frags_start = get_exts_count(orig_list);
 
 	blk_count = get_file_blocks(orig_list);
-	if (file_check(fd, buf, file, file_frags_start, blk_count) < 0)
+	if (file_check(fd, file, file_frags_start, blk_count) < 0)
 		goto out;
 
 	if (fsync(fd) < 0) {
@@ -1243,8 +1228,6 @@ int main(int argc, char *argv[])
 	if (argc == optind)
 		goto out;
 
-	current_uid = getuid();
