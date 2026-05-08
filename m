Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F753C0633;
	Fri,  8 May 2026 09:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232936; cv=none; b=e+iGiekJ68Rd5hHSmeqkMd8RmbROiSbsyJ3ODQqhVHzciR186Odlh40DPfhM5jBO3yq/9o22iOO0H302zCkh/vcZ/wu4w9fxzt4Lk4wWOdLnmT8reK07uKJE25VS4cbClO/prejKMQIAhJiwrMO1xEmOT7SlvB5435zQDI4vwn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232936; c=relaxed/simple;
	bh=iLEMVuIUAYNxQld7HNPZ4x6eyg9UYHHvPCzN+/WuXjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gjbp7IwQ+ZERsr9SZqyBw9vA5RQAJigeiXTIAsIMsVHc2G5EJ2l956b7Wd/8XV8EI3rriyA42o0nrCq3e5gVNZvZI3inAZAnGE3lwWJ6JDvw8wsbbX0iWEogN/megIDCfBBZ0WYcbRMxODq0w5aYAw7Uv4x96VBAdiof30qSjss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ef0SfN4O; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ef0SfN4O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ho
	x6VtJtqn/K6Bdh5hfLYu35wGS6LKEAxmhmuB+uoe4=; b=Ef0SfN4OpTU0tKeQ56
	8+1ipUPsd6CmNBgVdtL4bv5FZlljgs2yrJYDGk5OV0ImkZzk+BCxS2XUKZExjp1U
	gl0VcFR5tpWj1cYdoE5ZCXGFPr8va9Gqqig+0fSZ+SDZFWq1cry6Xdy8Z5CJ3X/0
	FlFizDrIpUc1YRDjXekWpuT8g=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXeCEprv1pUW9wDg--.60442S4;
	Fri, 08 May 2026 17:34:56 +0800 (CST)
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
Subject: [PATCH v4 v4 2/3] ext4: use atomic operations for s_mb_stats accesses
Date: Fri,  8 May 2026 17:34:27 +0800
Message-ID: <20260508093428.5814-3-liubaolin12138@163.com>
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
X-CM-TRANSID:PSgvCgDXeCEprv1pUW9wDg--.60442S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3ArWkAw4rtry5Ww48tr4UCFg_yoWxAFWxpr
	srZFyUAr48Zw18uF4DWa98W3Z5K3y0k347Jr4S934fuFyavFyFyasaqFyUAFyDArWDAFn5
	Z3yqyrWDGrWIka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zNiifUUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6QCVYGn9rkB+7gAA32

From: Baolin Liu <liubaolin@kylinos.cn>

