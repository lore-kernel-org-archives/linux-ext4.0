From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Tue, 15 Apr 2014 14:22:47 -0600
Message-ID: <534D9517.9080701@hp.com>
References: <1380728283-61038-1-git-send-email-tmac@hp.com> <1396456148-20455-1-git-send-email-tmac@hp.com> <20140402174109.GD8657@quack.suse.cz> <534C135A.9010803@hp.com> <20140414174024.GC13860@quack.suse.cz> <534D5E02.6030500@hp.com> <20140415172522.GA13276@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070805060601090001060607"
Cc: T Makphaibulchoke <tmac@hp.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, aswin@hp.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140415172522.GA13276@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070805060601090001060607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/15/2014 11:25 AM, Jan Kara wrote:
>   I have checked the source and I didn't find many places where i_mutex was
> not held. But maybe I'm wrong. That's why I wanted to see the patch where
> you are using i_mutex instead of hashed mutexes and which didn't perform
> good enough.
> 

I've attached two patches.  The first one, 0001-Orphan-patch-using-i_mutex-and-removing-s_orphan_loc.patch, is the one you requested, using i_mutex and removing the s_orphan_lock.  The second one, 0001-Adding-code-to-collect-i_mutex-usage-during-orphan.patch, with the code to collect statistics on the number of orphan operations with and without holding i_mutex, in case you are also interested, can be applied on top of the first patch.

Please note that these two patches is meant for data collection only, as the code is quite of submittal quality.

Please also let me know if you have any further comments or suggestion.  I'll hold submitting for a couple more days.


> 
> 								Honza
>

Thanks,
Mak.

 


--------------070805060601090001060607
Content-Type: text/x-patch;
 name="0001-Orphan-patch-using-i_mutex-and-removing-s_orphan_loc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Orphan-patch-using-i_mutex-and-removing-s_orphan_loc.pa";
 filename*1="tch"

