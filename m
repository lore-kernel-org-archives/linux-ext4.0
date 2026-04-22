Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A850D3090C4;
	Wed, 22 Apr 2026 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776822772; cv=none; b=Q9WZq81AN3VhgbigSa2r9t5wxa96Eg2UtXT7NWELWGBbLH5t2deBQrrerKqss7fHc7c8azctUA9qetLco132UeUXf2rii+W5uI4wzrlsCaqqOtd8OaYfGYkhw1LG4uqNpWyBZHkoyyn0Sfs8YDUe16+wqYYeZQcXwu7dcHLj5f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776822772; c=relaxed/simple;
	bh=d3/dSb8VCsfS1PnI0yLe8lTP/fXOz2nNcgCYfTB7PVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2Ug/kg4rwMHhGnFE0xXQs1oNZmKNnj9ME40rjFvEzg9w26J/7GM2yPQai9EAi1wvGzjb3YM8Wj3HzXUNsSTSjLQU7HkeSyrHYqMcY4Xwgx8YxTkVNzNuyy/O5cLsAQqyND8b5NIblTZon6iwXILX+R6Cz17ussAm2t5GdKnv0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VqiApriF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VqiApriF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=dE
	Z9FIUPUF+T6ETjcmLX+Rkx/mVcnjQZFx9WuuF6ilM=; b=VqiApriFvRN4Z6E9no
	7/+64z/mVsdsVapf9Ggzdz2vRtv3fAx+fhgHvdYgouQBq398YHi0asb6eX3Ah8Ar
	Rovw21Cz7AiuPIyUc7rNq4hsD/B4sr2IoQvesU32H1oh21lrEuM8a1O534MLTGXI
	WGmCfvLfFgz8K6M47zBO/4mig=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wA3Hx+uKehpOCzjAw--.387S4;
	Wed, 22 Apr 2026 09:52:01 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	liubaolin12138@163.com,
	Baolin Liu <liubaolin@kylinos.cn>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through mb_stats
Date: Wed, 22 Apr 2026 09:50:25 +0800
Message-ID: <20260422015026.7170-3-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422015026.7170-1-liubaolin12138@163.com>
References: <20260422015026.7170-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3Hx+uKehpOCzjAw--.387S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3JrW8GFyxCr45CF1fGrW3Jrb_yoW7tFyUpF
	s8ZFyxGr18Wa47uws7Gr4xZw1Yy3W8Cw1UKryIv34rur9Iqr9YyF1rtryjyFyYgrWUAayk
	XF429ryUGr42ka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_73kDUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwgEP2WnoKcE7yQAA3O

From: Baolin Liu <liubaolin@kylinos.cn>

Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
mballoc statistics when 0 is written.
Update the related documentation accordingly.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 Documentation/admin-guide/ext4.rst |  5 ++++
 Documentation/filesystems/proc.rst |  3 +++
 fs/ext4/ext4.h                     |  1 +
 fs/ext4/mballoc.c                  | 29 ++++++++++++++++++++++
 fs/ext4/sysfs.c                    | 40 ++++++++++++++++++++++++++++--
 5 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index ac0c709ea9e7..fb3887cd5e44 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -436,6 +436,11 @@ Files in /proc/fs/ext4/<devname>
   mb_groups
         details of multiblock allocator buddy cache of free blocks
 
+  mb_stats
+        reports runtime statistics from the multiblock allocator
+        (mballoc). Writing 0 to this file clears the current
+        statistics.
+
 /sys entries
 ============
 
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..7ce02573a3d9 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1634,6 +1634,9 @@ directory are shown in Table 1-12, below.
  ==============  ==========================================================
  File            Content
  mb_groups       details of multiblock allocator buddy cache of free blocks
+ mb_stats        reports runtime statistics from the multiblock allocator
+                 (mballoc). Writing 0 to this file clears the current
+                 statistics.
  ==============  ==========================================================
 
 1.9 /proc/consoles
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..3223e73612ae 100644
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
index 1e13ef62cb9d..79ddfa935813 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
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
index b87d7bdab06a..e90885d470ab 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -52,6 +52,42 @@ typedef enum {
 static const char proc_dirname[] = "fs/ext4";
 static struct proc_dir_entry *ext4_proc_root;
 
+static int ext4_mb_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ext4_seq_mb_stats_show, pde_data(inode));
+}
+
+static ssize_t ext4_mb_stats_write(struct file *file, const char __user *buf,
+					   size_t count, loff_t *ppos)
+{
+	struct super_block *sb = pde_data(file_inode(file));
+	char kbuf[2];
+
+	if (count == 0 || count > sizeof(kbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kbuf, buf, count))
+		return -EFAULT;
+
+	if (count == 2) {
+		if (kbuf[0] != '0' || kbuf[1] != '\n')
+			return -EINVAL;
+	} else if (kbuf[0] != '0') {
+		return -EINVAL;
+	}
+
+	ext4_mb_stats_clear(EXT4_SB(sb));
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
@@ -630,8 +666,8 @@ int ext4_register_sysfs(struct super_block *sb)
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

