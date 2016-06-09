From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with current_fs_time()
Date: Wed,  8 Jun 2016 22:04:45 -0700
Message-ID: <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Bob Copeland <me@bobcopeland.com>,
 David Howells <dhowells@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-afs@lists.infradead.org, y2038@lists.linaro.org,
 codalist@coda.cs.cmu.edu, Christoph Hellwig <hch@infradead.org>,
 coda@cs.cmu.edu, linux-ext4@vger.kernel.org,
 Evgeniy Dushistov <dushistov@mail.ru>, Arnd Bergmann <arnd@arndb.de>,
 Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Harkes <jaharkes@cs.cmu.edu>,
 Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 Adrian Hunter <adrian.hunter@intel.com>, Jan Kara <jack@suse.com>,
 linux-mtd@lists.infradead.org, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-karma-devel@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

CURRENT_TIME_SEC is not y2038 safe. current_fs_time() will
be transitioned to use 64 bit time along with vfs in a
separate patch.
There is no plan to transistion CURRENT_TIME_SEC to use
y2038 safe time interfaces.

current_fs_time() will also be extended to use superblock
range checking parameters when range checking is introduced.

This works because alloc_super() fills in the the s_time_gran
in super block to NSEC_PER_SEC.

Also note that filesystem specific times like the birthtime,
creation time that were using same interfaces to obtain time
retain same logistics.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
Cc: Bob Copeland <me@bobcopeland.com>
Cc: linux-karma-devel@lists.sourceforge.net
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/affs/amigaffs.c      |  6 +++---
 fs/affs/inode.c         |  2 +-
 fs/afs/inode.c          |  3 +--
 fs/bfs/dir.c            | 18 ++++++++++--------
 fs/coda/dir.c           |  2 +-
 fs/coda/file.c          |  2 +-
 fs/coda/inode.c         |  2 +-
 fs/ext2/acl.c           |  2 +-
 fs/ext2/dir.c           |  6 +++---
 fs/ext2/ialloc.c        |  2 +-
 fs/ext2/inode.c         |  4 ++--
 fs/ext2/ioctl.c         |  5 +++--
 fs/ext2/namei.c         |  6 +++---
 fs/ext2/super.c         |  2 +-
 fs/ext2/xattr.c         |  2 +-
 fs/fat/dir.c            |  2 +-
 fs/fat/file.c           |  4 ++--
 fs/fat/inode.c          |  2 +-
 fs/fat/namei_msdos.c    | 13 +++++++------
 fs/fat/namei_vfat.c     | 10 +++++-----
 fs/hfs/catalog.c        |  8 ++++----
 fs/hfs/dir.c            |  2 +-
 fs/hfs/inode.c          |  2 +-
 fs/hfsplus/catalog.c    |  8 ++++----
 fs/hfsplus/dir.c        |  6 +++---
 fs/hfsplus/inode.c      |  2 +-
 fs/hfsplus/ioctl.c      |  2 +-
 fs/jffs2/acl.c          |  2 +-
 fs/jffs2/fs.c           |  2 +-
 fs/minix/bitmap.c       |  2 +-
 fs/minix/dir.c          | 12 +++++++-----
 fs/minix/itree_common.c |  4 ++--
 fs/minix/namei.c        |  4 ++--
 fs/omfs/dir.c           |  4 ++--
 fs/omfs/inode.c         |  2 +-
 fs/reiserfs/inode.c     |  2 +-
 fs/reiserfs/ioctl.c     |  4 ++--
 fs/reiserfs/namei.c     | 14 +++++++-------
 fs/reiserfs/stree.c     |  6 ++----
 fs/reiserfs/super.c     |  2 +-
 fs/reiserfs/xattr.c     |  2 +-
 fs/reiserfs/xattr_acl.c |  2 +-
 fs/sysv/dir.c           |  6 +++---
 fs/sysv/ialloc.c        |  2 +-
 fs/sysv/itree.c         |  4 ++--
 fs/sysv/namei.c         |  4 ++--
 fs/ufs/dir.c            |  6 +++---
 fs/ufs/ialloc.c         |  8 +++++---
 fs/ufs/inode.c          |  6 +++---
 fs/ufs/namei.c          |  6 +++---
 50 files changed, 118 insertions(+), 113 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index d6c7a51..015b62c 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -58,7 +58,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	mark_buffer_dirty_inode(dir_bh, dir);
 	affs_brelse(dir_bh);
 
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	dir->i_version++;
 	mark_inode_dirty(dir);
 
