Return-Path: <SRS0=m/y1=PL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35732 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfACLi0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jan 2019 06:38:26 -0500
Date: Thu, 3 Jan 2019 14:38:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ext4: Fix some error pointer dereferences
Message-ID: <20190103113811.GA13543@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can't pass error pointers to brelse().

Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ext4/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7fddd519adae..6ddbbe21fdd8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -829,6 +829,7 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 		bh = ext4_sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl, REQ_PRIO);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 
@@ -2903,6 +2904,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 			if (error == -EIO)
 				EXT4_ERROR_INODE(inode, "block %llu read error",
 						 EXT4_I(inode)->i_file_acl);
+			bh = NULL;
 			goto cleanup;
 		}
 		error = ext4_xattr_check_block(inode, bh);
@@ -3059,6 +3061,7 @@ ext4_xattr_block_cache_find(struct inode *inode,
 		if (IS_ERR(bh)) {
 			if (PTR_ERR(bh) == -ENOMEM)
 				return NULL;
+			bh = NULL;
 			EXT4_ERROR_INODE(inode, "block %lu read error",
 					 (unsigned long)ce->e_value);
 		} else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {
-- 
2.17.1
