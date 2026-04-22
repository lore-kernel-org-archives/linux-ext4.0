Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE9C34FF74;
	Wed, 22 Apr 2026 02:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824225; cv=none; b=YxqCN2cgFmXZ06RyWuvBEWqLFom2FiGACcSydY01Y2kKSfZoZ1kduveS5U1n1/O64PjN0xjtkoaiJuMkbUVEAUcygm9ho5PVe5s3VF2W+llkrwMKzrF9jWHSUhTf5gUFoF//ob5h5kMbKFNGvOq6KvNqbuLzRZieygT8LmOm4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824225; c=relaxed/simple;
	bh=TR3wXiUMaCqs+/Baqxnmc8l4eBzCYOhR1cr0EWSBFS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR+Peeq1IwG1YKc4rHxUztkSssUvrOxI/dvuYWEAN3S644iczifHRg80nihO0dzB1CbqhsoESNQCyir3GlqsSKX1JnNr1uKTQJ/B4XLliV8ZbD444k1mpZRSyceLowgHZELWpG4jyPKXc6maopSvKxDg5/FoWWUU1L9wRvXWIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX50jh6zKHMTL;
	Wed, 22 Apr 2026 10:16:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 25618405D5;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S20;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 16/22] ext4: disable online defrag when inode using iomap buffered I/O path
Date: Wed, 22 Apr 2026 10:10:36 +0800
Message-ID: <20260422021042.4157510-17-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S20
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw47Gw4Uur15Ary8Jr4xJFb_yoWktwc_ta
	97Jry8Ww1YyFsa9398Jas8KrnYkF48GFn5WFZ5Gr18uw1UZ395Gr1vkry2vr98Wr1jqrZ8
	CFn7Jr1rKry2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Online defragmentation does not currently support inodes using the
iomap buffered I/O path, as it still relies on buffer_head for the
management of sub-folio blocks and on the data=ordered mode for data
consistency.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/move_extent.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 3329b7ad5dbd..f707a1096544 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -476,6 +476,17 @@ static int mext_check_validity(struct inode *orig_inode,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * TODO: support online defrag for inodes that using the buffered
+	 * I/O iomap path.
+	 */
+	if (ext4_inode_buffered_iomap(orig_inode) ||
+	    ext4_inode_buffered_iomap(donor_inode)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Online defrag not supported for inode with iomap buffered IO path");
+		return -EOPNOTSUPP;
+	}
+
 	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
 		ext4_debug("ext4 move extent: suid or sgid is set to donor file [ino:orig %llu, donor %llu]\n",
 			   orig_inode->i_ino, donor_inode->i_ino);
-- 
2.52.0

