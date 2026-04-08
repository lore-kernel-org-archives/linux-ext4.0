Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE6C3B3884;
	Wed,  8 Apr 2026 11:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647701; cv=pass; b=DwR9JPfs/vYXUrqYC9x1VKVo+VTCAR/kOIdVZhNuLzEzHAyPkkF3Brdw4/QLumVvcoAniQmcAdRa+J7aVe6zApwOVoZMhq/j2Zb8JZpovxbzlQ8+3cigZqPnYCaEcD7NHFLPjWf3lJg5wk3xVbfvhTOTEa7Brx94DVd7A6U1wg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647701; c=relaxed/simple;
	bh=6fnFM4SIDFqVFNwB1ZswIgwj5y50WZYZrO2BVNV9AqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLdg2v6doc2MHoCnc1fLMSbKgxfDsSQrarQUnZgrhR6DNkSgwLLYW4QfZjscBsvnVxM0AOa4g1coLD6lbVbLyujNnC5yljKjNyDsmUgwn92J9SDBVlDzmplgQxSqB8qbGnayuk9VupVd1ttpebrsGTxDeVdodIdpxU8Ekjqt/Bc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=WqzO/F5q; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="WqzO/F5q"
ARC-Seal: i=1; a=rsa-sha256; t=1775647288; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UriqaxI6g+C7zbXquyBR2wph/iAeO60DWWb6RLhCkEGtAljSEKcXhm9CeBKW5aKo8rYwRiEv+tTCWlqM3cwqqG3uGC5925Ua6zW0Rq3e3Tsw4GnmV3yt/dyRjBUfnM3WImb+SJj+SsUuy71u3TLUFraHsXpFZTaWwGXKFtHRkBA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775647288; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6XIlbKPn8BJCGST59C+8dNsF7W7V9tiD+xZydIj83hA=; 
	b=nZ+Yoi38i94JqH7YtYBtkXPliL18gU7VUl4mM/5RNdtbCpfCWOtTbhav1IDjB81l+t/Fy4Ugs/wASbdtdVbGBzQsxLvSHE3kqt0WGetx0xaRaPe/eZqGzrChR6i8E5kPIwjuWEfjkGSDFFH9dzKZFGvgzLPwZRBgJxpqXth+v1g=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775647288;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6XIlbKPn8BJCGST59C+8dNsF7W7V9tiD+xZydIj83hA=;
	b=WqzO/F5q2dv9/Mw8vZ5qziBS9vaOv/UJwvHOoyeMiupn9NI1PVymLO7QVLFDCW/W
	X7GsjHfWEuD+weEJteDxy1jctzpPNItwiOLdidfvVfWjHC/oltlJixzjC59Xk8RCZjY
	oAwJ4OMtz0Wd1P0YP+UOaCFyHDMc7dZtRg0MLsUk=
Received: by mx.zohomail.com with SMTPS id 1775647287115748.8747144064414;
	Wed, 8 Apr 2026 04:21:27 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [RFC v6 7/7] ext4: fast commit: export snapshot stats in fc_info
Date: Wed,  8 Apr 2026 19:20:18 +0800
Message-ID: <20260408112020.716706-8-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408112020.716706-1-me@linux.beauty>
References: <20260408112020.716706-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Snapshot-based fast commit can fall back when the commit-time snapshot
cannot be built (e.g. extent status cache misses). It is useful to
quantify the updates-locked window and to see why snapshotting failed.

Add best-effort snapshot counters to the ext4 superblock and extend
/proc/fs/ext4/<sb_id>/fc_info to report the number of snapshotted
inodes and ranges, snapshot failure reasons, and the average/max time
spent with journal updates locked.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- Start consuming locked_ns in fc_info, so this patch intentionally moves
  lock_updates_ns_{total,max,samples} accounting here.
- Guard the tracepoint call with trace_ext4_fc_lock_updates_enabled() and
  use trace_call__ext4_fc_lock_updates() to avoid the double static_branch
  at the guarded call site.
