Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:59330 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbeKTT3d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Nov 2018 14:29:33 -0500
To: darrick.wong@oracle.com, Jan Kara <jack@suse.cz>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: ext4: try to improve unwritten extents merges
Cc: linux-ext4@vger.kernel.org
Message-ID: <e3074993-0810-1954-7204-38b6d0b0f1e5@linux.alibaba.com>
Date: Tue, 20 Nov 2018 17:01:25 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hello Darrick & Jan,

First sorry to bother you again, recently we meet a 
"dioread_nolock,nodelalloc" slow writeback issue, Liu Bo has sent a 
patch to fix this issue. But here I also wonder whether we can merge 
unwritten extents as far as possible.
In current codes:

int
ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
				struct ext4_extent *ex2)
{
...
	if (ext4_ext_is_unwritten(ex1) &&
	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
		return 0;
...
}
This was added by Darrick in 2014:
commit a9b8241594adda0a7a4fb3b87bf29d2dff0d997d
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Thu Feb 20 21:17:35 2014 -0500

     ext4: merge uninitialized extents

     Allow for merging uninitialized extents.

     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

So long as we have a unwritten extents under io(which also means 
i_unwritten is not zero), then we can not do merge work for unwritten 
extents, I wonder whether this conditon is too strict. Assume that the
begin of the file is under io, but middle or end of the file could not
merge unwritten extetns, though they could be.

I'm not sure whether we could directly remove 
"atomic_read(&EXT4_I(inode)->i_unwritten)",if not, here I make a simple 
patch to respect same semantics. The idea is simple, I use a red-black
tree to record unwritten extents under io, when trying to merging
unwritten extents, we search this per-inode tree, it not hit, we can
merge. I have also run "xfstests quick group test cases", look like that
it works well. dio maybe also go to this way.

So what do you think this merge issue or this rfc patch, thanks very much.


 From 0a8d18025c86cb29dffc9456274786ce33517ff1 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Mon, 19 Nov 2018 17:38:51 +0800
Subject: [PATCH] ext4: improve dioread_nolock,nodelalloc

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
  fs/ext4/ext4.h           |   3 +
  fs/ext4/extents.c        |  22 ++++++-
  fs/ext4/extents_status.c | 133 +++++++++++++++++++++++++++++++++++++++
  fs/ext4/extents_status.h |  19 ++++++
  fs/ext4/inode.c          |   1 +
  fs/ext4/super.c          |   8 +++
  6 files changed, 185 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0ab08fc..c8bd68ae2d14 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1005,7 +1005,9 @@ struct ext4_inode_info {

  	/* extents status tree */
  	struct ext4_es_tree i_es_tree;
+	struct io_unwritten_tree i_io_unwritten_tree;
  	rwlock_t i_es_lock;
+	rwlock_t i_ue_lock;
  	struct list_head i_es_list;
  	unsigned int i_es_all_nr;	/* protected by i_es_lock */
  	unsigned int i_es_shk_nr;	/* protected by i_es_lock */
@@ -3224,6 +3226,7 @@ static inline void 
ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
  	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
  		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
  		/* Wake up anyone waiting on unwritten extent conversion */
+		ext4_remove_io_unwritten_extent(inode, io_end->offset >> 
inode->i_blkbits);
  		if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
  			wake_up_all(ext4_ioend_wq(inode));
  	}
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..b13b555d0318 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1713,6 +1713,26 @@ static int ext4_ext_correct_indexes(handle_t 
*handle, struct inode *inode,
  	return err;
  }

+static inline int ext4_unwritten_extents_in_io(struct inode *inode,
+			struct ext4_extent *ex1, struct ext4_extent *ex2)
+{
+	int ret, ret1;
+
+	ret = atomic_read(&EXT4_I(inode)->i_unwritten);
+	if (ret == 0)
+		return 0;
+
+	ret = ext4_lookup_io_unwritten_extent(inode,
+			le32_to_cpu(ex1->ee_block));
+	ret1 = ext4_lookup_io_unwritten_extent(inode,
+			le32_to_cpu(ex2->ee_block));
+
+	if (ret || ret1)
+		return 1;
+
+	return 0;
+}
+
  int
  ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
  				struct ext4_extent *ex2)
