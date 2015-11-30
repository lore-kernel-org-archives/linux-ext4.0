From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4:crypto fix endianess issues
Date: Mon, 30 Nov 2015 16:02:49 +0400
Message-ID: <1448884969-15851-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:41992 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbbK3MDB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 07:03:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/crypto.c  |    2 +-
 fs/ext4/symlink.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index af06830..1a08350 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -389,7 +389,7 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 	struct ext4_crypto_ctx	*ctx;
 	struct page		*ciphertext_page = NULL;
 	struct bio		*bio;
-	ext4_lblk_t		lblk = ex->ee_block;
+	ext4_lblk_t		lblk = le32_to_cpu(ex->ee_block);
 	ext4_fsblk_t		pblk = ext4_ext_pblock(ex);
 	unsigned int		len = ext4_ext_get_actual_len(ex);
 	int			ret, err = 0;
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index abe2401..e8e7af6 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,7 +52,7 @@ static const char *ext4_encrypted_follow_link(struct dentry *dentry, void **cook
 	/* Symlink is encrypted */
 	sd = (struct ext4_encrypted_symlink_data *)caddr;
 	cstr.name = sd->encrypted_path;
-	cstr.len  = le32_to_cpu(sd->len);
+	cstr.len  = le16_to_cpu(sd->len);
 	if ((cstr.len +
 	     sizeof(struct ext4_encrypted_symlink_data) - 1) >
 	    max_size) {
-- 
1.7.1