- keeps the stats unconditionally while avoiding extra tracepoint
  overhead when ext4_fc_lock_updates is disabled.

 fs/ext4/ext4.h        | 31 +++++++++++++++++++
 fs/ext4/fast_commit.c | 72 +++++++++++++++++++++++++++++++++++++------
 fs/ext4/super.c       |  1 +
 3 files changed, 94 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1ff6ea1bde3e..c9ed7ceca982 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1554,6 +1554,36 @@ struct ext4_orphan_info {
 						 * file blocks */
 };
 
+/*
+ * Ext4 fast commit snapshot statistics.
+ *
+ * These are best-effort counters intended for debugging / performance
+ * introspection; they are not exact under concurrent updates.
+ */
+struct ext4_fc_snap_stats {
+	u64 lock_updates_ns_total;
+	u64 lock_updates_ns_max;
+	u64 lock_updates_samples;
+
+	u64 snap_inodes;
+	u64 snap_ranges;
+
+	u64 snap_fail_es_miss;
+	u64 snap_fail_es_delayed;
+	u64 snap_fail_es_other;
+
+	u64 snap_fail_inodes_cap;
+	u64 snap_fail_ranges_cap;
+	u64 snap_fail_nomem;
+	u64 snap_fail_inode_loc;
+
+	/*
+	 * Missing inode snapshots during log writing should never happen.
+	 * Keep this counter to help catch unexpected regressions.
+	 */
+	u64 snap_fail_no_snap;
+};
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1828,6 +1858,7 @@ struct ext4_sb_info {
 	struct mutex s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
+	struct ext4_fc_snap_stats s_fc_snap_stats;
 	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 6ac6ebe79d7b..3c6ace2b0b94 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -890,13 +890,17 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	int inode_len;
 	int ret;
 
-	if (!snap)
+	if (!snap) {
+		EXT4_SB(inode->i_sb)->s_fc_snap_stats.snap_fail_no_snap++;
 		return -ECANCELED;
+	}
 
 	src = snap->inode_buf;
 	inode_len = snap->inode_len;
-	if (!src || inode_len == 0)
+	if (!src || inode_len == 0) {
+		EXT4_SB(inode->i_sb)->s_fc_snap_stats.snap_fail_no_snap++;
 		return -ECANCELED;
+	}
 
 	fc_inode.fc_ino = cpu_to_le32(inode->i_ino);
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
@@ -931,8 +935,10 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 	struct ext4_extent *ex;
 	struct ext4_fc_range *range;
 
-	if (!snap)
+	if (!snap) {
+		EXT4_SB(inode->i_sb)->s_fc_snap_stats.snap_fail_no_snap++;
 		return -ECANCELED;
+	}
 
 	list_for_each_entry(range, &snap->data_list, list) {
 		if (range->tag == EXT4_FC_TAG_DEL_RANGE) {
@@ -993,6 +999,8 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				       int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
 	unsigned int nr_ranges = 0;
 
@@ -1019,11 +1027,13 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		ext4_lblk_t len;
 
 		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL)) {
+			stats->snap_fail_es_miss++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
 			return -EAGAIN;
 		}
 
 		if (ext4_es_is_delayed(&es)) {
+			stats->snap_fail_es_delayed++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_ES_DELAYED);
 			return -EAGAIN;
@@ -1038,6 +1048,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		}
 
 		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+			stats->snap_fail_ranges_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
 			return -E2BIG;
@@ -1045,6 +1056,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 		if (!range) {
+			stats->snap_fail_nomem++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
@@ -1072,6 +1084,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			stats->snap_fail_es_other++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
@@ -1092,6 +1105,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_inode_snap *snap;
 	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
 	struct ext4_iloc iloc;
@@ -1102,6 +1117,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
 	if (ret) {
+		stats->snap_fail_inode_loc++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
 	}
@@ -1113,6 +1129,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		stats->snap_fail_nomem++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
@@ -1137,6 +1154,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	list_splice_tail_init(&ranges, &snap->data_list);
 	ext4_fc_unlock(inode->i_sb, alloc_ctx);
 
+	stats->snap_inodes++;
+	stats->snap_ranges += nr_ranges;
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
@@ -1246,6 +1265,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1271,6 +1291,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1314,6 +1335,7 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
@@ -1376,8 +1398,13 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 		return ret;
 
 	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
-	if (ret)
+	if (ret) {
+		if (ret == -E2BIG)
+			snap_stats->snap_fail_inodes_cap++;
+		else if (ret == -ENOMEM)
+			snap_stats->snap_fail_nomem++;
 		return ret;
+	}
 
 	/* Step 4: Mark all inodes as being committed. */
 	jbd2_journal_lock_updates(journal);
@@ -1398,12 +1425,15 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
 				      &snap_inodes, &snap_ranges, &snap_err);
 	jbd2_journal_unlock_updates(journal);
