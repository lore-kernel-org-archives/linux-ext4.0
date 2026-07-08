Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB7365A17;
	Wed,  8 Jul 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492132; cv=none; b=pL1pl/mvMl5IDZZNNoXTH6gQRyYeG6HBBgC0dwd+WTVtsQW76OcFao2T5f2o6kiUkAbLJ9wTj30L7D4a6frKQJRAIe24MbtwiJQLV+LJmjCfoo3qZpb4RBR33Y9Via3P7F4QhxNprM1zdJ+/l/8MC7BQaw4SOj6BBmeIlNY8nXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492132; c=relaxed/simple;
	bh=ok885O/M8/uiW2cyJr3n6s724fVMYl25AWFp/A+Nx3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPyv1n1JVDDG2VderJdRc2oBT/l/KtD+axhX2znyRdAPfJl3emfoa4BWZRK2mNIb4Y1pWy0SbhICjBrZqMC/M6beDNY/EZ1/aJLVbRz33Lmkup3zp8pEKVFSPvCoZRtAIQzBPsTOvhy4Bt69nez29U3YSeiGchw2CLM0pZFrRy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gw7TQ2Dt5zYQtl2;
	Wed,  8 Jul 2026 14:28:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DE12D40572;
	Wed,  8 Jul 2026 14:28:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S6;
	Wed, 08 Jul 2026 14:28:46 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 2/9] ext4: skip tail block zeroing for inline data files
Date: Wed,  8 Jul 2026 14:20:42 +0800
Message-ID: <20260708062049.1982410-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S6
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUWw1rCryruFyktw17GFg_yoW8JFW7p3
	W5G34DWrZ5u34q9a9aqr17Ww1Yq3WfWr45JFWa9w18Zay5Gr1IgFnI9a45XF4jvrW3Z3yS
	qF45Xry3Cw17ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUADGOUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_block_zero_eof() is called from ext4_write_checks() on every
append write beyond EOF. For inline data files, ext4_get_block()
returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
However, this error is currently ignored because the return value
of ext4_get_block() in ext4_load_tail_bh() is discarded.

Before we fix ext4_load_tail_bh() to properly propagate the error,
skip the zeroing for inline data inodes to avoid unnecessary
failures or confusion.

Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7b2face041ef..a3f7c71b701d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4218,6 +4218,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	offset = from & (blocksize - 1);
 	if (!offset || from >= end)
 		return 0;
+	/* Inline data has no tail block to zero. */
+	if (ext4_has_inline_data(inode))
+		return 0;
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
-- 
2.52.0

