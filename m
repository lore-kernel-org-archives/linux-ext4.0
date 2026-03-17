Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561A347523;
	Tue, 17 Mar 2026 08:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773737580; cv=pass; b=P36p8XIrBAcKQaDqnc+7zU/0MQiuzXBxKQTgV4/I3UhXSe+YDRGwY/kEEypYFaBd6OsiKJ9ycd/7ROgNZiPPr3V1Nzu3PlozUioi60y3CIRTkfTXqIjUqVIn23FR51I81E8oxaC4NlN+fuDfkNQ2g7eQO8p8xd1qjIpF9EdhJVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773737580; c=relaxed/simple;
	bh=YDfzirdiRo0M+LudTwjXEH9ec8iuiDmGrBlAZ6xVMj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrWNo5BB+nCW0M4PAMUU/2JboBH1iV1/dtPPD4W0QdILCBa5tPaci7yRY07HZps0qqdIJFjYkKXufQgzlIZtaQnDDkjdpBtOQknZJtsW7GWzqBL8XgP5zOzB1YxSHwFuu7cEMIixjYd7IuT1PgPCAR1lrmfnZ3N+rFtnvSa+pec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=NVweKBQn; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="NVweKBQn"
ARC-Seal: i=1; a=rsa-sha256; t=1773737223; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NmbCFMWPslHZfdKOAo2eAiktybGxSNNL/DNHfHb5aso2pT2asM8dCk3BfcJouUYsET9LVp8GyqUwsuzEEEg0oTyvF2pst0zWi1zaqRd201Z7khNzjrBncIrbmxOnHfv7YRaPZhOInCoPBQFyGdWktq50FxUGFitt3j7tTRdbpG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1773737223; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IZipebCCXIAh9kCsm/LsBh4bhP5jBk5luuGlwXcTazc=; 
	b=I94/QvvD7I4cILEAJrg/A9icssy9ATENKlIvBI9N0XyOcqEcaD8VX2xwstJLPOqc29KsBua0VWVHqSYrtxk1UKvGvqd0hyCBoyVl89YqH92c6gHgYViAAuGjDlpnfc4e2004Oy70EI0cmFY7ZCSh6op7eXE/xgFU9vKYY6D9/xI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773737223;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=IZipebCCXIAh9kCsm/LsBh4bhP5jBk5luuGlwXcTazc=;
	b=NVweKBQnF4eSkFEnGcucdGRIlu8Smp0L2wL+HRmeTP+BdrosKF6rp2pvhW8k5T05
	dRn+Be0dGWb2Uos8dJ1JK4vclcvXnf0qF1KSK9ZhECArIIcwJzvN9/7mnpdX8Zqk51b
	0NfDdsyIwVI82ORHFFnGZ+CLPl8EWUuVx4XReRhc=
Received: by mx.zohomail.com with SMTPS id 1773737221354759.2787295997053;
	Tue, 17 Mar 2026 01:47:01 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [RFC v5 7/7] ext4: fast commit: export snapshot stats in fc_info
Date: Tue, 17 Mar 2026 16:46:22 +0800
Message-ID: <20260317084624.457185-8-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317084624.457185-1-me@linux.beauty>
References: <20260317084624.457185-1-me@linux.beauty>
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
 fs/ext4/ext4.h        | 31 ++++++++++++++++++++++
 fs/ext4/fast_commit.c | 61 ++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/super.c       |  1 +
 3 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b9e146f3dd9e4..8b7530f2e0706 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1566,6 +1566,36 @@ struct ext4_orphan_info {
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
@@ -1837,6 +1867,7 @@ struct ext4_sb_info {
 	struct mutex s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
+	struct ext4_fc_snap_stats s_fc_snap_stats;
 	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 4929e2990b292..09ae8f52abdab 100644
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
 
@@ -1018,11 +1026,13 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
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
@@ -1037,6 +1047,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		}
 
 		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+			stats->snap_fail_ranges_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
 			return -E2BIG;
@@ -1044,6 +1055,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 		if (!range) {
+			stats->snap_fail_nomem++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
@@ -1071,6 +1083,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			stats->snap_fail_es_other++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
@@ -1091,6 +1104,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_inode_snap *snap;
 	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
 	struct ext4_iloc iloc;
@@ -1101,6 +1116,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
 	if (ret) {
+		stats->snap_fail_inode_loc++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
 	}
@@ -1112,6 +1128,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		stats->snap_fail_nomem++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
@@ -1136,6 +1153,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	list_splice_tail_init(&ranges, &snap->data_list);
 	ext4_fc_unlock(inode->i_sb, alloc_ctx);
 
+	stats->snap_inodes++;
+	stats->snap_ranges += nr_ranges;
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
@@ -1245,6 +1264,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1270,6 +1290,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1313,6 +1334,7 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
@@ -1375,8 +1397,13 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
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
@@ -1398,6 +1425,10 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 				      &snap_inodes, &snap_ranges, &snap_err);
 	jbd2_journal_unlock_updates(journal);
 	locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
+	snap_stats->lock_updates_ns_total += locked_ns;
+	snap_stats->lock_updates_samples++;
+	if (locked_ns > snap_stats->lock_updates_ns_max)
+		snap_stats->lock_updates_ns_max = locked_ns;
 	trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns, snap_inodes,
 				   snap_ranges, ret, snap_err);
 	kvfree(inodes);
@@ -2694,11 +2725,17 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
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
@@ -2709,6 +2746,22 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
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
index 4f5f0c21d436f..3afcaf9d80078 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4500,6 +4500,7 @@ static void ext4_fast_commit_init(struct super_block *sb)
 	sbi->s_fc_ineligible_tid = 0;
 	mutex_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));
+	memset(&sbi->s_fc_snap_stats, 0, sizeof(sbi->s_fc_snap_stats));
 	sbi->s_fc_replay_state.fc_regions = NULL;
 	sbi->s_fc_replay_state.fc_regions_size = 0;
 	sbi->s_fc_replay_state.fc_regions_used = 0;
-- 
2.53.0

