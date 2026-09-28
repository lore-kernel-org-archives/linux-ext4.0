Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5F30DEDC;
	Mon, 28 Sep 2026 12:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597828; cv=none; b=PAk1qJIsksPR3ob/d1clbuHbJPDYCclK7k0rxTRdNHPAW8D8D52e7AB7Jg3ebAQyMgrjfinqQ16fxdDWIjqMyGdmfimJO7jo10SXx8MfbmF+EY3ytS+/gDjwVLXL/ck8YoflWUw5jvkVexCEomb6O+s1VOteQhUpw9rYvv37f00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597828; c=relaxed/simple;
	bh=ljQyNuOW+f39zGJb1w1/isiCMkLWwPm1pdeJVM189d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fweFwpB1Mt1ZVCev1CtUuxfi0Qs4259sKkOfmGUoKt+9zR9rSfLUcXRHSGw7cB2u3VdR0eM6WJnCNn2dRoFL3qsAsXd8OQAbHXxVlZCHdEd+egi9d/Hoe2wDCgs0HdeoG9d9eGqt/5qpLwFQ9N8zPtCuokZZI/x2NX8LJEAOTNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4htgJz0KpszYQtwT;
	Mon, 28 Sep 2026 20:16:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 782AB40924;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S5;
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
Subject: [PATCH v5 1/4] mm/truncate: align truncation boundaries to mapping minimum folio order
Date: Mon, 28 Sep 2026 20:08:30 +0800
Message-ID: <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S5
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4Utr13Cw18Wr1rJr18Zrb_yoWruryDpF
	W7GwnxGrWkGrWxCr4kua1vyrs5XayDXa15CFyxG3sakrnYgF1qkr9Fk3W8tw4UG34xAF1F
	yF4jyFWvg3WqyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRMfOzDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

When the mapping has a non-zero minimum folio order (min_order),
folio_split() in truncate_inode_partial_folio() stops at min_order
instead of order 0, so the sub-folio containing a split point stays
aligned to 1 << min_order rather than to a single page. The original
boundaries in truncate_inode_pages_range() were based on page
granularity, so either boundary could land inside the min_order chunk at
its edge, and the truncation loop would drop that whole chunk, valid
out-of-range tail included.

For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
offset 0 to 36K:

  split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
  folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
  2nd split of folio2 -> [p8-p11, p12-p15]    # success
  end(old) = p9                               # BUG: p9 inside [p8-p11]
  loop truncates ... p8-p11               # p9-p11's valid tail is lost

It has gone unnoticed so far for two reasons. A non-zero min_order is
only used by filesystems with a block or sector size larger than the
page size, and those either always write back the affected range before
punching a hole or truncating, or they carry filesystem private data on
dirty folios (e.g. buffer_head), which makes filemap_release_folio()
fail and folio_split() abort with -EBUSY, so the folio is never split
and the old start/end boundaries remain valid. The bug only becomes
reachable on paths that truncate dirty large folios without prior
writeback and without filesystem private data, such as the upcoming ext4
iomap buffered I/O path.

Align both start (rounded up) and end (rounded down) to the mapping
minimum folio order so they always fall on a folio boundary.

Reported-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..8a28f4a21267 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate (inclusive)
  *
- * Truncate the page cache, removing the pages that are between
- * specified offsets (and zeroing out partial pages
- * if lstart or lend + 1 is not page aligned).
+ * Truncate the page cache, removing the folios that are between specified
+ * offsets (and zeroing out partial folios if lstart or lend + 1 is not
+ * folio aligned).  For mappings with a non-zero minimum folio order, the
+ * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
+ * straddling the range is kept.
  *
  * Truncate takes two passes - the first pass is nonblocking.  It will not
  * block on page locks and it will not block on writeback.  The second pass
@@ -366,6 +368,7 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, uoff_t lend)
 {
+	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
 	struct folio_batch fbatch;
@@ -379,9 +382,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		return;
 
 	/*
-	 * 'start' and 'end' always covers the range of pages to be fully
-	 * truncated. Partial pages are covered with 'partial_start' at the
-	 * start of the range and 'partial_end' at the end of the range.
+	 * 'start' and 'end' always covers the range of folios to be fully
+	 * truncated, with both boundaries aligned inwards to 1 << min_order.
 	 * Note that 'end' is exclusive while 'lend' is inclusive.
 	 */
 	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	else
 		end = (lend + 1) >> PAGE_SHIFT;
 
+	start = round_up(start, min_nrpages);
+	if (end != (pgoff_t)-1)
+		end = round_down(end, min_nrpages);
+
 	folio_batch_init(&fbatch);
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
-- 
2.52.0

