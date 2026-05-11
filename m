Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1FF374E6D;
	Mon, 11 May 2026 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484510; cv=none; b=IA6SONadqljyKvP9bymcQDO+NQXjxKpNMmXkykvSdCPSHuGs9HszMT3LLD6swKGqcLk/rikbzJUiVyqrNoxlTld7L8Xsn8ZDTYEPGG0VOXl0pHlNtxavCRJwPPfV9wMNSzJdPQeoMqtcxlxMRAW5necZROtnQ+qzifEQ7mIBOHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484510; c=relaxed/simple;
	bh=ZRjlGGFpGhbKsDKUIY6Uh38fsaCuluqJZzDsQ6eYbI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYjv3JXJXDM+POXHGePsKYSWeBweg6Ipk2PdfNsZI4kmpaabbVbZb2FFzMfKKm6sQGmEiRfSazm2USg6KBeGLoMdDPam//fFC3lCo10qLwYxXBJq0koBug+OvH2mj8MUDmmqEqC5SUmAo8hsOFopoED4yL0WQImSBHubgzeBJww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX50gQ9zKHMf8;
	Mon, 11 May 2026 15:27:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9A3DC40578;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S17;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
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
Subject: [PATCH v4 13/23] iomap: fix incorrect did_zero setting in iomap_zero_iter()
Date: Mon, 11 May 2026 15:23:33 +0800
Message-ID: <20260511072344.191271-14-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S17
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1UJr4fuw1kXF18uw4kZwb_yoW8tr48p3
	9xKayDCFn2qrW7WFn5JF9Ivr1Yywn5JrW7Wr4UGwn8ZF4qvr4akF1FgayYvF1xJ34fA3Wa
	yF4jyas2qF1UCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The did_zero output parameter was unconditionally set after the loop,
which is incorrect. It should only be set when the zeroing operation
actually completes, not when IOMAP_F_STALE is set or when
IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
or when iomap_iter_advance() returns an error.

This causes did_zero to be incorrectly set when zeroing a clean
unwritten extent because the loop exits early without actually zeroing
any data.

Fix it by using a local variable to track whether any folio was actually
zeroed, and only set did_zero after the loop if zeroing happened.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
This is cherry picked form:
 https://lore.kernel.org/linux-fsdevel/20260310082250.3535486-1-yi.zhang@huaweicloud.com/
No changes.

 fs/iomap/buffered-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 876c2f507f58..27ab33edbdee 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1542,6 +1542,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		const struct iomap_write_ops *write_ops)
 {
 	u64 bytes = iomap_length(iter);
+	bool zeroed = false;
 	int status;
 
 	do {
@@ -1560,6 +1561,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		/* a NULL folio means we're done with a folio batch */
 		if (!folio) {
 			status = iomap_iter_advance_full(iter);
+			if (status)
+				return status;
 			break;
 		}
 
@@ -1570,6 +1573,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 				bytes);
 
 		folio_zero_range(folio, offset, bytes);
+		zeroed = true;
 		folio_mark_accessed(folio);
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
@@ -1579,10 +1583,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		status = iomap_iter_advance(iter, bytes);
 		if (status)
-			break;
+			return status;
 	} while ((bytes = iomap_length(iter)) > 0);
 
-	if (did_zero)
+	if (did_zero && zeroed)
 		*did_zero = true;
 	return status;
 }
-- 
2.52.0

