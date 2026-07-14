Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4053F5BC5;
	Tue, 14 Jul 2026 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016554; cv=none; b=DyA44mNzSUgRxr0jDesTtJ38Q/WPK1xCVd424hca+7FqO7vyVOjQ+ycyxSjtCp8BGuB8py0Cd/DF9SVbvkc6YSPY9cc8d1sWHfnJocE6TXmq6lEB9KQiljgcCseP3qW7J/F0wEsz1Kw6xjrH2ttOf07QPXaaK/BcTrcxQ/BuGh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016554; c=relaxed/simple;
	bh=rTqNLMkj5qVxE9AC6BeTJP5Ra6PABzocZjpFwn8p8kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhuCEzXDxZpgOXTrQkcWHYZ+YlzoGaN9QEGXZ9GZUMvUzYs90SMaxned8NGxW+YcRL8DcFPpLrB6slO6qIvXeOtmCaZyJZsXT0mTu9Jym43pXwCLF3Y7mEOc+FH2191RvF99G1mm7eEcULaNPZGqumOQQ67LyJG9mt55yzFE/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzsPs5jdhzKHMNd;
	Tue, 14 Jul 2026 16:08:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2860540766;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S5;
	Tue, 14 Jul 2026 16:09:03 +0800 (CST)
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
Subject: [PATCH v4 1/9] ext4: use FGP_WRITEBEGIN for tail block zeroing
Date: Tue, 14 Jul 2026 16:00:36 +0800
Message-ID: <20260714080044.4038124-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S5
X-Coremail-Antispam: 1UD129KBjvdXoWrur4DWw4fAryUKrW3ZF4xWFg_yoWDurb_Ja
	4vqw48Ww45Xwn3uFsYya9Iqr1vvFyrKr4fCF48JFn3WryFvan5GrnYyFyrtFW7Wr4jgrZ8
	ur1xXrWftF17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbkxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
	x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUjrHUDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_load_tail_bh() returns a locked folio that callers immediately
mutate through folio_zero_range() and mark_buffer_dirty().  Use
FGP_WRITEBEGIN so that, on backing devices that require stable writes,
__filemap_get_folio() waits for writeback to finish before returning
the folio; on regular devices the wait is a no-op.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..7b2face041ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4037,7 +4037,7 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 	int err = 0;
 
 	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
-				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				    FGP_WRITEBEGIN | FGP_ACCESSED,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
 		return ERR_CAST(folio);
-- 
2.52.0

