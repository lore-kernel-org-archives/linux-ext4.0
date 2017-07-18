From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] ext4: silence array overflow warning
Date: Tue, 18 Jul 2017 12:27:02 +0300
Message-ID: <20170718092702.bpk2k5qjg4cz2mqk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19111 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdGRJ1Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 05:27:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I get a static checker warning:

    fs/ext4/ext4.h:3091 ext4_set_de_type()
    error: buffer overflow 'ext4_type_by_mode' 15 <= 15

It seems unlikely that we would hit this read overflow in real life, but
it's also simple enough to make the array 16 bytes instead of 15.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9ebde0cd632e..fbaeb441bed3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3074,7 +3074,7 @@ extern int ext4_handle_dirty_dirent_node(handle_t *handle,
 					 struct inode *inode,
 					 struct buffer_head *bh);
 #define S_SHIFT 12
-static const unsigned char ext4_type_by_mode[S_IFMT >> S_SHIFT] = {
+static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
 	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
 	[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
 	[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