>From 2f1b1a61742eb0626342e24372c9ccffcfe5eb1f Mon Sep 17 00:00:00 2001
From: T Makphaibulchoke <tmac@hp.com>
Date: Tue, 15 Apr 2014 11:46:12 -0600
Subject: [PATCH] Orphan patch using i_mutex and removing s_orphan_lock.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/ext4/ext4.h  |   4 +-
 fs/ext4/namei.c | 140 +++++++++++++++++++++++++++++++++++++-------------------
 fs/ext4/super.c |   4 +-
 3 files changed, 98 insertions(+), 50 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d3a534f..5222a6b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -77,6 +77,7 @@
 #define EXT4_ERROR_FILE(file, block, fmt, a...)				\
 	ext4_error_file((file), __func__, __LINE__, (block), (fmt), ## a)
 
+#define	EXT4_ORPHAN_OP_BITS	7
 /* data type for block offset of block group */
 typedef int ext4_grpblk_t;
 
@@ -1223,7 +1224,8 @@ struct ext4_sb_info {
 	/* Journaling */
 	struct journal_s *s_journal;
 	struct list_head s_orphan;
-	struct mutex s_orphan_lock;
+	spinlock_t s_orphan_lock;
+	struct mutex s_ondisk_orphan_lock;
 	unsigned long s_resize_flags;		/* Flags indicating if there
 						   is a resizer */
 	unsigned long s_commit_interval;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d050e04..4a1a6a0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2552,11 +2552,16 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	struct ext4_iloc iloc;
 	int err = 0, rc;
+	int lock_mutex = 0;
 
 	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
-	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
+	if (!mutex_is_locked(&inode->i_mutex)) {
+		lock_mutex = 1;
+		mutex_lock(&inode->i_mutex);
+	}
+
 	if (!list_empty(&EXT4_I(inode)->i_orphan))
 		goto out_unlock;
 
@@ -2582,9 +2587,23 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 * orphan list. If so skip on-disk list modification.
 	 */
 	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
-		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
-			goto mem_insert;
-
+		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
+			brelse(iloc.bh);
+			mutex_lock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
+			////spin_lock(&EXT4_SB(sb)->s_orphan_lock);
+			list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->
+				s_orphan);
+			mutex_unlock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
+			////spin_unlock(&EXT4_SB(sb)->s_orphan_lock);
+			jbd_debug(4, "superblock will point to %lu\n",
+				inode->i_ino);
+			jbd_debug(4, "orphan inode %lu will point to %d\n",
+				inode->i_ino, NEXT_ORPHAN(inode));
+			goto out_unlock;
+	}
+
+	mutex_lock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
+	//***spin_lock(&EXT4_SB(sb)->s_orphan_lock);
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
@@ -2592,24 +2611,28 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
-
-	/* Only add to the head of the in-memory list if all the
-	 * previous operations succeeded.  If the orphan_add is going to
-	 * fail (possibly taking the journal offline), we can't risk
-	 * leaving the inode on the orphan list: stray orphan-list
-	 * entries can cause panics at unmount time.
-	 *
-	 * This is safe: on error we're going to ignore the orphan list
-	 * anyway on the next recovery. */
-mem_insert:
-	if (!err)
+	if (!err) {
+		/* Only add to the head of the in-memory list if all the
+		 * previous operations succeeded.  If the orphan_add is going to
+		 * fail (possibly taking the journal offline), we can't risk
+		 * leaving the inode on the orphan list: stray orphan-list
+		 * entries can cause panics at unmount time.
+		 *
+		 * This is safe: on error we're going to ignore the orphan list
+		 * anyway on the next recovery. */
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
-
-	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
-	jbd_debug(4, "orphan inode %lu will point to %d\n",
+		//***spin_unlock(&EXT4_SB(sb)->s_orphan_lock);
+		jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
+		jbd_debug(4, "orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
+	}
+	//**else
+		//***spin_unlock(&EXT4_SB(sb)->s_orphan_lock);
+	mutex_unlock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
+
 out_unlock:
-	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
+	if (lock_mutex)
+		mutex_unlock(&inode->i_mutex);
 	ext4_std_error(inode->i_sb, err);
 	return err;
 }
@@ -2622,45 +2645,65 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 {
 	struct list_head *prev;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct ext4_sb_info *sbi;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	__u32 ino_next;
 	struct ext4_iloc iloc;
 	int err = 0;
+	int lock_mutex = 0;
 
-	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
-	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
+	if ((!sbi->s_journal) &&
+		!(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
-	if (list_empty(&ei->i_orphan))
-		goto out;
-
-	ino_next = NEXT_ORPHAN(inode);
-	prev = ei->i_orphan.prev;
-	sbi = EXT4_SB(inode->i_sb);
+	if (!mutex_is_locked(&inode->i_mutex)) {
+		lock_mutex = 1;
+		mutex_lock(&inode->i_mutex);
+	}
 
-	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+	if (list_empty(&ei->i_orphan)) {
+		if (lock_mutex)
+			mutex_unlock(&inode->i_mutex);
+		return 0;
+	}
 
-	list_del_init(&ei->i_orphan);
 
 	/* If we're on an error path, we may not have a valid
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (!handle)
-		goto out;
+	if (!handle) {
+		jbd_debug(4, "remove inode %lu from orphan list\n",
+			inode->i_ino);
+		mutex_lock(&sbi->s_ondisk_orphan_lock);
+		////spin_lock(&sbi->s_orphan_lock);
+		list_del_init(&ei->i_orphan);
+		mutex_unlock(&sbi->s_ondisk_orphan_lock);
+		////spin_unlock(&sbi->s_orphan_lock);
+	} else
+		err = ext4_reserve_inode_write(handle, inode, &iloc);
 
-	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (err)
-		goto out_err;
+	if (!handle || err) {
+		if (lock_mutex)
+			mutex_unlock(&inode->i_mutex);
+		goto out_set_err;
+	}
 
+	mutex_lock(&sbi->s_ondisk_orphan_lock);
+	ino_next = NEXT_ORPHAN(inode);
+	//***spin_lock(&sbi->s_orphan_lock);
+	prev = ei->i_orphan.prev;
+	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+	list_del_init(&ei->i_orphan);
+	//***spin_unlock(&sbi->s_orphan_lock);
 	if (prev == &sbi->s_orphan) {
 		jbd_debug(4, "superblock will point to %u\n", ino_next);
 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+		if (!err)
+			sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+		mutex_unlock(&sbi->s_ondisk_orphan_lock);
 		if (err)
-			goto out_brelse;
-		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+			goto brelse;
 		err = ext4_handle_dirty_super(handle, inode->i_sb);
 	} else {
 		struct ext4_iloc iloc2;
@@ -2670,25 +2713,28 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		jbd_debug(4, "orphan inode %lu will point to %u\n",
 			  i_prev->i_ino, ino_next);
 		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
+		if (!err)
+			NEXT_ORPHAN(i_prev) = ino_next;
+		mutex_unlock(&sbi->s_ondisk_orphan_lock);
 		if (err)
-			goto out_brelse;
-		NEXT_ORPHAN(i_prev) = ino_next;
+			goto brelse;
 		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
 	}
 	if (err)
-		goto out_brelse;
+		goto brelse;
 	NEXT_ORPHAN(inode) = 0;
+	if (lock_mutex)
+		mutex_unlock(&inode->i_mutex);
 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-
-out_err:
+out_set_err:
 	ext4_std_error(inode->i_sb, err);
-out:
-	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
 	return err;
 
-out_brelse:
+brelse:
+	if (lock_mutex)
+		mutex_unlock(&inode->i_mutex);
 	brelse(iloc.bh);
-	goto out_err;
+	goto out_set_err;
 }
 
 static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 710fed2..ad9c45d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3921,8 +3921,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-	mutex_init(&sbi->s_orphan_lock);
-
+	spin_lock_init(&sbi->s_orphan_lock);
+	mutex_init(&sbi->s_ondisk_orphan_lock);
 	sb->s_root = NULL;
 
 	needs_recovery = (es->s_last_orphan != 0 ||
-- 
1.7.11.3


--------------070805060601090001060607
Content-Type: text/x-patch;
 name="0001-Adding-code-to-collect-i_mutex-usage-during-orphan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Adding-code-to-collect-i_mutex-usage-during-orphan.patc";
 filename*1="h"

>From a656649fcf6fa5a17697ec55b2bd2ebd77eceac0 Mon Sep 17 00:00:00 2001
From: T Makphaibulchoke <tmac@hp.com>
Date: Tue, 15 Apr 2014 14:19:44 -0600
Subject: [PATCH] Adding code to collect i_mutex usage during orphan

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/ext4/namei.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a1a6a0..e747e43 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -48,6 +48,46 @@
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 
+static unsigned long num_add_call;
+static unsigned long num_del_call;
+static unsigned long num_add_mutex_lock;
+static unsigned long num_del_mutex_lock;
+static unsigned long num_add_error;
+static unsigned long num_del_error;
+
+static struct kobject *ext4_orphan_kobj;
+
+static ssize_t ext4_print_count(struct kobject *kobj, struct kobj_attribute
+	*attr, char *buff)
+{
+	return sprintf(buff, "Add_mutex_lock %ld(%ld), Del_mutex_lock %ld(%ld).\n",
+		num_add_mutex_lock, num_add_call,
+		num_del_mutex_lock, num_del_call);
+}
+
+static ssize_t ext4_print_error(struct kobject *kobj, struct kobj_attribute
+	*attr, char *buff)
+{
+	return sprintf(buff, "Add_mutex_lock %ld(%ld), Del_mutex_lock %ld(%ld).\n",
+		num_add_error, num_add_call, num_del_error, num_del_call);
+}
+
+static struct kobj_attribute ext4_show_count =
+	__ATTR(ext4_mutex_lock, 0444, ext4_print_count, NULL);
+
+static struct kobj_attribute ext4_show_error =
+	__ATTR(ext4_mutex_error, 0444, ext4_print_error, NULL);
+
+static struct attribute * attrs[] = {
+	&ext4_show_count.attr,
+	&ext4_show_error.attr,
+	NULL
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs
+};
+
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block)
@@ -2557,9 +2597,21 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
+	if (!ext4_orphan_kobj) {
+		ext4_orphan_kobj = kobject_create_and_add("ext4_orphan", NULL);
+		if (ext4_orphan_kobj) {
+			int ret = sysfs_create_group(ext4_orphan_kobj,
+				&attr_group);
+			pr_warning("%s: sys_create_group ret %d.\n",
+				__func__, ret);
+		}
+	}
+
+	++num_add_call;
 	if (!mutex_is_locked(&inode->i_mutex)) {
 		lock_mutex = 1;
 		mutex_lock(&inode->i_mutex);
+		++num_add_mutex_lock;
 	}
 
 	if (!list_empty(&EXT4_I(inode)->i_orphan))
@@ -2588,6 +2640,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 */
 	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
 		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
+			++num_add_error;
 			brelse(iloc.bh);
 			mutex_lock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
 			////spin_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2655,9 +2708,11 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		!(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
+	++num_del_call;
 	if (!mutex_is_locked(&inode->i_mutex)) {
 		lock_mutex = 1;
 		mutex_lock(&inode->i_mutex);
+		++num_del_mutex_lock;
 	}
 
 	if (list_empty(&ei->i_orphan)) {
@@ -2679,6 +2734,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		list_del_init(&ei->i_orphan);
 		mutex_unlock(&sbi->s_ondisk_orphan_lock);
 		////spin_unlock(&sbi->s_orphan_lock);
+		++num_del_error;
 	} else
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 
-- 
1.7.11.3


--------------070805060601090001060607--
