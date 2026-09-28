Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFEA1E7660;
	Mon, 28 Sep 2026 12:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597827; cv=none; b=Xx76y+GpH1M6rxHcOq8AtRbVC+P9PcoWE3jjflA12FeI9S7WHoJj7QClcLyyMpx9hvqksE88fNvour0PB64DbiP56H/y9Kgu077dttIHI3PsZPxOfiPRXwbyEltD/TIuxOf5UK+89QZVeWjPKTLjzK/G5E/loqLU0O9aSPrYdL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597827; c=relaxed/simple;
	bh=fBStmszF/xiQSK4QjJJO0TFN8tWTpmfsdPJK+StTcRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8VJAW4JPL7ym9awxxroqnEDIboGudphnUNI80stv36H0EvdbOJNp9u6AV2E/o3D3CRmV08dZc4LnGOkm4PA41B2g5bsKwBCQw0+TXMNvwc9O+7aBWG1ASrvNzdr8AqRALPKq9xVvKFp/JVsyty0uOFspTOZLuv5qytWP7egySc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4htgJp5Z7rzKHMZf;
	Mon, 28 Sep 2026 20:16:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C5CC34056D;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S8;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v5 4/4] mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Mon, 28 Sep 2026 20:08:33 +0800
Message-ID: <20260928120833.3440834-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S8
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW3CF4xuryfAry3XF15CFg_yoW5JFW5pa
	y3G3sxJ3ykWw4Ikw18uF4kZw4Yya9agFWUZFWxG3s7C3Z0qw4UKr1Ut3WUtw4rtr1kZ348
	tF1jyFW3W3W5JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNdb1DUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

With the earlier rework the callers no longer rely on the return value
of truncate_inode_partial_folio() to decide whether to adjust the
truncation range. The pstart/pend out-parameters carry that information
instead. The callers now only use the return value as a flag indicating
whether the loop should be reset to pick up newly split sub-folios on
the shmem path.

Return true if at least one split succeeded, and false otherwise.
This clarifies the existing confusing return value semantics.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9eb108769149..5b1b13cf8ff0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -216,8 +216,7 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
  * aligned inwards to min_order, i.e. the range of folios wholly within
  * [lstart, lend] and so safe to discard.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * Return %true if at least one split succeeded, %false otherwise.
  */
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
@@ -247,7 +246,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		return false;
 	}
 
 	/*
@@ -264,7 +263,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	if (folio_order(folio) == min_order)
-		return true;
+		return false;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
@@ -327,10 +326,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 			*pend = end;
 		return true;
 	}
-	if (folio_test_dirty(folio))
-		return false;
-	truncate_inode_folio(folio->mapping, folio);
-	return true;
+	if (!folio_test_dirty(folio))
+		truncate_inode_folio(folio->mapping, folio);
+	return false;
 }
 
 /*
-- 
2.52.0

