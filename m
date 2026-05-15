Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0143E9D1;
	Fri, 15 May 2026 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837095; cv=pass; b=S+NZZtuYfhLGbKqKvB20zuhCQFsTTJdXXptvVqgY1dkNwLNZZXOXYfszYBuqnB3xX1Q/kuSlp7RWGaogAPIGWpz5/BArZ50MoW3CGeZezbkrV4Vz2TMfftyG5+FA5+JBfRTTBizVh1MOFN347/w9CkSo0EMhnbgLOgzb7vMzFhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837095; c=relaxed/simple;
	bh=5inOJk0EdZuhxd3sd/3jcXTwKffPEw01d9zJ89xtcDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgBhJrdiUwB/RIqO6AiaX7nKQjMwy7M+gAt+PDjw0vuMLkUip6GeWtJHVFl5S7FsModRlicJE8Xb0c+qpQzAUQTZMn+3OuAwracwLBLw9M+wgEgooa+ucW1+4PpXxCD1yDm5CQQsD0/SzxEQYQJYxcB+TtH5d7Krs0DeirwkG/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=CaK4bOYD; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="CaK4bOYD"
ARC-Seal: i=1; a=rsa-sha256; t=1778836760; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ikqhuYklgETWFxB16R8wXfVwo6i/D8dSeDmT7hQ390gevnfcFbMIxGDHpbwgWpL3lczECU8l/zPL1Oc0vAqjNQ5xT6Y91+w3siAkP//lvDj9l2HwdYSn8usZu0VtHmLqe+iARLRQ4su+wjLexKSAx3PecZIrkFi4TEJDmHY7LCQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778836760; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HyAUH616uPbouyX9tzylNYqKKh64X2ipdncasiiELQ0=; 
	b=EEdJmycRpW1qQlW2Xrgq1on9/jYI3cfUuuuZFkFJpeXE1JZ1sXbUist+jTrS+xlpM+sfqVuudEsWYH+lDrQ8utv+nn8kXCL3iXqktSP/rgGU6myF34Z38vM9OuWBVAFeOrJy2sC0TD/EA50VWwWbIuSTAFs3wS4XIM9rdhsTQWg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778836760;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HyAUH616uPbouyX9tzylNYqKKh64X2ipdncasiiELQ0=;
	b=CaK4bOYDdlAImn1dzsBypiFWPM7CTXaJ+giJQkKiz6b+GXjSY7wiwAMSSvB2YONL
	lp4v4UaIsiijBhtGzJJygvDLODdM6WS6EGC9B9fHdfqkcLCMCSrJGbuKJqvAinJ0SB8
	8AknBcQu5vOdPzvXJFEncRfUfG1PswM5L9u04Mpk=
Received: by mx.zohomail.com with SMTPS id 1778836758208497.27615317434993;
	Fri, 15 May 2026 02:19:18 -0700 (PDT)
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
	linux-trace-kernel@vger.kernel.org
Subject: [RFC v8 7/7] ext4: fast commit: export snapshot stats in fc_info
Date: Fri, 15 May 2026 17:18:27 +0800
Message-ID: <20260515091829.194810-8-me@linux.beauty>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515091829.194810-1-me@linux.beauty>
References: <20260515091829.194810-1-me@linux.beauty>
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

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in v8:
- Treat stale snapshot inode sizing as a capacity fallback instead of
  letting log writing later report a missing snapshot.
- Use atomic64_t for the snapshot counters so fc_info cannot observe
  torn 64-bit values on 32-bit systems.

Changes in v7:
- Address Sashiko review by using READ_ONCE() + div64_u64() for the fc_info
  lock_updates average.

Changes in v6:
- Start consuming locked_ns in fc_info, so this patch intentionally moves
  lock_updates_ns_{total,max,samples} accounting here.
- Guard the tracepoint call with trace_ext4_fc_lock_updates_enabled() and
  use trace_call__ext4_fc_lock_updates() to avoid the double static_branch
  at the guarded call site.
- Keep the stats unconditionally while avoiding extra tracepoint
  overhead when ext4_fc_lock_updates is disabled.

 fs/ext4/ext4.h        |  31 ++++++++++++++
 fs/ext4/fast_commit.c |  96 ++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c       |   1 +
 3 files changed, 118 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index dd09d00a73af..ddc903738c6b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1550,6 +1550,36 @@ struct ext4_orphan_info {
 						 * file blocks */
 };
 
