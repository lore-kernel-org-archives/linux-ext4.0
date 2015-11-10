From: Jan Kara <jack@suse.com>
Subject: [PATCH 7/9] ext4: Provide ext4_issue_zeroout()
Date: Tue, 10 Nov 2015 20:50:57 +0100
Message-ID: <1447185059-16166-8-git-send-email-jack@suse.com>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, brian.boylston@hpe.com,
	Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbbKJTvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 14:51:17 -0500
In-Reply-To: <1447185059-16166-1-git-send-email-jack@suse.com>
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
index af06830bfc00..c8021208a7eb 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -384,14 +384,12 @@ int ext4_decrypt(struct page *page)
 				EXT4_DECRYPT, page->index, page, page);
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
 	int			ret, err = 0;
 
 #if 0
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1d09345c9793..353089c35485 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2204,7 +2204,8 @@ void ext4_restore_control_page(struct page *data_page);
 struct page *ext4_encrypt(struct inode *inode,
 			  struct page *plaintext_page);
 int ext4_decrypt(struct page *page);
-int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex);
+int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_fsblk_t pblk, ext4_lblk_t len);
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 int ext4_init_crypto(void);
@@ -2458,6 +2459,8 @@ extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+extern int ext4_issue_zeroout(struct inode *inode, ext4_lblk_t lblk,
+			      ext4_fsblk_t pblk, ext4_lblk_t len);
 
 /* indirect.c */
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f76db53eddc4..c0c7650c35ba 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3119,19 +3119,11 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
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
index 528d1a0aebff..39cdad9e2338 100644
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

