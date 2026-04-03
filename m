Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD5332EBD
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775204851; cv=none; b=pVDEs9NekQ2pASTO+spFRKJQWU5y9EHlmkO5WwnJwcwgwFPYoWs5uUADh5MSniU6XUpmM+3Wdz7wZuPq+/FELqEiAwulXp+3yby7fN4J53PTggHi8gxBBHfkI6XTqcKD73a9AerZRxx3U8nXtXncM2/AVrWKHNE2Ykmq5hZvNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775204851; c=relaxed/simple;
	bh=CjtkAc4EO1LkIlSvIhzwjEc17aJZLHMxj9rtizpySq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LKGn/v6kMvARazh2Rp68Fq86rtLaa71rwAU2HHIBNGLiqaCuyFos80MGX1QPcIr8nQO6jclEzqs7TtkEWMm5PmX1qAB5MMUtncV3FwSn7KBZ4pBaC5tkXlTBt4Ytd9y2kKRHmxhj2bbAVwmFSN36AkJ1HTfhx2fQlfK4T270N58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fnBf872S4zYQts0
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:26:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 533544056F
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:27:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0roec9pD5T6DA--.40142S6;
	Fri, 03 Apr 2026 16:27:22 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH 2/3] ext4: show inode orphan list detail information
Date: Fri,  3 Apr 2026 16:25:06 +0800
Message-Id: <20260403082507.1882703-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHn0roec9pD5T6DA--.40142S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy3Zr1kur48Jr1DGry5twb_yoWrGr43pF
	W5J34rAa1rWF93WF4fJF4UZFn3K3WxG3y7Xr9a93yYqryUXrWktF18t3WUZFy5ArW8Gwn0
	qws0gFy5Kr18urJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUzMKuUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Some inodes added to the orphan list are due to truncation, while others
are due to deletion.Therefore, we printed the information of inode as
follows: inode number/i_nlink/i_size/i_blocks/projid/file path. By using
this information, it is possible to quickly identify files that have been
deleted but are still being referenced.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/orphan.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 1d231aeaf282..272de32d1a47 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -662,25 +662,108 @@ int ext4_orphan_file_empty(struct super_block *sb)
 
 struct ext4_proc_orphan {
 	struct ext4_inode_info cursor;
+	bool print_title;
 };
 
-static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
+static inline bool ext4_is_cursor(struct ext4_inode_info *inode)
+{
+	return (inode->vfs_inode.i_ino == 0);
+}
+
+static struct inode *ext4_list_next(struct list_head *head, struct list_head *p)
 {
+	struct ext4_inode_info *inode;
+
+	list_for_each_continue(p, head) {
+		inode = list_entry(p, typeof(*inode), i_orphan);
+		if (!ext4_is_cursor(inode))
+			return &inode->vfs_inode;
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
+	return ext4_list_next(&sbi->s_orphan, prev);
+}
+
 static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	return NULL;
+	struct super_block *sb = pde_data(file_inode(seq->file));
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode = v;
+
+	++*pos;
+
+	return ext4_list_next(&sbi->s_orphan, &EXT4_I(inode)->i_orphan);
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
+		seq_dentry(seq, dentry, "\t\n\\");
+	else
+		seq_puts(seq, "unknown");
+
+	dput(dentry);
+	seq_putc(seq, '\n');
 }
 
 static int ext4_orphan_seq_show(struct seq_file *seq, void *v)
 {
+	struct inode *inode = v;
+	struct ext4_proc_orphan *s = seq->private;
+
+	if (s->print_title) {
+		seq_puts(seq, "INO\tNLINK\tSIZE\tBLOCKS\tPROJID\tPATH\n");
+		s->print_title = false;
+	}
+
+	seq_printf(seq, "%llu\t%u\t%llu\t%llu\t%u\t",
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
+	struct inode *inode = v;
+	struct ext4_proc_orphan *s = seq->private;
+
+	if (inode)
+		list_move_tail(&s->cursor.i_orphan, &EXT4_I(inode)->i_orphan);
+	else
+		list_del_init(&s->cursor.i_orphan);
+
+	mutex_unlock(&sbi->s_orphan_lock);
 }
 
 const struct seq_operations ext4_orphan_seq_ops = {
@@ -703,6 +786,7 @@ static int ext4_seq_orphan_open(struct inode *inode, struct file *file)
 		private = m->private;
 		INIT_LIST_HEAD(&private->cursor.i_orphan);
 		private->cursor.vfs_inode.i_ino = 0;
+		private->print_title = true;
 	}
 
 	return rc;
-- 
2.34.1