+/*
+ * Ext4 fast commit snapshot statistics.
+ *
+ * These are best-effort counters intended for debugging / performance
+ * introspection; they are not exact under concurrent updates.
+ */
+struct ext4_fc_snap_stats {
+	atomic64_t lock_updates_ns_total;
+	atomic64_t lock_updates_ns_max;
+	atomic64_t lock_updates_samples;
+
+	atomic64_t snap_inodes;
+	atomic64_t snap_ranges;
+
+	atomic64_t snap_fail_es_miss;
+	atomic64_t snap_fail_es_delayed;
+	atomic64_t snap_fail_es_other;
+
+	atomic64_t snap_fail_inodes_cap;
+	atomic64_t snap_fail_ranges_cap;
+	atomic64_t snap_fail_nomem;
+	atomic64_t snap_fail_inode_loc;
+
+	/*
+	 * Missing inode snapshots during log writing should never happen.
+	 * Keep this counter to help catch unexpected regressions.
+	 */
+	atomic64_t snap_fail_no_snap;
+};
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1824,6 +1854,7 @@ struct ext4_sb_info {
 	struct mutex s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
+	struct ext4_fc_snap_stats s_fc_snap_stats;
 	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index dc08f8ff43d9..4ef796b9b6cb 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -281,6 +281,19 @@ static inline void ext4_fc_wake_inode_state(struct inode *inode, int bit)
 		    ext4_inode_state_wait_bit(bit));
 }
 
+static void ext4_fc_snap_stats_update_max(atomic64_t *stat, u64 value)
+{
+	u64 old = atomic64_read(stat);
+
+	while (value > old) {
+		u64 prev = atomic64_cmpxchg(stat, old, value);
+
+		if (prev == old)
+			break;
+		old = prev;
+	}
+}
+
 /*
  * Remove inode from fast commit list. If the inode is being committed
  * we wait until inode commit is done.
@@ -868,6 +881,8 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_inode_snap *snap = ei->i_fc_snap;
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_inode fc_inode;
 	struct ext4_fc_tl tl;
 	u8 *dst;
@@ -875,13 +890,17 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	int inode_len;
 	int ret;
 
-	if (!snap)
+	if (!snap) {
+		atomic64_inc(&stats->snap_fail_no_snap);
 		return -ECANCELED;
+	}
 
 	src = snap->inode_buf;
 	inode_len = snap->inode_len;
-	if (!src || inode_len == 0)
+	if (!src || inode_len == 0) {
+		atomic64_inc(&stats->snap_fail_no_snap);
 		return -ECANCELED;
+	}
 
 	fc_inode.fc_ino = cpu_to_le32(inode->i_ino);
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
@@ -911,13 +930,17 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_inode_snap *snap = ei->i_fc_snap;
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_add_range fc_ext;
 	struct ext4_fc_del_range lrange;
 	struct ext4_extent *ex;
 	struct ext4_fc_range *range;
 
-	if (!snap)
+	if (!snap) {
+		atomic64_inc(&stats->snap_fail_no_snap);
 		return -ECANCELED;
+	}
 
 	list_for_each_entry(range, &snap->data_list, list) {
 		if (range->tag == EXT4_FC_TAG_DEL_RANGE) {
@@ -978,6 +1001,8 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				       int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
 	unsigned int nr_ranges = 0;
 
@@ -1005,11 +1030,13 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		u64 remaining = (u64)end_lblk - cur_lblk + 1;
 
 		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL)) {
+			atomic64_inc(&stats->snap_fail_es_miss);
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
 			return -EAGAIN;
 		}
 
 		if (ext4_es_is_delayed(&es)) {
+			atomic64_inc(&stats->snap_fail_es_delayed);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_ES_DELAYED);
 			return -EAGAIN;
@@ -1024,6 +1051,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		}
 
 		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+			atomic64_inc(&stats->snap_fail_ranges_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
 			return -E2BIG;
@@ -1031,6 +1059,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 		if (!range) {
+			atomic64_inc(&stats->snap_fail_nomem);
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
@@ -1058,6 +1087,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			atomic64_inc(&stats->snap_fail_es_other);
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
@@ -1081,6 +1111,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_inode_snap *snap;
 	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
 	struct ext4_iloc iloc;
@@ -1091,6 +1123,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
 	if (ret) {
+		atomic64_inc(&stats->snap_fail_inode_loc);
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
 	}
@@ -1102,6 +1135,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		atomic64_inc(&stats->snap_fail_nomem);
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
@@ -1126,6 +1160,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	list_splice_tail_init(&ranges, &snap->data_list);
 	ext4_fc_unlock(inode->i_sb, alloc_ctx);
 
+	atomic64_inc(&stats->snap_inodes);
+	atomic64_add(nr_ranges, &stats->snap_ranges);
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
@@ -1229,12 +1265,10 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	int ret = 0;
 	int alloc_ctx;
 
-	if (!inodes_size)
-		return 0;
-
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			atomic64_inc(&sbi->s_fc_snap_stats.snap_fail_inodes_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1260,6 +1294,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			atomic64_inc(&sbi->s_fc_snap_stats.snap_fail_inodes_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1303,6 +1338,7 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
@@ -1362,8 +1398,13 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 		return ret;
 
 	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
-	if (ret)
+	if (ret) {
+		if (ret == -E2BIG)
+			atomic64_inc(&snap_stats->snap_fail_inodes_cap);
+		else if (ret == -ENOMEM)
+			atomic64_inc(&snap_stats->snap_fail_nomem);
 		return ret;
+	}
 
 	/* Step 4: Mark all inodes as being committed. */
 	jbd2_journal_lock_updates(journal);
