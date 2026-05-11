Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B242DC357;
	Mon, 11 May 2026 08:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489193; cv=pass; b=KhZ3QsbyR0yjMj95YTaw34M1MCAonUlctO88hkTkNbUF6qBrtICoGyFVlXIYdU2sc7hktgEHr6lydQ87PW1VO11huPq4vK2MvgpGrlqRlvdW6jVoq/N3jG9UiwLXggoULi9lHQVuDwFpxW6BWNe7PX0jOoJ6r1tIxsSqIbqJttM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489193; c=relaxed/simple;
	bh=MrrEwY7AIm58bXp/ZX+9E9gYgtVD8lGh0GVDDZrj1mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTOwanMIlHkEGbntAZjeIRl3/w9msTafS53sbMT1qFmQiwlFI3lvnPyKgyh56CmBDwJ76DmAD9IfZr18qvpYTcp4cT9EGa7DJBEXcrELJujqH4PT84/M07we4TjxijQyz0VOYA6g1VyDJvYTOIOSiiJWCcqguQ/aweuELYq3QOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Ac/rHAMa; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Ac/rHAMa"
ARC-Seal: i=1; a=rsa-sha256; t=1778489037; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j6mSpy4nPMAJNbYHdSzGhB/GlrqM4ZGoQSXvQeEpf3xRvldUHu5kHEzidwDwrm0+i8zcqVoFQXunI5Gc4e3EqoPUULH82rTtVlbuHNQOdTsWCH9vDSi4etPDPK9hgLShQfkLh+OmuXIY3g0gOiHP+42n5F+Q5z1Z4CzC7GNo9UA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489037; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Y8Xxt3LfBC8k6KeKouRjskSmFCKYqYaicKxDFCHJmTM=; 
	b=Q3sFVmA0427YKgNMDmLof3HsNGMRtMW0kntYhyTww7TX48ZOEuUXrjJMVBpeGZTTXdwpzVlFD7/NyLkUUlPPrFiwDtds2a/d8k4Td+nzlif7XEh4KCUxBwchiHVPsUNc/AKxyn5ca+zVr07PWeN7YWMhWZxEXEeydYGROtbu2NM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489037;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Y8Xxt3LfBC8k6KeKouRjskSmFCKYqYaicKxDFCHJmTM=;
	b=Ac/rHAMaarFU3v7M5T0JcaLQXFIZL/7iHV8Fuy12TsGdR1glNyLirMCuyVxvPVmn
	34jdHjPdyhyP7lmzjt8NS5hkBpSoKZhskKcaQqUxq5elQy3bQa5HDVqGDQp1eAdqqXk
	WUpMJf1/wtaOKygDlA/0Po5JC6uqMammho+xLmis=
Received: by mx.zohomail.com with SMTPS id 1778489034861779.1047126173121;
	Mon, 11 May 2026 01:43:54 -0700 (PDT)
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
Subject: [RFC v7 5/7] ext4: fast commit: avoid i_data_sem by dropping ext4_map_blocks() in snapshots
Date: Mon, 11 May 2026 16:43:00 +0800
Message-ID: <20260511084304.1559557-6-me@linux.beauty>
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

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in v7:
- Address Sashiko review by guarding snapshot range arithmetic near
  EXT_MAX_BLOCKS to avoid cur_lblk / remaining-range wraparound in the
  snapshot walk.

 fs/ext4/fast_commit.c | 257 +++++++++++++++++++++++++++++-------------
 1 file changed, 181 insertions(+), 76 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index f9bb18c0b549..9fc17c1fa7af 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -184,6 +184,15 @@
 
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
@@ -938,7 +947,7 @@ static void ext4_fc_free_ranges(struct list_head *head)
 
 	list_for_each_entry_safe(range, range_n, head, list) {
 		list_del(&range->list);
-		kfree(range);
+		kmem_cache_free(ext4_fc_range_cachep, range);
 	}
 }
 
@@ -956,16 +965,19 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
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
@@ -979,61 +991,82 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		   (unsigned long long)inode->i_ino);
 
 	while (cur_lblk <= end_lblk) {
+		struct extent_status es;
 		struct ext4_fc_range *range;
+		ext4_lblk_t len;
+		u64 remaining = (u64)end_lblk - cur_lblk + 1;
 
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
+		if (len > remaining)
+			len = remaining;
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
+		if ((u64)range->len > (u64)end_lblk - cur_lblk)
+			break;
+
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
 
@@ -1057,7 +1090,8 @@ static int ext4_fc_snapshot_inode(struct inode *inode)
 	memcpy(snap->inode_buf, (u8 *)ext4_raw_inode(&iloc), inode_len);
 	brelse(iloc.bh);
 
-	ret = ext4_fc_snapshot_inode_data(inode, &ranges);
+	ret = ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_total,
+					  &nr_ranges);
 	if (ret) {
 		kfree(snap);
 		ext4_fc_free_ranges(&ranges);
@@ -1070,10 +1104,11 @@ static int ext4_fc_snapshot_inode(struct inode *inode)
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
@@ -1152,49 +1187,32 @@ static int ext4_fc_commit_dentry_updates(journal_t *journal, u32 *crc)
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
 
@@ -1214,6 +1232,10 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 		if (!list_empty(&ei->i_fc_list))
 			continue;
 
+		if (i >= inodes_size) {
+			ret = -E2BIG;
+			goto unlock;
+		}
 		/*
 		 * Create-only inodes may only be referenced via fcd_dilist and
 		 * not appear on s_fc_q[MAIN]. They may hit the last iput while
@@ -1225,15 +1247,22 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
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
 
@@ -1244,6 +1273,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	struct ext4_inode_info *iter;
 	struct ext4_fc_head head;
 	struct inode *inode;
+	struct inode **inodes;
+	unsigned int inodes_size;
 	struct blk_plug plug;
 	int ret = 0;
 	u32 crc = 0;
@@ -1296,6 +1327,10 @@ static int ext4_fc_perform_commit(journal_t *journal)
 		return ret;
 
 
+	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
+	if (ret)
+		return ret;
+
 	/* Step 4: Mark all inodes as being committed. */
 	jbd2_journal_lock_updates(journal);
 	/*
@@ -1311,8 +1346,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
 
-	ret = ext4_fc_snapshot_inodes(journal);
+	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
 	jbd2_journal_unlock_updates(journal);
+	kvfree(inodes);
 	if (ret)
 		return ret;
 
@@ -1368,6 +1404,64 @@ static int ext4_fc_perform_commit(journal_t *journal)
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
@@ -1460,7 +1554,10 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
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
@@ -1544,34 +1641,35 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 
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
@@ -2548,13 +2646,20 @@ int __init ext4_fc_init_dentry_cache(void)
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
