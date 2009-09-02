From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] e4defrag: fallocate donor file only once
Date: Wed,  2 Sep 2009 23:35:04 +0800
Message-ID: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:52334 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZIBPf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 11:35:58 -0400
Received: by ewy2 with SMTP id 2so947486ewy.17
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 08:36:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we allocate the donor file once for all, it will have a better chance
to be continuous.

Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
---
 misc/e4defrag.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c25514a..c1e9213 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1603,6 +1603,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	struct fiemap_extent_list	*donor_list_logical = NULL;
 	struct fiemap_extent_group	*orig_group_head = NULL;
 	struct fiemap_extent_group	*orig_group_tmp = NULL;
+	ext4_fsblk_t	orig_block_count;
 
 	defraged_file_count++;
 
@@ -1742,19 +1743,17 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	/* Allocate space for donor inode */
 	orig_group_tmp = orig_group_head;
 	do {
-		ret = fallocate(donor_fd, 0,
-		  (loff_t)orig_group_tmp->start->data.logical * block_size,
-		  (loff_t)orig_group_tmp->len * block_size);
-		if (ret < 0) {
-			if (mode_flag & DETAIL) {
-				PRINT_FILE_NAME(file);
-				PRINT_ERR_MSG_WITH_ERRNO("Failed to fallocate");
-			}
-			goto out;
-		}
