Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326899;
	b=4EmxMs6MNppfwegZbX7t6ouZu2901m1iFBlcZ8zfQOzb/zcJGP3s5Sp/1mibhh8uhwE7
	 xaUkimUdG7C6aDTl3/gGihvD4B03KlNIPBeW+V0U997zf8C9DIrmpHI3lCIq3HmHqlTW0
	 jzVh5bZ9uNpOu/KBF+CehcSEUaJF75FGiSZyK9yxwzV84Qquwg/afkYObpg24fdAg1NyQ
	 P+Xhf439elhwDHguhaX4PrnfGlHlWAr93hYe35559fDzXRtNPghhV9BDwWB2bOY0Nctee
	 YKz7E8QbZG+aoVo0BjG68D2WJjgo1JKsMgtJ7qFZJvE9gvXHGoiwSOQeIL0zZl2y2OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326899;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=Hemt9fONtl1n/BBCK7ytd9811xsib8uR0HnHueKsao4=;
	b=YLyJmrOcqe4yxdSeqCTA1PGtXVxynLzsJiS/Rc2CflkdjA6Wr2L4kXDMiXTXzgVbI8KB
	 dmwqNiYaVVGpCWEgyt7oOmMSQbE6PghhLuSUvnS05Xu+Wpru6yvjGVnBeAbDbdwTEvodU
	 bsG7L9Wgy81ZgeMRRE2io2d5aCac6Y1+wVs6IriAQnRIZAwMqOd3tQbdjVmvhfIBHI2hR
	 A5PKgMTr+wE9mfnH3oZRAD7UXmkf0A3CN2hpAQdzjQiyl4xtQOLnWs+lLKbMS9Ag9ZIco
	 Db+FJwlbFu+tIcFAtOJMdzZazfF/euYdQux1wLdJrlTtMUqdrP9PNUrjmmUIh8GzqcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA97606A31C;
	Fri, 30 Oct 2026 02:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DA97606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jG4bK475pz1yH3;
	Fri, 30 Oct 2026 10:21:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E9E4A4056F;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzewm_+NqieRyCQ--.40911S8;
	Fri, 30 Oct 2026 10:21:33 +0800 (CST)
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
Subject: [PATCH v2 4/4] ext4: initialize map->m_pblk in ext4_da_map_blocks()
Date: Fri, 30 Oct 2026 10:13:38 +0800
Message-ID: <20261030021338.1768292-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzewm_+NqieRyCQ--.40911S8
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW3tw45GFyDXrWDKrW5Awb_yoW8Gw1fpF
	yakF95GwsrW34j9a1fXr17JF1093WDG3y2vrWSk3WY9398GF1IqF129F43ZFW5trWxXF9Y
	qF45CryUuay0krDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
	6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
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