-	if (trace_ext4_fc_lock_updates_enabled()) {
-		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
-		trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
-					   snap_inodes, snap_ranges, ret,
-					   snap_err);
-	}
+	locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
+	snap_stats->lock_updates_ns_total += locked_ns;
+	snap_stats->lock_updates_samples++;
+	if (locked_ns > snap_stats->lock_updates_ns_max)
+		snap_stats->lock_updates_ns_max = locked_ns;
+	if (trace_ext4_fc_lock_updates_enabled())
+		trace_call__ext4_fc_lock_updates(sb, commit_tid, locked_ns,
+						 snap_inodes, snap_ranges,
+						 ret, snap_err);
 	kvfree(inodes);
 	if (ret)
 		return ret;
@@ -2704,11 +2734,17 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 {
 	struct ext4_sb_info *sbi = EXT4_SB((struct super_block *)seq->private);
 	struct ext4_fc_stats *stats = &sbi->s_fc_stats;
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
+	u64 lock_avg_ns = 0;
 	int i;
 
 	if (v != SEQ_START_TOKEN)
 		return 0;
 
+	if (snap_stats->lock_updates_samples)
+		lock_avg_ns = div_u64(snap_stats->lock_updates_ns_total,
+				      snap_stats->lock_updates_samples);
+
 	seq_printf(seq,
 		"fc stats:\n%ld commits\n%ld ineligible\n%ld numblks\n%lluus avg_commit_time\n",
 		   stats->fc_num_commits, stats->fc_ineligible_commits,
@@ -2719,6 +2755,22 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\"%s\":\t%d\n", fc_ineligible_reasons[i],
 			stats->fc_ineligible_reason_count[i]);
 
+	seq_printf(seq,
+		   "Snapshot stats:\n%llu inodes\n%llu ranges\n%lluus lock_updates_avg\n%lluus lock_updates_max\n",
+		   snap_stats->snap_inodes, snap_stats->snap_ranges,
+		   div_u64(lock_avg_ns, 1000),
+		   div_u64(snap_stats->lock_updates_ns_max, 1000));
+	seq_printf(seq,
+		   "Snapshot failures:\n%llu es_miss\n%llu es_delayed\n%llu es_other\n%llu inodes_cap\n%llu ranges_cap\n%llu nomem\n%llu inode_loc\n%llu no_snap\n",
+		   snap_stats->snap_fail_es_miss,
+		   snap_stats->snap_fail_es_delayed,
+		   snap_stats->snap_fail_es_other,
+		   snap_stats->snap_fail_inodes_cap,
+		   snap_stats->snap_fail_ranges_cap,
+		   snap_stats->snap_fail_nomem,
+		   snap_stats->snap_fail_inode_loc,
+		   snap_stats->snap_fail_no_snap);
+
 	return 0;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 286f05834900..9ae68a223ea6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4538,6 +4538,7 @@ static void ext4_fast_commit_init(struct super_block *sb)
 	sbi->s_fc_ineligible_tid = 0;
 	mutex_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));
+	memset(&sbi->s_fc_snap_stats, 0, sizeof(sbi->s_fc_snap_stats));
 	sbi->s_fc_replay_state.fc_regions = NULL;
 	sbi->s_fc_replay_state.fc_regions_size = 0;
 	sbi->s_fc_replay_state.fc_regions_used = 0;
-- 
2.53.0
