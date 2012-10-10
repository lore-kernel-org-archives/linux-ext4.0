From: zwu.kernel@gmail.com
Subject: [RFC v3 11/13] vfs: add 3 new ioctl interfaces
Date: Wed, 10 Oct 2012 18:07:33 +0800
Message-ID: <1349863655-29320-12-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  FS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in btrfs_freq_data structs, and also return a
calculated data temperature based on those metrics. Optionally, retrieve
the temperature from the hot data hash list instead of recalculating it.

  FS_IOC_GET_HEAT_OPTS: return an integer representing the current
state of hot data tracking and migration:

0 = do nothing
1 = track frequency of access

  FS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
migration, as described above.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c            |    9 +++
 fs/ioctl.c                   |  122 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h           |    1 +
 include/linux/hot_tracking.h |   22 ++++++++
 4 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f505402..820f4cc 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/hot_tracking.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -1398,6 +1399,11 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 
+/*Hot data tracking*/
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_INFO)
+COMPATIBLE_IOCTL(FS_IOC_SET_HEAT_OPTS)
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_OPTS)
+
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1577,6 +1583,9 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
+	case FS_IOC_GET_HEAT_INFO:
+	case FS_IOC_SET_HEAT_OPTS:
+	case FS_IOC_GET_HEAT_OPTS:
 		if (S_ISREG(f.file->f_path.dentry->d_inode->i_mode))
 			break;
 		/*FALL THROUGH*/
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 3bdad6d..35127ed 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include "hot_tracking.h"
 
 #include <asm/ioctls.h>
 
@@ -537,6 +538,118 @@ static int ioctl_fsthaw(struct file *filp)
 }
 
 /*
+ * Retrieve information about access frequency for the given file. Return it in
+ * a userspace-friendly struct for btrfsctl (or another tool) to parse.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the hashtable, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by hot_heat_info->live.
+ */
+static int ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *file_inode;
+	struct file *file_filp;
+	struct hot_info *root = global_hot_tracking_info;
+	struct hot_heat_info *heat_info;
+	struct hot_inode_item *he;
+	int ret = 0;
+
+	heat_info = kmalloc(sizeof(struct hot_heat_info),
+				GFP_KERNEL | GFP_NOFS);
+
+	if (copy_from_user((void *) heat_info,
+			argp,
+			sizeof(struct hot_heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	file_filp = filp_open(heat_info->filename, O_RDONLY, 0);
+	file_inode = file_filp->f_dentry->d_inode;
+	filp_close(file_filp, NULL);
+
+	he = hot_inode_item_find(root, file_inode->i_ino);
+	if (!he) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	spin_lock(&he->hot_inode.lock);
+	heat_info->avg_delta_reads =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_reads;
+	heat_info->avg_delta_writes =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_writes;
+	heat_info->last_read_time =
+		(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_read_time);
+	heat_info->last_write_time =
+		(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_write_time);
+	heat_info->num_reads =
+		(__u32) he->hot_inode.hot_freq_data.nr_reads;
+	heat_info->num_writes =
+		(__u32) he->hot_inode.hot_freq_data.nr_writes;
+
+	if (heat_info->live > 0) {
+		/*
+		 * got a request for live temperature,
+		 * call hot_hash_calc_temperature to recalculate
+		 */
+		heat_info->temperature =
+			hot_temperature_calculate(&he->hot_inode.hot_freq_data);
+	} else {
+		/* not live temperature, get it from the hashlist */
+		heat_info->temperature = he->hot_inode.hot_freq_data.last_temperature;
+	}
+	spin_unlock(&he->hot_inode.lock);
+
+	hot_inode_item_put(he);
+
+	if (copy_to_user(argp, (void *) heat_info,
+			sizeof(struct hot_heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+err:
+	kfree(heat_info);
+	return ret;
+}
+
+static int ioctl_heat_opts(struct file *file, void __user *argp, int set)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	unsigned arg;
+	int ret = 0;
+
+	if (!set) {
+		arg = TRACK_THIS_INODE(inode) ? 1 : 0;
+
+		if (copy_to_user(argp, (void *) &arg, sizeof(unsigned long)) != 0)
+			ret = -EFAULT;
+	} else {
+		if (copy_from_user((void *) &arg, argp, sizeof(unsigned long)) != 0) {
+			ret = -EFAULT;
+		} else {
+			switch (arg) {
+			case 0: /* track nothing */
+				/* set S_NOHOTDATATRACK */
+				inode->i_flags |= S_NOHOTDATATRACK;
+				break;
+			case 1: /* do tracking */
+				/* clear S_NOHOTDATATRACK */
+				inode->i_flags &= ~S_NOHOTDATATRACK;
+				break;
+			default:
+				ret = -EINVAL;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -591,6 +704,15 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_GET_HEAT_INFO:
+		return ioctl_heat_info(filp, argp);
+
+	case FS_IOC_SET_HEAT_OPTS:
+		return ioctl_heat_opts(filp, argp, 1);
+
+	case FS_IOC_GET_HEAT_OPTS:
+		return ioctl_heat_opts(filp, argp, 0);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b1a389..c2e2d0f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -256,6 +256,7 @@ struct inodes_stat_t {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
+#define S_NOHOTDATATRACK (1 << 13)	/* hot data tracking */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 6f31090..e3ca136 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -41,6 +41,18 @@ struct hot_freq_data {
 	u32 last_temperature;
 };
 
+struct hot_heat_info {
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	__u32 temperature;
+	__u8 live;
+	char filename[PATH_MAX];
+};
+
 /* List heads in hot map array */
 struct hot_map_head {
 	struct list_head node_list;
@@ -89,6 +101,16 @@ struct hot_info {
 	struct shrinker hot_shrink;
 };
 
+/*
+ * Hot data tracking ioctls:
+ *
+ * HOT_INFO - retrieve info on frequency of access
+ */
+#define FS_IOC_GET_HEAT_INFO _IOR('f', 17, \
+                                struct hot_heat_info)
+#define FS_IOC_SET_HEAT_OPTS _IOW('f', 18, unsigned long)
+#define FS_IOC_GET_HEAT_OPTS _IOR('f', 19, unsigned long)
+
 extern struct hot_info *global_hot_tracking_info;
 
 extern void hot_track_init(struct super_block *sb);
-- 
1.7.6.5
