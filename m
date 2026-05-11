Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F454652;
	Mon, 11 May 2026 08:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489069; cv=pass; b=gyqGNqdwUJmmUW9b5QNqT+GBhStYuO88e2nkQT+utGGMkCtroPvtEEcaKrnCoOvF01BtaKu6U2TRB28L42MBbGOLuA4dYtFoP2TWI0A3s0SpiPcCUjR6dHUYb3QqxS2SlyFwN9udHxg5dbPi0Y0NwumsLYoaPHvirnq+JxlS/7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489069; c=relaxed/simple;
	bh=QV7kIdsBd8OAM1Fqyg5OdjxU2Gv4x5QGOU+ajcd8jkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVn7QNFjf33zUP6JzPMe2VbWtZTQI9xTowr4GLGkLLYaEkKvydOaS0265o3g3EakrioB7F14dt9krzJoHs643oCfg5HKF6jmrE0r0GGk8Dv2ee1rp7/CHhXUCZB6K3hEticcD697y3xLd7OJHkMdrfAjddL2ZAjiG90O1zpUb/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=DU0whATC; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="DU0whATC"
ARC-Seal: i=1; a=rsa-sha256; t=1778489016; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cCia7XWnaJ0V+dNPrfzvm2DB9tIF5sd4X2kQIa+3iLVREug/IQ0Ai84cEWUKOtmOSP9Uw4Z/PdGDGWXvWnmvK/NuwU5KYtHYwlumMPqgpfL52USou92tb6r+HU6oJR5ttvq4oa+1t7N7zfh0d3G0bnGJdtXGBFG8HZFZQ3AxCHU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778489016; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yyS5Gbf2MMEaU6It3q8Bt3GloHNnxWhLYasDvwZ3AnU=; 
	b=V0Ksxq+WSjIQ5v63T/knX5Di9o11viuANY12+vPPW+l3r4i6IXWcLV05NpGdhLJIsE+JmEGJtPcMEHbNM0CgJ6KSuhv13alNrOxjkbwCflsub2TRZRoTrNCOICxUJqdu94+EpdFFlJKzyru8XNFr10PovCXo1RZj2H9lM/KdVVg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778489016;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yyS5Gbf2MMEaU6It3q8Bt3GloHNnxWhLYasDvwZ3AnU=;
	b=DU0whATCc+Dc4iUYe3tAFLy54YNEDnHC0XT9tNwE+rt6q8gU45BCVIg70m1+h/hy
	NJy4oal6SUwRmrGKKpreWtPAlqwrWk+7vLf7W6frsdOfBTWwGXxV+Gl8OkQ82dI9siw
	8YTRRHFRz51YDgGbsQMooVR4fZcKN8soVKeZBQ0I=
Received: by mx.zohomail.com with SMTPS id 17784890138221020.5425210051374;
	Mon, 11 May 2026 01:43:33 -0700 (PDT)
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
Subject: [RFC v7 1/7] ext4: fast commit: snapshot inode state before writing log
Date: Mon, 11 May 2026 16:42:56 +0800
Message-ID: <20260511084304.1559557-2-me@linux.beauty>
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

Fast commit writes inode metadata and data range updates after unlocking
journal updates. New handles can start at that point, so the log writing
path must not look at live inode state.

Add a commit-time per-inode snapshot and populate it while journal updates
are locked and existing handles are drained. Store the snapshot behind
ext4_inode_info->i_fc_snap so ext4_inode_info only grows by one pointer.
The snapshot contains a copy of the on-disk inode plus the data range
records needed for fast commit TLVs.

Snapshotting runs under jbd2_journal_lock_updates(). Avoid triggering I/O
there by using ext4_get_inode_loc_noio() and falling back to full commit
if the inode table block is not present or not uptodate.

Log writing then only serializes the snapshot, so it no longer needs to
call ext4_map_blocks() and take i_data_sem under s_fc_lock. The snapshot
is installed and freed under s_fc_lock and is released from fast commit
cleanup and inode eviction.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in v7:
- Drop the stale i_fc_wait initialization after rebasing onto the new
  linux-next base.

