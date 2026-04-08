Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34A93B27F2;
	Wed,  8 Apr 2026 11:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647554; cv=pass; b=E4A4rIrnEBgQTTgKaz/wt9/b1mAwGvWL9J8/6oZk0nlZ98YePJq0+VsW3MvNWQvdrgrFqvvJEoR+SfcLyFXR3OAiFngIU68xyO+k5ch3KtmibOPj0kr+JnWJBTodJcutLrCXf14au/RqZZDZo/2bSqxOufO9YoMKRftxBehkblw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647554; c=relaxed/simple;
	bh=B0aEscXzmYZWwFd85zkSyF4jEeOaeP1Ho6AK3/UBJjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBPq5DrAdqhTice4kTPLqK5Y+L5keh6+SauKIgg/iy1pKlni3Y3OIP7JFkuaspeyMGeL3HLKfYiQ5pgzXunQ97enn1EFjHpLB82GVKCzZAYRw7ICVaqhxBWTCixPSzMUE7BJQSdZ4btHC9WGKYKjna//6h8F5TB5Oql6pqmIu38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=WuGDH9Ke; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="WuGDH9Ke"
ARC-Seal: i=1; a=rsa-sha256; t=1775647282; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Vp3xArMic/hTfWwRY1EsOOSItyr1oKYkKwBS63ztGQCAlVxSdlQkt2/8XrJtIsMOVrwx342VMGpUC0f0OSILoFJn9oqe+cnjnUdq5l5m+DDeqRi7yHe65yP5o+g6GLICbuT3jik5BO+7+5OGE9EgWfe48KSw6v0G1aa8abnB1Qk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775647282; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Bchmw8afdzwx4XNLCbq/3HNYQmkHDSx6NKmX2p1+RAI=; 
	b=m5BE2+O3zYXToeehUcaLSAGv+jL2a3V1VcmoJ63sh0vN70M+nuML0b9szeF3oCEgHO6vPx5Q6SUsFGUx9yNFfegbi9T3TsFzYYg1D0JYONzEjK7OtKQ6NikVljLjPmsyEZdBfxInQtKOqVvua265pEfZg02dexvV96iEwqYpcVo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775647282;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Bchmw8afdzwx4XNLCbq/3HNYQmkHDSx6NKmX2p1+RAI=;
	b=WuGDH9KeTxH7yn8xHIlYteklSNm2h9Bnpd7FhOQK8QKbfb/SReTlGxHCtgajniRp
	9CkQ+iAuek8/RvNdblAAJZNgGhFWoMx8ANGmiK7w1Dq7wVKYVOZZZFU9X3Hfz9Kwb3m
	wQHM44n2iCWD2cdhpyrV64W8TyqH8nhZqvPlGuWQ=
Received: by mx.zohomail.com with SMTPS id 1775647281185254.41746707746904;
	Wed, 8 Apr 2026 04:21:21 -0700 (PDT)
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
Cc: Li Chen <me@linux.beauty>
Subject: [RFC v6 6/7] ext4: fast commit: add lock_updates tracepoint
Date: Wed,  8 Apr 2026 19:20:17 +0800
Message-ID: <20260408112020.716706-7-me@linux.beauty>
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

Commit-time fast commit snapshots run under jbd2_journal_lock_updates(),
so it is useful to quantify the time spent with updates locked and to
understand why snapshotting can fail.

Add a new tracepoint, ext4_fc_lock_updates, reporting the time spent in
the updates-locked window along with the number of snapshotted inodes
and ranges. Record the first snapshot failure reason in a stable snap_err
field for tooling.

Signed-off-by: Li Chen <me@linux.beauty>
---
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
index 13fe4fdf9bda..1ff6ea1bde3e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1028,6 +1028,21 @@ enum {
 
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
index ab751b855afa..6ac6ebe79d7b 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -193,6 +193,12 @@ static struct kmem_cache *ext4_fc_range_cachep;
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
@@ -983,11 +989,12 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
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
@@ -1011,11 +1018,16 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		struct ext4_fc_range *range;
 		ext4_lblk_t len;
 
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
 		if (len > end_lblk - cur_lblk + 1)
@@ -1025,12 +1037,17 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
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
@@ -1055,6 +1072,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				range->len = max;
 		} else {
 			kmem_cache_free(ext4_fc_range_cachep, range);
+			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
 			return -EAGAIN;
 		}
 
@@ -1071,7 +1089,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 
 static int ext4_fc_snapshot_inode(struct inode *inode,
 				  unsigned int nr_ranges_total,
-				  unsigned int *nr_rangesp)
+				  unsigned int *nr_rangesp, int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_inode_snap *snap;
@@ -1083,8 +1101,10 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	int alloc_ctx;
 
 	ret = ext4_get_inode_loc_noio(inode, &iloc);
-	if (ret)
+	if (ret) {
+		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 		return ret;
+	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
 		inode_len = EXT4_INODE_SIZE(inode->i_sb);
@@ -1093,6 +1113,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 
 	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
 	if (!snap) {
+		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 		brelse(iloc.bh);
 		return -ENOMEM;
 	}
@@ -1103,7 +1124,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
 	brelse(iloc.bh);
 
 	ret = ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_total,
-					  &nr_ranges);
+					  &nr_ranges, snap_err);
 	if (ret) {
 		kfree(snap);
 		ext4_fc_free_ranges(&ranges);
@@ -1204,7 +1225,10 @@ static int ext4_fc_alloc_snapshot_inodes(struct super_block *sb,
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
@@ -1222,6 +1246,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		if (i >= inodes_size) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
 			goto unlock;
 		}
@@ -1245,6 +1271,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 			continue;
 
 		if (i >= inodes_size) {
+			ext4_fc_set_snap_err(snap_err,
+					     EXT4_FC_SNAP_ERR_INODES_CAP);
 			ret = -E2BIG;
 			goto unlock;
 		}
@@ -1269,16 +1297,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
 		unsigned int inode_ranges = 0;
 
 		ret = ext4_fc_snapshot_inode(inodes[idx], nr_ranges,
-					     &inode_ranges);
+					     &inode_ranges, snap_err);
 		if (ret)
 			break;
 		nr_ranges += inode_ranges;
 	}
 
+	if (nr_inodesp)
+		*nr_inodesp = i;
+	if (nr_rangesp)
+		*nr_rangesp = nr_ranges;
 	return ret;
 }
 
-static int ext4_fc_perform_commit(journal_t *journal)
+static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1287,10 +1319,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1338,13 +1375,13 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1358,8 +1395,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1564,7 +1608,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
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