@@ -1384,12 +1425,15 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
 				      &snap_inodes, &snap_ranges, &snap_err);
 	jbd2_journal_unlock_updates(journal);
-	if (trace_ext4_fc_lock_updates_enabled()) {
-		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
-		trace_call__ext4_fc_lock_updates(sb, commit_tid, locked_ns,
-						 snap_inodes, snap_ranges,
-						 ret, snap_err);
-	}
+	locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
+	atomic64_add(locked_ns, &snap_stats->lock_updates_ns_total);
+	atomic64_inc(&snap_stats->lock_updates_samples);
+	ext4_fc_snap_stats_update_max(&snap_stats->lock_updates_ns_max,
+				      locked_ns);
+	if (trace_ext4_fc_lock_updates_enabled())
+		trace_call__ext4_fc_lock_updates(sb, commit_tid, locked_ns,
+						 snap_inodes, snap_ranges,
+						 ret, snap_err);
 	kvfree(inodes);
 	if (ret)
 		return ret;
@@ -2657,11 +2701,26 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 {
 	struct ext4_sb_info *sbi = EXT4_SB((struct super_block *)seq->private);
 	struct ext4_fc_stats *stats = &sbi->s_fc_stats;
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
+	u64 lock_avg_ns = 0;
+	u64 lock_updates_samples;
+	u64 lock_updates_ns_total;
+	u64 lock_updates_ns_max;
 	int i;
 
 	if (v != SEQ_START_TOKEN)
 		return 0;
 
+	lock_updates_samples =
+		atomic64_read(&snap_stats->lock_updates_samples);
+	lock_updates_ns_total =
+		atomic64_read(&snap_stats->lock_updates_ns_total);
+	lock_updates_ns_max =
+		atomic64_read(&snap_stats->lock_updates_ns_max);
+	if (lock_updates_samples)
+		lock_avg_ns = div64_u64(lock_updates_ns_total,
+					lock_updates_samples);
+
 	seq_printf(seq,
 		"fc stats:\n%ld commits\n%ld ineligible\n%ld numblks\n%lluus avg_commit_time\n",
 		   stats->fc_num_commits, stats->fc_ineligible_commits,
@@ -2672,6 +2731,23 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\"%s\":\t%d\n", fc_ineligible_reasons[i],
 			stats->fc_ineligible_reason_count[i]);
 
+	seq_printf(seq,
+		   "Snapshot stats:\n%llu inodes\n%llu ranges\n%lluus lock_updates_avg\n%lluus lock_updates_max\n",
+		   atomic64_read(&snap_stats->snap_inodes),
+		   atomic64_read(&snap_stats->snap_ranges),
+		   div_u64(lock_avg_ns, 1000),
+		   div_u64(lock_updates_ns_max, 1000));
+	seq_printf(seq,
+		   "Snapshot failures:\n%llu es_miss\n%llu es_delayed\n%llu es_other\n%llu inodes_cap\n%llu ranges_cap\n%llu nomem\n%llu inode_loc\n%llu no_snap\n",
+		   atomic64_read(&snap_stats->snap_fail_es_miss),
+		   atomic64_read(&snap_stats->snap_fail_es_delayed),
+		   atomic64_read(&snap_stats->snap_fail_es_other),
+		   atomic64_read(&snap_stats->snap_fail_inodes_cap),
+		   atomic64_read(&snap_stats->snap_fail_ranges_cap),
+		   atomic64_read(&snap_stats->snap_fail_nomem),
+		   atomic64_read(&snap_stats->snap_fail_inode_loc),
+		   atomic64_read(&snap_stats->snap_fail_no_snap));
+
 	return 0;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3c869f0001c5..f1f8819a2a23 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4544,6 +4544,7 @@ static void ext4_fast_commit_init(struct super_block *sb)
 	sbi->s_fc_ineligible_tid = 0;
 	mutex_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));
+	memset(&sbi->s_fc_snap_stats, 0, sizeof(sbi->s_fc_snap_stats));
 	sbi->s_fc_replay_state.fc_regions = NULL;
 	sbi->s_fc_replay_state.fc_regions_size = 0;
 	sbi->s_fc_replay_state.fc_regions_used = 0;
-- 
2.53.0
