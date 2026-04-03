Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8032ECEB9
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775204853; cv=none; b=Q7ksoBbNpQCS4kAbOufl8mamMhOkhv8fA9R5X4ZJwUX/5qiXssK7HQgDrZq8Vr8Ars3h4ngG9bYbPvethQUyX6ytPqC6dVqPeoPHju0AXYM8FG25secUOUqnGsBTXP7IF8fodo4otBVI7oCAqw1sGelX+rJzCzDKhmVsC0hjrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775204853; c=relaxed/simple;
	bh=LzvV8yEfo+zJJs+AjDvGyZbxxX5cjXj465DfE85WIyM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nfRpMgRVoeuepZcRwjcadCnPHsG7bp86qe96dJkPBYj1XJJ0CQ+hv7dD28dvSJQE2h3XMVO5vyyXje17rN0TA0absBbrl/pCbJNFi5rwWCl4Mxbl4MYzuiN5fOJY6FRpvuBIH+V73c8I4oO9d2e3UMkpUOUf9RhqM1Gsg03Yqq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fnBdd6MkszKHMT5
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:26:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 64C1F40574
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:27:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0roec9pD5T6DA--.40142S7;
	Fri, 03 Apr 2026 16:27:22 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH 3/3] ext4: show orphan file inode detail info
Date: Fri,  3 Apr 2026 16:25:07 +0800
Message-Id: <20260403082507.1882703-4-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260403082507.1882703-1-yebin@huaweicloud.com>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHn0roec9pD5T6DA--.40142S7
X-Coremail-Antispam: 1UD129KBjvJXoW3AryfCr13KFy8AFW3Jr13Arb_yoW7Ar4kpF
	98trykAa1UWas5WFs7JF4UZrn3K3WxK3yUXr9a93savryUtr1UtF18J3WUuFn5ArW7Grn0
	gw4YgFWUKr4UZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxU2ApnDUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Support show inode information in orphan file.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/orphan.c | 115 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 94 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 272de32d1a47..c01887fb496b 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -663,6 +663,11 @@ int ext4_orphan_file_empty(struct super_block *sb)
 struct ext4_proc_orphan {
 	struct ext4_inode_info cursor;
 	bool print_title;
+	struct ext4_orphan_info *oi;
+	int inodes_per_ob;
+	int block_idx;
+	int offset;
+	bool orphan_file;
 };
 
 static inline bool ext4_is_cursor(struct ext4_inode_info *inode)
@@ -683,24 +688,65 @@ static struct inode *ext4_list_next(struct list_head *head, struct list_head *p)
 	return NULL;
 }
 
+static struct inode *ext4_orphan_file_next(struct ext4_proc_orphan *s,
+					   struct super_block *sb)
+{
+	struct inode *inode;
+	struct ext4_orphan_info *oi = s->oi;
+
+	for (; s->block_idx < oi->of_blocks; s->block_idx++) {
+		__le32 *bdata = (__le32 *)(oi->of_binfo[s->block_idx].ob_bh->b_data);
+
+		if (atomic_read(&oi->of_binfo[s->block_idx].ob_free_entries) ==
+		    s->inodes_per_ob) {
+			s->offset = 0;
+			continue;
+		}
+		for (; s->offset < s->inodes_per_ob; s->offset++) {
+			if (!bdata[s->offset])
+				continue;
+			inode = ext4_iget(sb, le32_to_cpu(bdata[s->offset]),
+					  EXT4_IGET_NORMAL);
+			if (IS_ERR(inode))
+				continue;
+			s->offset++;
+			return inode;
+		}
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
+		if (!list_empty(prev)) {
+			ret = ext4_list_next(&sbi->s_orphan, prev);
+			if (ret)
+				return ret;
+		}
+
+		if (!s->oi)
 			return NULL;
+		list_del_init(&s->cursor.i_orphan);
+		mutex_unlock(&sbi->s_orphan_lock);
+		s->orphan_file = true;
 	}
 
-	return ext4_list_next(&sbi->s_orphan, prev);
+	return ext4_orphan_file_next(s, sb);
 }
 
 static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -708,10 +754,26 @@ static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct super_block *sb = pde_data(file_inode(seq->file));
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct inode *inode = v;
+	struct ext4_proc_orphan *s = seq->private;
+	void *ret;
 
 	++*pos;
 
-	return ext4_list_next(&sbi->s_orphan, &EXT4_I(inode)->i_orphan);
+	if (!s->orphan_file) {
+		ret = ext4_list_next(&sbi->s_orphan, &EXT4_I(inode)->i_orphan);
+		if (ret)
+			return ret;
+		if (!s->oi)
+			return NULL;
+		list_del_init(&s->cursor.i_orphan);
+		mutex_unlock(&sbi->s_orphan_lock);
+		s->orphan_file = true;
+		v = NULL;
+	}
+
+	iput(v);
+
+	return ext4_orphan_file_next(s, sb);
 }
 
 static void ext4_show_filename(struct seq_file *seq, struct inode *inode)
@@ -758,12 +820,16 @@ static void ext4_orphan_seq_stop(struct seq_file *seq, void *v)
 	struct inode *inode = v;
 	struct ext4_proc_orphan *s = seq->private;
 
-	if (inode)
-		list_move_tail(&s->cursor.i_orphan, &EXT4_I(inode)->i_orphan);
-	else
-		list_del_init(&s->cursor.i_orphan);
+	if (!s->orphan_file) {
+		if (inode)
+			list_move_tail(&s->cursor.i_orphan, &EXT4_I(inode)->i_orphan);
+		else
+			list_del_init(&s->cursor.i_orphan);
 
-	mutex_unlock(&sbi->s_orphan_lock);
+		mutex_unlock(&sbi->s_orphan_lock);
+	} else {
+		iput(v);
+	}
 }
 
 const struct seq_operations ext4_orphan_seq_ops = {
@@ -777,16 +843,21 @@ static int ext4_seq_orphan_open(struct inode *inode, struct file *file)
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
-		private->print_title = true;
+		s = m->private;
+		INIT_LIST_HEAD(&s->cursor.i_orphan);
+		s->cursor.vfs_inode.i_ino = 0;
+		s->print_title = true;
+		if (ext4_has_feature_orphan_file(sb)) {
+			s->oi = &EXT4_SB(sb)->s_orphan_info;
+			s->inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+		}
 	}
 
 	return rc;
@@ -798,9 +869,11 @@ static int ext4_seq_orphan_release(struct inode *inode, struct file *file)
 	struct ext4_proc_orphan *s = seq->private;
 	struct ext4_sb_info *sbi = EXT4_SB(pde_data(inode));
 
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

