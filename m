Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BF130AAB3;
	Tue, 17 Mar 2026 08:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773737551; cv=pass; b=NWeV5q6mxqyAJCL/EphsjvYuBXLEQyPqBJvtGME5E4kE+CPZpLzEgZLB/IVlKWk8zW67sKz+2uegduaAr6Cqy/zldnITpb/SqRShuh6OMEjAXgY4ZLlARPOb52wYKNx2Xy5pRl/V+1XS2Gyd8hBUvcqQBAsSHyn8JXSYop4G8rU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773737551; c=relaxed/simple;
	bh=+mhp8nB86SpIOIhz9PsOc/rLWfrwilDYHeN95YWdPaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3xCQzgxDg5S8PatcTipME9/OR6U9xCAXZvJCheghlIH3eul1i8VQLLUerDdN7pRIaKSuGFxN30LtRd06csmh9tD3hnPltPNkWPnJjg9Pc1KiFcz3NEA+xl7ZWDh3qipdDf13l1njMoV2o8bqwHZI0a2GsHApY1uoRtHSCMWEmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=NtiNegCB; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="NtiNegCB"
ARC-Seal: i=1; a=rsa-sha256; t=1773737217; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iIn3mMqFgLlyXWEnsAZuBnLHVjksm1Duw9DQQrIs7Uyh2DVLFQmCO0PD4lD8uUsf9vEVzr2xmolHWFOH94+9yvqo1+6Q+/Q/YIGFJoOU/2f4UQBG2NakrKsru/vbhwtUdQMAkLLMedMpZ8B/3XEOa5mM8jO9dF72O6CnoJs2Ewo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1773737217; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RxWMWPv1NdyaTr2fpCSAr/NyhvS6g2TMrFBNb4ftq+U=; 
	b=LJJSY86M+r8xIx4a1hDG0G6atnN6aozpwgrIOIDLnquxJxYJKyh/0Hjbme3tt2UI+NdIMwc+kw3gQbORcRppNN8PywuKfIWGpkC/J4eMt7t+Y+9SOwycOYflWdNHBGzNJRt4gi5f87uaDPEvfCotKulOiCM3UpvdZSTSXX4s28Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773737217;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=RxWMWPv1NdyaTr2fpCSAr/NyhvS6g2TMrFBNb4ftq+U=;
	b=NtiNegCBPSUkQN0vWx/KIXcTsQFOqrw39I6KgC2v74agWrMvBW6XoE/U3VXdsoKi
	T2poyyKsmO8sG3JpKr2+R+7ExR8rHIymfTywRw+fQfRO56BO9a9sJ8kQn2LDIzRMix2
	pgKlXKMHtTr3lGrlgj5JttDdPCwb00vRXD9gZG+o=
Received: by mx.zohomail.com with SMTPS id 1773737215239340.2094742257068;
	Tue, 17 Mar 2026 01:46:55 -0700 (PDT)
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
Subject: [RFC v5 5/7] ext4: fast commit: avoid i_data_sem by dropping ext4_map_blocks() in snapshots
Date: Tue, 17 Mar 2026 16:46:20 +0800
Message-ID: <20260317084624.457185-6-me@linux.beauty>
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

Commit-time snapshots run under jbd2_journal_lock_updates(), so the work
done there must stay bounded.

The snapshot path still used ext4_map_blocks() to build data ranges. This
can take i_data_sem and pulls the mapping code into the snapshot logic.
Build inode data range snapshots from the extent status tree instead.

The extent status tree is a cache, not an authoritative source. If the
needed information is missing or unstable (e.g. delayed allocation), treat
the transaction as fast commit ineligible and fall back to full commit.

Also cap the number of inodes and ranges snapshotted per fast commit and
allocate range records from a dedicated slab cache. The inode pointer
array is allocated outside the updates-locked window.

