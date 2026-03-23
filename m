Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F98C1F
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246152; cv=none; b=oLivVpwymcyF8FIYST7uwwAu0dCFeleY0kyFcGP/pbbg5nIIwvCjQdag8ue4j2vilhjBRNj/xRxXKZo1d7ot3De167XbXH5dhZ1vXBIX4mAVSeR0MYm4SvolrsNwZORs+ZX/fuMU37BSPsJwfhglEtnxHsu6QD5I32EZOovOnMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246152; c=relaxed/simple;
	bh=d69E3+lACx7NXqezL3EdQXp5qEvTFHlbA5XwGUKR0cY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y0xnEOuDWgc2c1T/gMUio28gEva96ND3T6aWZSbYMbY8mvDlSHWuQYDjZue4Bu8m5LFehgu78xv8k5rgGD80836rH5VECv3gsUaD1/Rji8IszMhjmmoqeSt06swmyi1Bi0Q++wuP+rIMd9pQycDHwlXtZm8EEXOUcoKmhNyAV6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oO5q5UYk; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oO5q5UYk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774246141; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9/L0hJ3W8kLPT3LkwKi7bqT3pDq0KcicVHWNFnrV6p8=;
	b=oO5q5UYkbHjFkZcdPByYNsGIlptSsKJY8qeY5uUWDtaKHNpEqe557XzhlEao0BRKyZ0tzv3wpkzKwQ5KvgVZukUx9nDmIQlTLMoivW3gfjBYcy7RwHQlyTgsu27gMrmzD3B5Y8OT3APEcLqu+Ys/1nIm7GgqOnFrrXN9h28woq0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X.TkNe3_1774246123;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.TkNe3_1774246123 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Mar 2026 14:09:00 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
Date: Mon, 23 Mar 2026 14:08:36 +0800
Message-ID: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During code review, Joseph found that ext4_fc_replay_inode() calls
ext4_get_fc_inode_loc() to get the inode location, which holds a
reference to iloc.bh that must be released via brelse().

However, several error paths jump to the 'out' label without
releasing iloc.bh:

 - ext4_handle_dirty_metadata() failure
 - sync_dirty_buffer() failure
 - ext4_mark_inode_used() failure
 - ext4_iget() failure

Fix this by introducing an 'out_brelse' label placed just before
the existing 'out' label to ensure iloc.bh is always released.

Additionally, make ext4_fc_replay_inode() propagate errors
properly instead of always returning 0.

Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/fast_commit.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index f575751f1cae..f1df5581fa96 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1613,19 +1613,21 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	/* Immediately update the inode on disk. */
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = sync_dirty_buffer(iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = ext4_mark_inode_used(sb, ino);
 	if (ret)
-		goto out;
+		goto out_brelse;
 
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		ext4_debug("Inode not found.");
-		return -EFSCORRUPTED;
+		inode = NULL;
+		ret = -EFSCORRUPTED;
+		goto out_brelse;
 	}
 
 	/*
@@ -1642,13 +1644,14 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	ext4_inode_csum_set(inode, ext4_raw_inode(&iloc), EXT4_I(inode));
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	sync_dirty_buffer(iloc.bh);
+out_brelse:
 	brelse(iloc.bh);
 out:
 	iput(inode);
 	if (!ret)
 		blkdev_issue_flush(sb->s_bdev);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.43.7

