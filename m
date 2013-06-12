From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: don't set root dir UID/GID automatically
Date: Tue, 11 Jun 2013 21:32:02 -0600
Message-ID: <1371007922-20423-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:16214 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3FLDlz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 23:41:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't change the root directory's UID/GID automatically just because
mke2fs was run as a non-root user.  This can be confusing for users,
and is not flexible for non-root installation tools that need to
create a filesystem with different ownership from the current user.

Add the "-E root_owner[=uid:gid]" option to mke2fs so that the user
and group can be explicitly specified for the root directory.  If
the "=uid:gid" argument is not specified, the current UID and GID
are extracted from the running process, as was done in the past.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.8.in            |    9 ++++++
 misc/mke2fs.c               |   45 +++++++++++++++++++++++------
 tests/m_root_owner/expect.1 |   67 +++++++++++++++++++++++++++++++++++++++++++
 tests/m_root_owner/script   |    4 ++
 4 files changed, 116 insertions(+), 9 deletions(-)
 create mode 100644 tests/m_root_owner/expect.1
 create mode 100644 tests/m_root_owner/script

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 023ba49..08f3e36 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -268,6 +268,15 @@ small risk if the system crashes before the journal has been overwritten
 entirely one time.  If the option value is omitted, it defaults to 1 to
 enable lazy journal inode zeroing.
 .TP
+.BI root_owner [=uid:gid]
+Specify the numeric user and group ID of the root directory.  If no UID:GID
+is specified, use the user and group ID of the user running \fBmke2fs\fR.
+In \fBmke2fs\fR 1.42 and earlier the UID and GID of the root directory were
+set by default to the UID and GID of the user running the mke2fs command.
+The \fBroot_owner=\fR option allows explicitly specifying these values,
+and avoid side-effects for users that do not expect the contents of the
+filesystem to change based on the user running \fBmke2fs\fR.
+.TP
 .B test_fs
 Set a flag in the filesystem superblock indicating that it may be
 mounted using experimental kernel code, such as the ext4dev filesystem.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..227d07c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -88,6 +88,8 @@ int	discard = 1;	/* attempt to discard device before fs creation */
 int	direct_io;
 int	force;
 int	noaction;
+uid_t	root_uid;
+gid_t	root_gid;
 int	journal_size;
 int	journal_flags;
 int	lazy_itable_init;
@@ -391,21 +393,19 @@ static void create_root_dir(ext2_filsys fs)
 		com_err("ext2fs_mkdir", retval, _("while creating root dir"));
 		exit(1);
 	}
-	if (geteuid()) {
+	if (root_uid != 0 || root_gid != 0) {
 		retval = ext2fs_read_inode(fs, EXT2_ROOT_INO, &inode);
 		if (retval) {
 			com_err("ext2fs_read_inode", retval,
 				_("while reading root inode"));
 			exit(1);
 		}
-		uid = getuid();
-		inode.i_uid = uid;
-		ext2fs_set_i_uid_high(inode, uid >> 16);
-		if (uid) {
-			gid = getgid();
-			inode.i_gid = gid;
-			ext2fs_set_i_gid_high(inode, gid >> 16);
-		}
+
+		inode.i_uid = root_uid;
+		ext2fs_set_i_uid_high(inode, root_uid >> 16);
+		inode.i_gid = root_gid;
+		ext2fs_set_i_gid_high(inode, root_gid >> 16);
+
 		retval = ext2fs_write_new_inode(fs, EXT2_ROOT_INO, &inode);
 		if (retval) {
 			com_err("ext2fs_write_inode", retval,
@@ -612,6 +612,8 @@ static void show_stats(ext2_filsys fs)
 		ext2fs_r_blocks_count(s),
 	       100.0 *  ext2fs_r_blocks_count(s) / ext2fs_blocks_count(s));
 	printf(_("First data block=%u\n"), s->s_first_data_block);
+	if (root_uid != 0 || root_gid != 0)
+		printf(_("Root directory owner=%u:%u\n"), root_uid, root_gid);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
 		       (s->s_reserved_gdt_blocks + fs->desc_blocks) *
@@ -835,6 +837,29 @@ static void parse_extended_opts(struct ext2_super_block *param,
 						EXT2_MKJOURNAL_LAZYINIT : 0;
 			else
 				journal_flags |= EXT2_MKJOURNAL_LAZYINIT;
+		} else if (!strcmp(token, "root_owner")) {
+			if (arg) {
+				root_uid = strtoul(arg, &p, 0);
+				if (*p != ':') {
+					fprintf(stderr,
+						_("Invalid root_owner: '%s'\n"),
+						arg);
+					r_usage++;
+					continue;
+				}
+				p++;
+				root_gid = strtoul(p, &p, 0);
+				if (*p) {
+					fprintf(stderr,
+						_("Invalid root_owner: '%s'\n"),
+						arg);
+					r_usage++;
+					continue;
+				}
+			} else {
+				root_uid = getuid();
+				root_gid = getgid();
+			}
 		} else if (!strcmp(token, "discard")) {
 			discard = 1;
 		} else if (!strcmp(token, "nodiscard")) {
@@ -872,6 +897,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tresize=<resize maximum size in blocks>\n"
 			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
 			"\tlazy_journal_init=<0 to disable, 1 to enable>\n"
+			"\troot_uid=<uid of root directory>\n"
+			"\troot_gid=<gid of root directory>\n"
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n"
diff --git a/tests/m_root_owner/expect.1 b/tests/m_root_owner/expect.1
new file mode 100644
index 0000000..97ce1f6
--- /dev/null
+++ b/tests/m_root_owner/expect.1
@@ -0,0 +1,67 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+Stride=0 blocks, Stripe width=0 blocks
+128 inodes, 1024 blocks
+51 blocks (4.98%) reserved for the super user
+First data block=1
+Root directory owner=1234:1234
+Maximum filesystem blocks=1048576
+1 block group
+8192 blocks per group, 8192 fragments per group
+128 inodes per group
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Filesystem features: ext_attr resize_inode dir_index filetype sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 38/1024 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              128
+Block count:              1024
+Reserved block count:     51
+Free blocks:              986
+Free inodes:              117
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      3
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         128
+Inode blocks per group:   16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          128
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 1-1023)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-5
+  Block bitmap at 6 (+5), Inode bitmap at 7 (+6)
+  Inode table at 8-23 (+7)
+  986 free blocks, 117 free inodes, 2 directories
+  Free blocks: 38-1023
+  Free inodes: 12-128
diff --git a/tests/m_root_owner/script b/tests/m_root_owner/script
new file mode 100644
index 0000000..02c5ef6
--- /dev/null
+++ b/tests/m_root_owner/script
@@ -0,0 +1,4 @@
+DESCRIPTION="root directory owner"
+FS_SIZE=1024
+MKE2FS_OPTS="-E root_owner=1234:1234"
+. $cmd_dir/run_mke2fs
-- 
1.7.3.4

