Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2193BBFAD;
	Wed,  8 Jul 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492134; cv=none; b=iMYoqmpRLfT3nfqWLxDcrBFyfF4SU7y3lRoYh9ck0KPeXCDs1l6P9avKVuvC8AoB9qJ2ObGS3KPKbz3lULLY7gFVnYe+XQRPCYXRxmEpUUTEbwkGNwFb6mWzB5A2e5QWMi12JBA/B39Ezrb7K0IWpsf4MUlrUQje25n2Dct8Lv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492134; c=relaxed/simple;
	bh=hAXIxIAejRFhCRK5bzlLeXKi/S+aiDosJlVaOoVm380=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6/NWOhkIEGIETPZvlb/yy9l5PDp1+yfQR3s3jTSv4992cReeuNZ/JnC14Okc0jNB9XeCufQm+HrUM3Ml83AEiO55xmeBu2wpj2OE3X/A2t1byKviqEa3B/GZnNIyNqN4M6mRkkW9S8w5T+FOITOtovhqL+HfhQv40XMzsNDvMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gw7T62xqMzKHMMk;
	Wed,  8 Jul 2026 14:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EE69B4056D;
	Wed,  8 Jul 2026 14:28:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S7;
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
Subject: [PATCH v3 3/9] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed,  8 Jul 2026 14:20:43 +0800
Message-ID: <20260708062049.1982410-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S7
X-Coremail-Antispam: 1UD129KBjvJXoWrury8JF48Xr4xAr4rtr43Wrg_yoW8Jr48p3
	sIgrykWr93W34q9F4Fk3W7X3W7t3WDGr4UJF4akF17ZrW5Wr1vqF4jy3WFgF47trZ3G390
	qF1UWry7A3WUCa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a3f7c71b701d..ba4fc3c93bb6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4064,7 +4064,9 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.52.0

