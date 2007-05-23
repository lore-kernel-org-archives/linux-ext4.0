From: coly <colyli@gmail.com>
Subject: [RFC 2/5] inode reservation v0.1 (ext4 kernel patch)
Date: Thu, 24 May 2007 02:06:46 +0800
Message-ID: <1179943606.4179.53.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:28042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXEWSGd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2007 14:06:33 -0400
Received: by ug-out-1314.google.com with SMTP id j3so619563ugf
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2007 11:06:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch is generated based on 2.6.20-ext4-2 branch. you can find the
benchmark from other email.

DO NOT waste time on reading the patch :-) I post this patch here is to
show that I really spent time on it and the patch can work (even not
well).


diff --git a/Makefile b/Makefile
index 7e2750f..21d21e4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,7 @@
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 20
-EXTRAVERSION =
-NAME = Homicidal Dwarf Hamster
+EXTRAVERSION = inores

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 11e93c1..daf88b4 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -30,3 +30,29 @@ unsigned long ext4_count_free (struct buffer_head *
map, unsigned int numchars)

#endif  /*  EXT4FS_DEBUG  */

+/*
+ * Read the inode allocation bitmap for a given block_group, reading
+ * into the specified slot in the superblock's bitmap cache.
+ *
+ * Return buffer_head of bitmap on success or NULL.
+ */
+struct buffer_head *
+read_inode_bitmap(struct super_block * sb, unsigned long block_group)
+{
+ struct ext4_group_desc *desc;
+ struct buffer_head *bh = NULL;
+
+ desc = ext4_get_group_desc(sb, block_group, NULL);
+ if (!desc)
+ goto error_out;
+
+ bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
+ if (!bh)
+ ext4_error(sb, "read_inode_bitmap",
+ "Cannot read inode bitmap - "
+ "block_group = %lu, inode_bitmap = %llu",
+ block_group, ext4_inode_bitmap(sb, desc));
+error_out:
+ return bh;
+}
+
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 427f830..bb83112 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -45,32 +45,6 @@


/*
- * Read the inode allocation bitmap for a given block_group, reading
- * into the specified slot in the superblock's bitmap cache.
- *
- * Return buffer_head of bitmap on success or NULL.
- */
-static struct buffer_head *
-read_inode_bitmap(struct super_block * sb, unsigned long block_group)
-{
- struct ext4_group_desc *desc;
- struct buffer_head *bh = NULL;
-
- desc = ext4_get_group_desc(sb, block_group, NULL);
- if (!desc)
- goto error_out;
-
- bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
- if (!bh)
- ext4_error(sb, "read_inode_bitmap",
-     "Cannot read inode bitmap - "
-     "block_group = %lu, inode_bitmap = %llu",
-     block_group, ext4_inode_bitmap(sb, desc));
-error_out:
- return bh;
-}
-
-/*
  * NOTE! When we get the inode, we're the only people
  * that have access to it, and as such there are no
  * race conditions we have to worry about. The inode
@@ -288,6 +262,12 @@ static int find_group_orlov(struct super_block *sb,
struct inode *parent)
for (i = 0; i < ngroups; i++) {
group = (parent_group + i) % ngroups;
desc = ext4_get_group_desc (sb, group, &bh);
+ if (test_opt(sb, INORES) &&
+     (ext4_unreserved_inodes(sb, group) < 
+ EXT4_INIT_RESERVE_INODES)) {
+ printk(KERN_DEBUG "no enough reserved inodes in group %d\n", group);
+ continue;
+ }
if (!desc || !desc->bg_free_inodes_count)
continue;
if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -323,6 +303,12 @@ static int find_group_orlov(struct super_block *sb,
struct inode *parent)
for (i = 0; i < ngroups; i++) {
group = (parent_group + i) % ngroups;
desc = ext4_get_group_desc (sb, group, &bh);
+ if (test_opt(sb, INORES) &&
+     (ext4_unreserved_inodes(sb, group) < 
+ EXT4_INIT_RESERVE_INODES)) {
+ printk(KERN_DEBUG "no enough reserved inodes in group %d\n", group);
+ continue;
+ }
if (!desc || !desc->bg_free_inodes_count)
continue;
if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
@@ -335,6 +321,9 @@ static int find_group_orlov(struct super_block *sb,
struct inode *parent)
}

fallback:
+ printk(KERN_DEBUG "reach fallback, disable INORES\n");
+ return -1; /* for test */
+ clear_opt(sbi->s_mount_opt, INORES);
for (i = 0; i < ngroups; i++) {
group = (parent_group + i) % ngroups;
desc = ext4_get_group_desc (sb, group, &bh);
@@ -414,6 +403,598 @@ static int find_group_other(struct super_block
*sb, struct inode *parent)
return -1;
}

