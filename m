From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4 crypto: handle ENOKEY correctly
Date: Fri, 29 May 2015 20:39:03 +0400
Message-ID: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:13463 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbbE2QjS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 May 2015 12:39:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we try to hide ENOKEY inside ext4_get_encryption_info(), but
it is not always correct. There are two class of callers ext4_get_encryption_info()
1) The one where we can ignore ENOKEY
    - ext4_setup_fname_crypto()
    - ext4_is_child_context_consistent_with_parent()
2) The one do care about any error because expect that ei->i_crypt_info will
   be initalized after ext4_get_encryption_info() succeed
   - ext4_file_mmap
   - ext4_file_open
   - ext4_inherit_context (key may becomes obsoleted, revoked, dead any time)

So let's return ENOKEY from ext4_get_encryption_info() if necessery and let caller
handle it correctly.

#Test case (try to read encrypted file w/o key)
keyctl clear @s
mount $DEV /mnt
cat > /mnt/enc_dir/enc_file
#Result
kernel BUG at fs/ext4/crypto.c:109
Call Trace:
 [<ffffffff81251311>] ext4_mpage_readpages+0x3ce/0x55d
 [<ffffffff810b6ee4>] ? sched_clock_cpu+0x8c/0xa8
 [<ffffffff81214f7d>] ext4_readpages+0x3c/0x3e
 [<ffffffff8115ac52>] __do_page_cache_readahead+0x164/0x1e6
 [<ffffffff8115aec3>] ondemand_readahead+0x1ef/0x204
 [<ffffffff8115b0d1>] page_cache_sync_readahead+0x40/0x42
 [<ffffffff81152d5d>] generic_file_read_iter+0x1b3/0x50d
 [<ffffffff8119070e>] __vfs_read+0xb3/0xd2
 [<ffffffff811918b8>] vfs_read+0x8f/0xcf
 [<ffffffff8119031a>] ? fdget_pos+0xd/0x18
 [<ffffffff811919e0>] SyS_read+0x5c/0x8c
 [<ffffffff817125ae>] system_call_fastpath+0x12/0x76

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/crypto_fname.c  |    2 +-
 fs/ext4/crypto_key.c    |    2 --
 fs/ext4/crypto_policy.c |    4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index e63dd29..9f450d3 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -265,7 +265,7 @@ int ext4_setup_fname_crypto(struct inode *inode)
 		return 0;
 
 	res = ext4_get_encryption_info(inode);
-	if (res < 0)
+	if (res < 0 && res != -ENOKEY)
 		return res;
 	ci = ei->i_crypt_info;
 
diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 858d7d6..db31972 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -191,8 +191,6 @@ int _ext4_get_encryption_info(struct inode *inode)
 				  crypt_info->ci_raw);
 out:
 	if (res < 0) {
-		if (res == -ENOKEY)
-			res = 0;
 		kmem_cache_free(ext4_crypt_info_cachep, crypt_info);
 	} else {
 		ei->i_crypt_info = crypt_info;
diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 683391f..db6e9f8 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -144,10 +144,10 @@ int ext4_is_child_context_consistent_with_parent(struct inode *parent,
 	if (!ext4_encrypted_inode(child))
 		return 0;
 	res = ext4_get_encryption_info(parent);
-	if (res)
+	if (res && res != -ENOKEY)
 		return 0;
 	res = ext4_get_encryption_info(child);
-	if (res)
+	if (res && res != -ENOKEY)
 		return 0;
 	parent_ci = EXT4_I(parent)->i_crypt_info;
 	child_ci = EXT4_I(child)->i_crypt_info;
-- 
1.7.1

