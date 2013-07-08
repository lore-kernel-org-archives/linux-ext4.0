From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH] ext4: deleted "set but not used" variables
Date: Mon, 8 Jul 2013 05:23:49 +0000
Message-ID: <CAGW2f1H1nj9YMUYZ+Fe5knzNQLNzFUk_7eZi2YrkE=J0c1R-cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f66.google.com ([209.85.160.66]:52097 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GHFXt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 01:23:49 -0400
Received: by mail-pb0-f66.google.com with SMTP id mc8so2418016pbc.1
        for <linux-ext4@vger.kernel.org>; Sun, 07 Jul 2013 22:23:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

to delete "set but not used" variables

Signed-off-by: Jon Ernst <jonernst07@gmail.com>
---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7097b0f..df0e9b2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4391,7 +4391,6 @@ void ext4_ext_truncate(handle_t *handle, struct
inode *inode)
 {
        struct super_block *sb = inode->i_sb;
        ext4_lblk_t last_block;
-       int err = 0;

        /*
         * TODO: optimization is possible here.
@@ -4405,9 +4404,9 @@ void ext4_ext_truncate(handle_t *handle, struct
inode *inode)

        last_block = (inode->i_size + sb->s_blocksize - 1)
                        >> EXT4_BLOCK_SIZE_BITS(sb);
-       err = ext4_es_remove_extent(inode, last_block,
-                                   EXT_MAX_BLOCKS - last_block);
-       err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
+       ext4_es_remove_extent(inode, last_block,
+                       EXT_MAX_BLOCKS - last_block);
+       ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
 }

 static void ext4_falloc_update_inode(struct inode *inode,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index b8a0746..35f43e9 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -994,11 +994,9 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
        struct inode    *dir = dentry->d_parent->d_inode;
        const char      *name = dentry->d_name.name;
        int             namelen = dentry->d_name.len;
-       unsigned short  reclen;
        int             err;
        struct ext4_dir_entry_2 *de;

-       reclen = EXT4_DIR_REC_LEN(namelen);
        err = ext4_find_dest_de(dir, inode, iloc->bh,
                                inline_start, inline_size,
                                name, namelen, &de);
@@ -1870,7 +1868,6 @@ int ext4_try_to_evict_inline_data(handle_t *handle,
 {
        int error;
        struct ext4_xattr_entry *entry;
-       struct ext4_xattr_ibody_header *header;
        struct ext4_inode *raw_inode;
        struct ext4_iloc iloc;

@@ -1879,7 +1876,6 @@ int ext4_try_to_evict_inline_data(handle_t *handle,
                return error;

        raw_inode = ext4_raw_inode(&iloc);
-       header = IHDR(inode, raw_inode);
        entry = (struct ext4_xattr_entry *)((void *)raw_inode +
                                            EXT4_I(inode)->i_inline_off);
        if (EXT4_XATTR_LEN(entry->e_name_len) +
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9491ac0..38b5169 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -100,7 +100,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
        handle_t *handle;
        int err;
        struct inode *inode_bl;
-       struct ext4_inode_info *ei;
        struct ext4_inode_info *ei_bl;
        struct ext4_sb_info *sbi;

@@ -115,7 +114,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
        }

        sbi = EXT4_SB(sb);
-       ei = EXT4_I(inode);

        inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
        if (IS_ERR(inode_bl)) {
