Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E823491D6
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250664; cv=none; b=SMvDPxpeo51peYDKZunjX9RLYAYPqT5qY0U4fdqem6T4tP83cdFy4Z6Jg/C8OA8LKkTS5HujXBisNwuMeqDL7RPt37hPsRpxXSIYPIrr4CRW3A/qi7ADikp6dTjErft6pPo2kpI0aG3qxY4ZqKqmvPwvbaJh+VAWvbyFDM6g8Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250664; c=relaxed/simple;
	bh=lBkIMdW9M4ScslU9Ve3XMZFYsU6IbZnPvAoADtH87Bc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SsIWruYxjnMqORyFapo05CYBXPQ7y/NjSK5R8x4cLsoflWFSXgX8+6Uu6Kx+YW1wPhEV+gHAofROkjG8aCcwmdSlcZmW95ACBw//NKa7dIyA9gNMFvTzhVK8pcmMDsbK2pbA024Qr9Y24SLa+NTvrKI29Zd4K76oieOeqTFrMyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fwdQJ0hXCzKHMXS
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A63324058F
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0fb99pbf70AQ--.45727S5;
	Wed, 15 Apr 2026 18:57:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 1/4] ext4: register 'orphan_list' procfs
Date: Wed, 15 Apr 2026 18:55:02 +0800
Message-Id: <20260415105505.342358-2-yebin@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgAHtL0fb99pbf70AQ--.45727S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXry3Kr45XrWDXF18Cw47twb_yoWrAFykpF
	Z8A34rJa1UWF9xWanxGF4UXrn3t3WxGw1Utr92934aqryaqryktF18t3Wj9F1rJrWUGr13
	Xa1jgFyUKr4a9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU14CJJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This patch register '/proc/fs/ext4/XXX/orphan_list' procfs for show inode
orphan list about EXT4 file system.
In actual production environments, there may be inconsistencies in df/du,
sometimes due to kernel occupation, making it difficult to find such files,
and it is also difficult to operate in the current network environment. So
add "orphan_list" procfs to quickly query files that have been deleted but
are occupied.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/ext4.h   |  1 +
 fs/ext4/orphan.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/sysfs.c  |  2 ++
 3 files changed, 80 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0cf68f85dfd1..ccb0fd1e63e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3875,6 +3875,7 @@ extern void ext4_stop_mmpd(struct ext4_sb_info *sbi);
 extern const struct fsverity_operations ext4_verityops;
 
 /* orphan.c */
+extern const struct proc_ops ext4_orphan_proc_ops;
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern void ext4_orphan_cleanup(struct super_block *sb,
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..f7e7f77e021e 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -4,6 +4,8 @@
 #include <linux/fs.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -657,3 +659,78 @@ int ext4_orphan_file_empty(struct super_block *sb)
 			return 0;
 	return 1;
 }
+
+struct ext4_proc_orphan {
+	struct ext4_inode_info cursor;
+};
+
+static void *ext4_orphan_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return NULL;
+}
+
+static void *ext4_orphan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	return NULL;
+}
+
+static int ext4_orphan_seq_show(struct seq_file *seq, void *v)
+{
+	return 0;
+}
+
+static void ext4_orphan_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+const struct seq_operations ext4_orphan_seq_ops = {
+	.start  = ext4_orphan_seq_start,
+	.next   = ext4_orphan_seq_next,
+	.stop   = ext4_orphan_seq_stop,
+	.show   = ext4_orphan_seq_show,
+};
+
+static int ext4_seq_orphan_open(struct inode *inode, struct file *file)
+{
+	int rc;
+	struct seq_file *m;
+	struct ext4_proc_orphan *private;
+
+	rc = seq_open_private(file, &ext4_orphan_seq_ops,
+			      sizeof(struct ext4_proc_orphan));
+	if (!rc) {
+		m = file->private_data;
+		private = m->private;
+		INIT_LIST_HEAD(&private->cursor.i_orphan);
+		private->cursor.vfs_inode.i_ino = 0;
+	}
+
+	return rc;
+}
+
+static int ext4_seq_orphan_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct ext4_proc_orphan *s = seq->private;
+	struct ext4_sb_info *sbi = EXT4_SB(pde_data(inode));
+
+	/*
+	 * The function close_pdeo() is called when deleting the procfs
+	 * in ext4_unregister_sysfs(), and this function is used to remove
+	 * the entry from the 'pde->pde_openers' list. Therefore, when the
+	 * file is closed, proc_reg_release() will not call close_pdeo()
+	 * again because it cannot find the node on the 'pde->pde_openers'
+	 * list. This prevents the UAF issue from occurring.
+	 */
+	mutex_lock(&sbi->s_orphan_lock);
+	list_del(&s->cursor.i_orphan);
+	mutex_unlock(&sbi->s_orphan_lock);
+
+	return seq_release_private(inode, file);
+}
+
+const struct proc_ops ext4_orphan_proc_ops = {
+	.proc_open      = ext4_seq_orphan_open,
+	.proc_read      = seq_read,
+	.proc_release   = ext4_seq_orphan_release,
+};
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..b40a934e30c9 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -639,6 +639,8 @@ int ext4_register_sysfs(struct super_block *sb)
 				ext4_seq_mb_stats_show, sb);
 		proc_create_seq_data("mb_structs_summary", 0444, sbi->s_proc,
 				&ext4_mb_seq_structs_summary_ops, sb);
+		proc_create_data("orphan_list", 0400, sbi->s_proc,
+				 &ext4_orphan_proc_ops, sb);
 	}
 	return 0;
 }
-- 
2.34.1

