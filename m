From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 21/21] fs: add read_iter and
	write_iter to more file systems
Date: Fri, 30 Mar 2012 10:43:48 -0500
Message-ID: <1333122228-13633-22-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	reiserfs-devel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, Zach Brown <zab@zabbo.net>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-fsdevel@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

File systems that use generic_file_aio_read() and generic_file_aio_write()
can trivially support generic_file_read_iter() and generic_file_write_iter().

This patch adds those file_operations for 9p, ext2, fat, hfs, hfsplus,
jfs, nilfs2, and reiserfs.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: v9fs-developer@lists.sourceforge.net
Cc: linux-ext4@vger.kernel.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux-nilfs@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
---
 fs/9p/vfs_file.c   |    4 ++++
 fs/ext2/file.c     |    2 ++
 fs/fat/file.c      |    2 ++
 fs/hfs/inode.c     |    2 ++
 fs/hfsplus/inode.c |    2 ++
 fs/jfs/file.c      |    2 ++
 fs/nilfs2/file.c   |    2 ++
 fs/reiserfs/file.c |    2 ++
 8 files changed, 18 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index fc06fd2..27a76d5 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -744,6 +744,8 @@ const struct file_operations v9fs_cached_file_operations = {
 	.write = v9fs_cached_file_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
@@ -757,6 +759,8 @@ const struct file_operations v9fs_cached_file_operations_dotl = {
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
diff --git a/fs/fat/file.c b/fs/fat/file.c
index a71fe37..e602729 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -167,6 +167,8 @@ const struct file_operations fat_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
 	.unlocked_ioctl	= fat_generic_ioctl,
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 96650e7..42796b8 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -662,8 +662,10 @@ static const struct file_operations hfs_file_operations = {
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
index 76e3f8e..b53d2bb 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -368,8 +368,10 @@ static const struct file_operations hfsplus_file_operations = {
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
index 844f946..7a5af5e 100644
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
index 2660152..c884ba5 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -146,6 +146,8 @@ const struct file_operations nilfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index ace6350..686f0a3 100644
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
1.7.9.5


------------------------------------------------------------------------------
This SF email is sponsosred by:
Try Windows Azure free for 90 days Click Here 
http://p.sf.net/sfu/sfd2d-msazure