@@ -112,7 +112,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 
 	affs_brelse(bh);
 
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	dir->i_version++;
 	mark_inode_dirty(dir);
 
@@ -313,7 +313,7 @@ affs_remove_header(struct dentry *dentry)
 	else
 		clear_nlink(inode);
 	affs_unlock_link(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 
 done:
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0fdb0f5..cdd6d64 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -309,7 +309,7 @@ affs_new_inode(struct inode *dir)
 	inode->i_gid     = current_fsgid();
 	inode->i_ino     = block;
 	set_nlink(inode, 1);
-	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime   = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 86cc726..ce3374b 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -178,8 +178,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	set_nlink(inode, 2);
 	inode->i_uid		= GLOBAL_ROOT_UID;
 	inode->i_gid		= GLOBAL_ROOT_GID;
-	inode->i_ctime.tv_sec	= get_seconds();
-	inode->i_ctime.tv_nsec	= 0;
+	inode->i_ctime		= current_fs_time(sb);
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
 	inode->i_blocks		= 0;
 	inode->i_version	= 0;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 34a5bc2..fcbb2a4 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -97,7 +97,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	set_bit(ino, info->si_imap);
 	info->si_freei--;
 	inode_init_owner(inode, dir, mode);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(s);
 	inode->i_blocks = 0;
 	inode->i_op = &bfs_file_inops;
 	inode->i_fop = &bfs_file_operations;
@@ -154,7 +154,8 @@ static int bfs_link(struct dentry *old, struct inode *dir,
 						struct dentry *new)
 {
 	struct inode *inode = d_inode(old);
-	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
+	struct super_block *s = inode->i_sb;
+	struct bfs_sb_info *info = BFS_SB(s);
 	int err;
 
 	mutex_lock(&info->bfs_lock);
@@ -165,7 +166,7 @@ static int bfs_link(struct dentry *old, struct inode *dir,
 		return err;
 	}
 	inc_nlink(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(s);
 	mark_inode_dirty(inode);
 	ihold(inode);
 	d_instantiate(new, inode);
@@ -194,7 +195,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	de->ino = 0;
 	mark_buffer_dirty_inode(bh, dir);
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 	inode->i_ctime = dir->i_ctime;
 	inode_dec_link_count(inode);
@@ -249,10 +250,10 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 	old_de->ino = 0;
-	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+	old_dir->i_ctime = old_dir->i_mtime = current_fs_time(old_dir->i_sb);
 	mark_inode_dirty(old_dir);
 	if (new_inode) {
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = current_fs_time(new_dir->i_sb);
 		inode_dec_link_count(new_inode);
 	}
 	mark_buffer_dirty_inode(old_bh, old_dir);
@@ -278,6 +279,7 @@ static int bfs_add_entry(struct inode *dir, const unsigned char *name,
 {
 	struct buffer_head *bh;
 	struct bfs_dirent *de;
+	struct super_block *s = dir->i_sb;
 	int block, sblock, eblock, off, pos;
 	int i;
 
@@ -300,9 +302,9 @@ static int bfs_add_entry(struct inode *dir, const unsigned char *name,
 				pos = (block - sblock) * BFS_BSIZE + off;
 				if (pos >= dir->i_size) {
 					dir->i_size += BFS_DIRENT_SIZE;
-					dir->i_ctime = CURRENT_TIME_SEC;
+					dir->i_ctime = current_fs_time(s);
 				}
-				dir->i_mtime = CURRENT_TIME_SEC;
+				dir->i_mtime = current_fs_time(s);
 				mark_inode_dirty(dir);
 				de->ino = cpu_to_le16((u16)ino);
 				for (i = 0; i < BFS_NAMELEN; i++)
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 6fb8672..4f97929 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -109,7 +109,7 @@ static inline void coda_dir_update_mtime(struct inode *dir)
 	/* optimistically we can also act as if our nose bleeds. The
 	 * granularity of the mtime is coarse anyways so we might actually be
 	 * right most of the time. Note: we only do this for directories. */
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 #endif
 }
 
diff --git a/fs/coda/file.c b/fs/coda/file.c
index f47c748..8643545 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -75,7 +75,7 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
 	ret = vfs_iter_write(cfi->cfi_container, to, &iocb->ki_pos);
 	coda_inode->i_size = file_inode(host_file)->i_size;
 	coda_inode->i_blocks = (coda_inode->i_size + 511) >> 9;
-	coda_inode->i_mtime = coda_inode->i_ctime = CURRENT_TIME_SEC;
+	coda_inode->i_mtime = coda_inode->i_ctime = current_fs_time(coda_inode->i_sb);
 	inode_unlock(coda_inode);
 	file_end_write(host_file);
 	return ret;
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 57e81cb..3894447 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -271,7 +271,7 @@ int coda_setattr(struct dentry *de, struct iattr *iattr)
 
 	memset(&vattr, 0, sizeof(vattr)); 
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	coda_iattr_to_vattr(iattr, &vattr);
 	vattr.va_type = C_VNON; /* cannot set type */
 
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 42f1d18..3b1a030 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -194,7 +194,7 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 				if (error < 0)
 					return error;
 				else {
-					inode->i_ctime = CURRENT_TIME_SEC;
+					inode->i_ctime = current_fs_time(inode->i_sb);
 					mark_inode_dirty(inode);
 					if (error == 0)
 						acl = NULL;
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 19efd11..3fa63ab 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -471,7 +471,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	err = ext2_commit_chunk(page, pos, len);
 	ext2_put_page(page);
 	if (update_times)
-		dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+		dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
 }
@@ -561,7 +561,7 @@ got_it:
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
 	err = ext2_commit_chunk(page, pos, rec_len);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
@@ -610,7 +610,7 @@ int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
 		pde->rec_len = ext2_rec_len_to_disk(to - from);
 	dir->inode = 0;
 	err = ext2_commit_chunk(page, pos, to - from);
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 	EXT2_I(inode)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(inode);
 out:
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index efe5fb2..13d88a2 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -551,7 +551,7 @@ got:
 
 	inode->i_ino = ino;
 	inode->i_blocks = 0;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_flags =
 		ext2_mask_flags(mode, EXT2_I(dir)->i_flags & EXT2_FL_INHERITED);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fcbe586..f5f655c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -594,7 +594,7 @@ static void ext2_splice_branch(struct inode *inode,
 	if (where->bh)
 		mark_buffer_dirty_inode(where->bh, inode);
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 }
 
@@ -1236,7 +1236,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	__ext2_truncate_blocks(inode, newsize);
 	dax_sem_up_write(EXT2_I(inode));
 
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		sync_inode_metadata(inode, 1);
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index b386af2..1cbb75b 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -21,6 +21,7 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	struct ext2_inode_info *ei = EXT2_I(inode);
+	struct super_block *sb = inode->i_sb;
 	unsigned int flags;
 	unsigned short rsv_window_size;
 	int ret;
@@ -79,7 +80,7 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		ei->i_flags = flags;
 
 		ext2_set_inode_flags(inode);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = current_fs_time(sb);
 		inode_unlock(inode);
 
 		mark_inode_dirty(inode);
@@ -103,7 +104,7 @@ setflags_out:
 		}
 
 		inode_lock(inode);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = current_fs_time(sb);
 		inode->i_generation = generation;
 		inode_unlock(inode);
 
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index d446203..7109cb3 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -221,7 +221,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	if (err)
 		return err;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	inode_inc_link_count(inode);
 	ihold(inode);
 
@@ -372,7 +372,7 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		if (!new_de)
 			goto out_dir;
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		if (dir_de)
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
@@ -388,7 +388,7 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	 * Like most other Unix systems, set the ctime for inodes on a
  	 * rename.
 	 */
-	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_ctime = current_fs_time(old_inode->i_sb);
 	mark_inode_dirty(old_inode);
 
 	ext2_delete_entry (old_de, old_page);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1d93795..3ead2de 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1543,7 +1543,7 @@ out:
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mtime = inode->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 	return len - towrite;
 }
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 1a5e3bf..8ff1494 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -691,7 +691,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 
 	/* Update the inode. */
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(sb);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 663e428..eb0ecb0 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1071,7 +1071,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		}
 	}
 
-	dir->i_mtime = dir->i_atime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_atime = current_fs_time(sb);
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
diff --git a/fs/fat/file.c b/fs/fat/file.c
index f701856..1f9f172 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -194,7 +194,7 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 	if (err)
 		goto out;
 
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		int err2;
@@ -297,7 +297,7 @@ static int fat_free(struct inode *inode, int skip)
 		MSDOS_I(inode)->i_logstart = 0;
 	}
 	MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(sb);
 	if (wait) {
 		err = fat_sync_inode(inode);
 		if (err) {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3bcf579..7dd9af7 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -237,7 +237,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	if (err < len)
 		fat_write_failed(mapping, pos + len);
 	if (!(err < 0) && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
-		inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 		MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index b7e2b33..c54888f 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -283,7 +283,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		goto out;
 	}
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(sb);
 	err = msdos_add_entry(dir, msdos_name, 0, is_hid, 0, &ts, &sinfo);
 	if (err)
 		goto out;
@@ -330,7 +330,7 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 
 	clear_nlink(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(sb);
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -364,7 +364,7 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out;
 	}
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(sb);
 	cluster = fat_alloc_new_dir(dir, &ts);
 	if (cluster < 0) {
 		err = cluster;
@@ -416,7 +416,7 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 	clear_nlink(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(sb);
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -481,7 +481,8 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 				mark_inode_dirty(old_inode);
 
 			old_dir->i_version++;
-			old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+			old_dir->i_ctime = old_dir->i_mtime =
+				current_fs_time(old_dir->i_sb);
 			if (IS_DIRSYNC(old_dir))
 				(void)fat_sync_inode(old_dir);
 			else
@@ -490,7 +491,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		}
 	}
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(new_inode->i_sb);
 	if (new_inode) {
 		if (err)
 			goto out;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 7092584..cad8666 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -777,7 +777,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(sb);
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
 	if (err)
 		goto out;
@@ -821,7 +821,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 
 	clear_nlink(inode);
-	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = current_fs_time(sb);
 	fat_detach(inode);
 	dentry->d_time = dir->i_version;
 out:
@@ -847,7 +847,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 	clear_nlink(inode);
-	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = current_fs_time(sb);
 	fat_detach(inode);
 	dentry->d_time = dir->i_version;
 out:
@@ -866,7 +866,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(sb);
 	cluster = fat_alloc_new_dir(dir, &ts);
 	if (cluster < 0) {
 		err = cluster;
@@ -931,7 +931,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
-	ts = CURRENT_TIME_SEC;
+	ts = current_fs_time(sb);
 	if (new_inode) {
 		if (is_dir) {
 			err = fat_dir_empty(new_inode);
diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index 98cde8b..0fabf66 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -125,7 +125,7 @@ int hfs_cat_create(u32 cnid, struct inode *dir, struct qstr *str, struct inode *
 		goto err1;
 
 	dir->i_size++;
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(dir);
 	hfs_find_exit(&fd);
 	return 0;
@@ -261,7 +261,7 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, struct qstr *str)
 	}
 
 	dir->i_size--;
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(dir);
 	res = 0;
 out:
@@ -321,7 +321,7 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
 	if (err)
 		goto out;
 	dst_dir->i_size++;
-	dst_dir->i_mtime = dst_dir->i_ctime = CURRENT_TIME_SEC;
+	dst_dir->i_mtime = dst_dir->i_ctime = current_fs_time(dst_dir->i_sb);
 	mark_inode_dirty(dst_dir);
 
 	/* finally remove the old entry */
@@ -333,7 +333,7 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
 	if (err)
 		goto out;
 	src_dir->i_size--;
-	src_dir->i_mtime = src_dir->i_ctime = CURRENT_TIME_SEC;
+	src_dir->i_mtime = src_dir->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(src_dir);
 
 	type = entry.type;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 163190e..d64c536 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -268,7 +268,7 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	if (res)
 		return res;
 	clear_nlink(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	hfs_delete_inode(inode);
 	mark_inode_dirty(inode);
 	return 0;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 8eed66a..b30b6d2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -193,7 +193,7 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, umode_t mode)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 	set_nlink(inode, 1);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
 	HFS_I(inode)->fs_blocks = 0;
diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index fb707e8..b2f9093 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -303,7 +303,7 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 	dir->i_size++;
 	if (S_ISDIR(inode->i_mode))
 		hfsplus_subfolders_inc(dir);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
 
 	hfs_find_exit(&fd);
@@ -400,7 +400,7 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 	dir->i_size--;
 	if (type == HFSPLUS_FOLDER)
 		hfsplus_subfolders_dec(dir);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
 
 	if (type == HFSPLUS_FILE || type == HFSPLUS_FOLDER) {
@@ -469,7 +469,7 @@ int hfsplus_rename_cat(u32 cnid,
 	dst_dir->i_size++;
 	if (type == HFSPLUS_FOLDER)
 		hfsplus_subfolders_inc(dst_dir);
-	dst_dir->i_mtime = dst_dir->i_ctime = CURRENT_TIME_SEC;
+	dst_dir->i_mtime = dst_dir->i_ctime = current_fs_time(dst_dir->i_sb);
 
 	/* finally remove the old entry */
 	err = hfsplus_cat_build_key(sb, src_fd.search_key,
@@ -486,7 +486,7 @@ int hfsplus_rename_cat(u32 cnid,
 	src_dir->i_size--;
 	if (type == HFSPLUS_FOLDER)
 		hfsplus_subfolders_dec(src_dir);
-	src_dir->i_mtime = src_dir->i_ctime = CURRENT_TIME_SEC;
+	src_dir->i_mtime = src_dir->i_ctime = current_fs_time(sb);
 
 	/* remove old thread entry */
 	hfsplus_cat_build_key_with_cnid(sb, src_fd.search_key, cnid);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 42e1286..f5b40db 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -347,7 +347,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
 	ihold(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 	sbi->file_count++;
 	hfsplus_mark_mdb_dirty(dst_dir->i_sb);
@@ -406,7 +406,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 			hfsplus_delete_inode(inode);
 	} else
 		sbi->file_count--;
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 out:
 	mutex_unlock(&sbi->vh_mutex);
@@ -427,7 +427,7 @@ static int hfsplus_rmdir(struct inode *dir, struct dentry *dentry)
 	if (res)
 		goto out;
 	clear_nlink(inode);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	hfsplus_delete_inode(inode);
 	mark_inode_dirty(inode);
 out:
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index ef9fefe..d0f0ee2 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -369,7 +369,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 	set_nlink(inode, 1);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 
 	hip = HFSPLUS_I(inode);
 	INIT_LIST_HEAD(&hip->open_dir_list);
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index 32a49e2..7b4820b 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -122,7 +122,7 @@ static int hfsplus_ioctl_setflags(struct file *file, int __user *user_flags)
 	else
 		hip->userflags &= ~HFSPLUS_FLG_NODUMP;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 
 out_unlock_inode:
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index bc2693d..f8c7308 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -242,7 +242,7 @@ int jffs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 
 				attr.ia_valid = ATTR_MODE | ATTR_CTIME;
 				attr.ia_mode = mode;
-				attr.ia_ctime = CURRENT_TIME_SEC;
+				attr.ia_ctime = current_fs_time(inode->i_sb);
 				rc = jffs2_do_setattr(inode, &attr);
 				if (rc < 0)
 					return rc;
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index ae2ebb2..2ce4091 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -472,7 +472,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	inode->i_mode = jemode_to_cpu(ri->mode);
 	i_gid_write(inode, je16_to_cpu(ri->gid));
 	i_uid_write(inode, je16_to_cpu(ri->uid));
-	inode->i_atime = inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_atime = inode->i_ctime = inode->i_mtime = current_fs_time(sb);
 	ri->atime = ri->mtime = ri->ctime = cpu_to_je32(I_SEC(inode->i_mtime));
 
 	inode->i_blocks = 0;
diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 742942a..0e72667 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -253,7 +253,7 @@ struct inode *minix_new_inode(const struct inode *dir, umode_t mode, int *error)
 	}
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = j;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	inode->i_blocks = 0;
 	memset(&minix_i(inode)->u, 0, sizeof(minix_i(inode)->u));
 	insert_inode_hash(inode);
diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 31dcd51..d86a1aa 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -274,7 +274,7 @@ got_it:
 		de->inode = inode->i_ino;
 	}
 	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(dir);
 out_put:
 	dir_put_page(page);
@@ -290,7 +290,8 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 	struct inode *inode = page->mapping->host;
 	char *kaddr = page_address(page);
 	loff_t pos = page_offset(page) + (char*)de - kaddr;
-	struct minix_sb_info *sbi = minix_sb(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct minix_sb_info *sbi = minix_sb(sb);
 	unsigned len = sbi->s_dirsize;
 	int err;
 
@@ -306,7 +307,7 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 		unlock_page(page);
 	}
 	dir_put_page(page);
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 	return err;
 }
@@ -412,7 +413,8 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
 	struct inode *dir = page->mapping->host;
-	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
+	struct super_block *sb = dir->i_sb;
+	struct minix_sb_info *sbi = minix_sb(sb);
 	loff_t pos = page_offset(page) +
 			(char *)de-(char*)page_address(page);
 	int err;
@@ -430,7 +432,7 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
 		unlock_page(page);
 	}
 	dir_put_page(page);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(dir);
 }
 
diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index a731cab..89d9288 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -124,7 +124,7 @@ static inline int splice_branch(struct inode *inode,
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
@@ -343,7 +343,7 @@ do_indirects:
 		}
 		first_whole++;
 	}
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 }
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 2887d1d..547fc16 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -106,7 +106,7 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 {
 	struct inode *inode = d_inode(old_dentry);
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	inode_inc_link_count(inode);
 	ihold(inode);
 	return add_nondir(dentry, inode);
@@ -219,7 +219,7 @@ static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
 		if (!new_de)
 			goto out_dir;
 		minix_set_link(new_de, new_page, old_inode);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		if (dir_de)
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index c8cbf3b..ce3e6eb 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -143,7 +143,7 @@ static int omfs_add_link(struct dentry *dentry, struct inode *inode)
 	mark_buffer_dirty(bh);
 	brelse(bh);
 
-	dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_ctime = current_fs_time(dir->i_sb);
 
 	/* mark affected inodes dirty to rebuild checksums */
 	mark_inode_dirty(dir);
@@ -395,7 +395,7 @@ static int omfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (err)
 		goto out;
 
-	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_ctime = current_fs_time(old_inode->i_sb);
 	mark_inode_dirty(old_inode);
 out:
 	return err;
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 3d935c8..0f0b65e 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -49,7 +49,7 @@ struct inode *omfs_new_inode(struct inode *dir, umode_t mode)
 	inode_init_owner(inode, NULL, mode);
 	inode->i_mapping->a_ops = &omfs_aops;
 
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		inode->i_op = &omfs_dir_inops;
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 825455d..a70378d 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2005,7 +2005,7 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 	if (S_ISLNK(inode->i_mode))
 		inode->i_flags &= ~(S_IMMUTABLE | S_APPEND);
 
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	inode->i_size = i_size;
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 2f1ddc9..30faa08 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -94,7 +94,7 @@ long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 			sd_attrs_to_i_attrs(flags, inode);
 			REISERFS_I(inode)->i_attrs = flags;
-			inode->i_ctime = CURRENT_TIME_SEC;
+			inode->i_ctime = current_fs_time(inode->i_sb);
 			mark_inode_dirty(inode);
 setflags_out:
 			mnt_drop_write_file(filp);
@@ -115,7 +115,7 @@ setflags_out:
 			err = -EFAULT;
 			goto setversion_out;
 		}
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = current_fs_time(inode->i_sb);
 		mark_inode_dirty(inode);
 setversion_out:
 		mnt_drop_write_file(filp);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 8a36696..d9e54b4 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -570,7 +570,7 @@ static int reiserfs_add_entry(struct reiserfs_transaction_handle *th,
 	}
 
 	dir->i_size += paste_size;
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	if (!S_ISDIR(inode->i_mode) && visible)
 		/* reiserfs_mkdir or reiserfs_rename will do that by itself */
 		reiserfs_update_sd(th, dir);
@@ -963,7 +963,7 @@ static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 			       inode->i_nlink);
 
 	clear_nlink(inode);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(inode->i_sb);
 	reiserfs_update_sd(&th, inode);
 
 	DEC_DIR_INODE_NLINK(dir)
@@ -1067,11 +1067,11 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 		inc_nlink(inode);
 		goto end_unlink;
 	}
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	reiserfs_update_sd(&th, inode);
 
 	dir->i_size -= (de.de_entrylen + DEH_SIZE);
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	reiserfs_update_sd(&th, dir);
 
 	if (!savelink)
