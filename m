Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BBB3F65FC;
	Tue, 14 Jul 2026 08:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016559; cv=none; b=cbErVJN1RyzKYeM85yWDiivnXN2f3wFb9A34cuCa6IEW+uzriqhba1ac2akNTKYWhBMochu4X7Yv9KKbWej3Zdd770atjqswyQ1zvE3mHsquZawFzg/Q92PrSM2queGWLH4Ro4g1A7kv6vSTeB7KnA2KRF+3h0ZlaPU19SL9jhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016559; c=relaxed/simple;
	bh=gi0hgWFkKIc5QLNT/ucok7g/HdEgmfTQbnGEoSB45/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZJ6tT69hfXV564FgQtHsDwVsVSYfDTeKQ2sJt6lWzSFYnV0FMpfWTBhzQXD3he7cH0V4NidrN7ZwJFVIgEy2dYeHpfLkAkymy3QIuH1oE/rBpceZ7xVsp8Q8eyemfJZza4O5cbt3GpAPe88BUfFlcIRGlmA5IdbH3LE+lCHghQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzsQ960c1zYQtm6;
	Tue, 14 Jul 2026 16:08:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C7B4C40590;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S12;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
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
Subject: [PATCH v4 8/9] ext4: write back partial-zeroed edges in WRITE_ZEROES
Date: Tue, 14 Jul 2026 16:00:43 +0800
Message-ID: <20260714080044.4038124-9-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4kury7GrWkKw18WrWxJFb_yoW8AF48pa
	y3Gr1UKrWUW3y7u393CF1093Wqk3Z3GrW7CrW3Gw4jvay5Xr15KFyjgF1jgF10gFWrC3y8
	ZFsxK345Kr43Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
	6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4U
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

FALLOC_FL_WRITE_ZEROES requires that all blocks in the requested range
end up as written extents with zeroed content. For unaligned edges that
were partial-zeroed in dirty unwritten or delalloc state, the buffer
is left dirty while the underlying extent may not yet be converted to
written. As a result, a subsequent SYNC write to this range would still
trigger metadata changes, which violates the semantics of WRITE_ZEROES.

Fix this by calling filemap_write_and_wait_range() for partial-zeroed
edges to flush out the zeroed data and ensure the extent conversion
is complete.

Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c34505765521..c083703bf704 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4791,7 +4791,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
+	/*
+	 * In FALLOC_FL_WRITE_ZEROES mode, edges that have been partially
+	 * zeroed must be written back to ensure the entire zeroed range
+	 * is converted to the written state. In SYNC mode, writeback is
+	 * also required to persist the zeroed data to disk.
+	 */
+	if (partial_zeroed &&
+	    ((mode & FALLOC_FL_WRITE_ZEROES) ||
+	     (file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);
 		if (ret)
-- 
2.52.0