Testing: QEMU/KVM guest, virtio-pmem + dax, ext4 -O fast_commit, mounted
dax,noatime. Ran python3 500x {4K write + fsync}, fallocate 256M, and
python3 500x {creat + fsync(dir)} without lockdep splats or errors.

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/ext4/fast_commit.c | 253 +++++++++++++++++++++++++++++-------------
 1 file changed, 177 insertions(+), 76 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 966211a3342a0..d1eefee609120 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -183,6 +183,15 @@
 
 #include <trace/events/ext4.h>
 static struct kmem_cache *ext4_fc_dentry_cachep;
+static struct kmem_cache *ext4_fc_range_cachep;
+
+/*
+ * Avoid spending unbounded time/memory snapshotting highly fragmented files
+ * under jbd2_journal_lock_updates(). If we exceed this limit, fall back to
+ * full commit.
+ */
+#define EXT4_FC_SNAPSHOT_MAX_INODES	1024
+#define EXT4_FC_SNAPSHOT_MAX_RANGES	2048
 
 static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 {
@@ -954,7 +963,7 @@ static void ext4_fc_free_ranges(struct list_head *head)
 
 	list_for_each_entry_safe(range, range_n, head, list) {
 		list_del(&range->list);
-		kfree(range);
+		kmem_cache_free(ext4_fc_range_cachep, range);
 	}
 }
 
@@ -972,16 +981,19 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
 }
 
 static int ext4_fc_snapshot_inode_data(struct inode *inode,
-				       struct list_head *ranges)
+				       struct list_head *ranges,
+				       unsigned int nr_ranges_total,
+				       unsigned int *nr_rangesp)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int nr_ranges = 0;
 	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
-	struct ext4_map_blocks map;
-	int ret;
 
 	spin_lock(&ei->i_fc_lock);
 	if (ei->i_fc_lblk_len == 0) {
 		spin_unlock(&ei->i_fc_lock);
+		if (nr_rangesp)
+			*nr_rangesp = 0;
 		return 0;
 	}
 	start_lblk = ei->i_fc_lblk_start;
@@ -994,61 +1006,78 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		   start_lblk, end_lblk, inode->i_ino);
 
 	while (cur_lblk <= end_lblk) {
+		struct extent_status es;
 		struct ext4_fc_range *range;
+		ext4_lblk_t len;
 
-		map.m_lblk = cur_lblk;
-		map.m_len = end_lblk - cur_lblk + 1;
-		ret = ext4_map_blocks(NULL, inode, &map,
-				      EXT4_GET_BLOCKS_IO_SUBMIT |
-				      EXT4_EX_NOCACHE);
-		if (ret < 0)
-			return -ECANCELED;
+		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL))
+			return -EAGAIN;
+
+		if (ext4_es_is_delayed(&es))
+			return -EAGAIN;
 
-		if (map.m_len == 0) {
+		len = es.es_len - (cur_lblk - es.es_lblk);
+		if (len > end_lblk - cur_lblk + 1)
+			len = end_lblk - cur_lblk + 1;
+		if (len == 0) {
 			cur_lblk++;
 			continue;
 		}
 
-		range = kmalloc(sizeof(*range), GFP_NOFS);
+		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES)
+			return -E2BIG;
+
+		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 		if (!range)
 			return -ENOMEM;
+		nr_ranges++;
 
-		range->lblk = map.m_lblk;
-		range->len = map.m_len;
+		range->lblk = cur_lblk;
+		range->len = len;
 		range->pblk = 0;
 		range->unwritten = false;
 
-		if (ret == 0) {
+		if (ext4_es_is_hole(&es)) {
 			range->tag = EXT4_FC_TAG_DEL_RANGE;
-		} else {
-			unsigned int max = (map.m_flags & EXT4_MAP_UNWRITTEN) ?
-				EXT_UNWRITTEN_MAX_LEN : EXT_INIT_MAX_LEN;
-
-			/* Limit the number of blocks in one extent */
-			map.m_len = min(max, map.m_len);
+		} else if (ext4_es_is_written(&es) ||
+			   ext4_es_is_unwritten(&es)) {
+			unsigned int max;
 
 			range->tag = EXT4_FC_TAG_ADD_RANGE;
-			range->len = map.m_len;
-			range->pblk = map.m_pblk;
-			range->unwritten = !!(map.m_flags & EXT4_MAP_UNWRITTEN);
+			range->pblk = ext4_es_pblock(&es) +
+				      (cur_lblk - es.es_lblk);
+			range->unwritten = ext4_es_is_unwritten(&es);
+
+			max = range->unwritten ? EXT_UNWRITTEN_MAX_LEN :
+						 EXT_INIT_MAX_LEN;
+			if (range->len > max)
+				range->len = max;
+		} else {
+			kmem_cache_free(ext4_fc_range_cachep, range);
+			return -EAGAIN;
 		}
 
 		INIT_LIST_HEAD(&range->list);
 		list_add_tail(&range->list, ranges);
 
-		cur_lblk += map.m_len;
+		cur_lblk += range->len;
 	}
 