s_mb_stats can be read from mballoc paths while being updated
through sysfs, which can race.
Convert it to atomic_t and use atomic_read()/atomic_set()
for all accesses.

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/mballoc.c | 24 ++++++++++++------------
 fs/ext4/sysfs.c   |  9 ++++++++-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..04bccfcb018e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1624,7 +1624,7 @@ struct ext4_sb_info {
 	unsigned int s_mb_stream_request;
 	unsigned int s_mb_max_to_scan;
 	unsigned int s_mb_min_to_scan;
-	unsigned int s_mb_stats;
+	atomic_t s_mb_stats;
 	unsigned int s_mb_order2_reqs;
 	unsigned int s_mb_group_prealloc;
 	unsigned int s_max_dir_size_kb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1e13ef62cb9d..95103fbc1583 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -924,7 +924,7 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 	xa_for_each_range(xa, group, grp, start, end - 1) {
 		int err;
 
-		if (sbi->s_mb_stats)
+		if (atomic_read(&sbi->s_mb_stats))
 			atomic64_inc(&sbi->s_bal_cX_groups_considered[cr]);
 
 		err = ext4_mb_scan_group(ac, grp->bb_group);
@@ -980,7 +980,7 @@ static int ext4_mb_scan_groups_p2_aligned(struct ext4_allocation_context *ac,
 		goto wrap_around;
 	}
 
-	if (sbi->s_mb_stats)
+	if (atomic_read(&sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 
 	/* Increment cr and search again if no group is found */
@@ -1031,7 +1031,7 @@ static int ext4_mb_scan_groups_goal_fast(struct ext4_allocation_context *ac,
 		goto wrap_around;
 	}
 
-	if (sbi->s_mb_stats)
+	if (atomic_read(&sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 	/*
 	 * CR_BEST_AVAIL_LEN works based on the concept that we have
@@ -1135,7 +1135,7 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 
 	/* Reset goal length to original goal length before falling into CR_GOAL_LEN_SLOW */
 	ac->ac_g_ex.fe_len = ac->ac_orig_goal_len;
-	if (sbi->s_mb_stats)
+	if (atomic_read(&sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 	ac->ac_criteria = CR_GOAL_LEN_SLOW;
 
@@ -1184,7 +1184,7 @@ static int ext4_mb_scan_groups_linear(struct ext4_allocation_context *ac,
 		ac->ac_criteria++;
 
 	/* Processed all groups and haven't found blocks */
-	if (sbi->s_mb_stats && i == ngroups)
+	if (atomic_read(&sbi->s_mb_stats) && i == ngroups)
 		atomic64_inc(&sbi->s_bal_cX_failed[cr]);
 
 	return 0;
@@ -2535,7 +2535,7 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 
 		BUG_ON(ac->ac_f_ex.fe_len != ac->ac_g_ex.fe_len);
 
-		if (EXT4_SB(sb)->s_mb_stats)
+		if (atomic_read(&EXT4_SB(sb)->s_mb_stats))
 			atomic_inc(&EXT4_SB(sb)->s_bal_2orders);
 
 		break;
@@ -2780,7 +2780,7 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 
 	if (!grp)
 		return -EFSCORRUPTED;
-	if (sbi->s_mb_stats)
+	if (atomic_read(&sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_groups_considered[ac->ac_criteria]);
 	if (should_lock) {
 		ext4_lock_group(sb, group);
@@ -3091,7 +3091,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		}
 	}
 
-	if (sbi->s_mb_stats && ac->ac_status == AC_STATUS_FOUND) {
+	if (atomic_read(&sbi->s_mb_stats) && ac->ac_status == AC_STATUS_FOUND) {
 		atomic64_inc(&sbi->s_bal_cX_hits[ac->ac_criteria]);
 		if (ac->ac_flags & EXT4_MB_STREAM_ALLOC &&
 		    ac->ac_b_ex.fe_group == ac->ac_g_ex.fe_group)
@@ -3204,7 +3204,7 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	seq_puts(seq, "mballoc:\n");
-	if (!sbi->s_mb_stats) {
+	if (!atomic_read(&sbi->s_mb_stats)) {
 		seq_puts(seq, "\tmb stats collection turned off.\n");
 		seq_puts(
 			seq,
@@ -3783,7 +3783,7 @@ int ext4_mb_init(struct super_block *sb)
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
-	sbi->s_mb_stats = MB_DEFAULT_STATS;
+	atomic_set(&sbi->s_mb_stats, MB_DEFAULT_STATS);
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
 	sbi->s_mb_best_avail_max_trim_order = MB_DEFAULT_BEST_AVAIL_TRIM_ORDER;
@@ -3929,7 +3929,7 @@ void ext4_mb_release(struct super_block *sb)
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
 	iput(sbi->s_buddy_cache);
-	if (sbi->s_mb_stats) {
+	if (atomic_read(&sbi->s_mb_stats)) {
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u blocks %u reqs (%u success)",
 				atomic_read(&sbi->s_bal_allocated),
@@ -4694,7 +4694,7 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
-	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len >= 1) {
+	if (atomic_read(&sbi->s_mb_stats) && ac->ac_g_ex.fe_len >= 1) {
 		atomic_inc(&sbi->s_bal_reqs);
 		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
 		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index b87d7bdab06a..0f65ab372dee 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -250,7 +250,7 @@ EXT4_ATTR_OFFSET(mb_best_avail_max_trim_order, 0644, mb_order,
 		 ext4_sb_info, s_mb_best_avail_max_trim_order);
 EXT4_ATTR_OFFSET(err_report_sec, 0644, err_report_sec, ext4_sb_info, s_err_report_sec);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
-EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
+EXT4_ATTR_OFFSET(mb_stats, 0644, pointer_atomic, ext4_sb_info, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
@@ -493,6 +493,7 @@ static ssize_t ext4_generic_attr_store(struct ext4_attr *a,
 				       const char *buf, size_t len)
 {
 	int ret;
+	int i;
 	unsigned int t;
 	unsigned long lt;
 	void *ptr = calc_ptr(a, sbi);
@@ -540,6 +541,12 @@ static ssize_t ext4_generic_attr_store(struct ext4_attr *a,
 			return ret;
 		*((unsigned long *) ptr) = lt;
 		return len;
+	case attr_pointer_atomic:
+		ret = kstrtoint(skip_spaces(buf), 0, &i);
+		if (ret)
+			return ret;
+		atomic_set((atomic_t *)ptr, i);
+		return len;
 	}
 	return 0;
 }
-- 
2.51.0

