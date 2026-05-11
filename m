Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E91E49F;
	Mon, 11 May 2026 08:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489221; cv=pass; b=UwTxfdrG9Mqn/t7QUGp362mL3dzHkeYQ+8E6DgW4quI05kcbouGmaCXgxDASkrBLkVOZ3kSWrxHHTMNSVbqv/vjdqRNR3M9/l3n72N6GfX5iWCQbPAwek+aYpjbMv/1jxhgRkTr/TulKnwpAXY68F7JLnFOpugBBBY2iYRzYZHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489221; c=relaxed/simple;
	bh=k3Hv1eaJp9IQxvVqMzfcNFjGvtv9bomawkaK6bthd+g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjMgEj4E1roRAPFdufvvi0Jtu3F/j0JDzHJJ5QKIHM8vuIPjCtpRJwWIgR4c2IdHY5m1hHWsJxskKwK+aGvXDykvXxSQ62eaoc6brI4iERIgsBE9xjtMK4RLPfbD23n8CN39lK2X81ehRUmXKuwF1NEGs+PdkluaanZWVj+Vi1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=oMkfsLw4; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="oMkfsLw4"
ARC-Seal: i=1; a=rsa-sha256; t=1778489043; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FSuGgwT1tAdcCWw5hOc8FNLSJrgdkYRaym9vO2XOUqp4279qcJQcBCw/gZRJrCdY2i5NwJB2y5ATE+9lUebRsvME4iyyVdscU5n7f3LKd6+9uMdkrbNq377RLtT88+9Xlk6mWpXoOxtRaGID5sx+ifOqGUYcWb28NU2qtscIAFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489043; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=jTrtfIQ31WOPCDzA9NvXdREsibDv3/UeQsSkA9Q0IOk=; 
	b=ltNaBZoIZwllsKLMew3njx2VHfzbk1B5+BKVhCIepFA6zUVGuVgYNOMVy/WuRXI7/qrKMc1CLhGEzXVLNpkWJm0rlR1Q5Mmh2o92zI2jQ0OyGQcmmajjNqCxO5CSBllBE0C/ajoKUDMTxmxGfwcrMZkbzVCyktn2mDYNjZjc5TA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489043;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=jTrtfIQ31WOPCDzA9NvXdREsibDv3/UeQsSkA9Q0IOk=;
	b=oMkfsLw4nV92aMEdD6nfOkj5/TWP65OoH8pQh1VrsbEk9Baj4vyX7m8wj9Y6jOZw
	TJ0NK5/7mNaD6Lh9DNtRLFk/QFctdp27PjbQOpJRs0/abGOATZYeLFvjF/yI1t9wJSD
	DOgbQSPLuzIIP3NhHKoaExVpBY9matFDA+PTnsyA=
Received: by mx.zohomail.com with SMTPS id 1778489039670558.8949207687377;
	Mon, 11 May 2026 01:43:59 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC v7 6/7] ext4: fast commit: add lock_updates tracepoint
Date: Mon, 11 May 2026 16:43:01 +0800
Message-ID: <20260511084304.1559557-7-me@linux.beauty>
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

Commit-time fast commit snapshots run under jbd2_journal_lock_updates(),
so it is useful to quantify the time spent with updates locked and to
understand why snapshotting can fail.

Add a new tracepoint, ext4_fc_lock_updates, reporting the time spent in
the updates-locked window along with the number of snapshotted inodes
and ranges. Record the first snapshot failure reason in a stable snap_err
field for tooling.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes in v7:
- Address Sashiko review by reporting successfully snapshotted inode counts
  in ext4_fc_lock_updates when snapshotting stops early.

Changes in v6:
- Drop explicit ext4_fc_snap_err assignments and rely on enum
  auto-increment.