@@ -1246,7 +1246,7 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 		return err ? err : retval;
 	}
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	reiserfs_update_sd(&th, inode);
 
 	ihold(inode);
@@ -1567,14 +1567,14 @@ static int reiserfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	mark_de_hidden(old_de.de_deh + old_de.de_entry_num);
 	journal_mark_dirty(&th, old_de.de_bh);
-	ctime = CURRENT_TIME_SEC;
+	ctime = current_fs_time(old_dir->i_sb);
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
 	/*
 	 * thanks to Alex Adriaanse <alex_a@caltech.edu> for patch
 	 * which adds ctime update of renamed object
 	 */
-	old_inode->i_ctime = ctime;
+	old_inode->i_ctime = current_fs_time(old_inode->i_sb);
 
 	if (new_dentry_inode) {
 		/* adjust link number of the victim */
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 5feacd6..7aebba07 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1987,8 +1987,7 @@ int reiserfs_do_truncate(struct reiserfs_transaction_handle *th,
 			pathrelse(&s_search_path);
 
 			if (update_timestamps) {
-				inode->i_mtime = CURRENT_TIME_SEC;
-				inode->i_ctime = CURRENT_TIME_SEC;
+				inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 			}
 			reiserfs_update_sd(th, inode);
 
@@ -2012,8 +2011,7 @@ int reiserfs_do_truncate(struct reiserfs_transaction_handle *th,
 update_and_out:
 	if (update_timestamps) {
 		/* this is truncate, not file closing */
-		inode->i_mtime = CURRENT_TIME_SEC;
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 	}
 	reiserfs_update_sd(th, inode);
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index c72c16c..dd58cf9 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2512,7 +2512,7 @@ out:
 	if (inode->i_size < off + len - towrite)
 		i_size_write(inode, off + len - towrite);
 	inode->i_version++;
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mtime = inode->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 	return len - towrite;
 }
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index a33812a..ada620b 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -456,7 +456,7 @@ static void update_ctime(struct inode *inode)
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 }
 
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index dbed42f..cf826f6 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -277,7 +277,7 @@ __reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
 	if (error == -ENODATA) {
 		error = 0;
 		if (type == ACL_TYPE_ACCESS) {
-			inode->i_ctime = CURRENT_TIME_SEC;
+			inode->i_ctime = current_fs_time(inode->i_sb);
 			mark_inode_dirty(inode);
 		}
 	}
diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 2661b77..d4f60f4 100644
--- a/fs/sysv/dir.c
+++ b/fs/sysv/dir.c
@@ -215,7 +215,7 @@ got_it:
 	memset (de->name + namelen, 0, SYSV_DIRSIZE - namelen - 2);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
 	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 out_page:
 	dir_put_page(page);
@@ -239,7 +239,7 @@ int sysv_delete_entry(struct sysv_dir_entry *de, struct page *page)
 	de->inode = 0;
 	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 	return err;
 }
