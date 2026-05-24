Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC452AD35;
	Sun, 24 May 2026 01:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779587723; cv=none; b=l80DK9v/Hp/I5lsTKxfI54ta26GoWzwfbIM8UY2W3rRpv1cQBjmHK2YZubbR6YbpEbpnMbJnq+kRIDnaQEGP/w2yuGMfq3yxxQ22ZahuFp64k7XNPQWzeGBBnoCygN1WQLiZe12L9KUQKBXdNLcEtDnSUHSNLdJSGpwU+NfFvlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779587723; c=relaxed/simple;
	bh=ys/WFercO1BG0GEj8pgLXktAqsELqBX339nbqtz3Hl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McPFl6qlCMuWgArwzTsQ5GdJzTOZUGXy0hU2Q8LTt2vcJFRbUgE9Cz5+1Sn2Cbm6JSdpLUIIi22+bV+hoN1AKCLlfqmmXOQ3tgFfLwtPLIXY1GadRF+cPghUFnCaHmo3No38sPb8oRzudeZl/p8OAgGq75aLA0tDLKeerQUeQy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j9ZX0L5S; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j9ZX0L5S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=SM
	YDAw6Simc31ovebDOSR++gQdumOKs9k/YiBIZ8Vpg=; b=j9ZX0L5Sp2sSillFfc
	tjJXPSwTwKOQcwKC1MTb1h3HjOmZjPeiPBOQ4S31vySlP4QcuCNuBSC8S6NQLgBq
	hxZI9v6fds51sb+7+p2PCXSDobXQ6SFwoALT2HNF1YoDKvJp7I0pKzjupBQPpI9Y
	+BvfdmDgmSHdA4Fu3CpyXriHg=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAn6uNUWhJqz5eTEw--.270S4;
	Sun, 24 May 2026 09:54:38 +0800 (CST)
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
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v6 v6 2/3] ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
Date: Sun, 24 May 2026 09:54:20 +0800
Message-ID: <20260524015421.2529617-3-liubaolin12138@163.com>
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
X-CM-TRANSID:PygvCgAn6uNUWhJqz5eTEw--.270S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3XFyDJrykGF1DAr18CFW7Arb_yoW3Jr4fpr
	47ZFyUAr47Zw1xCFsrWan8W3ZYk3yIkFy7JrWfu34F9FyagFyayryaqFyjyF9rArWDCFsY
	v3yqyrWDGrWIka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UNL0OUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwh7Ml2oSWl62rQAA3g

From: Baolin Liu <liubaolin@kylinos.cn>

