From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 3/3] ext4 online defrag (ver 0.7)
Date: Thu, 06 Mar 2008 09:01:21 +0900
Message-ID: <200803060001.AA00325@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a-fujita@rs.jp.nec.com
To: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55110 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbYCFACT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 19:02:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Change the error handling for ext4_iget() and some fixes.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
--
 ext4-online-defrag-defrag-command_ref.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
--- ext4-online-defrag-defrag-command.c	2008-03-04 17:28:26.000000000 +0900
+++ ext4-online-defrag-defrag-command_ref.c	2008-03-05 15:27:36.000000000 +0900
@@ -37,7 +37,7 @@
 #define EXT4_IOC_EXTENTS_INFO	_IOW('f', 13, struct ext4_extents_info)
 #define EXT4_IOC_RESERVE_BLOCK	_IOW('f', 14, struct ext4_extents_info)
 #define EXT4_IOC_MOVE_VICTIM	_IOW('f', 15, struct ext4_extents_info)
-#define EXT4_IOC_BLOCK_RELEASE	_IO('f', 16)
+#define EXT4_IOC_BLOCK_RELEASE	_IO('f', 8)
 
 #define DEFRAG_MAX_ENT	32
 
@@ -431,7 +431,8 @@ ftw_fn(const char *file, const struct st
 
 	if (flag == FTW_F) {
 		amount_cnt++;
-		if ((fd = open64(file, O_RDONLY)) < 0) {
+		fd = open64(file, O_RDWR);
+		if (fd < 0) {
 			if (detail_flag) {
 				perror(NGMSG_FILE_OPEN);
 				PRINT_FILE_NAME(file);
@@ -1382,7 +1383,7 @@ int get_used_extent(int fd, extent_t **e
 			       DEFRAG_MAX_ENT);
 			ret = ioctl(fd, EXT4_IOC_EXTENTS_INFO, &extents_info);
 			if (ret < 0) {
-				if (errno == ENOENT) {
+				if (errno == ENOENT || errno == ESTALE) {
 					continue;
 				} else {
 					/* Without ENOENT case*/
@@ -1416,9 +1417,8 @@ int get_used_extent(int fd, extent_t **e
 	}
 
 	if (ret < 0) {
-		if (errno == ENOENT) {
+		if (errno == ENOENT || errno == ESTALE)
 			return RETURN_OK;
-		}
 	}
 	return ret;
 }