Changes in v6:
- Rebase onto linux-next master as of 2026-04-08.
- Fix the inode debug print format after rebasing.

 fs/ext4/ext4.h        |  22 ++-
 fs/ext4/fast_commit.c | 331 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/inode.c       |  51 +++++++
 3 files changed, 352 insertions(+), 52 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..e01d00dbc077 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1023,6 +1023,7 @@ enum {
 	I_DATA_SEM_EA
 };
 
+struct ext4_fc_inode_snap;
 
 /*
  * fourth extended file system inode data in memory
@@ -1079,6 +1080,22 @@ struct ext4_inode_info {
 	/* End of lblk range that needs to be committed in this fast commit */
 	ext4_lblk_t i_fc_lblk_len;
 
+	/*
+	 * Commit-time fast commit snapshots.
+	 *
+	 * i_fc_snap is installed and freed under sbi->s_fc_lock. The fast
+	 * commit log writing path reads the snapshot under sbi->s_fc_lock while
+	 * serializing fast commit TLVs.
+	 *
+	 * The snapshot lifetime is bounded by EXT4_STATE_FC_COMMITTING and the
+	 * corresponding cleanup / eviction paths.
+	 *
+	 * i_fc_snap points to per-inode snapshot data for fast commit:
+	 * - a raw inode snapshot for EXT4_FC_TAG_INODE
+	 * - data range records for EXT4_FC_TAG_{ADD,DEL}_RANGE
+	 */
+	struct ext4_fc_inode_snap *i_fc_snap;
+
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
 
 	/*
@@ -3080,8 +3097,9 @@ extern int  ext4_file_getattr(struct mnt_idmap *, const struct path *,
 			      struct kstat *, u32, unsigned int);
 extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
-extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
-extern int ext4_get_fc_inode_loc(struct super_block *sb, unsigned long ino,
+int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc);
+int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc);
+int ext4_get_fc_inode_loc(struct super_block *sb, unsigned long ino,
 			  struct ext4_iloc *iloc);
 extern int ext4_inode_attach_jinode(struct inode *inode);
 extern int ext4_can_truncate(struct inode *inode);
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..cd4eac4e7dcb 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -56,21 +56,23 @@
  *     deleted while it is being flushed.
  * [2] Flush data buffers to disk and clear "EXT4_STATE_FC_FLUSHING_DATA"
  *     state.
- * [3] Lock the journal by calling jbd2_journal_lock_updates. This ensures that
- *     all the exsiting handles finish and no new handles can start.
- * [4] Mark all the fast commit eligible inodes as undergoing fast commit
- *     by setting "EXT4_STATE_FC_COMMITTING" state.
- * [5] Unlock the journal by calling jbd2_journal_unlock_updates. This allows
+ * [3] Lock the journal by calling jbd2_journal_lock_updates(). This ensures
+ *     that all the existing handles finish and no new handles can start.
+ * [4] Mark all the fast commit eligible inodes as undergoing fast commit by
+ *     setting "EXT4_STATE_FC_COMMITTING" state, and snapshot the inode state
+ *     needed for log writing.
+ * [5] Unlock the journal by calling jbd2_journal_unlock_updates(). This allows
  *     starting of new handles. If new handles try to start an update on
  *     any of the inodes that are being committed, ext4_fc_track_inode()
  *     will block until those inodes have finished the fast commit.
  * [6] Commit all the directory entry updates in the fast commit space.
- * [7] Commit all the changed inodes in the fast commit space and clear
- *     "EXT4_STATE_FC_COMMITTING" for these inodes.
+ * [7] Commit all the changed inodes in the fast commit space.
  * [8] Write tail tag (this tag ensures the atomicity, please read the following
  *     section for more details).
+ * [9] Clear "EXT4_STATE_FC_COMMITTING" and wake up waiters in
+ *     ext4_fc_cleanup().
  *
- * All the inode updates must be enclosed within jbd2_jounrnal_start()
+ * All the inode updates must be enclosed within jbd2_journal_start()
  * and jbd2_journal_stop() similar to JBD2 journaling.
  *
  * Fast Commit Ineligibility
@@ -200,6 +202,8 @@ static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 	unlock_buffer(bh);
 }
 
+static void ext4_fc_free_inode_snap(struct inode *inode);
+
 static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -216,6 +220,7 @@ void ext4_fc_init_inode(struct inode *inode)
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	INIT_LIST_HEAD(&ei->i_fc_list);
 	INIT_LIST_HEAD(&ei->i_fc_dilist);
+	ei->i_fc_snap = NULL;
 }
 
 static bool ext4_fc_disabled(struct super_block *sb)
@@ -246,6 +251,7 @@ void ext4_fc_del(struct inode *inode)
 
 	alloc_ctx = ext4_fc_lock(inode->i_sb);
 	if (list_empty(&ei->i_fc_list) && list_empty(&ei->i_fc_dilist)) {
+		ext4_fc_free_inode_snap(inode);
 		ext4_fc_unlock(inode->i_sb, alloc_ctx);
 		return;
 	}
@@ -287,6 +293,7 @@ void ext4_fc_del(struct inode *inode)
 		}
 		finish_wait(wq, &wait.wq_entry);
 	}
+	ext4_fc_free_inode_snap(inode);
 	list_del_init(&ei->i_fc_list);
 
 	/*
@@ -829,6 +836,21 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	return true;
 }
 
+struct ext4_fc_range {
+	struct list_head list;
+	u16 tag;
+	ext4_lblk_t lblk;
+	ext4_lblk_t len;
+	ext4_fsblk_t pblk;
+	bool unwritten;
+};
+
+struct ext4_fc_inode_snap {
+	struct list_head data_list;
+	unsigned int inode_len;
+	u8 inode_buf[];
+};
+
 /*
  * Writes inode in the fast commit space under TLV with tag @tag.
  * Returns 0 on success, error on failure.
@@ -836,21 +858,21 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
-	int ret;
-	struct ext4_iloc iloc;
+	struct ext4_fc_inode_snap *snap = ei->i_fc_snap;
 	struct ext4_fc_inode fc_inode;
 	struct ext4_fc_tl tl;
 	u8 *dst;
+	u8 *src;
+	int inode_len;
+	int ret;
 
-	ret = ext4_get_inode_loc(inode, &iloc);
-	if (ret)
-		return ret;
+	if (!snap)
+		return -ECANCELED;
 
-	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
-		inode_len = EXT4_INODE_SIZE(inode->i_sb);
-	else if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE)
-		inode_len += ei->i_extra_isize;
+	src = snap->inode_buf;
+	inode_len = snap->inode_len;
+	if (!src || inode_len == 0)
+		return -ECANCELED;
 
 	fc_inode.fc_ino = cpu_to_le32(inode->i_ino);
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
@@ -866,10 +888,9 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	dst += EXT4_FC_TAG_BASE_LEN;
 	memcpy(dst, &fc_inode, sizeof(fc_inode));
 	dst += sizeof(fc_inode);
-	memcpy(dst, (u8 *)ext4_raw_inode(&iloc), inode_len);
+	memcpy(dst, src, inode_len);
 	ret = 0;
 err:
-	brelse(iloc.bh);
 	return ret;
 }
 
@@ -879,12 +900,74 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
  */
 static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 {
-	ext4_lblk_t old_blk_size, cur_lblk_off, new_blk_size;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct ext4_map_blocks map;
+	struct ext4_fc_inode_snap *snap = ei->i_fc_snap;
 	struct ext4_fc_add_range fc_ext;
 	struct ext4_fc_del_range lrange;
 	struct ext4_extent *ex;
+	struct ext4_fc_range *range;
+
+	if (!snap)
+		return -ECANCELED;
+
+	list_for_each_entry(range, &snap->data_list, list) {
+		if (range->tag == EXT4_FC_TAG_DEL_RANGE) {
+			lrange.fc_ino = cpu_to_le32(inode->i_ino);
+			lrange.fc_lblk = cpu_to_le32(range->lblk);
+			lrange.fc_len = cpu_to_le32(range->len);
+			if (!ext4_fc_add_tlv(inode->i_sb, EXT4_FC_TAG_DEL_RANGE,
+					     sizeof(lrange), (u8 *)&lrange, crc))
+				return -ENOSPC;
+			continue;
+		}
+
+		fc_ext.fc_ino = cpu_to_le32(inode->i_ino);
+		ex = (struct ext4_extent *)&fc_ext.fc_ex;
+		ex->ee_block = cpu_to_le32(range->lblk);
+		ex->ee_len = cpu_to_le16(range->len);
+		ext4_ext_store_pblock(ex, range->pblk);
+		if (range->unwritten)
+			ext4_ext_mark_unwritten(ex);
+		else
+			ext4_ext_mark_initialized(ex);
+
+		if (!ext4_fc_add_tlv(inode->i_sb, EXT4_FC_TAG_ADD_RANGE,
+				     sizeof(fc_ext), (u8 *)&fc_ext, crc))
+			return -ENOSPC;
+	}
+
+	return 0;
+}
+
+static void ext4_fc_free_ranges(struct list_head *head)
+{
+	struct ext4_fc_range *range, *range_n;
+
+	list_for_each_entry_safe(range, range_n, head, list) {
+		list_del(&range->list);
+		kfree(range);
+	}
+}
+
+static void ext4_fc_free_inode_snap(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_inode_snap *snap = ei->i_fc_snap;
+
+	if (!snap)
+		return;
+
+	ext4_fc_free_ranges(&snap->data_list);
+	kfree(snap);
+	ei->i_fc_snap = NULL;
+}
+
+static int ext4_fc_snapshot_inode_data(struct inode *inode,
+				       struct list_head *ranges)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
+	struct ext4_map_blocks map;
 	int ret;
 
 	spin_lock(&ei->i_fc_lock);
