From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH 1/2] fs/ext4: adding and initalizing new members of ext4_inode_info and ext4_sb_info
Date: Wed,  2 Oct 2013 09:36:58 -0600
Message-ID: <1380728219-60784-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, aswin_proj@lists.hp.com,
	T Makphaibulchoke <tmac@hp.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adding new members, i_prev_oprhan to help decoupling the ondisk from the
in memory orphan list and i_mutex_orphan_mutex to serialize orphan list
updates on a single inode, to the ext4_inode_info structure.

Adding a new member, s_ondisk_oprhan_lock to protect the ondisk orphan list
and change s_orphan_lock from mutex to spinlock in the ext4_sb_info
structure in fs/ext4/inode.c.

Adding code to initialize newly added spinlock and mutex members in
fs/ext4/super.c.

Adding code to initialize the newly added i_orphan_mutex member of an
ext4_inode_info

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/ext4/ext4.h  | 5 ++++-
 fs/ext4/inode.c | 1 +
 fs/ext4/super.c | 4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b577e45..1b1232f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -817,6 +817,7 @@ struct ext4_inode_info {
 	struct rw_semaphore xattr_sem;
 
 	struct list_head i_orphan;	/* unlinked but open inodes */
+	struct mutex i_orphan_mutex;
 
 	/*
 	 * i_disksize keeps track of what the inode size is ON DISK, not
@@ -864,6 +865,7 @@ struct ext4_inode_info {
 	rwlock_t i_es_lock;
 	struct list_head i_es_lru;
 	unsigned int i_es_lru_nr;	/* protected by i_es_lock */
+	unsigned int i_prev_orphan;	/* protected by s_ondisk_orphan_lock */
 	unsigned long i_touch_when;	/* jiffies of last accessing */
 
 	/* ialloc */
@@ -1201,7 +1203,8 @@ struct ext4_sb_info {
 	/* Journaling */
 	struct journal_s *s_journal;
 	struct list_head s_orphan;
-	struct mutex s_orphan_lock;
+	spinlock_t s_orphan_lock;
+	struct mutex s_ondisk_orphan_lock;
 	unsigned long s_resize_flags;		/* Flags indicating if there
 						   is a resizer */
 	unsigned long s_commit_interval;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dd32a2e..3edb108 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4061,6 +4061,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	for (block = 0; block < EXT4_N_BLOCKS; block++)
 		ei->i_data[block] = raw_inode->i_block[block];
 	INIT_LIST_HEAD(&ei->i_orphan);
+	mutex_init(&ei->i_orphan_mutex);
 
 	/*
 	 * Set transaction id's of transactions that have to be committed
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 36b141e..2fecd19 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -920,6 +920,7 @@ static void init_once(void *foo)
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
 	INIT_LIST_HEAD(&ei->i_orphan);
+	mutex_init(&ei->i_orphan_mutex);
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
@@ -3841,7 +3842,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-	mutex_init(&sbi->s_orphan_lock);
+	spin_lock_init(&sbi->s_orphan_lock);
+	mutex_init(&sbi->s_ondisk_orphan_lock);
 
 	sb->s_root = NULL;
 
-- 
1.7.11.3
