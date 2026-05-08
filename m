Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8DB3203B6;
	Fri,  8 May 2026 09:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232929; cv=none; b=SZPgoS71+CfOMNvE0Di5mt+Iic4Jz5If+Jo0j7N8lSjFSlORP3BoHqb0MQXk1mL5QkKesAwq0frCqOfqvuuswmpwBeQ2Gdnb8YW5MhSAJPFjKC5LigvZj4ks1BtykRUSc2XNIS7P/bFX1wg5mMPAZuXWMxK/LBdzwNTSAToQs3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232929; c=relaxed/simple;
	bh=96jnxbsa5knuisQeX9tTapZe80ORU7nc+JjtWIozK6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGo5z5UoOnyQmxe82rdarh/cMOhHtR4BEIp93SZBsLTMFdTVxZTyzhC8dObH1b8/n0tjgge/5/Js5S0mzB/+58jx20/25FTB9lvuAP+2/MgpQIjuji5lEb9kbuNU8xQMeIuGLJGFmTmDFZSZZEHYbruDOlyf+Wbic8oXk6WcbRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=U16ZO1IX; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="U16ZO1IX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=h8
	+2ejIaLAunVzHWwrUrleLK9mjHS6IbId81JKiL/14=; b=U16ZO1IXdyk3g2c6q3
	K2JyTCnMjlJC7CTwVQ4/UZ2hj4TyWVHPUNZxyQli5sUZ6geZwXs12H8+MaI+WyBS
	fj/Ug8EkuzuKet9YpfrLTnm9QJPhAIbXXtCklyofMdpgMbFNHx963pb+po1xhqVR
	LiBL1T2cjXZFSh48I9caOFyCk=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXeCEprv1pUW9wDg--.60442S5;
	Fri, 08 May 2026 17:35:02 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com
Cc: ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	adilger@dilger.ca,
	liubaolin12138@163.com,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v4 v4 3/3] ext4: allow controlling mballoc stats through proc mb_stats
Date: Fri,  8 May 2026 17:34:28 +0800
Message-ID: <20260508093428.5814-4-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260508093428.5814-1-liubaolin12138@163.com>
References: <20260508093428.5814-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDXeCEprv1pUW9wDg--.60442S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw1kXFy3Ar4rXw13uw47XFb_yoW3tF4kpF
	sxAa4xGr1xWa4UCws7Gr4xXw13A3W8C347Kr1I9340gr9IvryFyF1ftrW0yFy5GrWUAa95
	XF4j9ryUGr42k37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRFtCcUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwgaWYWn9rkZEZwAA3s

From: Baolin Liu <liubaolin@kylinos.cn>

Make /proc/fs/ext4/<dev>/mb_stats writable. Writing 0 disables mballoc
statistics collection, writing 1 enables it, and writing -1 clears the
current statistics before enabling collection.
Update the ext4 documentation for proc mb_stats, document that the
sysfs mb_stats entry is deprecated, and point proc.rst to
Documentation/admin-guide/ext4.rst for ext4-specific /proc entries.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Ted Tso <tytso@mit.edu>
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
 Documentation/admin-guide/ext4.rst      |  9 ++++-
 Documentation/filesystems/proc.rst      | 13 +------
 fs/ext4/ext4.h                          |  1 +
 fs/ext4/mballoc.c                       | 31 ++++++++++++++++-
 fs/ext4/sysfs.c                         | 46 +++++++++++++++++++++++--
 6 files changed, 86 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 2edd0a6672d3..7bf06c533343 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -5,7 +5,8 @@ Description:
 		 Controls whether the multiblock allocator should
 		 collect statistics, which are shown during the unmount.
 		 1 means to collect statistics, 0 means not to collect
-		 statistics
+		 statistics. This sysfs entry is deprecated, and users
+		 should prefer /proc/fs/ext4/<disk>/mb_stats.
 
 What:		/sys/fs/ext4/<disk>/mb_group_prealloc
 Date:		March 2008
diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index ac0c709ea9e7..ca76e981b2aa 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -436,6 +436,12 @@ Files in /proc/fs/ext4/<devname>
   mb_groups
         details of multiblock allocator buddy cache of free blocks
 
+  mb_stats
+        reports runtime statistics from the multiblock allocator
+        (mballoc). Writing 0 disables statistics collection, writing
+        1 enables statistics collection, and writing -1 clears the
+        current statistics and enables statistics collection.
+
 /sys entries
 ============
 
@@ -493,7 +499,8 @@ Files in /sys/fs/ext4/<devname>:
   mb_stats
         Controls whether the multiblock allocator should collect statistics,
         which are shown during the unmount. 1 means to collect statistics, 0
-        means not to collect statistics.
+        means not to collect statistics. This sysfs entry is deprecated, and
+        users should prefer /proc/fs/ext4/<devname>/mb_stats.
 
   mb_stream_req
         Files which have fewer blocks than this tunable parameter will have
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..dd487004b862 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1623,18 +1623,7 @@ softirq.
 1.8 Ext4 file system parameters
 -------------------------------
 