@@ -337,7 +337,7 @@ void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
 	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 }
 
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index f9db4eb..8d2ea17 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -164,7 +164,7 @@ struct inode * sysv_new_inode(const struct inode * dir, umode_t mode)
 	dirty_sb(sb);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = fs16_to_cpu(sbi, ino);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	inode->i_blocks = 0;
 	memset(SYSV_I(inode)->i_data, 0, sizeof(SYSV_I(inode)->i_data));
 	SYSV_I(inode)->i_dir_start_lookup = 0;
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 2fde40a..2654a3d 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -178,7 +178,7 @@ static inline int splice_branch(struct inode *inode,
 	*where->p = where->key;
 	write_unlock(&pointers_lock);
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
@@ -418,7 +418,7 @@ do_indirects:
 		}
 		n++;
 	}
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (IS_SYNC(inode))
 		sysv_sync_inode (inode);
 	else
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 90b60c0..028100d 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -120,7 +120,7 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 {
 	struct inode *inode = d_inode(old_dentry);
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	inode_inc_link_count(inode);
 	ihold(inode);
 
@@ -240,7 +240,7 @@ static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
 		if (!new_de)
 			goto out_dir;
 		sysv_set_link(new_de, new_page, old_inode);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		if (dir_de)
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 57dcced..2f9a600 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -100,7 +100,7 @@ void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 	err = ufs_commit_chunk(page, pos, len);
 	ufs_put_page(page);
 	if (update_times)
-		dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+		dir->i_mtime = dir->i_ctime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 }
 