@@ -892,18 +975,21 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 		spin_unlock(&ei->i_fc_lock);
 		return 0;
 	}
-	old_blk_size = ei->i_fc_lblk_start;
-	new_blk_size = ei->i_fc_lblk_start + ei->i_fc_lblk_len - 1;
+	start_lblk = ei->i_fc_lblk_start;
+	end_lblk = ei->i_fc_lblk_start + ei->i_fc_lblk_len - 1;
 	ei->i_fc_lblk_len = 0;
 	spin_unlock(&ei->i_fc_lock);
 
-	cur_lblk_off = old_blk_size;
-	ext4_debug("will try writing %d to %d for inode %llu\n",
-		   cur_lblk_off, new_blk_size, inode->i_ino);
+	cur_lblk = start_lblk;
+	ext4_debug("snapshot data ranges %u-%u for inode %llu\n",
+		   start_lblk, end_lblk,
+		   (unsigned long long)inode->i_ino);
+
+	while (cur_lblk <= end_lblk) {
+		struct ext4_fc_range *range;
 
-	while (cur_lblk_off <= new_blk_size) {
-		map.m_lblk = cur_lblk_off;
-		map.m_len = new_blk_size - cur_lblk_off + 1;
+		map.m_lblk = cur_lblk;
+		map.m_len = end_lblk - cur_lblk + 1;
 		ret = ext4_map_blocks(NULL, inode, &map,
 				      EXT4_GET_BLOCKS_IO_SUBMIT |
 				      EXT4_EX_NOCACHE);
@@ -911,17 +997,21 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 			return -ECANCELED;
 
 		if (map.m_len == 0) {
-			cur_lblk_off++;
+			cur_lblk++;
 			continue;
 		}
 
+		range = kmalloc(sizeof(*range), GFP_NOFS);
+		if (!range)
+			return -ENOMEM;
+
+		range->lblk = map.m_lblk;
+		range->len = map.m_len;
+		range->pblk = 0;
+		range->unwritten = false;
+
 		if (ret == 0) {
-			lrange.fc_ino = cpu_to_le32(inode->i_ino);
-			lrange.fc_lblk = cpu_to_le32(map.m_lblk);
-			lrange.fc_len = cpu_to_le32(map.m_len);
-			if (!ext4_fc_add_tlv(inode->i_sb, EXT4_FC_TAG_DEL_RANGE,
-					    sizeof(lrange), (u8 *)&lrange, crc))
-				return -ENOSPC;
+			range->tag = EXT4_FC_TAG_DEL_RANGE;
 		} else {
 			unsigned int max = (map.m_flags & EXT4_MAP_UNWRITTEN) ?
 				EXT_UNWRITTEN_MAX_LEN : EXT_INIT_MAX_LEN;
@@ -929,26 +1019,67 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 			/* Limit the number of blocks in one extent */
 			map.m_len = min(max, map.m_len);
 
-			fc_ext.fc_ino = cpu_to_le32(inode->i_ino);
-			ex = (struct ext4_extent *)&fc_ext.fc_ex;
-			ex->ee_block = cpu_to_le32(map.m_lblk);
-			ex->ee_len = cpu_to_le16(map.m_len);
-			ext4_ext_store_pblock(ex, map.m_pblk);
-			if (map.m_flags & EXT4_MAP_UNWRITTEN)
-				ext4_ext_mark_unwritten(ex);
-			else
-				ext4_ext_mark_initialized(ex);
-			if (!ext4_fc_add_tlv(inode->i_sb, EXT4_FC_TAG_ADD_RANGE,
-					    sizeof(fc_ext), (u8 *)&fc_ext, crc))
-				return -ENOSPC;
+			range->tag = EXT4_FC_TAG_ADD_RANGE;
+			range->len = map.m_len;
+			range->pblk = map.m_pblk;
+			range->unwritten = !!(map.m_flags & EXT4_MAP_UNWRITTEN);
 		}
 
-		cur_lblk_off += map.m_len;
+		INIT_LIST_HEAD(&range->list);
+		list_add_tail(&range->list, ranges);
+
+		cur_lblk += map.m_len;
 	}
 
 	return 0;
 }
 