+
+static int ext4_inores_newdir_ino(handle_t * handle,
+   struct inode * dir, 
+   time_t ctime,
+   unsigned long * ino)
+{
+ struct super_block * sb;
+ struct ext4_sb_info * sbi;
+ int group;
+ struct buffer_head * bitmap_bh = NULL, * bh2;
+ unsigned long lastres_ino, start_ino, end_ino;
+ struct ext4_magic_inode * link_minode, * lastres_minode;
+ struct ext4_iloc link_iloc, lastres_iloc;
+ struct ext4_group_desc * gdp = NULL;
+ int itable_offset;
+ int ret = 0;
+
+ sb = dir->i_sb;
+ sbi = EXT4_SB(sb);
+
+find_group_again:
+ group = find_group_orlov(sb, dir);
+ 
+ if (group == -1) {
+ printk("no space in find_group_orlove.\n");
+ return -ENOSPC;
+ }
+ if (!test_opt (sb, INORES)) {
+ printk(KERN_DEBUG "INORES is not set, return 0.\n");
+ * ino = 0;
+ return 0;
+ }
+ 
+ /* 
+ * the corresponded block is already loaded into memory in 
+ * find_group_orlov(), this lock will not hurt performance 
+ * in common case.
+ */
+ spin_lock(sb_bgl_lock(sbi, group));
+ if (ext4_unreserved_inodes(sb, group) < EXT4_INIT_RESERVE_INODES) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ goto find_group_again;
+ }
+
+ lastres_ino = ext4_get_group_lastres_ino(sb, group);
+ ret = ext4_get_magic_inode_loc(sb, lastres_ino, &lastres_iloc);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return -EFAULT;
+ }
+ lastres_minode = (struct ext4_magic_inode *)
+ ((char *)lastres_iloc.bh->b_data + lastres_iloc.offset);
+ if(!ext4_magic_inode(lastres_minode, EXT4_MINODE_TYPE_LASTRES)) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ BUFFER_TRACE (lastres_iloc.bh, "call ext4_journal_get_write_access");
+ ret = ext4_journal_get_write_access(handle, lastres_iloc.bh);
+ if(ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ start_ino = le32_to_cpu(lastres_minode->mi_lastres_ino) + 1;
+ printk("start_ino: %lu, in group %d\n", start_ino, group);
+ lastres_minode->mi_lastres_ino = cpu_to_le32(start_ino + 
+ EXT4_INIT_RESERVE_INODES - 1);
+ BUFFER_TRACE(lastres_iloc.bh, "call ext4_journal_dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, lastres_iloc.bh);
+ if(ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ brelse(lastres_iloc.bh);
+ end_ino = start_ino + EXT4_INIT_RESERVE_INODES - 1;
+
+ ret = ext4_get_magic_inode_loc(sb, end_ino, &link_iloc);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return -EFAULT;
+ }
+ link_minode = (struct ext4_magic_inode *)
+ ((char *)link_iloc.bh->b_data + link_iloc.offset);
+
+ bitmap_bh = read_inode_bitmap(sb, group);
+ if (!bitmap_bh) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+
+ itable_offset = (end_ino - 1) % EXT4_INODES_PER_GROUP(sb);
+ printk(KERN_DEBUG "itable_offset of group %d is: %d\n", group,
itable_offset);
+ if (ext4_test_bit(itable_offset, bitmap_bh->b_data)) {
+ if(!ext4_magic_inode(link_minode, EXT4_MINODE_TYPE_LINK)) {
+ printk(KERN_INFO "Allocated inode %lu is not a "
+ "EXT4_MINODE_TYPE_LINK magic inode, "
+ "Disable directory inode reservation "
+ "now.\n", end_ino);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ clear_opt(sbi->s_mount_opt, INORES);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ * ino = 0;
+ return 0;
+ }
+ if(le32_to_cpu(link_minode->mi_parent_ino) != start_ino) {
+ printk(KERN_INFO "EXT4_MINODE_TYPE_LINK magic inode "
+ "%lu is allocated already and belongs to "
+ "a different directory inode %lu. Use this "
+ "magic inode for new directory inode %lu "
+ "with force now.\n",
+ end_ino, 
+ (unsigned long)le32_to_cpu(link_minode->mi_parent_ino),
+ start_ino);
+ }
+ if(le32_to_cpu(link_minode->mi_parent_ctime) !=
+ ctime) {
+ printk(KERN_INFO "EXT4_MINODE_TYPE_LINK magic inode "
+ "%lu ctime does not match, which means it "
+ "belongs a removed directory with same inode "
+ "number. Use this magic inode for new directory "
+ "inode %lu with force now.\n",
+ end_ino,
+ (unsigned long)le32_to_cpu(link_minode->mi_parent_ino));
+ }
+ }
+ BUFFER_TRACE (bitmap_bh, "call ext4_journal_get_write_access");
+ ret = ext4_journal_get_write_access(handle, bitmap_bh);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ jbd2_journal_release_buffer(handle, link_iloc.bh);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EIO;
+ }
+
+ if (ext4_set_bit((start_ino - 1) % EXT4_INODES_PER_GROUP(sb), 
+ bitmap_bh->b_data)) {
+ printk(KERN_ERR "inode %lu for new directory is already "
+ "set in bitmap of group %d\n", start_ino, group);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ jbd2_journal_release_buffer(handle, bitmap_bh);
+ jbd2_journal_release_buffer(handle, link_iloc.bh);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+ if (ext4_set_bit((end_ino - 1) % EXT4_INODES_PER_GROUP(sb),
+ bitmap_bh->b_data)) {
+ printk(KERN_INFO "EXT4_MINODE_TYPE_LINK magic inode "
+ "%lu is already set in bitmap of group %d\n", 
+ end_ino, group);
+ printk(KERN_INFO "Use inode %lu as EXT4_MINODE_TYPE_LINK magic "
+ "inode for directory inode %lu of group %d.\n",
+ end_ino, start_ino, group);
+ }
+ spin_unlock(sb_bgl_lock(sbi, group));
+
+ BUFFER_TRACE(link_iloc.bh, "call ext4_journal_get_write_access");
+ ret = ext4_journal_get_write_access(handle, link_iloc.bh);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+
+ ext4_init_magic_inode(link_minode, EXT4_MINODE_TYPE_LINK);
+ link_minode->mi_next_ino = cpu_to_le32(0);
+ link_minode->mi_parent_ino = cpu_to_le32(start_ino);
+ link_minode->mi_current_ressize =
cpu_to_le32(EXT4_INIT_RESERVE_INODES);
+ link_minode->mi_next_ressize = cpu_to_le32(EXT4_INIT_RESERVE_INODES *
2);
+ link_minode->mi_parent_ctime = cpu_to_le32(ctime);
+ BUFFER_TRACE (link_iloc.bh, "call ext4_journal_dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, link_iloc.bh);
+ if (ret) {
+ jbd2_journal_release_buffer(handle, bitmap_bh);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+ brelse(link_iloc.bh);
+ BUFFER_TRACE (bitmap_bh, "call ext4_journal_dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bitmap_bh);
+ if (ret) {
+ brelse(bitmap_bh);
+ return -EFAULT;
+ }
+ brelse(bitmap_bh);
+
+ gdp = ext4_get_group_desc(sb, group, &bh2);
+ if (!gdp)
+ return -EFAULT;
+ BUFFER_TRACE(bh2, "call ext4_journal_get_write_access");
+ ret = ext4_journal_get_write_access(handle, bh2);
+ if (ret) {
+ return -EFAULT;
+ }
+ spin_lock(sb_bgl_lock(sbi, group));
+ gdp->bg_free_inodes_count = 
+ cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bh2); 
+ if (ret) {
+ return -EFAULT;
+ }
+ 
+ * ino = start_ino;
+ return 0;
+
+}
+
+static int ext4_new_reserve_area(handle_t * handle,
+ struct super_block *sb,
+ int group,
+ struct ext4_magic_inode * prev_link_minode,
+ struct buffer_head * prev_link_bh,
+ unsigned long prev_link_mino,
+ int new_ressize)
+{
+ struct buffer_head * bitmap_bh, * bh2;
+ struct ext4_iloc link_iloc, lastres_iloc;
+ struct ext4_magic_inode * lastres_minode, * link_minode;
+ struct ext4_group_desc * gdp;
+ unsigned long lastres_ino, start_ino, end_ino;
+ int itable_offset;
+ int ret;
+ 
+
+
+ lastres_ino = (group + 1) * EXT4_INODES_PER_GROUP(sb) - 1;
+ printk(KERN_DEBUG "lastres_ino %lu in group %d\n", 
+ lastres_ino, group);
+ ret = ext4_get_magic_inode_loc(sb, lastres_ino, &lastres_iloc);
+ if (ret) 
+ return -EIO;
+ lastres_minode = (struct ext4_magic_inode *)
+ ((char *)lastres_iloc.bh->b_data + lastres_iloc.offset);
+ if (!ext4_magic_inode(lastres_minode, EXT4_MINODE_TYPE_LASTRES)) {
+ printk(KERN_ERR "EXT4_MINODE_TYPE_LASTRES magic inode in "
+ "group %d corrupt.\n", group);
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ start_ino = le32_to_cpu(lastres_minode->mi_lastres_ino) + 1;
+ printk(KERN_DEBUG "try start_ino %lu in group %d.\n", 
+ start_ino, group);
+ BUFFER_TRACE(lastres_iloc.bh, "get_write_access");
+ ret = ext4_journal_get_write_access(handle, lastres_iloc.bh);
+ if (ret) {
+ brelse(lastres_iloc.bh);
+ return -EIO;
+ }
+ lastres_minode->mi_lastres_ino = 
+ cpu_to_le32(le32_to_cpu(lastres_minode->mi_lastres_ino) + 
+ new_ressize);
+ BUFFER_TRACE(lastres_iloc.bh, "dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, lastres_iloc.bh);
+ if (ret) {
+ brelse(lastres_iloc.bh);
+ return -EIO;
+ }
+ end_ino = le32_to_cpu(lastres_minode->mi_lastres_ino);
+ brelse(lastres_iloc.bh);
+
+ itable_offset = (end_ino - 1) % EXT4_INODES_PER_GROUP(sb);
+ bitmap_bh = read_inode_bitmap(sb, group);
+ if(!bitmap_bh) {
+ printk(KERN_ERR "Can not read bitmap for group %d.\n",
+ group);
+ return -EIO;
+ }
+ BUFFER_TRACE(bitmap_bh, "get_write_access");
+ ret = ext4_journal_get_write_access(handle, bitmap_bh);
+ if(ret) {
+ brelse(bitmap_bh);
+ return -EIO;
+ }
+ printk(KERN_DEBUG "end ino offset of new reserve area: %d\n",
itable_offset);
+ if (ext4_set_bit(itable_offset, bitmap_bh->b_data)) {
+ printk(KERN_INFO "inode %lu in group %d is allocated "
+ "already. Give up this group.\n", 
+ end_ino, group);
+ jbd2_journal_release_buffer(handle, bitmap_bh);
+ brelse(bitmap_bh);
+ return -EFAULT;
+ }
+ BUFFER_TRACE(bitmap_bh, "dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bitmap_bh);
+ brelse(bitmap_bh);
+ if(ret)
+ return -EFAULT;
+
+ gdp = ext4_get_group_desc(sb, group, &bh2);
+ if (!gdp) {
+ printk(KERN_ERR "can not get group descriptor of "
+ "group %d.\n", group);
+ return -EIO;
+ }
+ BUFFER_TRACE(bh2, "get_write_access");
+ ret = ext4_journal_get_write_access(handle, bh2);
+ if (ret)
+ return -EIO;
+ gdp->bg_free_inodes_count = 
+ cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+ BUFFER_TRACE(bh2, "call dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bh2);
+ if(ret) 
+ return -EIO;
+ ret = ext4_get_magic_inode_loc(sb, end_ino, &link_iloc);
+ if(ret)
+ return -EIO;
+ ret = ext4_journal_get_write_access(handle, link_iloc.bh);
+ if (ret) {
+ brelse(link_iloc.bh);
+ return -EIO;
+ }
+ link_minode = (struct ext4_magic_inode *)
+ ((char *)link_iloc.bh->b_data + link_iloc.offset);
+ ext4_init_magic_inode(link_minode, EXT4_MINODE_TYPE_LINK);
+ link_minode->mi_next_ino = cpu_to_le32(0);
+ link_minode->mi_parent_ino = prev_link_minode->mi_parent_ino;
+ link_minode->mi_current_ressize = cpu_to_le32(new_ressize);
+ link_minode->mi_next_ressize = cpu_to_le32(0);
+ link_minode->mi_parent_ctime = prev_link_minode->mi_parent_ctime;
+ BUFFER_TRACE(link_iloc.bh, "call dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, link_iloc.bh);
+ if (ret) {
+ brelse(link_iloc.bh);
+ return -EIO;
+ }
+ brelse(link_iloc.bh);
+ ret = ext4_journal_get_write_access(handle, prev_link_bh);
+ if (ret)
+ return -EIO;
+ prev_link_minode->mi_next_ressize = cpu_to_le32(new_ressize);
+ prev_link_minode->mi_next_ino = start_ino;
+ ret = ext4_journal_dirty_metadata(handle, prev_link_bh);
+ if (ret)
+ return -EIO;
+ 
+ return 0;
+}
+
+static int ext4_reserve_inodes_area(handle_t * handle,
+ struct super_block * sb,
+ struct inode * dir,
+ struct ext4_magic_inode * prev_link_minode,
+ struct buffer_head * prev_link_bh,
+ unsigned long prev_link_mino)
+{
+ struct ext4_sb_info * sbi = EXT4_SB(sb);
+ int unreserved_inodes, new_ressize;
+ int group;
+ int i, ret;
+ 
+ spin_lock(dir->i_lock);
+ if (le32_to_cpu(prev_link_minode->mi_next_ino) != 0) {
+ printk(KERN_DEBUG "new reserve inodes area generated "
+ "by others. Nothing to do here.\n");
+ spin_unlock(dir->i_lock);
+ return 0;
+ }
+
+ group = (prev_link_mino - 1) / EXT4_INODES_PER_GROUP(sb);
+ new_ressize = le32_to_cpu(prev_link_minode->mi_current_ressize) * 2;
+ if (new_ressize > EXT4_INODES_PER_GROUP(sb))
+ new_ressize = new_ressize / 2;
+
+try_new_ressize:
+ for (i = 0; i < sbi->s_groups_count; i ++) {
+ printk(KERN_DEBUG "try reserv size %d in group %d\n", 
+ new_ressize, group);
+ spin_lock(sb_bgl_lock(sbi, group));
+ unreserved_inodes = ext4_unreserved_inodes(sb, group);
+ printk("%d inodes unreserved in group %d\n", unreserved_inodes,
group);
+ if (unreserved_inodes >= new_ressize) {
+ printk(KERN_DEBUG "group %d has enough inodes to "
+ "reserve.\n", group);
+ ret = ext4_new_reserve_area(handle, 
+     sb, 
+     group, 
+     prev_link_minode,
+     prev_link_bh,
+     prev_link_mino, 
+     new_ressize);
+ if (ret) {
+ printk(KERN_DEBUG "failed to make new "
+ "reserved area in group %d\n", 
+ group);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return ret;
+ }
+ printk(KERN_DEBUG "Success to make new reserved "
+ "inodes area in group %d\n", group);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return 0;
+ } 
+ spin_unlock(sb_bgl_lock(sbi, group));
+ group = (group + 1) % sbi->s_groups_count;
+ }
+ new_ressize = new_ressize >> 1;
+ if(new_ressize >= EXT4_INIT_RESERVE_INODES)
+ goto try_new_ressize;
+ return -EFAULT;
+}
+
+static int ext4_inores_newfile_ino(handle_t * handle, 
+    struct inode * dir, 
+    unsigned long * ino)
+{
+ struct super_block * sb;
+ struct ext4_sb_info * sbi;
+ unsigned long start_ino, end_ino;
+ int itable_offset;
+ int parent_group, prev_group, group;
+ int bitmap_size;
+ struct buffer_head * bitmap_bh;
+ struct ext4_iloc link_iloc;
+ struct ext4_magic_inode * link_minode;
+ int ret;
+
+ start_ino = dir->i_ino;
+ if((start_ino != EXT4_ROOT_INO) &&
+    ((start_ino - 1) % EXT4_INIT_RESERVE_INODES) != 0) {
+ printk(KERN_WARNING "directory inode %lu is not "
+ "%d inodes aligned.\n", 
+ start_ino, EXT4_INIT_RESERVE_INODES);
+ return -EFAULT;
+ }
+
+ sb = dir->i_sb;
+ sbi = EXT4_SB(sb);
+ group = parent_group = EXT4_I(dir)->i_block_group;
+ if (start_ino == EXT4_ROOT_INO)
+ end_ino = EXT4_INIT_RESERVE_INODES;
+ else
+ end_ino = start_ino + EXT4_INIT_RESERVE_INODES - 1;
+
+ if (unlikely(end_ino > 
+ (parent_group + 1) * EXT4_INODES_PER_GROUP(sb))) {
+ printk(KERN_ERR "end_io %lu of directory inode %lu "
+ "exceeds inodes of group %d.\n",
+ end_ino, start_ino, group);
+ return -EFAULT;
+ }
+ if (unlikely(end_ino <= EXT4_FIRST_INO(sb))) {
+ printk(KERN_ERR "end_ino %lu is small than fs' first "
+ "inode %d.\n", end_ino, EXT4_FIRST_INO(sb));
+ return -EFAULT;
+ }
+
+ start_ino += 1;
+
+ prev_group = group;
+
+ /* loop_count should be removed after debugging */
+ unsigned long  loop_count = 0; 
+ while(1) {
+ printk(KERN_INFO "try group %d\n", group);
+ bitmap_bh = read_inode_bitmap(sb, group);
+ if (!bitmap_bh) 
+ return -EIO;
+repeat_in_this_group:
+ loop_count += 1;
+ if (loop_count > 10000000){
+ brelse(bitmap_bh);
+ printk("too much time dead loop\n");
+ return -EIO;
+ }
+ itable_offset = (start_ino - 1) % 
+ EXT4_INODES_PER_GROUP(sb);
+ bitmap_size = (end_ino - 1) % EXT4_INODES_PER_GROUP(sb) + 1;
+ /* 
+ * should use a function here 
+ */
+ printk("bitmap_size: %d, itable_offset: %d\n", bitmap_size,
itable_offset);
+ * ino = ext4_find_next_zero_bit((unsigned long *)
+ bitmap_bh->b_data, bitmap_size, itable_offset);
+// * ino = ext4_find_next_zero_bit((unsigned long *)
+// bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), itable_offset);
+ printk("find offset %lu in group %d [%d - %d] inodes [%lu - %lu]\n", 
+ * ino, group, itable_offset, bitmap_size - 1,
+ start_ino, end_ino);
+ if ((* ino) < bitmap_size) {
+ BUFFER_TRACE(bitmap_bh, "get_write_access");
+ ret = ext4_journal_get_write_access(handle, bitmap_bh);
+ if(ret) {
+ brelse(bitmap_bh);
+ return -EIO;
+ }
+ if(!ext4_set_bit_atomic(sb_bgl_lock(sbi, group), 
+ * ino, bitmap_bh->b_data)) {
+ BUFFER_TRACE(bitmap_bh, 
+ "call ext4_journal_dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle,
+ bitmap_bh);
+ if(ret) {
+ brelse (bitmap_bh);
+ return -EIO;
+ }
+ brelse(bitmap_bh);
+ * ino = group * EXT4_INODES_PER_GROUP(sb) +
+ (* ino) + 1;
+ return 0;
+ }
+ printk("offset %lu set in bitmap already.\n", * ino);
+ jbd2_journal_release_buffer(handle, bitmap_bh);
+ goto repeat_in_this_group;
+ }
+ ret = ext4_get_magic_inode_loc(sb, end_ino, &link_iloc);
+ if (ret) {
+ printk (KERN_ERR "failed to get magic inode %lu "
+ "from group %d\n", end_ino, group);
+ brelse(bitmap_bh);
+ return ret;
+ }
+ link_minode = (struct ext4_magic_inode *)
+ ((char *)link_iloc.bh->b_data + link_iloc.offset);
+ if(!ext4_magic_inode(link_minode, EXT4_MINODE_TYPE_LINK)) {
+ printk(KERN_ERR "inode %lu is not a EXT4_MINODE_TYPE_LINK "
+ "magic inode.\n", end_ino);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+ printk("preextend, link_minode->mi_next_ino: %lu\n",
+ (unsigned long)le32_to_cpu(link_minode->mi_next_ino));
+ if (le32_to_cpu(link_minode->mi_next_ino) == 0) {
+ ret = ext4_reserve_inodes_area(handle, 
+ sb, 
+ dir,  
+ link_minode, 
+ link_iloc.bh, 
+ end_ino); 
+ if (ret) {
+ printk(KERN_ERR "get new reserve inodes area after "
+ "area [%lu - %lu] failed.\n",
+ start_ino, end_ino);
+ brelse(bitmap_bh);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+ }
+ printk("afterextend, link_minode->mi_next_ino: %lu\n",
+ (unsigned long)le32_to_cpu(link_minode->mi_next_ino));
+ start_ino = le32_to_cpu(link_minode->mi_next_ino);
+ end_ino = start_ino + 
+   le32_to_cpu(link_minode->mi_next_ressize) - 1;
+ brelse (link_iloc.bh);
+ group = (start_ino - 1) / EXT4_INODES_PER_GROUP(sb);
+ printk("prev_group: %d, group: %d, start_ino: %lu, end_ino: %lu\n",
+ prev_group, group, start_ino, end_ino);
+ if (group == prev_group) {
+ printk("try same group %d.\n", prev_group);
+ goto repeat_in_this_group;
+ }
+ printk("try new group %d.\n", group);
+ prev_group = group;
+ brelse(bitmap_bh);
+ }
+ printk(" ============= loop end ========= \n"); 
+ return -EINVAL;
+}
+
+static int ext4_find_inores_ino(handle_t * handle, 
+ struct inode * dir, 
+ int mode, 
+ time_t ctime,
+ unsigned long * ino)
+{
+
+ struct super_block *sb;
+ int ret = -EINVAL;
+ 
+ sb = dir->i_sb;
+ if (!test_opt(sb, INORES))
+ return ret;
+
+ if (S_ISDIR(mode))
+ ret = ext4_inores_newdir_ino(handle, dir, ctime, ino);
+ else
+ ret = ext4_inores_newfile_ino(handle, dir, ino);
+ 
+ return ret;
+}
+
+
/*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with
both
@@ -422,7 +1003,8 @@ static int find_group_other(struct super_block *sb,
struct inode *parent)
  * directories already is chosen.
  *
  * For other inodes, search forward from the parent directory's block
- * group to find a free inode.
+ * group to find a free inode. When directory inode reservation is
enabled,
+ * inodes will be searched in the reserved inodes area firstly.
  */
struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int
mode)
{
@@ -436,6 +1018,7 @@ struct inode *ext4_new_inode(handle_t *handle,
struct inode * dir, int mode)
struct ext4_super_block * es;
struct ext4_inode_info *ei;
struct ext4_sb_info *sbi;
+ struct timespec ctime;
int err = 0;
struct inode *ret;
int i;
@@ -452,6 +1035,31 @@ struct inode *ext4_new_inode(handle_t *handle,
struct inode * dir, int mode)

sbi = EXT4_SB(sb);
es = sbi->s_es;
+
+ ctime = ext4_current_time(inode);
+ if (test_opt (sb, INORES)) {
+ err = ext4_find_inores_ino(handle, dir, mode, ctime.tv_sec, &ino);
+ if (err)
+// goto fail;
+ return ERR_PTR(-ENOSPC); /* for test now */
+ if (ino > 0) {
+ group  = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
+ gdp = ext4_get_group_desc(sb, group, &bh2);
+ if (!gdp)
+ goto fail;
+ printk("find ino %lu in group %d from ext4_find_inores_ino.\n",
+ ino, group);
+ goto inores_got;
+ }
+ printk(KERN_INFO "can not find inode from reserved inodes "
+ "area, disable inode reservation for "
+ "directory now.\n");
+ return ERR_PTR(-ENOSPC); /* for test now */
+ clear_opt (sbi->s_mount_opt, INORES);
+ }
+
+ return ERR_PTR(-ENOSPC);
+
if (S_ISDIR(mode)) {
if (test_opt (sb, OLDALLOC))
group = find_group_dir(sb, dir);
@@ -521,9 +1129,10 @@ repeat_in_this_group:

got:
ino += group * EXT4_INODES_PER_GROUP(sb) + 1;
+inores_got:
if (ino < EXT4_FIRST_INO(sb) || ino > le32_to_cpu(es->s_inodes_count)) {
ext4_error (sb, "ext4_new_inode",
-     "reserved inode or inode > inodes count - "
+     "reserved inode or inode > inodes count -- "
    "block_group = %d, inode=%lu", group, ino);
err = -EIO;
goto fail;
@@ -564,7 +1173,7 @@ got:
/* This is the optimal IO size (for stat), not the fs block size */
inode->i_blocks = 0;
inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
-        ext4_current_time(inode);
+        ctime;

memset(ei->i_data, 0, sizeof(ei->i_data));
ei->i_dir_start_lookup = 0;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f50c8cd..6929991 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3330,3 +3330,338 @@ int ext4_change_inode_journal_flag(struct inode
*inode, int val)

return err;
}
+
+int ext4_magic_inode(struct ext4_magic_inode * magic_inode, 
+ int type)
+{
+ int i, sum;
+ if(le32_to_cpu(magic_inode->mi_zeropad) != 0)
+ return 0;
+ if(strncmp(magic_inode->mi_magic, EXT4_MINODE_MAGIC_STR, 
+ EXT4_MINODE_MAGIC_LEN))
+ return 0;
+ sum = 0;
+ for(i = 0; i < EXT4_MINODE_MAGIC_LEN; i ++)
+ sum += magic_inode->mi_magic[i];
+ if(sum + le32_to_cpu(magic_inode->mi_checksum) != 0)
+ return 0;
+ if(le32_to_cpu(magic_inode->mi_type) != type)
+ return 0;
+ return 1;
+}
+
+void ext4_init_magic_inode(struct ext4_magic_inode * magic_inode,
+ int type)
+{
+ int i, sum;
+ memset(magic_inode, 0, sizeof(struct ext4_magic_inode));
+ memcpy(magic_inode->mi_magic, EXT4_MINODE_MAGIC_STR,
+ EXT4_MINODE_MAGIC_LEN); 
+ sum = 0;
+ for(i = 0; i < EXT4_MINODE_MAGIC_LEN; i ++)
+ sum += magic_inode->mi_magic[i];
+ magic_inode->mi_checksum = cpu_to_le32(0 - sum);
+ magic_inode->mi_type = cpu_to_le32(type);
+}
+
+unsigned long ext4_get_group_lastres_ino(struct super_block * sb, int
group)
+{
+        unsigned long lastres_ino;
+        lastres_ino = (group + 1) * EXT4_INODES_PER_GROUP(sb) - 1;
+        return lastres_ino;
+}
+
+int  ext4_get_magic_inode_loc(struct super_block * sb, 
+       unsigned long ino,
+       struct ext4_iloc * iloc)
+{
+ unsigned long block_group, group_desc, desc;
+ unsigned long block, offset;
+ struct buffer_head * bh;
+ struct ext4_group_desc * gdp;
+
+ block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
+ if(block_group >= EXT4_SB(sb)->s_groups_count) {
+ ext4_error(sb, "ext4_get_magic_inode_loc", 
+ "group >= groups count");
+ return -EINVAL;
+ }
+
+ group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
+ desc = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
+ bh = EXT4_SB(sb)->s_group_desc[group_desc];
+ if(!bh) {
+ ext4_error (sb, "ext4_get_magic_inode_loc",
+ "Descriptor not loaded");
+ return -EINVAL;
+ }
+ gdp = (struct ext4_group_desc *)
+ ((char *)bh->b_data + desc * EXT4_DESC_SIZE(sb));
+
+ offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
+ EXT4_INODE_SIZE(sb);
+ block = ext4_inode_table(sb, gdp) + 
+ (offset >> EXT4_BLOCK_SIZE_BITS(sb));
+
+ bh = sb_bread(sb, block);
+ if(!bh) {
+ ext4_error (sb, "ext4_get_magic_inode_loc",
+ "unable to read inode block - "
+ "inode=%lu, block=%lu",
+ ino, block);
+ return -EIO;
+ }
+ offset = offset & (EXT4_BLOCK_SIZE(sb) - 1);
+ iloc->block_group = block_group;
+ iloc->offset = offset;
+ iloc->bh = bh;
+
+ return 0;
+}
+
+unsigned long ext4_unreserved_inodes(struct super_block *sb, 
+      int group)
+{
+ unsigned long lastres_ino;
+ unsigned long unreserved_nr;
+ struct ext4_iloc iloc;
+ struct ext4_magic_inode * magic_inode;
+
+ lastres_ino = ext4_get_group_lastres_ino(sb, group);
+ if(ext4_get_magic_inode_loc(sb, lastres_ino, &iloc) < 0) {
+ ext4_error (sb, "ext4_unreserved_inodes",
+ "failed to load inode block - "
+ "inode %lu, group %d", lastres_ino, group);
+ return 0;
+ }
+ magic_inode = (struct ext4_magic_inode * )
+ ((char *)iloc.bh->b_data + iloc.offset);
+ if(!ext4_magic_inode(magic_inode, EXT4_MINODE_TYPE_LASTRES)) {
+ ext4_error (sb, "ext4_unreserved_inodes",
+ "inode %lu in group %d is not "
+ "EXT4_MINODE_TYPE_LASTRES magic inode",
+ lastres_ino, group);
+ brelse(iloc.bh);
+ return 0;
+ }
+ unreserved_nr = (group + 1) * EXT4_INODES_PER_GROUP(sb) -
+ le32_to_cpu(magic_inode->mi_lastres_ino);
+ brelse(iloc.bh);
+ return (unreserved_nr > 0) ? unreserved_nr : 0;
+}
+
+static int ext4_shrink_inores_ino(struct super_block * sb,
+   int group, 
+   unsigned long link_ino, 
+   handle_t * handle,
+   struct buffer_head * lastres_bh,
+   struct ext4_magic_inode * lastres_minode) 
+{
+ struct ext4_sb_info * sbi;
+ struct buffer_head * bitmap_bh;
+ int lastres_mino_offset;
+ int len;
+ int prev_offset, offset;
+ int ret;
+
+ sbi = EXT4_SB(sb);
+ spin_lock(sb_bgl_lock(sbi, group));
+ 
+ if (link_ino != le32_to_cpu(lastres_minode->mi_lastres_ino)) {
+ printk(KERN_INFO "last reserved ino  of group %d is not "
+ "%lu any more. Give up shrink last reserved ino.\n",
+ group, link_ino);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return 0;
+ }
+
+ bitmap_bh = read_inode_bitmap(sb, group);
+ if (!bitmap_bh) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return -EFAULT;
+ }
+
+ lastres_mino_offset = 
+ (ext4_get_group_lastres_ino(sb, group) - 1) %
+ EXT4_INODES_PER_GROUP(sb);
+ len = (link_ino - 1) % EXT4_INODES_PER_GROUP(sb) + 1;
+
+ printk("lastres_mino_offset: %d, len: %d\n", 
+ lastres_mino_offset, len);
+ for(prev_offset = 0, offset = 0; offset < len; offset ++) {
+ offset = find_next_bit((unsigned long *)bitmap_bh->b_data,
+ len, offset);
+ if (offset >= len)
+ break;
+ if (offset != lastres_mino_offset)
+ prev_offset = offset;
+ }
+ printk("offset: %d, prev_offset: %d\n", offset, prev_offset);
+ BUFFER_TRACE(lastres_bh, "call get_write_access");
+ ret = ext4_journal_get_write_access(handle, lastres_bh);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return -EFAULT;
+ }
+ if (prev_offset)
+ prev_offset += 1;
+ lastres_minode->mi_lastres_ino = 
+ cpu_to_le32(group * EXT4_INODES_PER_GROUP(sb)
+ + prev_offset);
+ BUFFER_TRACE(lastres_bh, "call dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, lastres_bh);
+ if (ret) {
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return -EFAULT;
+ }
+ spin_unlock(sb_bgl_lock(sbi, group));
+ return 0;
+}
+
+
+int ext4_delete_link_magic_inodes(handle_t * handle, struct inode *
dir)
+{
+ struct super_block * sb;
+ struct ext4_sb_info * sbi;
+ unsigned long dir_ino, link_ino, next_ino;
+ unsigned long lastres_ino;
+ int next_ressize;
+ struct ext4_iloc link_iloc, lastres_iloc;
+ struct ext4_magic_inode * link_minode,* lastres_minode;
+ struct buffer_head * bitmap_bh, * bh2 ;
+ struct ext4_group_desc * gdp;
+ int group, bit;
+ int ret;
+
+ dir_ino = dir->i_ino;
+
+ if (dir_ino != EXT4_ROOT_INO && 
+     (dir_ino - 1) % EXT4_INIT_RESERVE_INODES != 0) {
+ printk(KERN_DEBUG "dir inode %lu is not %d aligned."
+ "Give up deleting EXT4_MINODE_TYPE_LINK magic "
+ "inodes of this dir inode.\n",
+ dir_ino, EXT4_INIT_RESERVE_INODES);
+ return 0;
+ }
+
+ sb = dir->i_sb;
+ sbi = EXT4_SB(sb);
+
+ if (dir_ino == EXT4_ROOT_INO)
+ link_ino = EXT4_INIT_RESERVE_INODES;
+ else
+ link_ino = dir_ino + EXT4_INIT_RESERVE_INODES - 1;
+
+ printk("at begining, dir_ino: %lu, link_ino: %lu.\n", dir_ino,
link_ino);
+
+ next_ino = dir_ino;
+ while (next_ino) {
+ ret = ext4_get_magic_inode_loc(sb, link_ino, &link_iloc);
+ if (ret)
+ return ret;
+ link_minode = (struct ext4_magic_inode *)
+ ((char *)link_iloc.bh->b_data + link_iloc.offset);
+ if(!ext4_magic_inode(link_minode, EXT4_MINODE_TYPE_LINK)) {
+ printk(KERN_WARNING "Inode %lu is not a "
+ "EXT4_MINODE_TYPE_LINK magic inode. "
+ "Give up removing other magic inodes.\n",
+ link_ino);
+ brelse(link_iloc.bh);
+ return -EFAULT;
+ }
+ next_ino = le32_to_cpu(link_minode->mi_next_ino);
+ next_ressize = le32_to_cpu(link_minode->mi_next_ressize);
+ brelse(link_iloc.bh);
+ group = (link_ino - 1) / EXT4_INODES_PER_GROUP(sb);
+ bit = (link_ino - 1) % EXT4_INODES_PER_GROUP(sb);
+ bitmap_bh = read_inode_bitmap(sb, group);
+ if (!bitmap_bh) 
+ return -EIO;
+ BUFFER_TRACE(bitmap_bh, "call get_write_access");
+ ret = ext4_journal_get_write_access(handle, bitmap_bh);
+ if (ret) {
+ brelse(bitmap_bh);
+ return -EFAULT;
+ }
+ printk(KERN_DEBUG "clear magic inode %lu in bitmap of group %d.\n",
+ link_ino, group);
+ if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, group),
+ bit, bitmap_bh->b_data)) {
+ ext4_error(sb, "ext4_delete_link_magic_inodes",
+ "bit already cleared for inode %lu",
+ link_ino);
+ }
+ BUFFER_TRACE(bitmap_bh, "call dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bitmap_bh);
+ if (ret) {
+ brelse(bitmap_bh);
+ return -EFAULT;
+ }
+ brelse(bitmap_bh);
+ gdp = ext4_get_group_desc(sb, group, &bh2);
+ if (!gdp) {
+ ext4_error(sb, "ext4_delete_link_magic_inodes",
+ "get group %d desc failed.",
+ group);
+ return -EFAULT;
+ }
+ BUFFER_TRACE(bh2, "call get_write_access");
+ ret = ext4_journal_get_write_access(handle, bh2);
+ if (ret) 
+ return -EFAULT;
+ spin_lock(sb_bgl_lock(sbi, group));
+ gdp->bg_free_inodes_count = 
+ cpu_to_le32(le32_to_cpu(gdp->bg_free_inodes_count) + 1);
+ spin_unlock(sb_bgl_lock(sbi, group));
+ BUFFER_TRACE(bh2, "call dirty_metadata");
+ ret = ext4_journal_dirty_metadata(handle, bh2);
+ if (ret)
+ return -EFAULT;
+ 
+ lastres_ino = ext4_get_group_lastres_ino(sb, group);
+ ret = ext4_get_magic_inode_loc(sb, lastres_ino, &lastres_iloc);
+ if (ret) {
+ ext4_error(sb, "ext4_delete_link_magic_inodes",
+ "read EXT4_MINODE_TYPE_LASTRES magic inode %lu"
+ "of group %d failed.", lastres_ino, group);
+ return -EFAULT;
+ }
+ lastres_minode = (struct ext4_magic_inode *)
+ ((char *)lastres_iloc.bh->b_data + lastres_iloc.offset);
+ if (!ext4_magic_inode(lastres_minode, EXT4_MINODE_TYPE_LASTRES)) {
+ ext4_error(sb, "ext4_delete_link_magic_inodes",
+ "inode %lu is not EXT4_MINODE_TYPE_LASTRES "
+ "magic inode of group %d.",
+ lastres_ino, group);
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ printk("whether to shrink the last reserved ino?  link_ino: %lu,
lastres_ino: %lu\n",
+ link_ino,
+ le32_to_cpu(lastres_minode->mi_lastres_ino));
+ if (link_ino == le32_to_cpu(lastres_minode->mi_lastres_ino)) {
+ ret = ext4_shrink_inores_ino( sb, 
+ group, 
+ link_ino, 
+ handle, 
+ lastres_iloc.bh,
+ lastres_minode);
+ if (ret) {
+ ext4_error(sb, "ext4_delete_link_magic_inodes",
+ "shrink last reserved ino of group "
+ "%d failed.", group);
+ brelse(lastres_iloc.bh);
+ return -EFAULT;
+ }
+ printk("shrink group %d last reserved ino to %lu.\n",
+ group, le32_to_cpu(lastres_minode->mi_lastres_ino));
+ }
+ brelse(lastres_iloc.bh);
+ link_ino = next_ino + next_ressize - 1;
+ printk(KERN_DEBUG "try next link_ino: %lu\n", link_ino);
+ }
+
+ return 0;
+}
+
+
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f135b3b..c25f8b3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2044,6 +2044,10 @@ static int ext4_rmdir (struct inode * dir, struct
dentry *dentry)
if (!empty_dir (inode))
goto end_rmdir;

+ retval = ext4_delete_link_magic_inodes(handle, inode);
+ if (retval)
+ goto end_rmdir;
+
retval = ext4_delete_entry(handle, dir, de, bh);
if (retval)
goto end_rmdir;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9dd43d8..b385e2a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -729,7 +729,7 @@ static struct export_operations ext4_export_ops = {
enum {
Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
- Opt_nouid32, Opt_nocheck, Opt_debug, Opt_oldalloc, Opt_orlov,
+ Opt_nouid32, Opt_nocheck, Opt_debug, Opt_oldalloc, Opt_orlov,
Opt_inores,
Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
@@ -759,6 +759,7 @@ static match_table_t tokens = {
{Opt_debug, "debug"},
{Opt_oldalloc, "oldalloc"},
{Opt_orlov, "orlov"},
+ {Opt_inores, "inode_reservation"},
{Opt_user_xattr, "user_xattr"},
{Opt_nouser_xattr, "nouser_xattr"},
{Opt_acl, "acl"},
@@ -894,6 +895,9 @@ static int parse_options (char *options, struct
super_block *sb,
case Opt_orlov:
clear_opt (sbi->s_mount_opt, OLDALLOC);
break;
+ case Opt_inores:
+ set_opt (sbi->s_mount_opt, INORES);
+ break;
#ifdef CONFIG_EXT4DEV_FS_XATTR
case Opt_user_xattr:
set_opt (sbi->s_mount_opt, XATTR_USER);
@@ -1303,6 +1307,119 @@ static int ext4_check_descriptors (struct
super_block * sb)
return 1;
}

+/* Called at mount-time, super-block is locked 
+ * ext4_check_lastres_magic_inode() checks every
EXT4_MINODE_TYPE_LASTRES magic
+ * inode in each block group. 
+ */
+int ext4_check_lastres_magic_inode(struct super_block * sb)
+{
+ struct ext4_sb_info *sbi = EXT4_SB(sb);
+ struct ext4_group_desc *gdp = NULL;
+ struct buffer_head *bitmap_bh = NULL;
+ struct ext4_magic_inode * magic_inode;
+ struct ext4_iloc iloc;
+ int desc_block = 0;
+ unsigned long offset, prev_offset;
+ unsigned long itable_offset;
+ unsigned long lastres_ino;
+ int group;
+ int i;
+ 
+
+ ext4_debug("ext4_check_lastres_magic_inode");
+
+ for(group = 0; group < sbi->s_groups_count; group ++)
+ {
+ if((group % EXT4_DESC_PER_BLOCK(sb)) == 0)
+ gdp = (struct ext4_group_desc *)
+ sbi->s_group_desc[desc_block++]->b_data;
+
+ bitmap_bh = sb_bread(sb, ext4_inode_bitmap(sb, gdp));
+ if(!bitmap_bh) {
+ ext4_error (sb, "ext4_check_lastres_magic_inode",
+ "can not read inode bitmap for group %d",
+ group);
+ return 0;
+ }
+
+ lastres_ino = ext4_get_group_lastres_ino(sb, group);
+ itable_offset = (lastres_ino % EXT4_INODES_PER_GROUP(sb)) - 1;
+ if(ext4_test_bit(itable_offset, bitmap_bh->b_data)) {
+ if(ext4_get_magic_inode_loc(sb, lastres_ino, &iloc) < 0) {
+ ext4_error (sb, "ext4_check_lastres_magic_inode",
+ "failed to load inode block - inode %lu, "
+ "group %d", lastres_ino, group);
+ brelse(bitmap_bh);
+ return 0;
+ }
+ magic_inode = (struct ext4_magic_inode *)
+ ((char *)iloc.bh->b_data + iloc.offset);
+
+ if(!ext4_magic_inode(magic_inode, EXT4_MINODE_TYPE_LASTRES)) {
+ ext4_error(sb, "ext4_check_lastres_magic_inode",
+ "inode %lu in group %d is not "
+ "EXT4_MINODE_TYPE_LASTRES magic inode",
+ lastres_ino, group);
+ brelse(bitmap_bh);
+ brelse(iloc.bh);
+ return 0;
+ }
+ printk(KERN_DEBUG "group %d last reserved inode %lu.\n",
+ group, le32_to_cpu(magic_inode->mi_lastres_ino));
+ if(le32_to_cpu(magic_inode->mi_lastres_ino) > 
+ ((group + 1) * EXT4_INODES_PER_GROUP(sb))) {
+ ext4_error(sb, "ext4_check_lastres_magic_inode",
+ "last reserved inode %d is not in inode "
+ "table of group %d",
+ (int)le32_to_cpu(magic_inode->mi_lastres_ino), group);
+ brelse(bitmap_bh);
+ brelse(iloc.bh);
+ return 0;
+ }
+ i = EXT4_INODES_PER_GROUP(sb) - 
+ le32_to_cpu(gdp->bg_free_inodes_count);
+ for(prev_offset = 0, offset = 0; i > 0; i --, offset ++)
+ {
+ offset = find_next_bit((unsigned long *)bitmap_bh->b_data, 
+ EXT4_INODES_PER_GROUP(sb), offset);
+ if (offset != itable_offset)
+ prev_offset = offset;
+ }
+ offset --;
+ if(offset == itable_offset)
+ offset = prev_offset;
+ if(offset > (le32_to_cpu(magic_inode->mi_lastres_ino) - 1) % 
+ EXT4_INODES_PER_GROUP(sb)) {
+ printk(KERN_INFO "last reserved inode offset in "
+ "magic inode (group %d) does not match "
+ "in inode bitmap\n", group);
+ printk(KERN_INFO "set last reserved inode offset "
+ "from %d to %lu for group %d\n", 
+ (int)le32_to_cpu(magic_inode->mi_lastres_ino),
+ group * EXT4_INODES_PER_GROUP(sb) + offset, 
+ group);
+ magic_inode->mi_lastres_ino = 
+ cpu_to_le32(group * EXT4_INODES_PER_GROUP(sb) + 
+     offset);
+ mark_buffer_dirty(iloc.bh);
+ }
+ } else {
+ printk(KERN_INFO "can not find EXT4_MINODE_LASTRES magic "
+ "inode in group %d. Disable inode_reservaion now\n",
+ group);
+ clear_opt(sbi->s_mount_opt, INORES);
+ brelse(bitmap_bh);
+ return 1;
+ }
+ brelse(bitmap_bh);
+ brelse(iloc.bh);
+ gdp = (struct ext4_group_desc *)
+ ((__u8 *)gdp + EXT4_DESC_SIZE(sb));
+ }
+ 
+ return 1;
+}
+

/* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting
at
  * the superblock) which were deleted from all directories, but held
open by
@@ -1747,6 +1864,12 @@ static int ext4_fill_super (struct super_block
*sb, void *data, int silent)
printk(KERN_ERR "EXT4-fs: group descriptors corrupted!\n");
goto failed_mount2;
}
+ if(test_opt(sb, INORES) && !ext4_check_lastres_magic_inode(sb)) {
+ printk(KERN_ERR "EXT4-fs: EXT4_MINODE_TYPE_LASTRES "
+ "magic inodes correupted!\n");
+ goto failed_mount2;
+ }
+ 
sbi->s_gdb_count = db_count;
get_random_bytes(&sbi->s_next_generation, sizeof(u32));
spin_lock_init(&sbi->s_next_gen_lock);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 19635a4..fb7ebfe 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -352,6 +352,34 @@ struct ext4_inode {
__le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch)
*/
};

+/* 
+ * inode reservation for directories 
+ */
+#define EXT4_INIT_RESERVE_INODES 16
+
+#define EXT4_MINODE_MAGIC_STR "ext_magic_inode\0"
+#define EXT4_MINODE_MAGIC_LEN 16
+
+#define EXT4_MINODE_TYPE_LASTRES 0x0001
+#define EXT4_MINODE_TYPE_LINK 0x0002
+
+struct ext4_magic_inode {
+ __le32 mi_zeropad; /* Zero pad */
+ __u8 mi_magic[EXT4_MINODE_MAGIC_LEN];/* Magic string */
+ __le32 mi_checksum; /* Checksum for magic string */
+ __le32 mi_type; /* Type of magic inode */
+ __le32 mi_lastres_ino; /* Offset in inode table, for */
+ /* EXT4_MINODE_TYPE_LASTRES magic inode */
+ __le32 mi_next_ino; /* Inode number for head inode of next */
+ /* reserved inodes area */
+ __le32 mi_parent_ino; /* Dir inode number */
+ __le32 mi_parent_ctime; /* Dir inode ctime */
+ __le32 mi_current_ressize; /* Reserved inodes size for current
reserved */
+ /* inodes area */
+ __le32 mi_next_ressize; /* Reserved inodes size for next reserved */
+ /* inodes area */
+};
+
#define i_size_high i_dir_acl

#define EXT4_EPOCH_BITS 2
@@ -459,6 +487,7 @@ do {        \
#define EXT4_MOUNT_GRPQUOTA 0x200000 /* "old" group quota */
#define EXT4_MOUNT_EXTENTS 0x400000 /* Extents support */
#define EXT4_MOUNT_DELAYED_ALLOC 0x1000000/* Delayed allocation support
*/
+#define EXT4_MOUNT_INORES 0x2000000/* Inode reservation support */

/* Compatibility, for having both ext2_fs.h and ext4_fs.h included at
once */
#ifndef _LINUX_EXT2_FS_H
@@ -926,6 +955,8 @@ extern int  ext4_sync_inode (handle_t *, struct
inode *);
extern void ext4_discard_reservation (struct inode *);
extern void ext4_dirty_inode(struct inode *);
extern int ext4_change_inode_journal_flag(struct inode *, int);
+extern int ext4_magic_inode(struct ext4_magic_inode * , int);
+extern void ext4_init_magic_inode(struct ext4_magic_inode *, int);
extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
extern void ext4_truncate (struct inode *);
extern void ext4_set_inode_flags(struct inode *);
@@ -933,6 +964,13 @@ extern void ext4_set_aops(struct inode *inode);
extern int ext4_writepage_trans_blocks(struct inode *);
extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
struct address_space *mapping, loff_t from);
+extern int ext4_magic_inode(struct ext4_magic_inode * magic_inode, int
type);
+extern void ext4_init_magic_inode(struct ext4_magic_inode *
magic_inode, int type);
+extern unsigned long ext4_get_group_lastres_ino(struct super_block *
sb, int group);
+extern int ext4_get_magic_inode_loc(struct super_block * sb,
+ unsigned long ino, struct ext4_iloc * iloc);
+extern unsigned long ext4_unreserved_inodes(struct super_block *sb, int
group);
+int ext4_delete_link_magic_inodes(handle_t * handle, struct inode *
dir);

/* ioctl.c */
extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
@@ -952,6 +990,10 @@ extern int ext4_group_extend(struct super_block
*sb,
struct ext4_super_block *es,
ext4_fsblk_t n_blocks_count);

+/* bitmap.c */
+extern struct buffer_head *
+read_inode_bitmap(struct super_block * sb, unsigned long block_group);
+
/* super.c */
extern void ext4_error (struct super_block *, const char *, const char
*, ...)
__attribute__ ((format (printf, 3, 4)));
