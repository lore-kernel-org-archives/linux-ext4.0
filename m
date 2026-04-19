Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF552DEA9B;
	Sun, 19 Apr 2026 06:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776580532; cv=none; b=qDi4Se4JmL3MLQxuDGlOBToTESu9io9KfinIrFu6iuQ5rAb1hLf7P6tNXculYZry8kONSeqfJmER4P+hUQkWjJhm5FIigOUo5ufBiyOA3tyOjTjXmgCj8GGw7eCA1wQr3wXa5xsakEwLY0aWS8gmSGfilafL95Klzd2Ei3BHVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776580532; c=relaxed/simple;
	bh=IcElDLJMjCTMHhG4c/y16TwfxnjzAG4K21cNoJ+Olfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK+WuQ8GbPv66VaCbSV5ZK2KZDjh4rC5TNT5CbPuACwf/sCs/9iLuDHWWQYnPlEwCC+SdZEMiWtZNtJpmk3zRDbTn9nc+xIgKEdHxPuCtL6qNSruyp9zZ3+9nNeEJeO6UICq2QA6OjfrvQqZSokIpmBrqtNL7xqmsTHvjZ547KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BORXkzTC; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BORXkzTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=E9
	AclkEwYTBKthkg3Pap5rseCoa48EkPaTwn3i5g9gs=; b=BORXkzTCjzHuf8KvXw
	G8oWLq1l/4UVELyuiKBfeoUKdaZ3MeDs+qjdDVQiP3eMeWbIEgeZ8uQYEYNL7kcd
	50S2nZCyEM26sCYbDV9U07cEmpShicBDaNroTndoc9MHgybFam++GHoM9mk3lgbs
	a0P0o1jQLI7W2a5idsbrYkE48=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBHBQKBd+Rp1PA9Ag--.97S4;
	Sun, 19 Apr 2026 14:35:04 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: wangguanyu@vivo.com,
	liubaolin12138@163.com,
	yi.zhang@huaweicloud.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through mb_stats
Date: Sun, 19 Apr 2026 14:34:36 +0800
Message-ID: <20260419063436.17999-3-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419063436.17999-1-liubaolin12138@163.com>
References: <20260419063436.17999-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBHBQKBd+Rp1PA9Ag--.97S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFyUtFW3uFyDtF4UWr1kGrg_yoWrCrW7pF
	s8Za15Gr4UW3Wxuws3GF4fZwn093W0k34UtrWSv34rCryagryrJFnYqFyjyFyYqrWUJ3Wk
	Xa1q934DWr4xKa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zMMKZUUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hiXYmnkd5gOhAAA3v

From: Baolin Liu <liubaolin@kylinos.cn>

Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
mballoc statistics when 0 is written.

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/mballoc.c | 29 +++++++++++++++++++++++++++++
 fs/ext4/sysfs.c   | 40 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 2 deletions(-)

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

