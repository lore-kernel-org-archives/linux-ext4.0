Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8933491D0
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 10:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250668; cv=none; b=DK9nv+1qYjKV5Hr+LxSgW6ZWr6WOJaP2kHU84b0uewX8TnxfnaZvKNu6Lkmkmj1tRH6/Va8bhbqboL9cF8wqoxxhcCM/LZEFIPlxvfSC4unBJX6qMOHGOjN8WEkXwx8QQLQKF1lCI8c5ZjR+aLEtod5Mql37yFJAJuzztYcgOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250668; c=relaxed/simple;
	bh=K3gW/q82FCk0AlfMaNRJQvvnTld23QVn0QVTztoK/M8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YNziGiyb9/A/wBxZpFeHCFZuxemIuGdgB8icV8EWkhDnlBA44vquLiaYFbwICS078qVQmrBQIwB6P1dQV/8Nz5yPzLhF8nRirlKA1PiGW+lXy+dGVZmTLGtaBSWU6K6pmRjsQeuGqe5x8a5O05bW2sG4mBHOqhg96iVTWsZHSbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fwdPb64gCzYQtpY
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:56:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id BD7DC40577
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0fb99pbf70AQ--.45727S7;
	Wed, 15 Apr 2026 18:57:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 3/4] ext4: show inode orphan list detail information
Date: Wed, 15 Apr 2026 18:55:04 +0800
Message-Id: <20260415105505.342358-4-yebin@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgAHtL0fb99pbf70AQ--.45727S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy3Zr1kur48Jr1DGry5twb_yoWruw1UpF
	s8J34rAan8Was3WF4ftF4UXrnay3WxG3y5Jr9I93yFqrW5XryIqF18tw1UZF98ArW8Gr90
	qw4jgFW5Kr10grDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07jec_-UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Some inodes added to the orphan list are due to truncation, while others
are due to deletion.Therefore, we printed the information of inode as
follows: inode number/i_nlink/i_size/i_blocks/projid/file path. By using
this information, it is possible to quickly identify files that have been
deleted but are still being referenced.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/orphan.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index a6bffe67ef75..4d6f8c9edaeb 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -682,23 +682,147 @@ struct ext4_proc_orphan {
 	struct ext4_inode_info cursor;
 };
 
-static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
+static struct inode *ext4_list_next(struct ext4_proc_orphan *s,
+				    struct list_head *head,
+				    struct list_head *p)
 {
+	list_for_each_continue(p, head) {
+		struct ext4_inode_info *ei;
+		struct inode *inode;
+
+		ei = list_entry(p, typeof(*ei), i_orphan);
+		inode = &ei->vfs_inode;
+
+		/*
+		 * It is safe to insert a cursor into the orphan list
+		 * because ext4_orphan_del() will skip cursor. When the
+		 * orphan list is processed in ext4_put_super(),
+		 * ext4_seq_orphan_release() must have already been called,
+		 * so the cursor must have already been removed from the
+		 * orphan list.Therefore, there will be no access to a
+		 * stale cursor.
+		 */
+		list_move(&s->cursor.i_orphan, &ei->i_orphan);
+
+		/*
+		 * Because the cursor has moved to the node after the
+		 * current node, the traversal cannot continue from the
+		 * current node. Instead, the traversal should continue
+		 * from the cursor.
+		 */
+		p = &s->cursor.i_orphan;
+
+		if (ext4_is_cursor(inode))
+			continue;
+
+		if (!igrab(inode))
+			continue;
+
+		return inode;
+	}
+
 	return NULL;
 }
 
+static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct ext4_proc_orphan *s = seq->private;
+	struct super_block *sb = pde_data(file_inode(seq->file));
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct list_head *prev;
+
+	mutex_lock(&sbi->s_orphan_lock);
+
+	if (!*pos) {
+		prev = &sbi->s_orphan;
+	} else {
+		prev = &s->cursor.i_orphan;
+		if (list_empty(prev))
+			return NULL;
+	}
+
+	return ext4_list_next(s, &sbi->s_orphan, prev);
+}
+
 static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	return NULL;
+	struct super_block *sb = pde_data(file_inode(seq->file));
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_proc_orphan *s = seq->private;
+	struct inode *inode = v;
+
+	++*pos;
+
+	/*
+	 * To prevent the deadlock caused by orphan node deletion when the
+	 * last inode reference count is released, the inode reference
+	 * count needs to be released in the unlocked state.
+	 */
+	mutex_unlock(&sbi->s_orphan_lock);
+	iput(inode);
+	mutex_lock(&sbi->s_orphan_lock);
+
+	return ext4_list_next(s, &sbi->s_orphan, &s->cursor.i_orphan);
+}
+
+static void ext4_show_filename(struct seq_file *seq, struct inode *inode)
+{
+	struct dentry *dentry;
+
+	dentry = d_find_alias(inode);
+	if (!dentry)
+		dentry = d_find_any_alias(inode);
+
+	if (dentry)
+		seq_dentry(seq, dentry, " \t\n\\");
+	else
+		seq_puts(seq, "unknown");
+
+	seq_puts(seq, "\"\n");
+
+	/*
+	 * Since igrab() has already been called in ext4_list_next(), the
+	 * inode will not be released here, so there will be no deadlock.
+	 */
+	dput(dentry);
 }
 
 static int ext4_orphan_seq_show(struct seq_file *seq, void *v)
 {
+	struct inode *inode = v;
+
+	/*
+	 * Print the original data without differentiating namespaces.
+	 */
+	seq_printf(seq, "ino: %llu, link: %u, size: %llu, blocks: %llu, proj: %u, path: \"",
+		   inode->i_ino, inode->i_nlink,
+		   i_size_read(inode), inode->i_blocks,
+		   __kprojid_val(EXT4_I(inode)->i_projid));
+
+	ext4_show_filename(seq, inode);
+
 	return 0;
 }
 
 static void ext4_orphan_seq_stop(struct seq_file *seq, void *v)
 {
+	struct super_block *sb = pde_data(file_inode(seq->file));
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_proc_orphan *s = seq->private;
+	struct inode *inode = v;
+
+	/*
+	 * stop() is called when the cache is full, so the traversal
+	 * position needs to be moved back to the front of the current
+	 * inode.
+	 */
+	if (v)
+		list_move_tail(&s->cursor.i_orphan,
+			       &EXT4_I(inode)->i_orphan);
+
+	mutex_unlock(&sbi->s_orphan_lock);
+
+	iput(inode);
 }
 
 const struct seq_operations ext4_orphan_seq_ops = {
-- 
2.34.1

