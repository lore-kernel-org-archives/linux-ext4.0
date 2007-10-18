From: akpm@linux-foundation.org
Subject: - fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:40 -0700
Message-ID: <200710180656.l9I6ueEW030720@imap1.linux-foundation.org>
To: mathieu.desnoyers@polymtl.ca, bfields@fieldses.org, hch@lst.de,
	linux-ext4@vger.kernel.org, mark.fasheh@oracle.com,
	mbligh@google.com, rdunlap@xenotime.net,
	trond.myklebust@fys.uio.no
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761664AbXJRHsL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 03:48:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Fix f_version type: should be u64 instead of unsigned long
has been removed from the -mm tree.  Its filename was
     fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix f_version type: should be u64 instead of unsigned long
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix f_version type: should be u64 instead of long

There is a type inconsistency between struct inode i_version and struct file
f_version.

fs.h:

struct inode
  u64                     i_version;

and

struct file
  unsigned long           f_version;

Users do:

fs/ext3/dir.c:

if (filp->f_version != inode->i_version) {

So why isn't f_version a u64 ? It becomes a problem if versions gets
higher than 2^32 and we are on an architecture where longs are 32 bits.

This patch changes the f_version type to u64, and updates the users accordingly.

It applies to 2.6.23-rc2-mm2.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: <linux-ext4@vger.kernel.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c            |    2 +-
 fs/ext4/dir.c            |    2 +-
 fs/ocfs2/dir.c           |   10 +++++-----
 fs/proc/base.c           |    4 ++--
 include/linux/fs.h       |    2 +-
 include/linux/seq_file.h |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ext3/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long fs/ext3/dir.c
--- a/fs/ext3/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/fs/ext3/dir.c
@@ -210,7 +210,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				u64 version = filp->f_version;
 
 				error = filldir(dirent, de->name,
 						de->name_len,
diff -puN fs/ext4/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long fs/ext4/dir.c
--- a/fs/ext4/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/fs/ext4/dir.c
@@ -210,7 +210,7 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				u64 version = filp->f_version;
 
 				error = filldir(dirent, de->name,
 						de->name_len,
diff -puN fs/ocfs2/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/fs/ocfs2/dir.c
@@ -586,7 +586,7 @@ bail:
 }
 
 static int ocfs2_dir_foreach_blk_id(struct inode *inode,
-				    unsigned long *f_version,
+				    u64 *f_version,
 				    loff_t *f_pos, void *priv,
 				    filldir_t filldir, int *filldir_err)
 {
@@ -648,7 +648,7 @@ revalidate:
 			 * not the directory has been modified
 			 * during the copy operation.
 			 */
-			unsigned long version = *f_version;
+			u64 version = *f_version;
 			unsigned char d_type = DT_UNKNOWN;
 
 			if (de->file_type < OCFS2_FT_MAX)
@@ -677,7 +677,7 @@ out:
 }
 
 static int ocfs2_dir_foreach_blk_el(struct inode *inode,
-				    unsigned long *f_version,
+				    u64 *f_version,
 				    loff_t *f_pos, void *priv,
 				    filldir_t filldir, int *filldir_err)
 {
@@ -798,7 +798,7 @@ out:
 	return stored;
 }
 
-static int ocfs2_dir_foreach_blk(struct inode *inode, unsigned long *f_version,
+static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
 				 loff_t *f_pos, void *priv, filldir_t filldir,
 				 int *filldir_err)
 {
@@ -818,7 +818,7 @@ int ocfs2_dir_foreach(struct inode *inod
 		      filldir_t filldir)
 {
 	int ret = 0, filldir_err = 0;
-	unsigned long version = inode->i_version;
+	u64 version = inode->i_version;
 
 	while (*f_pos < i_size_read(inode)) {
 		ret = ocfs2_dir_foreach_blk(inode, &version, f_pos, priv,
diff -puN fs/proc/base.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long fs/proc/base.c
--- a/fs/proc/base.c~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/fs/proc/base.c
@@ -2586,7 +2586,7 @@ static int proc_task_readdir(struct file
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
-	tid = filp->f_version;
+	tid = (int)filp->f_version;
 	filp->f_version = 0;
 	for (task = first_tid(leader, tid, pos - 2);
 	     task;
@@ -2595,7 +2595,7 @@ static int proc_task_readdir(struct file
 		if (proc_task_fill_cache(filp, dirent, filldir, task, tid) < 0) {
 			/* returning this tgid failed, save it as the first
 			 * pid for the next readir call */
-			filp->f_version = tid;
+			filp->f_version = (u64)tid;
 			put_task_struct(task);
 			break;
 		}
diff -puN include/linux/fs.h~fix-f_version-type-should-be-u64-instead-of-unsigned-long include/linux/fs.h
--- a/include/linux/fs.h~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/include/linux/fs.h
@@ -792,7 +792,7 @@ struct file {
 	unsigned int		f_uid, f_gid;
 	struct file_ra_state	f_ra;
 
-	unsigned long		f_version;
+	u64			f_version;
 #ifdef CONFIG_SECURITY
 	void			*f_security;
 #endif
diff -puN include/linux/seq_file.h~fix-f_version-type-should-be-u64-instead-of-unsigned-long include/linux/seq_file.h
--- a/include/linux/seq_file.h~fix-f_version-type-should-be-u64-instead-of-unsigned-long
+++ a/include/linux/seq_file.h
@@ -18,7 +18,7 @@ struct seq_file {
 	size_t from;
 	size_t count;
 	loff_t index;
-	loff_t version;
+	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
 	void *private;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
