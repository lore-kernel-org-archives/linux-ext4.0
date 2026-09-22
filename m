Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF23B53A39A;
	Tue, 22 Sep 2026 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075725; cv=none; b=jUt3ujf0Offl5mJtPfksJ6hmQrqFz8Pu3g6DQbmo6Iprf0c46yC7czX6DiydPMSlWgQGyjcfq2P569p9Qo1edi78UQsT69+gT3kCv34nwJ1brdlZIvJDIh4n/uoPZYLi6A1aORX4JLpdbLQ53vjF7AisuLRGak6CQla6ArQvmdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075725; c=relaxed/simple;
	bh=RQQXjrlWGv8ZPWsAJeovpmU7boL0Ryw4AYbxrrW5dGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X72fKX8rcEkT96JwX1besdmXz9gFGmhIeGbpnJYTurwEEpglNihagZ6uW/V1tWpbZQdc93GMIL+czlMuwkegdx8zKXE/69CDPkBvKSvI+9NK2cpLtaER+w7ETR3q9DT0KO/t7oYGHTr9Hlvk83MBS98qJx2GRGt1lQt49jhIQJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hpyDj6yKszYQvj1;
	Tue, 22 Sep 2026 19:15:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 10A6440ACB;
	Tue, 22 Sep 2026 19:15:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xik4Y7JqtosFBQ--.39851S6;
	Tue, 22 Sep 2026 19:15:16 +0800 (CST)
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
Subject: [PATCH v4 2/4] mm/truncate: look up the end-edge straddler by index
Date: Tue, 22 Sep 2026 19:07:01 +0800
Message-ID: <20260922110703.468389-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3xik4Y7JqtosFBQ--.39851S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW7XrWkGF1UJry5Xr4xZwb_yoW5tFW5pr
	WYgrn5GrWkWr1Ikwsrua1jyrn8Ca4rXayUCFyxGw17AFn0q3WDKryjga48W3y7tw1kA348
	XrWjqFyY9Fy5Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRipB-tUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In truncate_inode_partial_folio(), after the first split at the start
edge, folio_split() unlocks and drops the refcount of the after-split
sub-folios. The sub-folio straddling the end of the truncation range is
therefore unlocked and only transiently ref'd in the page cache while
the code still derives it from a page pointer inside the original folio.

Between the first split finishing and page_folio() resolving split_at2,
that tail page can be reclaimed, freed and reallocated as a new large
folio in the same mapping at a different file offset. folio2 then points
at a folio that does not cover the end boundary, yet
folio2->mapping == folio->mapping still holds, so the stale pointer
passes the mapping check and folio_split_or_unmap() splits a folio at a
wrong position (or, with a transient refcount, a use-after-free window
opens between try_get and the split). __folio_split()'s own
folio != page_folio(split_at) check cannot catch this either since
split_at2 has been reallocated as part of the new folio, so
page_folio(split_at2) resolves back to folio2.

Look the straddler up by its page index instead. __filemap_get_folio()
returns the folio currently covering the boundary, ref'd and locked,
with the mapping validated under the lock, so the split target is always
the real folio at the end edge.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index f9625bb4916f..a8a179b38252 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		pgoff_t end_idx;
 
 		if (offset + length == size)
 			goto no_split;
 
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);
-
-		if (!folio_try_get(folio2))
+		/*
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at end_idx
+		 * and returns it locked and ref'd with the mapping
+		 * validated.
+		 */
+		end_idx = (pos + offset + length) >> PAGE_SHIFT;
+		folio2 = __filemap_get_folio(folio->mapping, end_idx,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2))
 			goto no_split;
 
+		/* make sure folio2 is large */
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
-			goto out;
-
-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
-
-		folio_unlock(folio2);
+		split_at2 = folio_page(folio2, (end_idx - folio2->index));
+		folio_split_or_unmap(folio2, split_at2, min_order);
 out:
+		folio_unlock(folio2);
 		folio_put(folio2);
 no_split:
 		return true;
-- 
2.52.0

