From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp limits
Date: Sat,  8 Apr 2017 12:37:44 -0700
Message-ID: <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
Cc: torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, y2038@lists.linaro.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Allow read only mounts for filesystems that do not
have maximum timestamps beyond the y2038 expiry
timestamp.

Also, allow a sysctl override to all such filesystems
to be mounted with write permissions.
A boot param supports initial override of these
checks from the early boot without recompilation.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 fs/inode.c                                      | 15 +++++++++++++++
 fs/internal.h                                   |  2 ++
 fs/namespace.c                                  | 12 ++++++++++++
 fs/super.c                                      |  7 +++++++
 include/linux/fs.h                              |  1 +
 include/linux/time64.h                          |  4 ++++
 include/uapi/linux/fs.h                         |  6 +++++-
 kernel/sysctl.c                                 |  7 +++++++
 9 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c2f220d..57f4a50 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1193,6 +1193,14 @@
 			can be changed at run time by the max_graph_depth file
 			in the tracefs tracing directory. default: 0 (no limit)
 
+	fstimestampcheck
+			Enable checking of max filesystem time supported
+			at mount time. The value is checked against y2038
+			date: Mon Jan 18 19:14:07 PST 2038. The option
+			disables rw mount of filesystems that are not able
+			to represent times beyond y2038 time mentioned above.
+			This check is off by default.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/fs/inode.c b/fs/inode.c
index a9caf53..a0c1522 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -75,6 +75,21 @@ static DEFINE_PER_CPU(unsigned long, nr_unused);
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
+struct vfs_max_timestamp_check timestamp_check = {
+	.timestamp_supported = Y2038_EXPIRY_TIMESTAMP,
+	.check_on = 0,
+};
+
+static int __init setup_timestamp_check(char *str)
+{
+	if (*str)
+		return 0;
+	timestamp_check.check_on = 1;
+	return 1;
+}
+
+__setup("fstimestampcheck", setup_timestamp_check);
+
 static long get_nr_inodes(void)
 {
 	int i;
diff --git a/fs/internal.h b/fs/internal.h
index cef253a..76fbcde 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -67,6 +67,8 @@ extern int finish_automount(struct vfsmount *, struct path *);
 
 extern int sb_prepare_remount_readonly(struct super_block *);
 
+extern bool sb_file_times_updatable(struct super_block *sb);
+
 extern void __init mnt_init(void);
 
 extern int __mnt_want_write(struct vfsmount *);
diff --git a/fs/namespace.c b/fs/namespace.c
index 6b81c20..fd6e479 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -538,6 +538,18 @@ static void __mnt_unmake_readonly(struct mount *mnt)
 	unlock_mount_hash();
 }
 
+bool sb_file_times_updatable(struct super_block *sb)
+{
+
+	if (!timestamp_check.check_on)
+		return true;
+
+	if (sb->s_time_max > timestamp_check.timestamp_supported)
+		return true;
+
+	return false;
+}
+
 int sb_prepare_remount_readonly(struct super_block *sb)
 {
 	struct mount *mnt;
diff --git a/fs/super.c b/fs/super.c
index f9c2241..4e7577b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1245,6 +1245,13 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	WARN((sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
 		"negative value (%lld)\n", type->name, sb->s_maxbytes);
 
+	if (!(sb->s_flags & MS_RDONLY) && !sb_file_times_updatable(sb)) {
+		WARN(1, "File times cannot be updated on the filesystem.\n");
+		WARN(1, "Retry mounting the filesystem readonly.\n");
+		error = -EROFS;
+		goto out_sb;
+	}
+
 	up_write(&sb->s_umount);
 	free_secdata(secdata);
 	return root;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63f83440..a39dc8e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -68,6 +68,7 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern struct vfs_max_timestamp_check timestamp_check;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 25433b18..906e0b3 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -43,6 +43,10 @@ struct itimerspec64 {
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
 
+/* Timestamps on boundary */
+#define Y2038_EXPIRY_TIMESTAMP		S32_MAX /* 2147483647 */
+#define Y2106_EXPIRY_TIMESTAMP		U32_MAX /* 4294967295 */
+
 #if __BITS_PER_LONG == 64
 
 static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 048a85e..125e4ae 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -91,6 +91,11 @@ struct files_stat_struct {
 	unsigned long max_files;		/* tunable */
 };
 
+struct vfs_max_timestamp_check {
+	time64_t timestamp_supported;
+	int check_on;
+};
+
 struct inodes_stat_t {
 	long nr_inodes;
 	long nr_unused;
@@ -100,7 +105,6 @@ struct inodes_stat_t {
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
-
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
  */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 60474df..d88487c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1668,6 +1668,13 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
+		.procname	= "fs-timestamp-check-on",
+		.data		= &timestamp_check.check_on,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "nr_open",
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(unsigned int),
-- 
2.7.4
