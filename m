Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD53DA7CE;
	Fri, 27 Mar 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607683; cv=none; b=WrpgtoGIOuuDcrPGLhxAZo35ex+SgAnWYIyANVo30zV2KvWu1SIWhZUmSf4BngloX5BBJX/SeGAYQz9as/uZz8WFOOPTGShnlCKiblnmeJ/AnykhPxTTTHRuyYpo0J5T4zLZh6jmbyWSAA88BZtvPT44KyuxBL4kvUSLYin+2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607683; c=relaxed/simple;
	bh=SJjes3iGDrA6L1XeuCKnKGzpfXUkDoov3mS2gTY12Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPdITwTA/PGRKKFqX1G8zTi1K0g30Ub/BW0GPaa1Qu55UlA+JExSuphzkHjBNAnj4snFiMPsEE54EWwx73jAgE79aUrsEEgD90V0cxh73pLE1VW8MstfVgHaZ4ERGp7bFsn0kThYNSaw69uSnHRGUY+ZgGeD6SFxz0oQ0mg5Of8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhxpM1FY4zYQv70;
	Fri, 27 Mar 2026 18:34:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id BF9224058D;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S14;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 10/13] ext4: unify SYNC mode checks in fallocate paths
Date: Fri, 27 Mar 2026 18:29:36 +0800
Message-ID: <20260327102939.1095257-11-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S14
X-Coremail-Antispam: 1UD129KBjvJXoW7uF17Ary5CF1xJrWDuw1kGrg_yoW8KF1kp3
	yrGa48Kr10gFyjgrsagF4UZF12y3WkK3y8WrWkC34Fqa9Iqr1Fga4rt3WFkF47X3yruF4U
	XFWUK34UGa17C37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In the ext4 fallocate call chain, SYNC mode handling is inconsistent:
some places check the inode state, while others check the open file
descriptor state. Unify these checks by evaluating both conditions
to ensure consistent behavior across all fallocate operations.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 9 +++++----
 fs/ext4/inode.c   | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 16386f499138..f4009544f762 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4753,7 +4753,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		goto out_handle;
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
-	if (file->f_flags & O_SYNC)
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
 out_handle:
@@ -4791,7 +4791,8 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
 	if (ret)
 		goto out;
 
-	if (file->f_flags & O_SYNC && EXT4_SB(inode->i_sb)->s_journal) {
+	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) &&
+	    EXT4_SB(inode->i_sb)->s_journal) {
 		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
 					EXT4_I(inode)->i_sync_tid);
 	}
@@ -5564,7 +5565,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 		goto out_handle;
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
-	if (IS_SYNC(inode))
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
 out_handle:
@@ -5688,7 +5689,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 		goto out_handle;
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
-	if (IS_SYNC(inode))
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
 out_handle:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b934ad86a96d..3b150e643ef5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4501,7 +4501,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		goto out_handle;
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
-	if (IS_SYNC(inode))
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode))
 		ext4_handle_sync(handle);
 out_handle:
 	ext4_journal_stop(handle);
-- 
2.52.0

