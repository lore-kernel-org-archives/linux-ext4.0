Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A02379EE7;
	Tue, 13 Oct 2026 08:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879854; cv=none; b=h2Hdj+7r8NLlcO3OSanBnl1OPWePKABfCZpMKzaPOvrnf4JRPeZgVKXxpXviqspH/bkjq9s2wyG8Ytw1MfCD+aR7/KiPltWG3vJldVwdrk+MiYw4ApPFoAUHD5jYTvuhn/db8U/1HFWRInsVupL4chSoYM8eL2zd4rAb6UtBVdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879854; c=relaxed/simple;
	bh=qEMEBMaKvoK/+Jb6E36XWo/yjSbgRICGwA/YmjzAdfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gu7ufCR5KMT5V9a5FMaEE6fLXhITLYup6nPH+o9/c4xhC55cng9vgQXrNELt0nAUvQ09JdsIQvQ/xYz+4x3DEtaIQn8jGrhwrBlk6b/ZL6qHn9I8di5BNsOYB2Ju6GW8maalPmE5WH5FOCFiwvbnqLYcpG5chN3tOEcKXSIOMw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=aIXd4sak; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="aIXd4sak"
Received: from localhost (gy-adaptive-ssl-proxy-2-entmail-virt205.gy.ntes [39.144.128.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50da51905;
	Tue, 13 Oct 2026 16:24:04 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] ext4: check return value of blkdev_issue_flush() when initializing inode tables
Date: Tue, 13 Oct 2026 08:23:30 +0000
Message-Id: <20261013082331.2089623-2-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013082331.2089623-1-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1345c902f03a2kunm812feddd4afbc8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGE1DVk1KHR0eHkpPS0hKTlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpISVlXWRYaDxIVHRRZQVlPS0hVSktJQk
	NNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=aIXd4saksdJGeLLKObqKdwXvvNGXsX/fb4Nny/lTjcQ/kLVwuuvsiwnmlWWYu/LqkWd50z3rCApKiCR1CkHbaWaXYTWekS0aWy3uZvP4xl+39KEklWtIHgfW9K3xwm4AS7jlEe/TFVbNKovuIztl2ephi9J/bbmm6MyTRaPvkk8=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=nt9idrHBaE2DunDdPWUoZTj/FKw0bcs1G5U4ni1iPpE=;
	h=date:mime-version:subject:message-id:from;

When lazily zeroing an inode table, ext4_init_inode_table() issues a
cache flush to make sure the zeroed blocks have reached the disk
before setting the EXT4_BG_INODE_ZEROED flag, but the return value is
ignored.  If the cache flush fails, the inode table is still marked as
initialized, and a subsequent crash can leave the table containing
stale data from the previous use of the disk, which may then be
exposed to user space through newly allocated inodes.

Check the return value of blkdev_issue_flush() and leave
EXT4_BG_INODE_ZEROED unset if the cache flush fails, so that the inode
table zeroing is retried on the next mount.

Since a cache flush failure now aborts the lazy inode table
initialization, also pass the barrier mount option down to
ext4_init_inode_table(), consistent with the other cache flushes in
ext4 and jbd2 which are issued only when the barrier option is
enabled.  This keeps file systems mounted with nobarrier working on
devices with failing cache flushes.

Fixes: a107e5a3a473a ("Merge branch 'next' into upstream-merge")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/ialloc.c | 7 +++++--
 fs/ext4/super.c  | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a5831fc536db..9abd7fb75b02 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1610,8 +1610,11 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 	ret = sb_issue_zeroout(sb, blk, num, GFP_NOFS);
 	if (ret < 0)
 		goto err_out;
-	if (barrier)
-		blkdev_issue_flush(sb->s_bdev);
+	if (barrier) {
+		ret = blkdev_issue_flush(sb->s_bdev);
+		if (ret)
+			goto err_out;
+	}
 
 skip_zeroout:
 	ext4_lock_group(sb, group);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d636b89090a2..941af6fd050c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3793,7 +3793,8 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	if (!ret) {
 		start_time = ktime_get_ns();
 		ret = ext4_init_inode_table(sb, group,
-					    elr->lr_timeout ? 0 : 1);
+					    !elr->lr_timeout &&
+					    test_opt(sb, BARRIER));
 		trace_ext4_lazy_itable_init(sb, group);
 		if (elr->lr_timeout == 0) {
 			elr->lr_timeout = nsecs_to_jiffies((ktime_get_ns() - start_time) *
-- 
2.34.1

