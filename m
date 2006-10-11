From: akpm@osdl.org
Subject: [patch 037/100] ext4 whitespace cleanups
Date: Wed, 11 Oct 2006 01:21:24 -0700
Message-ID: <200610110821.k9B8LOiv012052@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29061 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965187AbWJKIut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 04:50:49 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k9B8oPb5024846
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2006 01:50:48 -0700
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Someone's tab key is emitting spaces.  Attempt to repair some of the damage.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/acl.c     |    4 +--
 fs/ext4/dir.c     |    7 +++--
 fs/ext4/extents.c |   14 +++++------
 fs/ext4/namei.c   |   52 +++++++++++++++++++++-----------------------
 fs/ext4/super.c   |   14 ++++++-----
 5 files changed, 46 insertions(+), 45 deletions(-)

diff -puN fs/ext4/acl.c~ext4-whitespace-cleanups fs/ext4/acl.c
--- a/fs/ext4/acl.c~ext4-whitespace-cleanups
+++ a/fs/ext4/acl.c
@@ -141,7 +141,7 @@ ext4_iget_acl(struct inode *inode, struc
 
 static inline void
 ext4_iset_acl(struct inode *inode, struct posix_acl **i_acl,
-                  struct posix_acl *acl)
+		struct posix_acl *acl)
 {
 	spin_lock(&inode->i_lock);
 	if (*i_acl != EXT4_ACL_NOT_CACHED)
@@ -375,7 +375,7 @@ int
 ext4_acl_chmod(struct inode *inode)
 {
 	struct posix_acl *acl, *clone;
-        int error;
+	int error;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
diff -puN fs/ext4/dir.c~ext4-whitespace-cleanups fs/ext4/dir.c
--- a/fs/ext4/dir.c~ext4-whitespace-cleanups
+++ a/fs/ext4/dir.c
@@ -188,8 +188,9 @@ revalidate:
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
 			if (!ext4_check_dir_entry ("ext4_readdir", inode, de,
 						   bh, offset)) {
-				/* On error, skip the f_pos to the
-                                   next block. */
+				/*
+				 * On error, skip the f_pos to the next block
+				 */
 				filp->f_pos = (filp->f_pos |
 						(sb->s_blocksize - 1)) + 1;
 				brelse (bh);
@@ -508,7 +509,7 @@ finished:
 
 static int ext4_release_dir (struct inode * inode, struct file * filp)
 {
-       if (filp->private_data)
+	if (filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
 
 	return 0;
diff -puN fs/ext4/extents.c~ext4-whitespace-cleanups fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-whitespace-cleanups
+++ a/fs/ext4/extents.c
@@ -1014,7 +1014,7 @@ ext4_ext_next_allocated_block(struct ext
  * returns first allocated block from next leaf or EXT_MAX_BLOCK
  */
 static unsigned ext4_ext_next_leaf_block(struct inode *inode,
-                                               struct ext4_ext_path *path)
+					struct ext4_ext_path *path)
 {
 	int depth;
 
@@ -1097,8 +1097,8 @@ static int inline
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-        if (le32_to_cpu(ex1->ee_block) + le16_to_cpu(ex1->ee_len)
-	    != le32_to_cpu(ex2->ee_block))
+	if (le32_to_cpu(ex1->ee_block) + le16_to_cpu(ex1->ee_len) !=
+			le32_to_cpu(ex2->ee_block))
 		return 0;
 
 	/*
@@ -1113,7 +1113,7 @@ ext4_can_extents_be_merged(struct inode 
 		return 0;
 #endif
 
-        if (ext_pblock(ex1) + le16_to_cpu(ex1->ee_len) == ext_pblock(ex2))
+	if (ext_pblock(ex1) + le16_to_cpu(ex1->ee_len) == ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -2008,9 +2008,9 @@ int ext4_ext_get_blocks(handle_t *handle
 		goto out2;
 	}
 	/*
-         * Okay, we need to do block allocation.  Lazily initialize the block
-         * allocation info here if necessary.
-        */
+	 * Okay, we need to do block allocation.  Lazily initialize the block
+	 * allocation info here if necessary.
+	 */
 	if (S_ISREG(inode->i_mode) && (!EXT4_I(inode)->i_block_alloc_info))
 		ext4_init_block_alloc_info(inode);
 
diff -puN fs/ext4/namei.c~ext4-whitespace-cleanups fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-whitespace-cleanups
+++ a/fs/ext4/namei.c
@@ -241,13 +241,13 @@ static inline unsigned dx_node_limit (st
 #ifdef DX_DEBUG
 static void dx_show_index (char * label, struct dx_entry *entries)
 {
-        int i, n = dx_get_count (entries);
+	int i, n = dx_get_count (entries);
         printk("%s index ", label);
-        for (i = 0; i < n; i++)
-        {
-                printk("%x->%u ", i? dx_get_hash(entries + i): 0, dx_get_block(entries + i));
-        }
-        printk("\n");
+	for (i = 0; i < n; i++) {
+		printk("%x->%u ", i? dx_get_hash(entries + i) :
+				0, dx_get_block(entries + i));
+	}
+	printk("\n");
 }
 
 struct stats
@@ -688,28 +688,26 @@ static int dx_make_map (struct ext4_dir_
 
 static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 {
-        struct dx_map_entry *p, *q, *top = map + count - 1;
-        int more;
-        /* Combsort until bubble sort doesn't suck */
-        while (count > 2)
-	{
-                count = count*10/13;
-                if (count - 9 < 2) /* 9, 10 -> 11 */
-                        count = 11;
-                for (p = top, q = p - count; q >= map; p--, q--)
-                        if (p->hash < q->hash)
-                                swap(*p, *q);
-        }
-        /* Garden variety bubble sort */
-        do {
-                more = 0;
-                q = top;
-                while (q-- > map)
-		{
-                        if (q[1].hash >= q[0].hash)
+	struct dx_map_entry *p, *q, *top = map + count - 1;
+	int more;
+	/* Combsort until bubble sort doesn't suck */
+	while (count > 2) {
+		count = count*10/13;
+		if (count - 9 < 2) /* 9, 10 -> 11 */
+			count = 11;
+		for (p = top, q = p - count; q >= map; p--, q--)
+			if (p->hash < q->hash)
+				swap(*p, *q);
+	}
+	/* Garden variety bubble sort */
+	do {
+		more = 0;
+		q = top;
+		while (q-- > map) {
+			if (q[1].hash >= q[0].hash)
 				continue;
-                        swap(*(q+1), *q);
-                        more = 1;
+			swap(*(q+1), *q);
+			more = 1;
 		}
 	} while(more);
 }
diff -puN fs/ext4/super.c~ext4-whitespace-cleanups fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-whitespace-cleanups
+++ a/fs/ext4/super.c
@@ -1191,9 +1191,10 @@ static int ext4_setup_super(struct super
 			"running e2fsck is recommended\n");
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
-                   inconsistencies, to force a fsck at reboot.  But for
-                   a plain journaled filesystem we can keep it set as
-                   valid forever! :) */
+		 * inconsistencies, to force a fsck at reboot.  But for
+		 * a plain journaled filesystem we can keep it set as
+		 * valid forever! :)
+		 */
 	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT4_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
@@ -1791,8 +1792,9 @@ static int ext4_fill_super (struct super
 	switch (test_opt(sb, DATA_FLAGS)) {
 	case 0:
 		/* No mode set, assume a default based on the journal
-                   capabilities: ORDERED_DATA if the journal can
-                   cope, else JOURNAL_DATA */
+		 * capabilities: ORDERED_DATA if the journal can
+		 * cope, else JOURNAL_DATA
+		 */
 		if (jbd2_journal_check_available_features
 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE))
 			set_opt(sbi->s_mount_opt, ORDERED_DATA);
@@ -2802,7 +2804,7 @@ static int __init init_ext4_fs(void)
 	err = init_inodecache();
 	if (err)
 		goto out1;
-        err = register_filesystem(&ext4dev_fs_type);
+	err = register_filesystem(&ext4dev_fs_type);
 	if (err)
 		goto out;
 	return 0;
_
