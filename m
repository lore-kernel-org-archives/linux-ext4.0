From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [RFC] Heads up on sys_fallocate()
Date: Fri, 2 Mar 2007 00:04:45 +0530
Message-ID: <20070301183445.GA7911@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070225022326.137b4875.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is to give a heads up on few patches that we will be soon coming up
with. These patches implement a new system call sys_fallocate() and a
new inode operation "fallocate", for persistent preallocation. The new
system call, as Andrew suggested, will look like:

  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);

As we are developing and testing the required patches, we decided to
post a preliminary patch and get inputs from the community to give it
a right direction and shape. First, a little description on the feature.
 
Persistent preallocation is a file system feature using which an
application (say, relational database servers) can explicitly
preallocate blocks to a particular file. This feature can be used to
reserve space for a file to get mainly the following benefits:
1> contiguity - less defragmentation and thus faster access speed, and
2> guarantee for a minimum space availibility (depending on how many
blocks were preallocated) for the file, even if the filesystem becomes
full.

XFS already has an implementation for this, using an ioctl interface. And,
ext4 is now coming up with this feature. In coming time we may see a few
more file systems implementing this. Thus, it makes sense to have a more
standard interface for this, like this new system call.

Here is the initial and incomplete version of the patch, which can be
used for the discussion, till we come up with a set of more complete
patches.

---
 arch/i386/kernel/syscall_table.S |    1 +
 fs/ext4/file.c                   |    1 +
 fs/open.c                        |   18 ++++++++++++++++++
 include/asm-i386/unistd.h        |    3 ++-
 include/linux/fs.h               |    1 +
 include/linux/syscalls.h         |    1 +
 6 files changed, 24 insertions(+), 1 deletion(-)

Index: linux-2.6.20.1/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.1.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6.20.1/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_fallocate		/* 320 */
Index: linux-2.6.20.1/fs/ext4/file.c
===================================================================
--- linux-2.6.20.1.orig/fs/ext4/file.c
+++ linux-2.6.20.1/fs/ext4/file.c
@@ -135,5 +135,6 @@ struct inode_operations ext4_file_inode_
 	.removexattr	= generic_removexattr,
 #endif
 	.permission	= ext4_permission,
+	.fallocate	= ext4_fallocate,
 };
 
Index: linux-2.6.20.1/fs/open.c
===================================================================
--- linux-2.6.20.1.orig/fs/open.c
+++ linux-2.6.20.1/fs/open.c
@@ -350,6 +350,24 @@ asmlinkage long sys_ftruncate64(unsigned
 }
 #endif
 
+asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
+{
+	struct file *file;
+	struct inode *inode;
+	long ret = -EINVAL;
+	file = fget(fd);
+	if (!file)
+		goto out;
+	inode = file->f_path.dentry->d_inode;
+	if (inode->i_op && inode->i_op->fallocate)
+		ret = inode->i_op->fallocate(inode, offset, len);
+	else
+		ret = -ENOTTY;
+	fput(file);
+out:
+        return ret;
+}
+
 /*
  * access() needs to use the real uid/gid, not the effective uid/gid.
  * We do this by temporarily clearing all FS-related capabilities and
Index: linux-2.6.20.1/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.1.orig/include/asm-i386/unistd.h
+++ linux-2.6.20.1/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.20.1/include/linux/fs.h
===================================================================
--- linux-2.6.20.1.orig/include/linux/fs.h
+++ linux-2.6.20.1/include/linux/fs.h
@@ -1124,6 +1124,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	long (*fallocate)(struct inode *, loff_t, loff_t);
 };
 
 struct seq_file;
Index: linux-2.6.20.1/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.1.orig/include/linux/syscalls.h
+++ linux-2.6.20.1/include/linux/syscalls.h
@@ -602,6 +602,7 @@ asmlinkage long sys_get_robust_list(int 
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
+asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);

--
Regards,
Amit Arora 