@@ -1744,7 +1764,7 @@ ext4_can_extents_be_merged(struct inode *inode, 
struct ext4_extent *ex1,
  	 */
  	if (ext4_ext_is_unwritten(ex1) &&
  	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
-	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
+	    ext4_unwritten_extents_in_io(inode, ex1, ex2) ||
  	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
  		return 0;
  #ifdef AGGRESSIVE_TEST
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 2b439afafe13..62dfd4a4c02e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1870,3 +1870,136 @@ void ext4_es_remove_blks(struct inode *inode, 
ext4_lblk_t lblk,

  	ext4_da_release_space(inode, reserved);
  }
+
+
+static struct kmem_cache *ext4_io_unwritten_cachep;
+
+int ext4_lookup_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk)
+{
+	struct io_unwritten_tree *tree;
+	struct io_unwritten_extent *ue;
+	struct rb_node *node;
+	int found = 0;
+
+	tree = &EXT4_I(inode)->i_io_unwritten_tree;
+	read_lock(&EXT4_I(inode)->i_ue_lock);
+
+	node = tree->root.rb_node;
+	while (node) {
+		ue = rb_entry(node, struct io_unwritten_extent, rb_node);
+		if (lblk < ue->es_lblk)
+			node = node->rb_left;
+		else if (lblk >= ue->es_lblk + ue->es_len)
+			node = node->rb_right;
+		else {
+			found = 1;
+			break;
+		}
+	}
+	read_unlock(&EXT4_I(inode)->i_ue_lock);
+
+	return found;
+}
+
+static struct io_unwritten_extent *
+ext4_alloc_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk,
+			       ext4_lblk_t len)
+{
+	struct io_unwritten_extent *ue;
+
+	ue = kmem_cache_alloc(ext4_io_unwritten_cachep, GFP_ATOMIC);
+	if (ue == NULL)
+		return NULL;
+	ue->es_lblk = lblk;
+	ue->es_len = len;
+	return ue;
+}
+
+
+int ext4_insert_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk,
+				    ext4_lblk_t len)
+{
+	struct io_unwritten_tree *tree = &EXT4_I(inode)->i_io_unwritten_tree;
+	struct rb_node **p = &tree->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct io_unwritten_extent *ue;
+
+	write_lock(&EXT4_I(inode)->i_ue_lock);
+	while (*p) {
+		parent = *p;
+		ue = rb_entry(parent, struct io_unwritten_extent, rb_node);
+
+		if (lblk < ue->es_lblk)
+			p = &(*p)->rb_left;
+		else if (lblk > ue->es_lblk) {
+			p = &(*p)->rb_right;
+		} else {
+			BUG_ON(1);
+			return -EINVAL;
+		}
+	}
+
+	ue = ext4_alloc_io_unwritten_extent(inode, lblk, len);
+	if (!ue) {
+		write_unlock(&EXT4_I(inode)->i_ue_lock);
+		return -ENOMEM;
+	}
+
+	rb_link_node(&ue->rb_node, parent, p);
+	rb_insert_color(&ue->rb_node, &tree->root);
+	write_unlock(&EXT4_I(inode)->i_ue_lock);
+
+	return 0;
+}
+
+int ext4_remove_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk)
+{
+	struct io_unwritten_tree *tree = &EXT4_I(inode)->i_io_unwritten_tree;
+	struct rb_node **p = &tree->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct io_unwritten_extent *ue;
+	int found = 0;
+
+	write_lock(&EXT4_I(inode)->i_ue_lock);
+	while (*p) {
+		parent = *p;
+		ue = rb_entry(parent, struct io_unwritten_extent, rb_node);
+
+		if (lblk < ue->es_lblk)
+			p = &(*p)->rb_left;
+		else if (lblk > ue->es_lblk) {
+			p = &(*p)->rb_right;
+		} else {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		rb_erase(&ue->rb_node, &tree->root);
+		kmem_cache_free(ext4_io_unwritten_cachep, ue);
+	}
+	write_unlock(&EXT4_I(inode)->i_ue_lock);
+	return 0;
+}
+
+void ext4_init_io_unwritten_tree(struct io_unwritten_tree *tree)
+{
+	tree->root = RB_ROOT;
+}
+
+int __init ext4_io_unwritten_extent_init(void)
+{
+	ext4_io_unwritten_cachep = kmem_cache_create("ext4_io_unwritten_status",
+					sizeof(struct io_unwritten_extent),
+					0, (SLAB_RECLAIM_ACCOUNT), NULL);
+	if (ext4_io_unwritten_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+void ext4_exit_io_unwritten_extent(void)
+{
+	kmem_cache_destroy(ext4_io_unwritten_cachep);
+}
+
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 131a8b7df265..e65878b17999 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -249,4 +249,23 @@ extern unsigned int ext4_es_delayed_clu(struct 
inode *inode, ext4_lblk_t lblk,
  extern void ext4_es_remove_blks(struct inode *inode, ext4_lblk_t lblk,
  				ext4_lblk_t len);

+struct io_unwritten_extent {
+	struct rb_node rb_node;
+	ext4_lblk_t es_lblk;    /* first logical block extent covers */
+	ext4_lblk_t es_len;     /* length of extent in block */
+};
+
+struct io_unwritten_tree {
+	struct rb_root root;
+};
+
+int ext4_lookup_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk);
+int ext4_insert_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk,
+				    ext4_lblk_t len);
+int ext4_remove_io_unwritten_extent(struct inode *inode, ext4_lblk_t lblk);
+
+void ext4_init_io_unwritten_tree(struct io_unwritten_tree *tree);
+int __init ext4_io_unwritten_extent_init(void);
+void ext4_exit_io_unwritten_extent(void);
+
  #endif /* _EXT4_EXTENTS_STATUS_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..6315b9907820 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2487,6 +2487,7 @@ static int mpage_map_one_extent(handle_t *handle, 
struct mpage_da_data *mpd)
  			handle->h_rsv_handle = NULL;
  		}
  		ext4_set_io_unwritten_flag(inode, mpd->io_submit.io_end);
