Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47230 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAEMf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:12:35 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 7/7] ext4: lost brelse in ext4_expand_extra_isize_ea()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <c5dc2118-ac42-c899-f218-4a78aa39c37f@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:13:09 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes de05ca852679 ("ext4: move call to ext4_error() into ...") # 4.17

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c9bc0d85cc0..0b9688683526 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2698,7 +2698,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			       struct ext4_inode *raw_inode, handle_t *handle)
 {
 	struct ext4_xattr_ibody_header *header;
-	struct buffer_head *bh;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	static unsigned int mnt_count;
 	size_t min_offs;
@@ -2739,13 +2738,17 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	 * EA block can hold new_extra_isize bytes.
 	 */
 	if (EXT4_I(inode)->i_file_acl) {
+		struct buffer_head *bh;
+
 		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 		error = -EIO;
 		if (!bh)
 			goto cleanup;
 		error = ext4_xattr_check_block(inode, bh);
-		if (error)
+		if (error) {
+			brelse(bh);
 			goto cleanup;
+		}
 		base = BHDR(bh);
 		end = bh->b_data + bh->b_size;
 		min_offs = end - base;
-- 
2.17.1