+static int ext4_fc_snapshot_inode(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_inode_snap *snap;
+	int inode_len = EXT4_GOOD_OLD_INODE_SIZE;
+	struct ext4_iloc iloc;
+	LIST_HEAD(ranges);
+	int ret;
+	int alloc_ctx;
+
+	ret = ext4_get_inode_loc_noio(inode, &iloc);
+	if (ret)
+		return ret;
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
+		inode_len = EXT4_INODE_SIZE(inode->i_sb);
+	else if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE)
+		inode_len += ei->i_extra_isize;
+
+	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
+	if (!snap) {
+		brelse(iloc.bh);
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&snap->data_list);
+	snap->inode_len = inode_len;
+
+	memcpy(snap->inode_buf, (u8 *)ext4_raw_inode(&iloc), inode_len);
+	brelse(iloc.bh);
+
+	ret = ext4_fc_snapshot_inode_data(inode, &ranges);
+	if (ret) {
+		kfree(snap);
+		ext4_fc_free_ranges(&ranges);
+		return ret;
+	}
+
+	alloc_ctx = ext4_fc_lock(inode->i_sb);
+	ext4_fc_free_inode_snap(inode);
+	ei->i_fc_snap = snap;
+	list_splice_tail_init(&ranges, &snap->data_list);
+	ext4_fc_unlock(inode->i_sb, alloc_ctx);
+
+	return 0;
+}
+
 
 /* Flushes data of all the inodes in the commit queue. */
 static int ext4_fc_flush_data(journal_t *journal)
