Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D4E3B27D0;
	Mon, 11 May 2026 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489255; cv=pass; b=VbdkHWM+FsNHX0MGIErs+Kci2tx9feMvBXssr5lTnmYkGWQInPS+7ibnDHUkzZLgPlB8wirFHhHnZSyO62Akg5RAFCesxm01/9/Jow2/xnmYZ99IuUvJpzzZhhH70COV3JtRmL4Xv5nIROh5n6yc+2KSFtEoP6A6dxuuWHPPdh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489255; c=relaxed/simple;
	bh=9+r0lXSAyXV2axYn2KPYR7C9ZTyqeMxFEhiqo0oAZvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RH6sKICgY3iXRM1r6KeKUgqERV7SDzzsRhb77Xx2TsXDqCzqZ8Q5PimNOOUlSv1P+cTOgrGeHJ80OkIg6sLCTIiAhI5rqWALErDDE5USa9wcYw9Qlsg4En43X04zK6WINJwbeXJuKF1j3pOFwPlzGbwIFlJQCRgOsT0ta9TRKLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=nUXvM8ZR; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="nUXvM8ZR"
ARC-Seal: i=1; a=rsa-sha256; t=1778489047; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WyoS015f3djO5Y4dPKyoo2z5zTgdpeR9xI8K1zEiZkliUlo6KwM+NCO/F8PAO+rJpZc0dE0IWU+I/ZbFNnM+mOqdbFCdDp2VFcTWHCABrkpcERo6Br7K1uDXicm6dr19sxSV96bxDusQ9zqdFyMVad4AKZxm4o1+VtMXgGzfFnI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489047; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aVVT3ps1SdnisVf/bD8Ws+M3UP7WXtuL/UZyauh6zA8=; 
	b=LVVWsztFjRqId3BBkzbXKcw4aaT2pR75mwEVaeMcluVrL+Jj6WipGc4dtk91WP8dgqM0hL5xgt99Hjk/zuSPAXaNE1HJQjkqMM+wiC6ERdfkGxKtoHawBeBOKBR1s+jMFJOV3Eo4Ejbl5o+dGX8mE47sUB0Ub5q2wCHz4c+xjYY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489047;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=aVVT3ps1SdnisVf/bD8Ws+M3UP7WXtuL/UZyauh6zA8=;
	b=nUXvM8ZRK+dzw0bset72KC3dWKBot9hlgSJEeaExS8y8eRePJakBfC4VRiYhaqC5
	9uR0jFqDFLVq5fG7jy2I9EvQJ7bzGrWZ0/FFsw/88sQDctlzz367mG+h5eZDdatLx08
	mPau/xvOuULLdimv0MuwdHjd/KCgldlLScDBo090=
Received: by mx.zohomail.com with SMTPS id 1778489044493301.0632124891529;
	Mon, 11 May 2026 01:44:04 -0700 (PDT)
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
Subject: [RFC v7 7/7] ext4: fast commit: export snapshot stats in fc_info
Date: Mon, 11 May 2026 16:43:02 +0800
Message-ID: <20260511084304.1559557-8-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511084304.1559557-1-me@linux.beauty>
References: <20260511084304.1559557-1-me@linux.beauty>
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

 fs/ext4/ext4.h        | 31 +++++++++++++++++
 fs/ext4/fast_commit.c | 78 +++++++++++++++++++++++++++++++++++++------
 fs/ext4/super.c       |  1 +
 3 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index df30f8705c98..3457b4950c02 100644
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
@@ -1824,6 +1854,7 @@ struct ext4_sb_info {
 	struct mutex s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
+	struct ext4_fc_snap_stats s_fc_snap_stats;
 	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index c24984d8df83..1dfcccf4179e 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -874,13 +874,17 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
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
@@ -915,8 +919,10 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 	struct ext4_extent *ex;
 	struct ext4_fc_range *range;
 
-	if (!snap)
+	if (!snap) {
+		EXT4_SB(inode->i_sb)->s_fc_snap_stats.snap_fail_no_snap++;
 		return -ECANCELED;
+	}
 
 	list_for_each_entry(range, &snap->data_list, list) {
 		if (range->tag == EXT4_FC_TAG_DEL_RANGE) {
@@ -977,6 +983,8 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				       int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
 	unsigned int nr_ranges = 0;
 
@@ -1004,11 +1012,13 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		u64 remaining = (u64)end_lblk - cur_lblk + 1;
 
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
@@ -1023,6 +1033,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		}
 
 		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+			stats->snap_fail_ranges_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
 			return -E2BIG;
@@ -1030,6 +1041,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 		if (!range) {
+			stats->snap_fail_nomem++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
@@ -1057,6 +1069,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			stats->snap_fail_es_other++;
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
@@ -1080,6 +1093,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_snap_stats *stats =
+		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
 	struct ext4_fc_inode_snap *snap;
 	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
 	struct ext4_iloc iloc;
@@ -1090,6 +1105,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
 	if (ret) {
+		stats->snap_fail_inode_loc++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
 	}
@@ -1101,6 +1117,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		stats->snap_fail_nomem++;
 		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
@@ -1125,6 +1142,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	list_splice_tail_init(&ranges, &snap->data_list);
 	ext4_fc_unlock(inode->i_sb, alloc_ctx);
 
+	stats->snap_inodes++;
+	stats->snap_ranges += nr_ranges;
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
@@ -1234,6 +1253,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1259,6 +1279,7 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			sbi->s_fc_snap_stats.snap_fail_inodes_cap++;
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
@@ -1302,6 +1323,7 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_fc_snap_stats *snap_stats = &sbi->s_fc_snap_stats;
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
@@ -1364,8 +1386,13 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
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
@@ -1386,12 +1413,15 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
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
@@ -2667,11 +2697,23 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
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
 
+	lock_updates_samples = READ_ONCE(snap_stats->lock_updates_samples);
+	lock_updates_ns_total = READ_ONCE(snap_stats->lock_updates_ns_total);
+	lock_updates_ns_max = READ_ONCE(snap_stats->lock_updates_ns_max);
+	if (lock_updates_samples)
+		lock_avg_ns = div64_u64(lock_updates_ns_total,
+					lock_updates_samples);
+
 	seq_printf(seq,
 		"fc stats:\n%ld commits\n%ld ineligible\n%ld numblks\n%lluus avg_commit_time\n",
 		   stats->fc_num_commits, stats->fc_ineligible_commits,
@@ -2682,6 +2724,22 @@ int ext4_fc_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\"%s\":\t%d\n", fc_ineligible_reasons[i],
 			stats->fc_ineligible_reason_count[i]);
 
+	seq_printf(seq,
+		   "Snapshot stats:\n%llu inodes\n%llu ranges\n%lluus lock_updates_avg\n%lluus lock_updates_max\n",
+		   snap_stats->snap_inodes, snap_stats->snap_ranges,
+		   div_u64(lock_avg_ns, 1000),
+		   div_u64(lock_updates_ns_max, 1000));
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
