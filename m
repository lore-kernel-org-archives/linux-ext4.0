From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] xstat: Implement a requestable extra result to procure
	some inode flags [ver #4]
Date: Fri, 02 Jul 2010 00:57:38 +0100
Message-ID: <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

[This is, for the moment, to be considered an example.  Do we actually want to
 export these flags?  Should they be a full member of struct xstat?]

Allow an extra result to be requested that makes available some inode flags,
along the lines of BSD's st_flags and Ext2/3/4's inode flags.  This is
requested by setting XSTAT_REQUEST_INODE_FLAGS in the request_mask.  If the
filesystem supports it for that file, then this will be set in result_mask and
16 bytes of information will be appended to the xstat buffer, if sufficient
buffer space is available.

The extra result is laid out according to the following structure:

	struct xstat_inode_flags {
		unsigned long long	st_flags;
		unsigned long long	st_supported_flags;
	};

where the filesystem indicates the flags it supports for that file and the
flags that are set on that file.  The structure is of length:

	XSTAT_LENGTH_INODE_FLAGS

The flags come in three sets:

 (1) User settable flags (to be consistent with the BSD st_flags field):

	UF_NODUMP	Do not dump this file.
	UF_IMMUTABLE	This file is immutable.
	UF_APPEND	This file is append-only.
	UF_OPAQUE	This directory is opaque (unionfs).
	UF_NOUNLINK	This file can't be removed or renamed.
	UF_COMPRESSED	This file is compressed.
	UF_HIDDEN	This file shouldn't be displayed in a GUI.

     The UF_SETTABLE constant is the union of the above flags.

 (2) Superuser settable flags (to be consistent with the BSD st_flags field):

	SF_ARCHIVED	This file has been archived.
	SF_IMMUTABLE	This file is immutable.
	SF_APPEND	This file is append-only.
	SF_NOUNLINK	This file can't be removed or renamed.
	SF_HIDDEN	This file is a snapshot inode.

     The SF_SETTABLE constant is the union of the above flags.

 (3) Linux-specific flags:

	XSTAT_LF_MAGIC_FILE	Magic file, such as found in procfs and sysfs.
	XSTAT_LF_SYNC		File is written synchronously.
	XSTAT_LF_NOATIME	Atime is not updated on this file.
	XSTAT_LF_JOURNALLED_DATA Data modifications to this file are journalled.
	XSTAT_LF_ENCRYPTED	This file is encrypted.
	XSTAT_LF_SYSTEM		This file is a system file (FAT/NTFS/CIFS).
	XSTAT_LF_TEMPORARY	This file is a temporary file (NTFS/CIFS).
	XSTAT_LF_OFFLINE	file is currently unavailable (CIFS).


The Ext4 filesystem has been modified to map certain Ext4 inode flags to the
above:

	EXT4 FLAG		MAPPED TO
	=======================	=======================================
	EXT4_COMPR_FL		UF_COMPRESSED
	EXT4_SYNC_FL		XSTAT_LF_SYNC
	EXT4_IMMUTABLE_FL	UF_IMMUTABLE and SF_IMMUTABLE
	EXT4_APPEND_FL		UF_APPEND and SF_APPEND
	EXT4_NODUMP_FL		UF_NODUMP
	EXT4_NOATIME_FL		XSTAT_LF_NOATIME
	EXT4_JOURNAL_DATA_FL	XSTAT_LF_JOURNALLED_DATA
	EXT4_DIRSYNC_FL		XSTAT_LF_SYNC (directories only)

With this patch applied, the test program given in the patch that introduced
the xstat() syscalls now does this:

	[root@andromeda ~]# chattr +ia /var/cache/fscache/cull_atimes
	[root@andromeda ~]# lsattr /var/cache/fscache/cull_atimes
	----ia-------e- /var/cache/fscache/cull_atimes
	[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cull_atimes
	xstat(/var/cache/fscache/cull_atimes) = 168
	results=5fef
	  Size: 78088           Blocks: 168        IO Block: 4096    regular file
	Device: 08:06           Inode: 13          Links: 1
	Access: (0600/-rw-------)  Uid: 0
	Gid: 0
	Access: 2010-06-29 18:17:41.092290108+0100
	Modify: 2010-06-25 17:25:53.320261493+0100
	Change: 2010-07-02 00:46:51.278803967+0100
	Create: 2010-06-25 15:17:39.711172889+0100
	Inode version: f585ab73h
	0098: 0000000000060006 0000000e00060027

The extra results are hex dumped at the end in 64-bit chunks.  As can be seen
above, st_flags=0x0000000000060006 and st_supported_flags=0000000e00060027.
That's showing that the file now has [SU]F_IMMUTABLE and [SU]F_APPEND enabled.

Note also that XSTAT_REQUEST_INODE_FLAGS (0x4000) is present in the result_mask
value (0x5fef) returned to userspace, and the amount of data returned by
xstat() has increased from 152 to 168 as appropriate for 16 bytes of extra
data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/ext4.h       |    2 ++
 fs/ext4/file.c       |    1 +
 fs/ext4/inode.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c      |    2 ++
 fs/ext4/symlink.c    |    2 ++
 include/linux/stat.h |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 103 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 96823f3..26b8dd6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1573,6 +1573,8 @@ extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
 extern int  ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
+extern int  ext4_getattr_extra(struct vfsmount *, struct dentry *,
+			       struct xstat_extra_result *);
 extern void ext4_delete_inode(struct inode *);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 18c29ab..657ffa0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -151,6 +151,7 @@ const struct inode_operations ext4_file_inode_operations = {
 	.truncate	= ext4_truncate,
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_file_getattr,
+	.getattr_extra	= ext4_getattr_extra,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9a730a..efa17d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5595,6 +5595,56 @@ int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
+int ext4_getattr_inode_flags(struct inode *inode,
+			     struct xstat_extra_result *extra)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct xstat_inode_flags xif = { 0, 0 };
+
+#define _(FL, ST)		      \
+	xif.st_supported_flags |= ST; \
+	if (ei->i_flags & FL)	      \
+		xif.st_flags |= ST;
+
+	_(EXT4_COMPR_FL,	UF_COMPRESSED);
+	_(EXT4_SYNC_FL,		XSTAT_LF_SYNC);
+	_(EXT4_IMMUTABLE_FL,	UF_IMMUTABLE | SF_IMMUTABLE);
+	_(EXT4_APPEND_FL,	UF_APPEND | SF_APPEND);
+	_(EXT4_NODUMP_FL,	UF_NODUMP);
+	_(EXT4_NOATIME_FL,	XSTAT_LF_NOATIME);
+	_(EXT4_JOURNAL_DATA_FL,	XSTAT_LF_JOURNALLED_DATA);
+
+	if (S_ISDIR(ei->vfs_inode.i_mode))
+		_(EXT4_DIRSYNC_FL,	XSTAT_LF_SYNC);
+
+	return extra->pass_result(extra, ilog2(XSTAT_REQUEST_INODE_FLAGS),
+				  &xif, sizeof(xif));
+}
+
+int ext4_getattr_extra(struct vfsmount *mnt, struct dentry *dentry,
+		       struct xstat_extra_result *extra)
+{
+	struct inode *inode = dentry->d_inode;
+	u64 request_mask = extra->request_mask;
+	int request, ret;
+
+	do {
+		request = __ffs64(request_mask);
+		request_mask &= ~(1ULL << request);
+
+		switch (request) {
+		case ilog2(XSTAT_REQUEST_INODE_FLAGS):
+			ret = ext4_getattr_inode_flags(inode, extra);
+			break;
+		default:
+			ret = 0;
+			break;
+		}
+
+	} while (ret == 0 && request_mask);
+	return ret;
+}
+
 static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 				      int chunk)
 {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0f776c7..3c37b3f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2543,6 +2543,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.rename		= ext4_rename,
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
+	.getattr_extra	= ext4_getattr_extra,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -2556,6 +2557,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
+	.getattr_extra	= ext4_getattr_extra,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index d8fe7fb..8c206b2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -36,6 +36,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
 	.put_link	= page_put_link,
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
+	.getattr_extra	= ext4_getattr_extra,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -49,6 +50,7 @@ const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.follow_link	= ext4_follow_link,
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
+	.getattr_extra	= ext4_getattr_extra,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 9e27f88..4c87878 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -107,7 +107,8 @@ struct xstat_parameters {
 #define XSTAT_REQUEST_GEN		0x00001000ULL	/* want/got st_gen */
 #define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL	/* want/got st_data_version */
 #define XSTAT_REQUEST__EXTENDED_STATS	0x00003fffULL	/* the stuff in the xstat struct */
-#define XSTAT_REQUEST__ALL_STATS	0x00003fffULL	/* the defined set of requestables */
+#define XSTAT_REQUEST_INODE_FLAGS	0x00004000ULL	/* want/got xstat_inode_flags */
+#define XSTAT_REQUEST__ALL_STATS	0x00007fffULL	/* the defined set of requestables */
 #define XSTAT_REQUEST__EXTRA_STATS	(XSTAT_REQUEST__ALL_STATS & ~XSTAT_REQUEST__EXTENDED_STATS)
 };
 
@@ -140,6 +141,50 @@ struct xstat {
 	unsigned long long	st_extra_results[0]; /* extra requested results */
 };
 
+/*
+ * Extra result field for inode flags (XSTAT_REQUEST_INODE_FLAGS)
+ */
+struct xstat_inode_flags {
+	/* Flags set on the file
+	 * - the LSW matches the BSD st_flags
+	 * - the MSW are Linux-specific
+	 */
+	unsigned long long	st_flags;
+	/* st_flags that users can set */
+#define UF_SETTABLE	0x0000ffff
+#define UF_NODUMP	0x00000001	/* do not dump */
+#define UF_IMMUTABLE	0x00000002	/* immutable */
+#define UF_APPEND	0x00000004	/* append-only */
+#define UF_OPAQUE	0x00000008	/* directory is opaque (unionfs) */
+#define UF_NOUNLINK	0x00000010	/* can't be removed or renamed */
+#define UF_COMPRESSED	0x00000020	/* file is compressed */
+#define UF_HIDDEN	0x00008000	/* file shouldn't be displayed in a GUI */
+
+	/* st_flags that only root can set */
+#define SF_SETTABLE	0xffff0000
+#define SF_ARCHIVED	0x00010000	/* archived */
+#define SF_IMMUTABLE	0x00020000	/* immutable */
+#define SF_APPEND	0x00040000	/* append-only */
+#define SF_NOUNLINK	0x00100000	/* can't be removed or renamed */
+#define SF_SNAPSHOT	0x00200000	/* snapshot inode */
+
+	/* Linux-specific st_flags */
+#define XSTAT_LF_MAGIC_FILE	(1ULL << 32)	/* magic file, such as /proc/? and /sys/? */
+#define XSTAT_LF_SYNC		(1ULL << 33)	/* file is written synchronously */
+#define XSTAT_LF_NOATIME	(1ULL << 34)	/* atime is not updated on file */
+#define XSTAT_LF_JOURNALLED_DATA (1ULL << 35)	/* data modifications to file are journalled */
+#define XSTAT_LF_ENCRYPTED	(1ULL << 36)	/* file is encrypted */
+#define XSTAT_LF_SYSTEM		(1ULL << 37)	/* system file */
+#define XSTAT_LF_TEMPORARY	(1ULL << 38)	/* temporary file */
+#define XSTAT_LF_OFFLINE	(1ULL << 39)	/* file is currently unavailable */
+
+	/* Which st_flags are actually supported by this filesystem for this
+	 * file */
+	unsigned long long	st_supported_flags;
+};
+#define XSTAT_LENGTH_INODE_FLAGS (sizeof(struct xstat_inode_flags))
+
+
 #ifdef __KERNEL__
 #define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)
 #define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
