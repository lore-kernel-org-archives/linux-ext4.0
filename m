From: Andreas Rid <andreas@rid-net.de>
Subject: [patch] e4defrag: relevant file fragmentation with base_file
Date: Sun, 29 Aug 2010 21:47:36 +0200
Message-ID: <4C7AB958.4080101@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: k-mio@sx.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:43444 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0H2Tra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Aug 2010 15:47:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi Kazuya Mio,

as I promised the implementation of the new interface
   e4defrag  -r  base_file  move_file..

Feel free to change.

 Andreas

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 6022758..b7813d7 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -125,7 +125,8 @@
 #define MSG_USAGE		\
 "Usage	: e4defrag [-v] file...| directory...| device...\n\
 	: e4defrag  -c  file...| directory...| device...\n\
-	: e4defrag  -r  directory...| device...\n"
+	: e4defrag  -r  directory...| device...\n\
+	: e4defrag  -r  base_file move_file...\n"
 
 #define NGMSG_EXT4		"Filesystem is not ext4 filesystem"
 #define NGMSG_FILE_EXTENT	"Failed to get file extents"
@@ -133,7 +134,6 @@
 #define NGMSG_FILE_OPEN		"Failed to open"
 #define NGMSG_FILE_UNREG	"File is not regular file"
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
-#define NGMSG_FILE_UNDIR	"Target is not directory"
 
 /* Data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
@@ -1593,7 +1593,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 	return 0;
 }
 
-static unsigned long long get_dir_offset(const int fd, int *ret)
+static unsigned long long get_physical_offset(const int fd, int *ret)
 {
 	struct fiemap	*fiemap_buf;
 	char *fiebuf;
@@ -2129,13 +2129,6 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
-		/* -r mode can defrag only directory. */
-		if ((mode_flag & RELEVANT) && arg_type == FILENAME) {
-			PRINT_ERR_MSG(NGMSG_FILE_UNDIR);
-			PRINT_FILE_NAME(argv[i]);
-			continue;
-		}
-
 		/* Set blocksize */
 		block_size = buf.st_blksize;
 
@@ -2223,7 +2216,7 @@ int main(int argc, char *argv[])
 					continue;
 				}
 
-				r_pstart = get_dir_offset(fd, &ret);
+				r_pstart = get_physical_offset(fd, &ret);
 				if (ret < 0) {
 					if (mode_flag & DETAIL) {
 						perror("failed to fiemap\n");
@@ -2327,8 +2320,44 @@ int main(int argc, char *argv[])
 			} else
 				printf("ext4 defragmentation for %s\n",
 								 argv[i]);
-			/* Defrag single file process */
-			file_defrag(argv[i], &buf, FTW_F, NULL);
+
+			if (mode_flag & RELEVANT && i == optind) {
+				if (i - argc == 1)
+					/* not enought arguemnts */
+					goto out;
+
+				/*
+				 * call defrag for base_file
+				 * don't move extents to r_pstart
+				 */
+				mode_flag &= ~RELEVANT;
+				file_defrag(argv[i], &buf, FTW_F, NULL);
+				mode_flag |= RELEVANT;
+
+				/* get physical start of base_file for PA */
+				int fd, ret;
+				fd = open(argv[i], O_RDONLY);
+				if (fd < 0) {
+					if (mode_flag & DETAIL) {
+						PRINT_FILE_NAME(argv[i]);
+						STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
+					}
+					goto out;
+				}
+				
+				r_pstart = get_physical_offset(fd, &ret);
+				if (ret < 0) {
+					if (mode_flag & DETAIL) {
+						perror("failed to fiemap\n");
+						PRINT_FILE_NAME(dir_name);
+					}
+					goto out;
+				}
+				close(fd);
+			} else 
+				/* Defrag single file process */
+				file_defrag(argv[i], &buf, FTW_F, NULL);
+			
 			if (succeed_cnt != 0)
 				printf(" Success:\t\t\t[1/1]\n");
 			else