Use READ_ONCE()/WRITE_ONCE() for concurrent accesses to
s_mb_stats.

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 fs/ext4/mballoc.c | 24 ++++++++++++------------
 fs/ext4/sysfs.c   | 25 ++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d36b0f7b5d7d..fed6d854877b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -924,7 +924,7 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 	xa_for_each_range(xa, group, grp, start, end - 1) {
 		int err;
 
-		if (sbi->s_mb_stats)
+		if (READ_ONCE(sbi->s_mb_stats))
 			atomic64_inc(&sbi->s_bal_cX_groups_considered[cr]);
 
 		err = ext4_mb_scan_group(ac, grp->bb_group);
@@ -980,7 +980,7 @@ static int ext4_mb_scan_groups_p2_aligned(struct ext4_allocation_context *ac,
 		goto wrap_around;
 	}
 
-	if (sbi->s_mb_stats)
+	if (READ_ONCE(sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 
 	/* Increment cr and search again if no group is found */
@@ -1031,7 +1031,7 @@ static int ext4_mb_scan_groups_goal_fast(struct ext4_allocation_context *ac,
 		goto wrap_around;
 	}
 
-	if (sbi->s_mb_stats)
+	if (READ_ONCE(sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 	/*
 	 * CR_BEST_AVAIL_LEN works based on the concept that we have
@@ -1135,7 +1135,7 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 
 	/* Reset goal length to original goal length before falling into CR_GOAL_LEN_SLOW */
 	ac->ac_g_ex.fe_len = ac->ac_orig_goal_len;
-	if (sbi->s_mb_stats)
+	if (READ_ONCE(sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_failed[ac->ac_criteria]);
 	ac->ac_criteria = CR_GOAL_LEN_SLOW;
 
@@ -1184,7 +1184,7 @@ static int ext4_mb_scan_groups_linear(struct ext4_allocation_context *ac,
 		ac->ac_criteria++;
 
 	/* Processed all groups and haven't found blocks */
-	if (sbi->s_mb_stats && i == ngroups)
+	if (READ_ONCE(sbi->s_mb_stats) && i == ngroups)
 		atomic64_inc(&sbi->s_bal_cX_failed[cr]);
 
 	return 0;
@@ -2541,7 +2541,7 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 
 		BUG_ON(ac->ac_f_ex.fe_len != ac->ac_g_ex.fe_len);
 
-		if (EXT4_SB(sb)->s_mb_stats)
+		if (READ_ONCE(EXT4_SB(sb)->s_mb_stats))
 			atomic_inc(&EXT4_SB(sb)->s_bal_2orders);
 
 		break;
@@ -2786,7 +2786,7 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 
 	if (!grp)
 		return -EFSCORRUPTED;
-	if (sbi->s_mb_stats)
+	if (READ_ONCE(sbi->s_mb_stats))
 		atomic64_inc(&sbi->s_bal_cX_groups_considered[ac->ac_criteria]);
 	if (should_lock) {
 		ext4_lock_group(sb, group);
@@ -3097,7 +3097,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		}
 	}
 
-	if (sbi->s_mb_stats && ac->ac_status == AC_STATUS_FOUND) {
+	if (READ_ONCE(sbi->s_mb_stats) && ac->ac_status == AC_STATUS_FOUND) {
 		atomic64_inc(&sbi->s_bal_cX_hits[ac->ac_criteria]);
 		if (ac->ac_flags & EXT4_MB_STREAM_ALLOC &&
 		    ac->ac_b_ex.fe_group == ac->ac_g_ex.fe_group)
@@ -3210,7 +3210,7 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	seq_puts(seq, "mballoc:\n");
-	if (!sbi->s_mb_stats) {
+	if (!READ_ONCE(sbi->s_mb_stats)) {
 		seq_puts(seq, "\tmb stats collection turned off.\n");
 		seq_puts(
 			seq,
@@ -3787,7 +3787,7 @@ int ext4_mb_init(struct super_block *sb)
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
-	sbi->s_mb_stats = MB_DEFAULT_STATS;
+	WRITE_ONCE(sbi->s_mb_stats, MB_DEFAULT_STATS);
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
 	sbi->s_mb_best_avail_max_trim_order = MB_DEFAULT_BEST_AVAIL_TRIM_ORDER;
@@ -3929,7 +3929,7 @@ void ext4_mb_release(struct super_block *sb)
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
 	iput(sbi->s_buddy_cache);
-	if (sbi->s_mb_stats) {
+	if (READ_ONCE(sbi->s_mb_stats)) {
 		ext4_msg(sb, KERN_INFO,
 		       "mballoc: %u blocks %u reqs (%u success)",
 				atomic_read(&sbi->s_bal_allocated),
@@ -4694,7 +4694,7 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
-	if (sbi->s_mb_stats && ac->ac_g_ex.fe_len >= 1) {
+	if (READ_ONCE(sbi->s_mb_stats) && ac->ac_g_ex.fe_len >= 1) {
 		atomic_inc(&sbi->s_bal_reqs);
 		atomic_add(ac->ac_b_ex.fe_len, &sbi->s_bal_allocated);
 		if (ac->ac_b_ex.fe_len >= ac->ac_o_ex.fe_len)
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index afe12bcc1603..47e06c32c6fb 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -41,6 +41,7 @@ typedef enum {
 	attr_pointer_atomic,
 	attr_journal_task,
 	attr_err_report_sec,
+	attr_mb_stats,
 } attr_id_t;
 
 typedef enum {
@@ -241,6 +242,7 @@ EXT4_ATTR_FUNC(session_write_kbytes, 0444);
 EXT4_ATTR_FUNC(lifetime_write_kbytes, 0444);
 EXT4_ATTR_FUNC(reserved_clusters, 0644);
 EXT4_ATTR_FUNC(sra_exceeded_retry_limit, 0444);
+EXT4_ATTR_FUNC(mb_stats, 0644);
 
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, inode_readahead,
 		 ext4_sb_info, s_inode_readahead_blks);
@@ -250,7 +252,6 @@ EXT4_ATTR_OFFSET(mb_best_avail_max_trim_order, 0644, mb_order,
 		 ext4_sb_info, s_mb_best_avail_max_trim_order);
 EXT4_ATTR_OFFSET(err_report_sec, 0644, err_report_sec, ext4_sb_info, s_err_report_sec);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
-EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
@@ -451,6 +452,24 @@ static ssize_t ext4_generic_attr_show(struct ext4_attr *a,
 	return 0;
 }
 
+static ssize_t mb_stats_show(struct ext4_sb_info *sbi, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", READ_ONCE(sbi->s_mb_stats));
+}
+
+static ssize_t mb_stats_store(struct ext4_sb_info *sbi,
+			      const char *buf, size_t len)
+{
+	unsigned int t;
+	int ret;
+
+	ret = kstrtouint(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
+	WRITE_ONCE(sbi->s_mb_stats, t);
+	return len;
+}
+
 static ssize_t ext4_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
@@ -475,6 +494,8 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 		return sysfs_emit(buf, "%llu\n",
 				(unsigned long long)
 			percpu_counter_sum(&sbi->s_sra_exceeded_retry_limit));
+	case attr_mb_stats:
+		return mb_stats_show(sbi, buf);
 	case attr_feature:
 		return sysfs_emit(buf, "supported\n");
 	case attr_first_error_time:
@@ -559,6 +580,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
 		return inode_readahead_blks_store(sbi, buf, len);
 	case attr_trigger_test_error:
 		return trigger_test_error(sbi, buf, len);
+	case attr_mb_stats:
+		return mb_stats_store(sbi, buf, len);
 	case attr_err_report_sec:
 		return err_report_sec_store(sbi, buf, len);
 	default:
-- 
2.51.0

