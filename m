Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F0B349B1C
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250663; cv=none; b=bTU9fs1qaBpd9dmaMFvXHQ0InNor0IAIn/qvv0+AgBjBR5qyhXLo/DBxVa8sG3fJoRh3bLueOP4FRPNgmLS3z9q7xSz2s4pUE1iyZgDpmT1Up8o4qHwsAWtYi7b6zjLVQ3vaxMdFChLTl/teffL8BlgjpSZThLJI9R7Z1kTwDmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250663; c=relaxed/simple;
	bh=NDW0yeA/LjLxjRO+vXMfLiHC8KHZdh1AELPZG5HcilQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZOvRFyD2Ah0cD3x8y1aXISPuq4lhEoSfyxKhks7jH5XwxjPALsbyhPscmYEoEb+toTaDcGEc6DmvW+kI/e3YheyRlyqygSjImuKu1WpynzEY90hPYuY+DxITpQt5YgmzC7HclhCh/U4GbnTz0DEi0qI/Q1HjzWLwfPvK9lA5lPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fwdQJ11dyzKHMYB
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id B25F340590
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0fb99pbf70AQ--.45727S6;
	Wed, 15 Apr 2026 18:57:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 2/4] ext4: skip cursor node in ext4_orphan_del()
Date: Wed, 15 Apr 2026 18:55:03 +0800
Message-Id: <20260415105505.342358-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgAHtL0fb99pbf70AQ--.45727S6
X-Coremail-Antispam: 1UD129KBjvJXoW7AFy5uw45JFWUuF4ktrW3GFg_yoW8Xw48pF
	W3GF98Ja1UGFyS9a93tFWjqFn3t3WxW3yjqFWSk340qFy3XrWDtF18K3W5ZFn5JrW8Gr1j
	gr48WFWYgF4jvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07URpBfUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This patch is prepared for displaying orphan_list information. Because
temporary nodes may be inserted when the orphan_list is traversed and
displayed, these temporary nodes need to be skipped.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/orphan.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index f7e7f77e021e..a6bffe67ef75 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -220,6 +220,23 @@ static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
 	return ret;
 }
 
+static inline bool ext4_is_cursor(struct inode *inode)
+{
+	return (inode->i_ino == 0);
+}
+
+static inline struct list_head *ext4_orphan_prev_node(
+					struct ext4_inode_info *pos,
+					struct list_head *head)
+{
+	list_for_each_entry_continue_reverse(pos, head, i_orphan) {
+		if (likely(!ext4_is_cursor(&pos->vfs_inode)))
+			return &pos->i_orphan;
+	}
+
+	return head;
+}
+
 /*
  * ext4_orphan_del() removes an unlinked or truncated inode from the list
  * of such inodes stored on disk, because it is finally being cleaned up.
@@ -253,7 +270,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	mutex_lock(&sbi->s_orphan_lock);
 	ext4_debug("remove inode %llu from orphan list\n", inode->i_ino);
 
-	prev = ei->i_orphan.prev;
+	prev = ext4_orphan_prev_node(ei, &sbi->s_orphan);
+
 	list_del_init(&ei->i_orphan);
 
 	/* If we're on an error path, we may not have a valid
-- 
2.34.1