+	if (nr_rangesp)
+		*nr_rangesp = nr_ranges;
 	return 0;
 }
 
-static int ext4_fc_snapshot_inode(struct inode *inode)
+static int ext4_fc_snapshot_inode(struct inode *inode,
+				  unsigned int nr_ranges_total,
+				  unsigned int *nr_rangesp)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_inode_snap *snap;
 	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
 	struct ext4_iloc iloc;
 	LIST_HEAD(ranges);
+	unsigned int nr_ranges = 0;
 	int ret;
 	int alloc_ctx;
 
@@ -1072,7 +1101,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode)
 	memcpy(snap->inode_buf, (u8 *)ext4_raw_inode(&iloc), inode_len);
 	brelse(iloc.bh);
 
-	ret = ext4_fc_snapshot_inode_data(inode, &ranges);
+	ret = ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_total,
+					  &nr_ranges);
 	if (ret) {
 		kfree(snap);
 		ext4_fc_free_ranges(&ranges);
@@ -1085,10 +1115,11 @@ static int ext4_fc_snapshot_inode(struct inode *inode)
 	list_splice_tail_init(&ranges, &snap->data_list);
 	ext4_fc_unlock(inode->i_sb, alloc_ctx);
 
+	if (nr_rangesp)
+		*nr_rangesp = nr_ranges;
 	return 0;
 }
 
-
 /* Flushes data of all the inodes in the commit queue. */
 static int ext4_fc_flush_data(journal_t *journal)
 {
@@ -1167,49 +1198,32 @@ static int ext4_fc_commit_dentry_updates(journal_t *journal, u32 *crc)
 	return 0;
 }
 
-static int ext4_fc_snapshot_inodes(journal_t *journal)
+static int ext4_fc_alloc_snapshot_inodes(struct super_block *sb,
+					 struct inode ***inodesp,
+					 unsigned int *nr_inodesp);
+
+static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
+				   unsigned int inodes_size)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_inode_info *iter;
 	struct ext4_fc_dentry_update *fc_dentry;
-	struct inode **inodes;
-	unsigned int nr_inodes = 0;
 	unsigned int i = 0;
+	unsigned int idx;
+	unsigned int nr_ranges = 0;
 	int ret = 0;
 	int alloc_ctx;
 
-	alloc_ctx = ext4_fc_lock(sb);
-	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list)
-		nr_inodes++;
-
-	list_for_each_entry(fc_dentry, &sbi->s_fc_dentry_q[FC_Q_MAIN], fcd_list) {
-		struct ext4_inode_info *ei;
-
-		if (fc_dentry->fcd_op != EXT4_FC_TAG_CREAT)
-			continue;
-		if (list_empty(&fc_dentry->fcd_dilist))
-			continue;
-
-		/* See the comment in ext4_fc_commit_dentry_updates(). */
-		ei = list_first_entry(&fc_dentry->fcd_dilist,
-				      struct ext4_inode_info, i_fc_dilist);
-		if (!list_empty(&ei->i_fc_list))
-			continue;
-
-		nr_inodes++;
-	}
-	ext4_fc_unlock(sb, alloc_ctx);
-
-	if (!nr_inodes)
+	if (!inodes_size)
 		return 0;
 
