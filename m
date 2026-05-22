Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE8F28F948;
	Fri, 22 May 2026 04:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779422424; cv=none; b=Bf2YjcyM9jsPhx00SiK+1D9mod/AjMxQWM5F/antwiPJ2CpOJYOSLT+QKQIwTgOob06+xRNFLvxMm08AAa3kV0yt94qWFx6iphweOSpndGC+oGCmOItZ07CN5yt2DDzQYOIEIT9NT/nJxqNfXMZ8oNBbn8vR1DxWMZgVvhKt/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779422424; c=relaxed/simple;
	bh=usrhubYvV6DbP7IaKA+XoWkdgfWfWsU/BecHNkIWpHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/cyKpgp5HoqEz/We8fNfZXxf+uifEox5W9Lk9wOqldhwWGIdHEZFHdf6qruDobbGSWkODUnal+xDZ4E070Xj2BmAaHG1NeCls5GfnDOAJ/BzoIyjWTEhxvo7Ol10Xt6km9Ud6UbuRZfNUAGfP8ejR+ko7L4PEfr0r5w/js8RXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ez4x85CZ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ez4x85CZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=hD
	L4307WehZFu9ngGDPsnnlOD6nltomLHMa43Oq2eJE=; b=Ez4x85CZdwYuy4x8M3
	SXElqY63zbz4M8I9lFrlc/nStMaT7aqmBPg2Qc+Q1yDwFF9e9wRBwZ62RwBJjHwD
	H1OEhLF5Gwk2ZIoe8ECxG3bkFNNeBNj0nW/H4givj740aiSF6DGTxSRPDLan80oi
	QmNegyEl0LGNiRooPltxzG8gQ=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDX3wWO1A9qtnXKCg--.18860S5;
	Fri, 22 May 2026 11:59:19 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v5 v5 3/3] ext4: allow controlling mballoc stats through proc mb_stats
Date: Fri, 22 May 2026 11:59:05 +0800
Message-ID: <20260522035905.1145743-4-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522035905.1145743-1-liubaolin12138@163.com>
References: <20260522035905.1145743-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3wWO1A9qtnXKCg--.18860S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw1kXFy3Ar4rXw13uw47XFb_yoW3Kr45pF
	nxZa4xGr1xXa4UCws7Gr4xXw13C3WxC347tr1I9340gr9IvryFyF1ftrW0yFy5GrWUAa95
	XF4j9ryUGr42k37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jgfHUUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6Ri5hGoP1JgjQQAA3H

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
 fs/ext4/mballoc.c                       | 31 +++++++++++++++-
 fs/ext4/sysfs.c                         | 48 +++++++++++++++++++++++--
 6 files changed, 88 insertions(+), 17 deletions(-)

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
index df96bcd53a59..483438d5742b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2995,6 +2995,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 extern const struct seq_operations ext4_mb_seq_groups_ops;
 extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
 extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
+extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
 extern int ext4_mb_init(struct super_block *);
 extern void ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fed6d854877b..3f6454ada587 100644
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
index 47e06c32c6fb..76e6c346231a 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -53,6 +53,50 @@ typedef enum {
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
@@ -666,8 +710,8 @@ int ext4_register_sysfs(struct super_block *sb)
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