-Information about mounted ext4 file systems can be found in
-/proc/fs/ext4.  Each mounted filesystem will have a directory in
-/proc/fs/ext4 based on its device name (i.e., /proc/fs/ext4/hdc or
-/proc/fs/ext4/sda9 or /proc/fs/ext4/dm-0).   The files in each per-device
-directory are shown in Table 1-12, below.
-
-.. table:: Table 1-12: Files in /proc/fs/ext4/<devname>
-
- ==============  ==========================================================
- File            Content
- mb_groups       details of multiblock allocator buddy cache of free blocks
- ==============  ==========================================================
+See Documentation/admin-guide/ext4.rst for ext4-specific /proc entries.
 
 1.9 /proc/consoles
 -------------------
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 04bccfcb018e..536589dda8d1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2994,6 +2994,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 extern const struct seq_operations ext4_mb_seq_groups_ops;
 extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
 extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
+extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
 extern int ext4_mb_init(struct super_block *);
 extern void ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 95103fbc1583..69ee737f8655 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3208,7 +3208,7 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 		seq_puts(seq, "\tmb stats collection turned off.\n");
 		seq_puts(
 			seq,
-			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
+			"\tTo enable, please write \"1\" to proc file mb_stats.\n");
 		return 0;
 	}
 	seq_printf(seq, "\tblocks_allocated: %u\n",
@@ -4723,6 +4723,35 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 		trace_ext4_mballoc_prealloc(ac);
 }
 
+void ext4_mb_stats_clear(struct ext4_sb_info *sbi)
+{
+	int i;
+
+	atomic_set(&sbi->s_bal_reqs, 0);
+	atomic_set(&sbi->s_bal_success, 0);
+	atomic_set(&sbi->s_bal_allocated, 0);
+	atomic_set(&sbi->s_bal_groups_scanned, 0);
+
+	for (i = 0; i < EXT4_MB_NUM_CRS; i++) {
+		atomic64_set(&sbi->s_bal_cX_hits[i], 0);
+		atomic64_set(&sbi->s_bal_cX_groups_considered[i], 0);
+		atomic_set(&sbi->s_bal_cX_ex_scanned[i], 0);
+		atomic64_set(&sbi->s_bal_cX_failed[i], 0);
+	}
+
+	atomic_set(&sbi->s_bal_ex_scanned, 0);
+	atomic_set(&sbi->s_bal_goals, 0);
+	atomic_set(&sbi->s_bal_stream_goals, 0);
+	atomic_set(&sbi->s_bal_len_goals, 0);
+	atomic_set(&sbi->s_bal_2orders, 0);
+	atomic_set(&sbi->s_bal_breaks, 0);
+	atomic_set(&sbi->s_mb_lost_chunks, 0);
+	atomic_set(&sbi->s_mb_buddies_generated, 0);
+	atomic64_set(&sbi->s_mb_generation_time, 0);
+	atomic_set(&sbi->s_mb_preallocated, 0);
+	atomic_set(&sbi->s_mb_discarded, 0);
+}
+
 /*
  * Called on failure; free up any blocks from the inode PA for this
  * context.  We don't need this for MB_GROUP_PA because we only change
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 0f65ab372dee..86e2ae022659 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -52,6 +52,48 @@ typedef enum {
 static const char proc_dirname[] = "fs/ext4";
 static struct proc_dir_entry *ext4_proc_root;
 
+static int ext4_mb_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ext4_seq_mb_stats_show, pde_data(inode));
+}
+
+static ssize_t ext4_mb_stats_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct super_block *sb = pde_data(file_inode(file));
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int val;
+	int ret;
+
+	ret = kstrtoint_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	switch (val) {
+	case -1:
+		ext4_mb_stats_clear(sbi);
+		fallthrough;
+	case 1:
+		atomic_set(&sbi->s_mb_stats, 1);
+		break;
+	case 0:
+		atomic_set(&sbi->s_mb_stats, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static const struct proc_ops ext4_mb_stats_proc_ops = {
+	.proc_open	= ext4_mb_stats_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= ext4_mb_stats_write,
+};
+
 struct ext4_attr {
 	struct attribute attr;
 	short attr_id;
@@ -637,8 +679,8 @@ int ext4_register_sysfs(struct super_block *sb)
 					ext4_fc_info_show, sb);
 		proc_create_seq_data("mb_groups", S_IRUGO, sbi->s_proc,
 				&ext4_mb_seq_groups_ops, sb);
-		proc_create_single_data("mb_stats", 0444, sbi->s_proc,
-				ext4_seq_mb_stats_show, sb);
+		proc_create_data("mb_stats", 0644, sbi->s_proc,
+				 &ext4_mb_stats_proc_ops, sb);
 		proc_create_seq_data("mb_structs_summary", 0444, sbi->s_proc,
 				&ext4_mb_seq_structs_summary_ops, sb);
 	}
-- 
2.51.0

