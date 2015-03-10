From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 2/6] fs: protected project id
Date: Tue, 10 Mar 2015 20:22:06 +0300
Message-ID: <20150310172206.23081.95005.stgit@buzz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Historically XFS project id doesn't have any permission control: file owner
is able to set any project id. Later they was sealed with user-namespace:
XFS allows to change it only from init user-ns. That works fine for isolated
containers or if user doesn't have direct access to the filesystem (NFS/FTP).

This patch adds sysctl fs.protected_projects which makes changing project id
privileged operation which requires CAP_SYS_RESOURCE in current user-namespace.
Thus there are two levels of protection: project id mapping in user-ns defines
set of permitted projects and capability protects operations within this set.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 Documentation/sysctl/fs.txt     |   16 ++++++++++++++++
 fs/ioctl.c                      |    6 +++++-
 include/linux/fs.h              |    1 +
 include/uapi/linux/capability.h |    1 +
 kernel/sysctl.c                 |    9 +++++++++
 kernel/user_namespace.c         |    4 ++--
 6 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 88152f214f48..9f6579b99be6 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -34,6 +34,7 @@ Currently, these files are in /proc/sys/fs:
 - overflowgid
 - protected_hardlinks
 - protected_symlinks
+- protected_projects
 - suid_dumpable
 - super-max
 - super-nr
@@ -199,6 +200,21 @@ This protection is based on the restrictions in Openwall and grsecurity.
 
 ==============================================================
 
+protected_projects:
+
+Project id allows to enforce disk quota for several subtrees or individual
+files on the filesystem. Historically changing project id was a unprivileged
+operation and file owner is able to set any project id.
+
+When set to "0", changing project id is unprivileged operation. File owner
+can set any project id mapped in current user namespace.
+
+When set to "1" changing project id requires capability CAP_SYS_RESOURCE
+in current user namespace. Also defining project id mapping for nested
+user namespace requires CAP_SYS_RESOURCE in the parent user namespace.
+
+==============================================================
+
 suid_dumpable:
 
 This value can be used to query and set the core dump mode for setuid
diff --git a/fs/ioctl.c b/fs/ioctl.c
index d351576d95c8..2acf5efbc045 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -565,6 +565,8 @@ static int ioctl_getproject(struct file *filp, projid_t __user *argp)
 	return put_user(projid, argp);
 }
 
+int sysctl_protected_projects;
+
 static int ioctl_setproject(struct file *filp, projid_t __user *argp)
 {
 	struct user_namespace *ns = current_user_ns();
@@ -576,7 +578,9 @@ static int ioctl_setproject(struct file *filp, projid_t __user *argp)
 
 	if (!sb->s_op->set_project)
 		return -EOPNOTSUPP;
-	if (ns != &init_user_ns)
+	if (sysctl_protected_projects ?
+	    !ns_capable(ns, CAP_SYS_RESOURCE) :
+	    (ns != &init_user_ns))
 		return -EPERM;
 	ret = get_user(projid, argp);
 	if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 42156801739e..d3021feb3f7f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -64,6 +64,7 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_projects;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 12c37a197d24..0292885567cc 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -278,6 +278,7 @@ struct vfs_cap_data {
 /* Override resource limits. Set resource limits. */
 /* Override quota limits. */
 /* Override reserved space on ext2 filesystem */
+/* Modify file project id if protected_projects = 1 */
 /* Modify data journaling mode on ext3 filesystem (uses journaling
    resources) */
 /* NOTE: ext2 honors fsuid when checking for resource overrides, so
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 88ea2d6e0031..cb6f9fb13de3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1649,6 +1649,15 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "protected_projects",
+		.data		= &sysctl_protected_projects,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4109f8320684..88f66198b251 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -807,8 +807,8 @@ ssize_t proc_projid_map_write(struct file *file, const char __user *buf,
 	if ((seq_ns != ns) && (seq_ns != ns->parent))
 		return -EPERM;
 
-	/* Anyone can set any valid project id no capability needed */
-	return map_write(file, buf, size, ppos, -1,
+	return map_write(file, buf, size, ppos,
+			 sysctl_protected_projects ? CAP_SYS_RESOURCE : -1,
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
