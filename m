Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA811347FD0
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 10:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250668; cv=none; b=APBUr6BQwmn6e2m2tz7dxvqKNXQ2F6QuJRKZ+ZcoJ3DqOqIikrIeAwJ0DdyV7wmx5+d6PjEIY/9CjaLEDd0hHIcMESjHpyLzlzCrei64yIcf97Q1a0X+LzmQbYjR1odCYZSdTEbRDJ20TG7abc5QMw/3BaJ03+kvreFvKjX4gOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250668; c=relaxed/simple;
	bh=QMgA0vjYT1SaSCMl22Tl4PgBTOQAAWQE1b0ZB0vyKAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cP1eYzs2zCN04kcsIc34fccRH/cn/GZczhEEukpvZN//8WhITS7YNpMj6iQlx6+bpPRTO4CZBL0ob3PDkCDwuK8U47ThZBL2dGPGiSTSc8lGegzoNkBe8P78ZgIyMP+CwF6qerhXpI44GAAOKLC21l6L8QPnSyew7Cng+9Z/YS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fwdPb6FgBzYQtpY
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:56:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C530D4058D
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0fb99pbf70AQ--.45727S8;
	Wed, 15 Apr 2026 18:57:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 4/4] ext4: show orphan file inode detail info
Date: Wed, 15 Apr 2026 18:55:05 +0800
Message-Id: <20260415105505.342358-5-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415105505.342358-1-yebin@huaweicloud.com>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL0fb99pbf70AQ--.45727S8
X-Coremail-Antispam: 1UD129KBjvJXoW3AryfCr1xWrW8KF1DAw45trb_yoWxtrWUpF
	s8Kr95Aa1UWas5Wan7XF4UXrn3t3WxK34UJrya93yFvFyYvr17tF18J3WUuF98ArW8Jrn0
	gw4jgFWUKF4UZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x07jeVbkUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Support show inode information in orphan file.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/orphan.c | 179 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 146 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 4d6f8c9edaeb..715d04e386d0 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -680,6 +680,11 @@ int ext4_orphan_file_empty(struct super_block *sb)
 
 struct ext4_proc_orphan {
 	struct ext4_inode_info cursor;
+	struct ext4_orphan_info *oi;
+	int inodes_per_ob;
+	int block_idx;
+	int offset;
+	bool orphan_file;
 };
 
 static struct inode *ext4_list_next(struct ext4_proc_orphan *s,
@@ -724,24 +729,94 @@ static struct inode *ext4_list_next(struct ext4_proc_orphan *s,
 	return NULL;
 }
 
+static struct inode *ext4_orphan_file_next(struct ext4_proc_orphan *s,
+					   struct super_block *sb)
+{
+	struct inode *inode = NULL;
+	struct ext4_orphan_info *oi = s->oi;
+
+	for (; s->block_idx < oi->of_blocks; s->block_idx++) {
+		int idx = s->block_idx;
+		struct ext4_orphan_block *binfo = &oi->of_binfo[idx];
+		__le32 *bdata = (__le32 *)(binfo->ob_bh->b_data);
+
+		if (atomic_read(&binfo->ob_free_entries) ==
+				s->inodes_per_ob) {
+			s->offset = 0;
+			continue;
+		}
+		for (; s->offset < s->inodes_per_ob; s->offset++) {
+			u64 ino = le32_to_cpu(bdata[s->offset]);
+
+			if (!ino)
+				continue;
+			/*
+			 * Orphan nodes in the running state are those
+			 * inodes that are still in use, so here we get
+			 * them from the cache if available.
+			 */
+			inode = ilookup(sb, ino);
+			if (!inode)
+				continue;
+
+			if (!ext4_test_inode_state(inode,
+						EXT4_STATE_ORPHAN_FILE)) {
+				iput(inode);
+				continue;
+			}
+
+			s->offset++;
+			if (s->offset == s->inodes_per_ob) {
+				s->offset = 0;
+				s->block_idx++;
+			}
+			return inode;
+		}
+
+		s->offset = 0;
+	}
+
+	return NULL;
+}
+
 static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct ext4_proc_orphan *s = seq->private;
 	struct super_block *sb = pde_data(file_inode(seq->file));
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct list_head *prev;
+	void *ret;
 
-	mutex_lock(&sbi->s_orphan_lock);
+	if (!s->orphan_file) {
+		mutex_lock(&sbi->s_orphan_lock);
+		if (!*pos)
+			prev = &sbi->s_orphan;
+		else
+			prev = &s->cursor.i_orphan;
 
-	if (!*pos) {
-		prev = &sbi->s_orphan;
-	} else {
-		prev = &s->cursor.i_orphan;
-		if (list_empty(prev))
+		/*
+		 * Here, the code checks whether the linked list is empty
+		 * because when the orphan_file feature is supported, the
+		 * cursor is removed from the linked list after the orphan
+		 * list is traversed. If the orphan_file feature is not
+		 * enabled, calling ext4_orphan_seq_start() again would
+		 * cause an infinite loop.
+		 */
+		if (!list_empty(prev)) {
+			ret = ext4_list_next(s, &sbi->s_orphan, prev);
+			if (ret)
+				return ret;
+		}
+
+		if (!s->oi)
 			return NULL;
+
+		list_del_init(&s->cursor.i_orphan);
+		mutex_unlock(&sbi->s_orphan_lock);
+		s->orphan_file = true;
 	}
 
-	return ext4_list_next(s, &sbi->s_orphan, prev);
+	return ext4_orphan_file_next(s, sb);
 }
 
 static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -750,19 +825,36 @@ static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_proc_orphan *s = seq->private;
 	struct inode *inode = v;
+	void *ret;
 
 	++*pos;
 
-	/*
-	 * To prevent the deadlock caused by orphan node deletion when the
-	 * last inode reference count is released, the inode reference
-	 * count needs to be released in the unlocked state.
-	 */
-	mutex_unlock(&sbi->s_orphan_lock);
-	iput(inode);
-	mutex_lock(&sbi->s_orphan_lock);
+	if (!s->orphan_file) {
+		/*
+		 * To prevent the deadlock caused by orphan node deletion
+		 * when the last inode reference count is released, the
+		 * inode reference count needs to be released in the
+		 * unlocked state.
+		 */
+		mutex_unlock(&sbi->s_orphan_lock);
+		iput(inode);
+		mutex_lock(&sbi->s_orphan_lock);
+
+		ret = ext4_list_next(s, &sbi->s_orphan,
+				     &s->cursor.i_orphan);
+		if (ret)
+			return ret;
+		if (!s->oi)
+			return NULL;
+		list_del_init(&s->cursor.i_orphan);
+		mutex_unlock(&sbi->s_orphan_lock);
+		s->orphan_file = true;
+	} else {
+		iput(inode);
+	}
+
 
-	return ext4_list_next(s, &sbi->s_orphan, &s->cursor.i_orphan);
+	return ext4_orphan_file_next(s, sb);
 }
 
 static void ext4_show_filename(struct seq_file *seq, struct inode *inode)