@@ -395,7 +395,7 @@ got_it:
 	ufs_set_de_type(sb, de, inode->i_mode);
 
 	err = ufs_commit_chunk(page, pos, rec_len);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = current_fs_time(sb);
 
 	mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
@@ -545,7 +545,7 @@ int ufs_delete_entry(struct inode *inode, struct ufs_dir_entry *dir,
 		pde->d_reclen = cpu_to_fs16(sb, to - from);
 	dir->d_ino = 0;
 	err = ufs_commit_chunk(page, pos, to - from);
-	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = inode->i_mtime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 out:
 	ufs_put_page(page);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index fd0203c..6cbf2e3 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -176,6 +176,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	struct inode * inode;
+	struct timespec ts;
 	unsigned cg, bit, i, j, start;
 	struct ufs_inode_info *ufsi;
 	int err = -ENOSPC;
@@ -290,7 +291,7 @@ cg_found:
 	inode_init_owner(inode, dir, mode);
 	inode->i_blocks = 0;
 	inode->i_generation = 0;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_fs_time(sb);
 	ufsi->i_flags = UFS_I(dir)->i_flags;
 	ufsi->i_lastfrag = 0;
 	ufsi->i_shadow = 0;
@@ -323,8 +324,9 @@ cg_found:
 		lock_buffer(bh);
 		ufs2_inode = (struct ufs2_inode *)bh->b_data;
 		ufs2_inode += ufs_inotofsbo(inode->i_ino);
-		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, CURRENT_TIME.tv_sec);
-		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, CURRENT_TIME.tv_nsec);
+		ts = current_fs_time(sb);
+		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, ts.tv_sec);
+		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, ts.tv_nsec);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		if (sb->s_flags & MS_SYNCHRONOUS)
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 9f49431..f0c6fb5 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -293,7 +293,7 @@ ufs_inode_getfrag(struct inode *inode, unsigned index,
 
 	if (new)
 		*new = 1;
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(sb);
 	if (IS_SYNC(inode))
 		ufs_sync_inode (inode);
 	mark_inode_dirty(inode);
@@ -375,7 +375,7 @@ ufs_inode_getblock(struct inode *inode, u64 ind_block,
 	mark_buffer_dirty(bh);
 	if (IS_SYNC(inode))
 		sync_dirty_buffer(bh);
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(sb);
 	mark_inode_dirty(inode);
 out:
 	brelse (bh);
@@ -1185,7 +1185,7 @@ static int ufs_truncate(struct inode *inode, loff_t size)
 	truncate_setsize(inode, size);
 
 	__ufs_truncate_blocks(inode);
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
 out:
 	UFSD("EXIT: err %d\n", err);
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index a1559f7..eea9b7a 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -153,7 +153,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = d_inode(old_dentry);
 	int error;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = current_fs_time(inode->i_sb);
 	inode_inc_link_count(inode);
 	ihold(inode);
 
@@ -279,7 +279,7 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!new_de)
 			goto out_dir;
 		ufs_set_link(new_dir, new_de, new_page, old_inode, 1);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		if (dir_de)
 			drop_nlink(new_inode);
 		inode_dec_link_count(new_inode);
@@ -295,7 +295,7 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * Like most other Unix systems, set the ctime for inodes on a
  	 * rename.
 	 */
-	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_ctime = current_fs_time(old_inode->i_sb);
 
 	ufs_delete_entry(old_dir, old_de, old_page);
 	mark_inode_dirty(old_inode);
-- 
1.9.1


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
