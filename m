Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015961;
	b=asM2CeUi/p8yYC4nHYAEAg53qnsTjB5BmJmX3NIZDquOWV8Dzd8PPvJrE7Gv0rQ4fN8w
	 5ccLeff0/ix66JWkbVYb3T9S9KG/iTcLBiYpBg95LwJTBGirjG6Mr6etxu6dxLLiBXsWE
	 zz7eRyXEin7KMpj4r+gXkvjLlFjF3X60bYZQJ5NAQeuzKdWHdiwJM+Fe5tEb90Ud3m4+F
	 Q1X/WFUynn1vruywMntpP+X1Hfb4M49s6Dd/v7J9R3iYZQAhocqXBw1idgV/3bnX8xRN3
	 5ERJLbIOULVDhKypAK5IyToumBYd5E27bQcHYKi14j5e0rh8wmFCOGnKx0TS8W3S5sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015961;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=Hemt9fONtl1n/BBCK7ytd9811xsib8uR0HnHueKsao4=;
	b=X4ztyWEAcrvDx5TBvgkfcNPqAUdpatP0oZEPsHnY8NZggzNnrnAhxSu1Goei4Jg4WDfl
	 moxT4GIy2LDvfZLkr0u2so27VRa0xz2KvMJyq52au3xzNVYcr0PRkk62ybsUN7CUUrrC8
	 WGEL3JzdjhNXmpWPTYk12Tytqx0UEzcDrmywg0OKQSvjgev3JNKRU+MrT51a7L5gUMbkQ
	 n60FbKP+5tRdaLisbYy7FDl0thcjvwSc5xBMLBAtTn/Rhh1LYQLDl+9UHO+VsBd8fSBZz
	 RcEGaDOFJ6gnd716AsU4dwcBSvCI5u9fiyRj3tj7UZyEPmfaol6IlD/HX9iSpMuZ98Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E990A606A31A;
	Mon, 26 Oct 2026 11:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E990A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jCsbs2ng4z1rrfR;
	Mon, 26 Oct 2026 19:59:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 39B0040574;
	Mon, 26 Oct 2026 19:59:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvWLQN9q6RyfBw--.40032S8;
	Mon, 26 Oct 2026 19:59:16 +0800 (CST)
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
Subject: [PATCH 4/4] ext4: initialize map->m_pblk in ext4_da_map_blocks()
Date: Mon, 26 Oct 2026 19:51:31 +0800
Message-ID: <20261026115131.1735014-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvWLQN9q6RyfBw--.40032S8
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW3tw45GFyDXrWDKrW5Awb_yoW8Gw1fpF
	yakF95GwsrW34j9a1fXr17JF1093WDG3y2vrWSk3WY9398GF1IqF129F43ZFW5trWxXF9Y
	qF45CryUuay0krDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_da_map_blocks() returns a delalloc mapping through @map without
touching map->m_pblk at all. Callers that only set up m_lblk and m_len
of their local struct ext4_map_blocks and leave the rest to the mapping
helper, like ext4_iomap_map_blocks() does, end up with whatever happened
to be on their stack, so the trace_ext4_iomap_buffered_write_begin()
tracepoint prints an uninitialized pblk for a delalloc mapping.

This has been harmless so far, ext4_da_get_block_prep() and
ext4_set_iomap() both ignore m_pblk for a delalloc mapping, only the new
tracepoint dumps it.

Initialize m_pblk along with m_flags at the beginning of
ext4_da_map_blocks(), so that a delalloc mapping is always reported with
pblk 0, the same way ext4_map_blocks() reports it.

Fixes: 008f019ab559 ("ext4: add block mapping tracepoints for iomap buffered I/O path")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6b2f1b07f41e6..c1c46e86bba3e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2041,6 +2041,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 #endif
 
 	map->m_flags = 0;
+	map->m_pblk = 0;
 	ext_debug(inode, "max_blocks %u, logical block %lu\n", map->m_len,
 		  (unsigned long) map->m_lblk);
 
-- 
2.52.0

