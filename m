From: Jan Kara <jack@suse.com>
Subject: [PATCH 7/9] ext4: Provide ext4_issue_zeroout()
Date: Wed,  4 Nov 2015 17:18:38 +0100
Message-ID: <1446653920-23127-8-git-send-email-jack@suse.com>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbbKDQSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 11:18:53 -0500
In-Reply-To: <1446653920-23127-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create new function ext4_issue_zeroout() to zeroout contiguous (both
logically and physically) part of inode data. We will need to issue
zeroout when extent structure is not readily available and this function
will allow us to do it without making up fake extent structures.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/crypto.c  |  6 ++----
 fs/ext4/ext4.h    |  5 ++++-
 fs/ext4/extents.c | 12 ++----------
 fs/ext4/inode.c   | 15 +++++++++++++++
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 45731558138c..6b63d1e9f05a 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -403,14 +403,12 @@ int ext4_decrypt_one(struct inode *inode, struct page *page)
 	return ret;
 }
 
-int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
+int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_fsblk_t pblk, ext4_lblk_t len)
 {
 	struct ext4_crypto_ctx	*ctx;
 	struct page		*ciphertext_page = NULL;
 	struct bio		*bio;
-	ext4_lblk_t		lblk = ex->ee_block;
-	ext4_fsblk_t		pblk = ext4_ext_pblock(ex);
-	unsigned int		len = ext4_ext_get_actual_len(ex);
 	int			err = 0;
 
 	BUG_ON(inode->i_sb->s_blocksize != PAGE_CACHE_SIZE);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 142e935d1f3d..785737a342e6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2072,7 +2072,8 @@ struct page *ext4_encrypt(struct inode *inode,
 			  struct page *plaintext_page);
 int ext4_decrypt(struct ext4_crypto_ctx *ctx, struct page *page);
 int ext4_decrypt_one(struct inode *inode, struct page *page);
-int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex);
+int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_fsblk_t pblk, ext4_lblk_t len);
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 int ext4_init_crypto(void);
@@ -2327,6 +2328,8 @@ extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+extern int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk,
+			      ext4_fsblk_t pblk, ext4_lblk_t len);
 
 /* indirect.c */
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index be5496c14f6b..e13669b09dc1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3118,19 +3118,11 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
 	ext4_fsblk_t ee_pblock;
 	unsigned int ee_len;
-	int ret;
 
 	ee_len    = ext4_ext_get_actual_len(ex);
 	ee_pblock = ext4_ext_pblock(ex);
-
-	if (ext4_encrypted_inode(inode))
-		return ext4_encrypted_zeroout(inode, ex);
-
-	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
-	if (ret > 0)
-		ret = 0;
-
-	return ret;
+	return ext4_issue_zeroout(inode, le32_to_cpu(ex->ee_block), ee_pblock,
+				  ee_len);
 }
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f220dfa6dbc3..5c92b0096f85 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -383,6 +383,21 @@ static int __check_block_validity(struct inode *inode, const char *func,
 	return 0;
 }
 
+int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk, ext4_fsblk_t pblk,
+		       ext4_lblk_t len)
+{
+	int ret;
+
+	if (ext4_encrypted_inode(inode))
+		return ext4_encrypted_zeroout(inode, lblk, pblk, len);
+
+	ret = sb_issue_zeroout(inode->i_sb, pblk, len, GFP_NOFS);
+	if (ret > 0)
+		ret = 0;
+
+	return ret;
+}
+
 #define check_block_validity(inode, map)	\
 	__check_block_validity((inode), __func__, __LINE__, (map))
 
-- 
2.1.4

