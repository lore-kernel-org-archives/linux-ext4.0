Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA5B2F12CF
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775204852; cv=none; b=oZ7DIrAxNkeex5LUX7luJBHbsh8upGk2uRat5TeLTE/4KEWTG2ECwfHf/MubBgRyqqDho3+B19Mf2At3yK1m56NXkfOSAI5SPxeku8f0youAZ1ZizfoxwmCdluPxkgBWqE9gSR+1JnYXy8LPae1GWB8YnrqVDS5+8Jo7InxUNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775204852; c=relaxed/simple;
	bh=cs3PrjdXCZ7lXzH3HW/egMfXNvncUhNvd9xXy4zum3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DP0uLyZIJ69CcOpzoWb/zOP6owSZcxo/Mdq+bKdyqf3gEbGrSTDOKi6zws2LVeO3QKl4BVRuRQQOKmpMDs3ESXvQ4qCjPJ6Oks0llqo6dlz+/VOVCc5wPnm/8Xer4Xcl1aBkolYK99AYFZ4PFakUAZdgkC4Jp1Z4H8lqthBAx9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fnBf86vFVzYQtqT
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:26:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4DD824056D
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:27:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0roec9pD5T6DA--.40142S5;
	Fri, 03 Apr 2026 16:27:22 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH 1/3] ext4: register 'orphan_list' procfs
Date: Fri,  3 Apr 2026 16:25:05 +0800
Message-Id: <20260403082507.1882703-2-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHn0roec9pD5T6DA--.40142S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXry3Kr45XFW7Zr4DZFWfuFg_yoWrGFy5pF
	98Ar1rJa1UWasxWanxGF4UZrn3K3WxGw1Utr92934aqryaqryvqF18t3Wj9F1rJrWUGr13
	Xa1jgFyUKr4a9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
	DU0xZFpf9x07UAEfrUUUUU=
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
 fs/ext4/orphan.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/sysfs.c  |  2 ++
 3 files changed, 73 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 876597f8331d..fa38a8380fed 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3873,6 +3873,7 @@ extern void ext4_stop_mmpd(struct ext4_sb_info *sbi);
 extern const struct fsverity_operations ext4_verityops;
 
 /* orphan.c */
+extern const struct proc_ops ext4_orphan_proc_ops;
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern void ext4_orphan_cleanup(struct super_block *sb,
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..1d231aeaf282 100644
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
@@ -657,3 +659,71 @@ int ext4_orphan_file_empty(struct super_block *sb)
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
+	.proc_lseek     = seq_lseek,
+	.proc_release   = ext4_seq_orphan_release,
+};
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index b87d7bdab06a..324eb6b5900e 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -634,6 +634,8 @@ int ext4_register_sysfs(struct super_block *sb)
 				ext4_seq_mb_stats_show, sb);
 		proc_create_seq_data("mb_structs_summary", 0444, sbi->s_proc,
 				&ext4_mb_seq_structs_summary_ops, sb);
+		proc_create_data("orphan_list", 0444, sbi->s_proc,
+				 &ext4_orphan_proc_ops, sb);
 	}
 	return 0;
 }
-- 
2.34.1