+		ext4_insert_io_unwritten_extent(inode, map->m_lblk, map->m_len);
  	}

  	BUG_ON(map->m_len == 0);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 53ff6c2a26ed..ecac98925a0c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1043,7 +1043,9 @@ static struct inode *ext4_alloc_inode(struct 
super_block *sb)
  	INIT_LIST_HEAD(&ei->i_prealloc_list);
  	spin_lock_init(&ei->i_prealloc_lock);
  	ext4_es_init_tree(&ei->i_es_tree);
+	ext4_init_io_unwritten_tree(&ei->i_io_unwritten_tree);
  	rwlock_init(&ei->i_es_lock);
+	rwlock_init(&ei->i_ue_lock);
  	INIT_LIST_HEAD(&ei->i_es_list);
  	ei->i_es_all_nr = 0;
  	ei->i_es_shk_nr = 0;
@@ -5983,6 +5985,10 @@ static int __init ext4_init_fs(void)
  	if (err)
  		goto out6;

+	ext4_io_unwritten_extent_init();
+	if (err)
+		return err;
+
  	err = ext4_init_pageio();
  	if (err)
  		goto out5;
@@ -6024,6 +6030,7 @@ static int __init ext4_init_fs(void)
  	ext4_exit_pending();
  out6:
  	ext4_exit_es();
+	ext4_exit_io_unwritten_extent();

  	return err;
  }
@@ -6041,6 +6048,7 @@ static void __exit ext4_exit_fs(void)
  	ext4_exit_pageio();
  	ext4_exit_es();
  	ext4_exit_pending();
+	ext4_exit_io_unwritten_extent();
  }

  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas 
Dilger, Theodore Ts'o and others");
-- 
2.17.2



Regards,
Xiaougang Wang