@@ -999,6 +1130,11 @@ static int ext4_fc_commit_dentry_updates(journal_t *journal, u32 *crc)
 		 */
 		if (list_empty(&fc_dentry->fcd_dilist))
 			continue;
+		/*
+		 * For EXT4_FC_TAG_CREAT, fcd_dilist is linked on the created
+		 * inode's i_fc_dilist list (kept singular), so we can recover the
+		 * inode through it.
+		 */
 		ei = list_first_entry(&fc_dentry->fcd_dilist,
 				struct ext4_inode_info, i_fc_dilist);
 		inode = &ei->vfs_inode;
@@ -1023,6 +1159,88 @@ static int ext4_fc_commit_dentry_updates(journal_t *journal, u32 *crc)
 	return 0;
 }
 
+static int ext4_fc_snapshot_inodes(journal_t *journal)
+{
+	struct super_block *sb = journal->j_private;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_inode_info *iter;
+	struct ext4_fc_dentry_update *fc_dentry;
+	struct inode **inodes;
+	unsigned int nr_inodes = 0;
+	unsigned int i = 0;
+	int ret = 0;
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
+	if (!nr_inodes)
+		return 0;
+
+	inodes = kvcalloc(nr_inodes, sizeof(*inodes), GFP_NOFS);
+	if (!inodes)
+		return -ENOMEM;
+
+	alloc_ctx = ext4_fc_lock(sb);
+	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
+		inodes[i] = igrab(&iter->vfs_inode);
+		if (inodes[i])
+			i++;
+	}
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
+		inodes[i] = igrab(&ei->vfs_inode);
+		if (inodes[i])
+			i++;
+	}
+	ext4_fc_unlock(sb, alloc_ctx);
+
+	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
+		ret = ext4_fc_snapshot_inode(inodes[nr_inodes]);
+		if (ret)
+			break;
+	}
+
+	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
+		if (inodes[nr_inodes])
+			iput(inodes[nr_inodes]);
+	}
+	kvfree(inodes);
+	return ret;
+}
+
 static int ext4_fc_perform_commit(journal_t *journal)
 {
 	struct super_block *sb = journal->j_private;
@@ -1095,7 +1313,11 @@ static int ext4_fc_perform_commit(journal_t *journal)
 				     EXT4_STATE_FC_COMMITTING);
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
+
+	ret = ext4_fc_snapshot_inodes(journal);
 	jbd2_journal_unlock_updates(journal);
