From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 5/8] fat: remove lock/unlock super
Date: Thu, 16 Aug 2012 12:03:30 +0200
Message-ID: <502CC572.4040202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52363 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2HPKJ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 06:09:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marco Stornelli <marco.stornelli@gmail.com>

Replaced lock and unlock super with a new fs mutex s_lock.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/fat/dir.c linux-3.6-rc1/fs/fat/dir.c
--- linux-3.6-rc1-orig/fs/fat/dir.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/fat/dir.c	2012-08-16 09:57:24.000000000 +0200
@@ -568,7 +568,7 @@ static int __fat_readdir(struct inode *i
 	int short_len = 0, fill_len = 0;
 	int ret = 0;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	cpos = filp->f_pos;
 	/* Fake . and .. for the root directory. */
@@ -689,7 +689,7 @@ fill_failed:
 	if (unicode)
 		__putname(unicode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return ret;
 }
 
diff -Nurp linux-3.6-rc1-orig/fs/fat/fat.h linux-3.6-rc1/fs/fat/fat.h
--- linux-3.6-rc1-orig/fs/fat/fat.h	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/fat/fat.h	2012-08-16 09:56:36.000000000 +0200
@@ -69,6 +69,7 @@ struct msdos_sb_info {
 	unsigned long root_cluster;  /* first cluster of the root directory */
 	unsigned long fsinfo_sector; /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
+	struct mutex s_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
diff -Nurp linux-3.6-rc1-orig/fs/fat/inode.c linux-3.6-rc1/fs/fat/inode.c
--- linux-3.6-rc1-orig/fs/fat/inode.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/fat/inode.c	2012-08-16 11:10:46.000000000 +0200
@@ -634,9 +634,9 @@ static int fat_write_inode(struct inode
 	if (inode->i_ino == MSDOS_FSINFO_INO) {
 		struct super_block *sb = inode->i_sb;
 
-		lock_super(sb);
+		mutex_lock(&MSDOS_SB(sb)->s_lock);
 		err = fat_clusters_flush(sb);
-		unlock_super(sb);
+		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
 		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 
@@ -762,7 +762,7 @@ static struct dentry *fat_get_parent(str
 	struct inode *inode;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
 	if (err) {
@@ -774,7 +774,7 @@ static struct dentry *fat_get_parent(str
 
 	parent = d_obtain_alias(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return parent;
 }
@@ -1332,6 +1332,7 @@ int fat_fill_super(struct super_block *s
 		b = (struct fat_boot_sector *) bh->b_data;
 	}
 
+	mutex_init(&sbi->s_lock);
 	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
 	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
 	sbi->fats = b->fats;
diff -Nurp linux-3.6-rc1-orig/fs/fat/namei_msdos.c linux-3.6-rc1/fs/fat/namei_msdos.c
--- linux-3.6-rc1-orig/fs/fat/namei_msdos.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/fat/namei_msdos.c	2012-08-16 11:12:25.000000000 +0200
@@ -208,7 +208,7 @@ static struct dentry *msdos_lookup(struc
 	struct inode *inode;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	switch (err) {
 	case -ENOENT:
@@ -221,7 +221,7 @@ static struct dentry *msdos_lookup(struc
 	default:
 		inode = ERR_PTR(err);
 	}
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return d_splice_alias(inode, dentry);
 }
 
@@ -273,7 +273,7 @@ static int msdos_create(struct inode *di
 	unsigned char msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -302,7 +302,7 @@ static int msdos_create(struct inode *di
 
 	d_instantiate(dentry, inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 	return err;
@@ -316,7 +316,7 @@ static int msdos_rmdir(struct inode *dir
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	/*
 	 * Check whether the directory is not in use, then check
 	 * whether it is empty.
@@ -337,7 +337,7 @@ static int msdos_rmdir(struct inode *dir
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 
@@ -354,7 +354,7 @@ static int msdos_mkdir(struct inode *dir
 	struct timespec ts;
 	int err, is_hid, cluster;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -392,14 +392,14 @@ static int msdos_mkdir(struct inode *dir
 
 	d_instantiate(dentry, inode);
 
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	fat_flush_inodes(sb, dir, inode);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -411,7 +411,7 @@ static int msdos_unlink(struct inode *di
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (err)
 		goto out;
@@ -423,7 +423,7 @@ static int msdos_unlink(struct inode *di
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 
@@ -607,7 +607,7 @@ static int msdos_rename(struct inode *ol
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(old_dentry->d_name.name,
 				old_dentry->d_name.len, old_msdos_name,
@@ -626,7 +626,7 @@ static int msdos_rename(struct inode *ol
 	err = do_msdos_rename(old_dir, old_msdos_name, old_dentry,
 			      new_dir, new_msdos_name, new_dentry, is_hid);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!err)
 		err = fat_flush_inodes(sb, old_dir, new_dir);
 	return err;
diff -Nurp linux-3.6-rc1-orig/fs/fat/namei_vfat.c linux-3.6-rc1/fs/fat/namei_vfat.c
--- linux-3.6-rc1-orig/fs/fat/namei_vfat.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/fat/namei_vfat.c	2012-08-16 11:13:50.000000000 +0200
@@ -721,7 +721,7 @@ static struct dentry *vfat_lookup(struct
 	struct dentry *alias;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err) {
@@ -752,13 +752,13 @@ static struct dentry *vfat_lookup(struct
 		if (!S_ISDIR(inode->i_mode))
 			d_move(alias, dentry);
 		iput(inode);
-		unlock_super(sb);
+		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 		return alias;
 	} else
 		dput(alias);
 
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
@@ -766,7 +766,7 @@ out:
 	return dentry;
 
 error:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return ERR_PTR(err);
 }
 
@@ -779,7 +779,7 @@ static int vfat_create(struct inode *dir
 	struct timespec ts;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	ts = CURRENT_TIME_SEC;
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
@@ -800,7 +800,7 @@ static int vfat_create(struct inode *dir
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -811,7 +811,7 @@ static int vfat_rmdir(struct inode *dir,
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = fat_dir_empty(inode);
 	if (err)
@@ -829,7 +829,7 @@ static int vfat_rmdir(struct inode *dir,
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 }
@@ -841,7 +841,7 @@ static int vfat_unlink(struct inode *dir
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err)
@@ -854,7 +854,7 @@ static int vfat_unlink(struct inode *dir
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 }
@@ -867,7 +867,7 @@ static int vfat_mkdir(struct inode *dir,
 	struct timespec ts;
 	int err, cluster;
 
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	ts = CURRENT_TIME_SEC;
 	cluster = fat_alloc_new_dir(dir, &ts);
@@ -896,13 +896,13 @@ static int vfat_mkdir(struct inode *dir,
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return err;
 }
 
@@ -921,7 +921,7 @@ static int vfat_rename(struct inode *old
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
-	lock_super(sb);
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo);
 	if (err)
 		goto out;
@@ -997,7 +997,7 @@ out:
 	brelse(sinfo.bh);
 	brelse(dotdot_bh);
 	brelse(old_sinfo.bh);
-	unlock_super(sb);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
 	return err;
 