- Treat locked_ns as trace-only in this patch and calculate it only when
  ext4_fc_lock_updates is enabled, as suggested by Steven Rostedt.

 fs/ext4/ext4.h              | 15 ++++++++
 fs/ext4/fast_commit.c       | 74 +++++++++++++++++++++++++++++--------
 include/trace/events/ext4.h | 61 ++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2a706acdfaf8..df30f8705c98 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1027,6 +1027,21 @@ enum {
 
 struct ext4_fc_inode_snap;
 
+/*
+ * Snapshot failure reasons for ext4_fc_lock_updates tracepoint.
+ * Keep these stable for tooling.
+ */
+enum ext4_fc_snap_err {
+	EXT4_FC_SNAP_ERR_NONE = 0,
+	EXT4_FC_SNAP_ERR_ES_MISS,
+	EXT4_FC_SNAP_ERR_ES_DELAYED,
+	EXT4_FC_SNAP_ERR_ES_OTHER,
+	EXT4_FC_SNAP_ERR_INODES_CAP,
+	EXT4_FC_SNAP_ERR_RANGES_CAP,
+	EXT4_FC_SNAP_ERR_NOMEM,
+	EXT4_FC_SNAP_ERR_INODE_LOC,
+};
+
 /*
  * fourth extended file system inode data in memory
  */
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 9fc17c1fa7af..c24984d8df83 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -194,6 +194,12 @@ static struct kmem_cache *ext4_fc_range_cachep;
 #define EXT4_FC_SNAPSHOT_MAX_INODES	1024
 #define EXT4_FC_SNAPSHOT_MAX_RANGES	2048
 
+static inline void ext4_fc_set_snap_err(int *snap_err, int err)
+{
+	if (snap_err && *snap_err == EXT4_FC_SNAP_ERR_NONE)
+		*snap_err = err;
+}
+
 static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 {
 	BUFFER_TRACE(bh, "");
@@ -967,11 +973,12 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
 static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				       struct list_head *ranges,
 				       unsigned int nr_ranges_total,
-				       unsigned int *nr_rangesp)
+				       unsigned int *nr_rangesp,
+				       int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	unsigned int nr_ranges = 0;
 	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
+	unsigned int nr_ranges = 0;
 
 	spin_lock(&ei->i_fc_lock);
 	if (ei->i_fc_lblk_len == 0) {
@@ -996,11 +1003,16 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		ext4_lblk_t len;
 		u64 remaining = (u64)end_lblk - cur_lblk + 1;
 
-		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL))
+		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL)) {
+			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
 			return -EAGAIN;
+		}
 
-		if (ext4_es_is_delayed(&es))
+		if (ext4_es_is_delayed(&es)) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_ES_DELAYED);
 			return -EAGAIN;
+		}
 
 		len = es.es_len - (cur_lblk - es.es_lblk);
 		if (len > remaining)
@@ -1010,12 +1022,17 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			continue;
 		}
 
-		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES)
+		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_RANGES_CAP);
 			return -E2BIG;
+		}
 
 		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
-		if (!range)
+		if (!range) {
+			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
+		}
 		nr_ranges++;
 
 		range->lblk = cur_lblk;
@@ -1040,6 +1057,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
 
@@ -1059,7 +1077,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int nr_ranges_total,
-				  unsigned int *nr_rangesp)
+				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_inode_snap *snap;
@@ -1071,8 +1089,10 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	int alloc_ctx;
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
-	if (ret)
+	if (ret) {
+		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
+	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
 		inode_len = EXT4_INODE_SIZE(inode->i_sb);
@@ -1081,6 +1101,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
 	}
@@ -1091,7 +1112,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	brelse(iloc.bh);
 
 	ret = ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_total,
-					  &nr_ranges);
+					  &nr_ranges, snap_err);
 	if (ret) {
 		kfree(snap);
 		ext4_fc_free_ranges(&ranges);
@@ -1192,7 +1213,10 @@ static int ext4_fc_alloc_snapshot_inodes(struct super_block *sb,
 					 unsigned int *nr_inodesp);
 
 static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
-				   unsigned int inodes_size)
+				   unsigned int inodes_size,
+				   unsigned int *nr_inodesp,
+				   unsigned int *nr_rangesp,
+				   int *snap_err)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1210,6 +1234,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
 			goto unlock;
 		}
@@ -1233,6 +1259,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
 			goto unlock;
 		}
@@ -1257,16 +1285,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 		unsigned int inode_ranges = 0;
 
 		ret = ext4_fc_snapshot_inode(inodes[idx], nr_ranges,
-					     &inode_ranges);
+					     &inode_ranges, snap_err);
 		if (ret)
 			break;
 		nr_ranges += inode_ranges;
 	}
 
+	if (nr_inodesp)
+		*nr_inodesp = idx;
+	if (nr_rangesp)
+		*nr_rangesp = nr_ranges;
 	return ret;
 }
 
-static int ext4_fc_perform_commit(journal_t *journal)
+static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1275,10 +1307,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	struct inode *inode;
 	struct inode **inodes;
 	unsigned int inodes_size;
+	unsigned int snap_inodes = 0;
+	unsigned int snap_ranges = 0;
+	int snap_err = EXT4_FC_SNAP_ERR_NONE;
 	struct blk_plug plug;
 	int ret = 0;
 	u32 crc = 0;
 	int alloc_ctx;