@@ -811,16 +903,28 @@ static void ext4_orphan_seq_stop(struct seq_file *seq, void *v)
 	struct ext4_proc_orphan *s = seq->private;
 	struct inode *inode = v;
 
-	/*
-	 * stop() is called when the cache is full, so the traversal
-	 * position needs to be moved back to the front of the current
-	 * inode.
-	 */
-	if (v)
-		list_move_tail(&s->cursor.i_orphan,
-			       &EXT4_I(inode)->i_orphan);
+	if (!s->orphan_file) {
+		/*
+		 * stop() is called when the cache is full, so the
+		 * traversal position needs to be moved back to the
+		 * front of the current inode. If stop() due to EOF
+		 * then remove cursor from orphan list.
+		 */
+		if (inode)
+			list_move_tail(&s->cursor.i_orphan,
+				       &EXT4_I(inode)->i_orphan);
+		else
+			list_del_init(&s->cursor.i_orphan);
 
-	mutex_unlock(&sbi->s_orphan_lock);
+		mutex_unlock(&sbi->s_orphan_lock);
+	} else if (inode) {
+		if (s->offset) {
+			s->offset--;
+		} else if (s->block_idx) {
+			s->block_idx--;
+			s->offset = s->inodes_per_ob - 1;
+		}
+	}
 
 	iput(inode);
 }
@@ -836,15 +940,21 @@ static int ext4_seq_orphan_open(struct inode *inode, struct file *file)
 {
 	int rc;
 	struct seq_file *m;
-	struct ext4_proc_orphan *private;
+	struct ext4_proc_orphan *s;
 
 	rc = seq_open_private(file, &ext4_orphan_seq_ops,
 			      sizeof(struct ext4_proc_orphan));
 	if (!rc) {
+		struct super_block *sb = pde_data(file_inode(file));
 		m = file->private_data;
-		private = m->private;
-		INIT_LIST_HEAD(&private->cursor.i_orphan);
-		private->cursor.vfs_inode.i_ino = 0;
+		s = m->private;
+		INIT_LIST_HEAD(&s->cursor.i_orphan);
+		s->cursor.vfs_inode.i_ino = 0;
+		s->orphan_file = 0;
+		if (ext4_has_feature_orphan_file(sb)) {
+			s->oi = &EXT4_SB(sb)->s_orphan_info;
+			s->inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+		}
 	}
 
 	return rc;
@@ -862,11 +972,14 @@ static int ext4_seq_orphan_release(struct inode *inode, struct file *file)
 	 * the entry from the 'pde->pde_openers' list. Therefore, when the
 	 * file is closed, proc_reg_release() will not call close_pdeo()
 	 * again because it cannot find the node on the 'pde->pde_openers'
-	 * list. This prevents the UAF issue from occurring.
+	 * list. This prevents the UAF issue from occurring. Maybe, cursor
+	 * already removed in stop().
 	 */
-	mutex_lock(&sbi->s_orphan_lock);
-	list_del(&s->cursor.i_orphan);
-	mutex_unlock(&sbi->s_orphan_lock);
+	if (!s->orphan_file) {
+		mutex_lock(&sbi->s_orphan_lock);
+		list_del(&s->cursor.i_orphan);
+		mutex_unlock(&sbi->s_orphan_lock);
+	}
 
 	return seq_release_private(inode, file);
 }
-- 
2.34.1