-	inodes = kvcalloc(nr_inodes, sizeof(*inodes), GFP_NOFS);
-	if (!inodes)
-		return -ENOMEM;
-
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
+		if (i >= inodes_size) {
+			ret = -E2BIG;
+			goto unlock;
+		}
 		inodes[i++] = &iter->vfs_inode;
 	}
 
@@ -1229,6 +1243,10 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 		if (!list_empty(&ei->i_fc_list))
 			continue;
 
+		if (i >= inodes_size) {
+			ret = -E2BIG;
+			goto unlock;
+		}
 		/*
 		 * Create-only inodes may only be referenced via fcd_dilist and
 		 * not appear on s_fc_q[MAIN]. They may hit the last iput while
@@ -1240,15 +1258,22 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 		ext4_set_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 		inodes[i++] = inode;
 	}
+unlock:
 	ext4_fc_unlock(sb, alloc_ctx);
 
-	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
-		ret = ext4_fc_snapshot_inode(inodes[nr_inodes]);
+	if (ret)
+		return ret;
+
+	for (idx = 0; idx < i; idx++) {
+		unsigned int inode_ranges = 0;
+
+		ret = ext4_fc_snapshot_inode(inodes[idx], nr_ranges,
+					     &inode_ranges);
 		if (ret)
 			break;
+		nr_ranges += inode_ranges;
 	}
 
-	kvfree(inodes);
 	return ret;
 }
 
@@ -1259,6 +1284,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
+	struct inode **inodes;
+	unsigned int inodes_size;
 	struct blk_plug plug;
 	int ret = 0;
 	u32 crc = 0;
@@ -1311,6 +1338,10 @@ static int ext4_fc_perform_commit(journal_t *journal)
 		return ret;
 
 
+	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
+	if (ret)
+		return ret;
+
 	/* Step 4: Mark all inodes as being committed. */
 	jbd2_journal_lock_updates(journal);
 	/*
@@ -1326,8 +1357,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
 
-	ret = ext4_fc_snapshot_inodes(journal);
+	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
 	jbd2_journal_unlock_updates(journal);
+	kvfree(inodes);
 	if (ret)
 		return ret;
 
@@ -1383,6 +1415,64 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	return ret;
 }
 
+static unsigned int ext4_fc_count_snapshot_inodes(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_inode_info *iter;
+	struct ext4_fc_dentry_update *fc_dentry;
+	unsigned int nr_inodes = 0;
+	int alloc_ctx;
+
+	alloc_ctx = ext4_fc_lock(sb);
+	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list)
+		nr_inodes++;
+
+	list_for_each_entry(fc_dentry, &sbi->s_fc_dentry_q[FC_Q_MAIN], fcd_list) {
+		struct ext4_inode_info *ei;
+
+		if (fc_dentry->fcd_op != EXT4_FC_TAG_CREAT)
+			continue;
+		if (list_empty(&fc_dentry->fcd_dilist))
+			continue;
+
+		/* See the comment in ext4_fc_commit_dentry_updates(). */
+		ei = list_first_entry(&fc_dentry->fcd_dilist,
+				      struct ext4_inode_info, i_fc_dilist);
+		if (!list_empty(&ei->i_fc_list))
+			continue;
+
+		nr_inodes++;
+	}
+	ext4_fc_unlock(sb, alloc_ctx);
+
+	return nr_inodes;
+}
+
+static int ext4_fc_alloc_snapshot_inodes(struct super_block *sb,
+					 struct inode ***inodesp,
+					 unsigned int *nr_inodesp)
+{
+	unsigned int nr_inodes = ext4_fc_count_snapshot_inodes(sb);
+	struct inode **inodes;
+
+	*inodesp = NULL;
+	*nr_inodesp = 0;
+
+	if (!nr_inodes)
+		return 0;
+
+	if (nr_inodes > EXT4_FC_SNAPSHOT_MAX_INODES)
+		return -E2BIG;
+
+	inodes = kvcalloc(nr_inodes, sizeof(*inodes), GFP_NOFS);
+	if (!inodes)
+		return -ENOMEM;
+
+	*inodesp = inodes;
+	*nr_inodesp = nr_inodes;
+	return 0;
+}
+
 static void ext4_fc_update_stats(struct super_block *sb, int status,
 				 u64 commit_time, int nblks, tid_t commit_tid)
 {
@@ -1475,7 +1565,10 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
 	ret = ext4_fc_perform_commit(journal);
 	if (ret < 0) {
-		status = EXT4_FC_STATUS_FAILED;
+		if (ret == -EAGAIN || ret == -E2BIG || ret == -ECANCELED)
+			status = EXT4_FC_STATUS_INELIGIBLE;
+		else
+			status = EXT4_FC_STATUS_FAILED;
 		goto fallback;
 	}
 	nblks = (sbi->s_fc_bytes + bsize - 1) / bsize - fc_bufs_before;
@@ -1559,34 +1652,35 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 
 	while (!list_empty(&sbi->s_fc_dentry_q[FC_Q_MAIN])) {
 		fc_dentry = list_first_entry(&sbi->s_fc_dentry_q[FC_Q_MAIN],
-					     struct ext4_fc_dentry_update,
-					     fcd_list);
+						 struct ext4_fc_dentry_update,
+						 fcd_list);
 		list_del_init(&fc_dentry->fcd_list);
 		if (fc_dentry->fcd_op == EXT4_FC_TAG_CREAT &&
-		    !list_empty(&fc_dentry->fcd_dilist)) {
+			!list_empty(&fc_dentry->fcd_dilist)) {
 			/* See the comment in ext4_fc_commit_dentry_updates(). */
 			ei = list_first_entry(&fc_dentry->fcd_dilist,
-					      struct ext4_inode_info,
-					      i_fc_dilist);
+						  struct ext4_inode_info,
+						  i_fc_dilist);
 			ext4_fc_free_inode_snap(&ei->vfs_inode);
 			spin_lock(&ei->i_fc_lock);
 			ext4_clear_inode_state(&ei->vfs_inode,
-					       EXT4_STATE_FC_REQUEUE);
+						   EXT4_STATE_FC_REQUEUE);
 			ext4_clear_inode_state(&ei->vfs_inode,
-					       EXT4_STATE_FC_COMMITTING);
+						   EXT4_STATE_FC_COMMITTING);
 			spin_unlock(&ei->i_fc_lock);
 			/*
 			 * Make sure clearing of EXT4_STATE_FC_COMMITTING is
-			 * visible before we send the wakeup. Pairs with implicit
-			 * barrier in prepare_to_wait() in ext4_fc_del().
+			 * visible before we send the wakeup. Pairs with
+			 * implicit barrier in prepare_to_wait() in
+			 * ext4_fc_del().
 			 */
 			smp_mb();
 #if (BITS_PER_LONG < 64)
 			wake_up_bit(&ei->i_state_flags,
-				    EXT4_STATE_FC_COMMITTING);
+					EXT4_STATE_FC_COMMITTING);
 #else
 			wake_up_bit(&ei->i_flags,
-				    EXT4_STATE_FC_COMMITTING);
+					EXT4_STATE_FC_COMMITTING);
 #endif
 		}
 		list_del_init(&fc_dentry->fcd_dilist);
@@ -2582,13 +2676,20 @@ int __init ext4_fc_init_dentry_cache(void)
 	ext4_fc_dentry_cachep = KMEM_CACHE(ext4_fc_dentry_update,
 					   SLAB_RECLAIM_ACCOUNT);
 
-	if (ext4_fc_dentry_cachep == NULL)
+	if (!ext4_fc_dentry_cachep)
 		return -ENOMEM;
 
+	ext4_fc_range_cachep = KMEM_CACHE(ext4_fc_range, SLAB_RECLAIM_ACCOUNT);
+	if (!ext4_fc_range_cachep) {
+		kmem_cache_destroy(ext4_fc_dentry_cachep);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 void ext4_fc_destroy_dentry_cache(void)
 {
+	kmem_cache_destroy(ext4_fc_range_cachep);
 	kmem_cache_destroy(ext4_fc_dentry_cachep);
 }
-- 
2.53.0

