From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 17/22] fs: add read_iter and write_iter to several file systems
Date: Mon, 22 Oct 2012 10:15:17 -0500
Message-ID: <1350918922-6096-18-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	"Maxim V. Patlasov" <mpatlasov@parallels.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	v9fs-developer@lists.sourceforge.net, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	reiserfs-devel@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

These are the simple ones.

File systems that use generic_file_aio_read() and generic_file_aio_write()
can trivially support generic_file_read_iter() and generic_file_write_iter().

This patch adds those file_operations for 9p, ext2, ext3, fat, hfs, hfsplus,
jfs, nilfs2, and reiserfs.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: v9fs-developer@lists.sourceforge.net
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux-nilfs@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
---
 fs/9p/vfs_file.c   | 4 ++++
 fs/ext2/file.c     | 2 ++
 fs/ext3/file.c     | 2 ++
 fs/fat/file.c      | 2 ++
 fs/hfs/inode.c     | 2 ++
 fs/hfsplus/inode.c | 2 ++
 fs/jfs/file.c      | 2 ++
 fs/nilfs2/file.c   | 2 ++
 fs/reiserfs/file.c | 2 ++
 9 files changed, 20 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c2483e9..d19458b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -748,6 +748,8 @@ const struct file_operations v9fs_cached_file_operations = {
 	.write = v9fs_cached_file_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
@@ -761,6 +763,8 @@ const struct file_operations v9fs_cached_file_operations_dotl = {
 	.write = v9fs_cached_file_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock_dotl,
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index a5b3a5d..eee8f86 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -66,6 +66,8 @@ const struct file_operations ext2_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 25cb413..86828f7 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -54,6 +54,8 @@ const struct file_operations ext3_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
diff --git a/fs/fat/file.c b/fs/fat/file.c
index a62e0ec..250d1b7 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -166,6 +166,8 @@ const struct file_operations fat_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
 	.unlocked_ioctl	= fat_generic_ioctl,
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 986cb91..f750dbe 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -656,8 +656,10 @@ static const struct file_operations hfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= hfs_file_fsync,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 94fc092..0191a0d 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -369,8 +369,10 @@ static const struct file_operations hfsplus_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= hfsplus_file_fsync,
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 9d3afd1..a49ede70 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -151,6 +151,8 @@ const struct file_operations jfs_file_operations = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 16f35f7..f4c58c9 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -155,6 +155,8 @@ const struct file_operations nilfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 8375c92..8f86c2b 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -306,6 +306,8 @@ const struct file_operations reiserfs_file_operations = {
 	.fsync = reiserfs_sync_file,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.splice_read = generic_file_splice_read,
 	.splice_write = generic_file_splice_write,
 	.llseek = generic_file_llseek,
-- 
1.7.12.3
