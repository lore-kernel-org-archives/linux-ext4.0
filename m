Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985C2AD37;
	Sun, 24 May 2026 01:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779587724; cv=none; b=a0pjL0sPQoC1NGH0neDqIBiOjBuH2BbV2EUe2qf44N0Huc/+wPpkKBzPv9lbArJD6rPnNnU14YRhq12KlRwad+mzIhiFnmVFI99YL9/1V4idX5X90x87q3Awwk60SxucAWID+qEstXyl7wsllsdzdquq3Xl+8uNHmTcKHx2JO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779587724; c=relaxed/simple;
	bh=2xa+UOgJAQH45eruBhL7e5/kvCaCmag8kVNHk1/9hBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSeni9JIWMkWXgfbBYNRlEILkQ08Ugj4BXEqJRSYqLLT8yKvl7uLwHs5ku66JwuOiVtt7pwg7aZhkPV20T5ItBItnz0JOzf/AseMFUyMvO4o32saeyBEfRAY6qxaumoTQ8BX9605SJJolCLW3aqI6Vbgp8KRtyHKBBOD3J8E8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KrGvbT/O; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KrGvbT/O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Mv
	OgnY40bYdKwI7ETui6agwoUfKK5zDwLk9monVSo78=; b=KrGvbT/OORbxBNSvVG
	9vql1wdwwZ0cbonuVDNFIKrNM+SAJmeZKFk/W2l8UDm6S//Q5ZZ0AMTZPIMEgybS
	FUz+rUtB87VehyXAAd3FUg92Os6Ex8DFGfbkxW+RROyTBfqEEYo7nnWgefOcXL3s
	T8VjC1O6+hPEAj80sduIjLnFU=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAn6uNUWhJqz5eTEw--.270S5;
	Sun, 24 May 2026 09:54:42 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 v6 3/3] ext4: allow controlling mballoc stats through proc mb_stats
Date: Sun, 24 May 2026 09:54:21 +0800
Message-ID: <20260524015421.2529617-4-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260524015421.2529617-1-liubaolin12138@163.com>
References: <20260524015421.2529617-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAn6uNUWhJqz5eTEw--.270S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw1DCFW8XF1fAw43WF1UAwb_yoWfZw1UpF
	nxZa4xGr1xZ348Cws7Gr47Xw13Ka48Cw17Jr1Iv34fuFyYvryFyF1ftrW0yFy5GrWUAan5
	Xa1j9ryDGr42k37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jquWdUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6QLNmGoSWmIAiAAA32

From: Baolin Liu <liubaolin@kylinos.cn>

Make /proc/fs/ext4/<dev>/mb_stats writable. Writing 0 disables mballoc
statistics collection, writing 1 enables it, and writing -1 clears the
current statistics before enabling collection.
Update the documentation and deprecate the sysfs mb_stats entry.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Ted Tso <tytso@mit.edu>
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
 Documentation/admin-guide/ext4.rst      |  9 +++-
 Documentation/filesystems/proc.rst      | 13 +-----
 fs/ext4/ext4.h                          |  2 +
 fs/ext4/mballoc.c                       | 32 +++++++++++++-
 fs/ext4/sysfs.c                         | 55 ++++++++++++++++++++++++-
 6 files changed, 97 insertions(+), 17 deletions(-)

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
index df96bcd53a59..ab69ef8e5634 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1625,6 +1625,7 @@ struct ext4_sb_info {
 	unsigned int s_mb_stream_request;
 	unsigned int s_mb_max_to_scan;
 	unsigned int s_mb_min_to_scan;
+	struct mutex s_mb_stats_mutex;
 	unsigned int s_mb_stats;
 	unsigned int s_mb_order2_reqs;
 	unsigned int s_mb_group_prealloc;
@@ -2995,6 +2996,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 extern const struct seq_operations ext4_mb_seq_groups_ops;
 extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
 extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
+extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
 extern int ext4_mb_init(struct super_block *);
 extern void ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fed6d854877b..ee8f62861941 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3214,7 +3214,7 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 		seq_puts(seq, "\tmb stats collection turned off.\n");
 		seq_puts(
 			seq,
-			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
+			"\tTo enable, please write \"1\" to proc file mb_stats.\n");
 		return 0;
 	}
 	seq_printf(seq, "\tblocks_allocated: %u\n",
@@ -3787,6 +3787,7 @@ int ext4_mb_init(struct super_block *sb)
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
+	mutex_init(&sbi->s_mb_stats_mutex);
 	WRITE_ONCE(sbi->s_mb_stats, MB_DEFAULT_STATS);
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
@@ -4723,6 +4724,35 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
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
index 47e06c32c6fb..20935493dda8 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -53,6 +53,54 @@ typedef enum {
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
+	ret = count;
+	mutex_lock(&sbi->s_mb_stats_mutex);
+	switch (val) {
+	case -1:
+		WRITE_ONCE(sbi->s_mb_stats, 0);
+		ext4_mb_stats_clear(sbi);
+		WRITE_ONCE(sbi->s_mb_stats, 1);
+		break;
+	case 1:
+		WRITE_ONCE(sbi->s_mb_stats, 1);
+		break;
+	case 0:
+		WRITE_ONCE(sbi->s_mb_stats, 0);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	mutex_unlock(&sbi->s_mb_stats_mutex);
+
+	return ret;
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
@@ -466,7 +514,10 @@ static ssize_t mb_stats_store(struct ext4_sb_info *sbi,
 	ret = kstrtouint(skip_spaces(buf), 0, &t);
 	if (ret)
 		return ret;
+
+	mutex_lock(&sbi->s_mb_stats_mutex);
 	WRITE_ONCE(sbi->s_mb_stats, t);
+	mutex_unlock(&sbi->s_mb_stats_mutex);
 	return len;
 }
 
@@ -666,8 +717,8 @@ int ext4_register_sysfs(struct super_block *sb)
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

