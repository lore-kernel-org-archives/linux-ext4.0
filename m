Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F2347521
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917128; cv=none; b=Ou9PDY8wnPCj0tJVpcukmxBwR+n7Ii3uXldlUkURCtaFfZVqefhhbUhe9iA5koXUtM6p9K08M2SXCEDhR9mW1tToXUOah2LD960lX5tf31P3F1FPDCnYSd8M+Ej9SlCU7SrSK7dK+boKrLhd0O5VgYGn6HhmGPiD8uI7PT8vBrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917128; c=relaxed/simple;
	bh=AcNuI26d/l5Rdbt2AV2eINKaSRaL9pxTPDO3FtSjN4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU61uluP9+f9uCCms1QHUsdWZQc3/6F21mAJPtLdXP2YSPAaZcK8KaoUh/E3yEgJfISriFjffkzIjc2Y8W8daoYgSfsnLESb+SH0QmP2SPfTNXZUuBAs2QFg+fHRphb3zOOyKY/TQw9zu41pyG2icTwu8+Bf/LmORSyEf/UgeAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VfIG2jPE; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VfIG2jPE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780917124; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=3h+lqYs4BUZdhfngP2jwLbUrKUCLn9BF7fX1N60A4N0=;
	b=VfIG2jPE0KjKCKTfqqSnj4sLSKozHT4WjNryq7x+34Q/9NT6xkwse8GZOSvvnTEDxEffCFY8lMQqXqrM9Lb895UindPkCUu1KOzIE/7o7tvj/zqOmR8qAL+Dgd5jVPH1xbjdkrCPrjZTzNvTs9rHw4ZnyFvT7BxadEXv4iVlK6g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4Nw8SN_1780917123;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4Nw8SN_1780917123 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 19:12:03 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 3/3] ext4: reject mount if inodes per group is not a multiple of inodes per block
Date: Mon,  8 Jun 2026 19:11:50 +0800
Message-ID: <20260608111150.827117-4-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260608111150.827117-1-libaokun@linux.alibaba.com>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If s_inodes_per_group is not a multiple of s_inodes_per_block, the
division that computes s_itb_per_group truncates, reserving fewer blocks
for the inode table than needed.

On a crafted filesystem image, this allows __ext4_get_inode_loc() to
compute a block offset beyond the inode table, reading unrelated data as
an inode structure.

Add the missing divisibility check alongside the existing validation in
ext4_block_group_meta_init().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ddcb4a8d4db..5ec9e1ef00c0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5306,7 +5306,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
 	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
-	    sbi->s_inodes_per_group & 7) {
+	    sbi->s_inodes_per_group & 7 ||
+	    sbi->s_inodes_per_group % sbi->s_inodes_per_block) {
 		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
 			 sbi->s_inodes_per_group);
 		return -EINVAL;
-- 
2.43.7