+	ktime_t lock_start;
+	u64 locked_ns;
 
 	/*
 	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
@@ -1326,13 +1363,13 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	if (ret)
 		return ret;
 
-
 	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
 	if (ret)
 		return ret;
 
 	/* Step 4: Mark all inodes as being committed. */
 	jbd2_journal_lock_updates(journal);
+	lock_start = ktime_get();
 	/*
 	 * The journal is now locked. No more handles can start and all the
 	 * previous handles are now drained. Snapshotting happens in this
@@ -1346,8 +1383,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
 
-	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
+	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
+				      &snap_inodes, &snap_ranges, &snap_err);
 	jbd2_journal_unlock_updates(journal);
+	if (trace_ext4_fc_lock_updates_enabled()) {
+		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
+		trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
+					   snap_inodes, snap_ranges, ret,
+					   snap_err);
+	}
 	kvfree(inodes);
 	if (ret)
 		return ret;
@@ -1552,7 +1596,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 		journal_ioprio = EXT4_DEF_JOURNAL_IOPRIO;
 	set_task_ioprio(current, journal_ioprio);
 	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
-	ret = ext4_fc_perform_commit(journal);
+	ret = ext4_fc_perform_commit(journal, commit_tid);
 	if (ret < 0) {
 		if (ret == -EAGAIN || ret == -E2BIG || ret == -ECANCELED)
 			status = EXT4_FC_STATUS_INELIGIBLE;
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f493642cf121..7028a28316fa 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -107,6 +107,26 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_VERITY);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_MOVE_EXT);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 
+#undef EM
+#undef EMe
+#define EM(a)	TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
+#define EMe(a)	TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
+
+#define TRACE_SNAP_ERR						\
+	EM(NONE)						\
+	EM(ES_MISS)						\
+	EM(ES_DELAYED)						\
+	EM(ES_OTHER)						\
+	EM(INODES_CAP)						\
+	EM(RANGES_CAP)						\
+	EM(NOMEM)						\
+	EMe(INODE_LOC)
+
+TRACE_SNAP_ERR
+
+#undef EM
+#undef EMe
+
 #define show_fc_reason(reason)						\
 	__print_symbolic(reason,					\
 		{ EXT4_FC_REASON_XATTR,		"XATTR"},		\
@@ -2818,6 +2838,47 @@ TRACE_EVENT(ext4_fc_commit_stop,
 		  __entry->num_fc_ineligible, __entry->nblks_agg, __entry->tid)
 );
 
+#define EM(a)	{ EXT4_FC_SNAP_ERR_##a, #a },
+#define EMe(a)	{ EXT4_FC_SNAP_ERR_##a, #a }
+
+TRACE_EVENT(ext4_fc_lock_updates,
+	    TP_PROTO(struct super_block *sb, tid_t commit_tid, u64 locked_ns,
+		     unsigned int nr_inodes, unsigned int nr_ranges, int err,
+		     int snap_err),
+
+	TP_ARGS(sb, commit_tid, locked_ns, nr_inodes, nr_ranges, err, snap_err),
+
+	TP_STRUCT__entry(/* entry */
+		__field(dev_t, dev)
+		__field(tid_t, tid)
+		__field(u64, locked_ns)
+		__field(unsigned int, nr_inodes)
+		__field(unsigned int, nr_ranges)
+		__field(int, err)
+		__field(int, snap_err)
+	),
+
+	TP_fast_assign(/* assign */
+		__entry->dev = sb->s_dev;
+		__entry->tid = commit_tid;
+		__entry->locked_ns = locked_ns;
+		__entry->nr_inodes = nr_inodes;
+		__entry->nr_ranges = nr_ranges;
+		__entry->err = err;
+		__entry->snap_err = snap_err;
+	),
+
+	TP_printk("dev %d,%d tid %u locked_ns %llu nr_inodes %u nr_ranges %u err %d snap_err %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
+		  __entry->locked_ns, __entry->nr_inodes, __entry->nr_ranges,
+		  __entry->err, __print_symbolic(__entry->snap_err,
+						 TRACE_SNAP_ERR))
+);
+
+#undef EM
+#undef EMe
+#undef TRACE_SNAP_ERR
+
 #define FC_REASON_NAME_STAT(reason)					\
 	show_fc_reason(reason),						\
 	__entry->fc_ineligible_rc[reason]
-- 
2.53.0