+	if (ret)
+		return ret;
 
 	/*
 	 * Step 5: If file system device is different from journal device,
@@ -1292,6 +1514,7 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 					struct ext4_inode_info,
 					i_fc_list);
 		list_del_init(&ei->i_fc_list);
+		ext4_fc_free_inode_snap(&ei->vfs_inode);
 		ext4_clear_inode_state(&ei->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
 		if (tid_geq(tid, ei->i_sync_tid)) {
@@ -1327,6 +1550,14 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 					     struct ext4_fc_dentry_update,
 					     fcd_list);
 		list_del_init(&fc_dentry->fcd_list);
+		if (fc_dentry->fcd_op == EXT4_FC_TAG_CREAT &&
+		    !list_empty(&fc_dentry->fcd_dilist)) {
+			/* See the comment in ext4_fc_commit_dentry_updates(). */
+			ei = list_first_entry(&fc_dentry->fcd_dilist,
+					      struct ext4_inode_info,
+					      i_fc_dilist);
+			ext4_fc_free_inode_snap(&ei->vfs_inode);
+		}
 		list_del_init(&fc_dentry->fcd_dilist);
 
 		release_dentry_name_snapshot(&fc_dentry->fcd_name);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..4678612f82e8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5025,6 +5025,57 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 	return ret;
 }
 
+/*
+ * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
+ * It looks up the inode table block in the buffer cache and returns -EAGAIN if
+ * the block is not present or not uptodate, without starting any I/O.
+ */
+int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_group_desc *gdp;
+	struct buffer_head *bh;
+	ext4_fsblk_t block;
+	int inodes_per_block, inode_offset;
+	unsigned long ino = inode->i_ino;
+
+	iloc->bh = NULL;
+	if (ino < EXT4_ROOT_INO ||
+	    ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))
+		return -EFSCORRUPTED;
+
+	iloc->block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
+	gdp = ext4_get_group_desc(sb, iloc->block_group, NULL);
+	if (!gdp)
+		return -EIO;
+
+	/* Figure out the offset within the block group inode table. */
+	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
+	inode_offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb));
+	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
+
+	block = ext4_inode_table(sb, gdp);
+	if (block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) ||
+	    block >= ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+		ext4_error(sb,
+			   "Invalid inode table block %llu in block_group %u",
+			   block, iloc->block_group);
+		return -EFSCORRUPTED;
+	}
+	block += inode_offset / inodes_per_block;
+
+	bh = sb_find_get_block(sb, block);
+	if (!bh)
+		return -EAGAIN;
+	if (!ext4_buffer_uptodate(bh)) {
+		brelse(bh);
+		return -EAGAIN;
+	}
+
+	iloc->bh = bh;
+	return 0;
+}
+
 
 int ext4_get_fc_inode_loc(struct super_block *sb, unsigned long ino,
 			  struct ext4_iloc *iloc)
-- 
2.53.0

