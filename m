Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0753C3A9;
	Tue, 22 Sep 2026 11:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075732; cv=none; b=JX3ViCV846JOqwUPXI5A4J9PLSx4oRZNpatks1ZmJsvrkzqavrqpjBf2CYLzbchIjmPlWEl9WpGzujcP9QeNGj1lL6uwqnon2NaHFGR6My9aXuG/DBq5V0a6np8nOrnkGurPWzwqYVWr111e5ulAO6ixfue+EVHijOUEUc/Wc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075732; c=relaxed/simple;
	bh=G9dil8fSoJaxMTnGQpG/LZRDRpkJuMKVQjJOM0FqmUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdV+e9vwsOIz6C5oAQy3K6qrJI8g1BmzaICRCbY/eNvo6QXLiUqHtr51pO+bO21QzVlRYTSwaL1TJ6vQUj+Vj7jZCoInlbjRFXwFje/q2L+KoA/JdoGntTY4bYMRnmcSMeE99cJxz8MBuPAmbVM582mao7QqCDnEWkJGSzDSOXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hpyDY0MKVzKHNKY;
	Tue, 22 Sep 2026 19:14:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 28C2240AC0;
	Tue, 22 Sep 2026 19:15:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xik4Y7JqtosFBQ--.39851S7;
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
Subject: [PATCH v4 3/4] mm/truncate: fix data loss when splitting straddling large folios fails
Date: Tue, 22 Sep 2026 19:07:02 +0800
Message-ID: <20260922110703.468389-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3xik4Y7JqtosFBQ--.39851S7
X-Coremail-Antispam: 1UD129KBjvJXoW3KrWkCF17Ww1kGr4ktFW5Jrb_yoWkArWUpa
	yUK3sxtrZ5Ww42krnrZa1UXw45tas3XFWUAFWxGwnxCan0qw17KF1UK3WUKFW7Jr97Zryr
	XF1jyay7WF1UJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnI
	WIevJa73UjIFyTuYvjTRM6wCDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

truncate_inode_partial_folio() splits a large folio so that the caller's
truncate loop can drop the in-range sub-folios while keeping the
out-of-range tail. The first split at the punch start edge is
non-uniform, which leaves the sub-folio at the truncation end edge as
large as possible, this means it may still straddle the range, holding
both zeroed in-range and valid out-of-range data. The function then
attempts a second split at offset + length to isolate that tail.

If the second split fails the straddling sub-folio stays merged. The
function returned true unconditionally on all exit paths of the success
block, telling the caller it was fully handled. The caller kept its
default end and the truncate loop truncated every sub-folio below it,
including the merged straddler, discarding the valid out-of-range tail.

For example, a 4-page order-2 folio punched from offset 0 to the middle
of the last page:

  truncate_inode_pages_range()
    truncate_inode_partial_folio()      # same_folio == true
      1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
      folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
      2nd split of folio2 fails / cannot lock
      return true                       # BUG: caller keeps default end
    end = 3
    loop truncates p0, p1, p2-3        # p3's valid tail is lost

This became reachable after commit 7460b470a131 ("mm/truncate: use
folio_split() in truncate operation") replaced the atomic split_folio()
with folio_split(), whose non-uniform split can partially split a folio
and leave the end edge merged.

It has gone unnoticed because a dirty large folio normally carries the
filesystem's private data, for example buffer_head, so
filemap_release_folio() fails on a dirty folio and folio_split() aborts
with -EBUSY before any split, leaving the straddler safely unsplit. The
bug is only reachable on paths that produce dirty large folios without
filesystem private data, and it was caught on the upcoming ext4 iomap
buffered I/O path when no ifs is attached.

Rework the contract so the caller is told the folio range to discard:

  - Add pgoff_t *pstart and *pend out-parameters that receive the folio
    range fully covered by [lstart, lend] after any split (or none),
    aligned inwards to min_order, i.e. the folios wholly within the
    range and safe to discard.

  - Report a reliable end position to the caller. The straddler is
    looked up at an index aligned inwards to the mapping minimum folio
    order, and *pend is set to that boundary on success. If nothing
    covers the boundary, discarding up to it stays safe. If the
    straddler is locked by someone else, fall back to folio->index.
    This best-effort fallback may leave the in-range sub-folios to a
    later pass but never discards the out-of-range tail. If the
    straddler cannot be split, fall back to folio2->index so the caller
    keeps the out-of-range tail.

  - Rename the byte-range parameters start/end to lstart/lend to better
    express their semantics.

Callers in truncate_inode_pages_range() and shmem_undo_range() pass
&pstart for the folio at the start edge and &pend for the folio at the
end edge, so the truncate loop drops exactly the fully covered pages and
never touches a straddling folio that still holds valid out-of-range
data.

Suggested-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/internal.h |  4 +--
 mm/shmem.c    | 13 +++-----
 mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
 3 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..3278a5e360e3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -624,8 +624,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
-		loff_t end);
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..30e7df7d7309 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1176,11 +1176,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	if (folio) {
 		same_folio = lend < folio_next_pos(folio);
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
+		truncate_inode_partial_folio(folio, lstart, lend, &start,
+					     same_folio ? &end : NULL);
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -1190,8 +1187,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
 	if (folio) {
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend))
-			end = folio->index;
+		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
@@ -1259,7 +1255,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
-				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+				} else if (truncate_inode_partial_folio(folio,
+						lstart, lend, NULL, NULL)) {
 					/*
 					 * If we split a page, reset the loop so
 					 * that we pick up the new sub pages.
diff --git a/mm/truncate.c b/mm/truncate.c
index a8a179b38252..81fb4de6226b 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -206,30 +206,43 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
- * folio that's within the [start, end] range, and then split the folio if
+ * folio that's within the [lstart, lend] range, and then split the folio if
  * it's large.  split_page_range() will discard pages which now lie beyond
  * i_size, and we rely on the caller to discard pages which lie within a
  * newly created hole.
  *
+ * When @pstart and/or @pend are non-NULL they receive the indexes of the
+ * folio range fully covered by [lstart, lend] after any split (or none),
+ * aligned inwards to min_order, i.e. the range of folios wholly within
+ * [lstart, lend] and so safe to discard.
+ *
  * Returns false if splitting failed so the caller can avoid
  * discarding the entire folio which is stubbornly unsplit.
  */
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
 {
 	loff_t pos = folio_pos(folio);
 	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned long min_nrbytes;
 	unsigned int min_order;
 
-	if (pos < start)
-		offset = start - pos;
+	if (pos < lstart)
+		offset = lstart - pos;
 	else
 		offset = 0;
-	if (pos + size <= (u64)end)
+	if (pos + size <= (u64)lend)
 		length = size - offset;
 	else
-		length = end + 1 - pos - offset;
+		length = lend + 1 - pos - offset;
+
+	if (pstart)
+		*pstart = offset ? folio_next_index(folio) : folio->index;
+	if (pend)
+		*pend = (pos + size > (u64)lend) ? folio->index :
+						   folio_next_index(folio);
 
 	folio_wait_writeback(folio);
 	if (length == size) {
@@ -251,6 +264,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		return true;
 
 	min_order = mapping_min_folio_order(folio->mapping);
+	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
@@ -259,34 +273,57 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
-		pgoff_t end_idx;
+		pgoff_t end, aligned_end = round_down(pos + offset + length,
+						min_nrbytes) >> PAGE_SHIFT;
 
+		if (pstart)
+			*pstart = round_up(pos + offset,
+					   min_nrbytes) >> PAGE_SHIFT;
+
+		end = aligned_end;
 		if (offset + length == size)
-			goto no_split;
+			goto out;
 
 		/*
 		 * After the first split at the start edge, the folio at the
 		 * end edge may be freed and reused concurrently.
-		 * __filemap_get_folio() looks up the straddler at end_idx
+		 * __filemap_get_folio() looks up the straddler at aligned_end
 		 * and returns it locked and ref'd with the mapping
 		 * validated.
 		 */
-		end_idx = (pos + offset + length) >> PAGE_SHIFT;
-		folio2 = __filemap_get_folio(folio->mapping, end_idx,
+		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
 					     FGP_LOCK | FGP_NOWAIT, 0);
-		if (IS_ERR(folio2))
-			goto no_split;
-
-		/* make sure folio2 is large */
-		if (!folio_test_large(folio2))
+		if (IS_ERR(folio2)) {
+			/*
+			 * No sub-folio straddles the boundary when
+			 * aligned_end is empty, so discarding up to it is
+			 * safe.  Otherwise the straddler is locked by
+			 * someone else and we cannot obtain a reliable end
+			 * position, so we fall back to folio->index, which
+			 * is safe but leaves the sub-folios split off at
+			 * the offset edge in the page cache.
+			 */
+			if (PTR_ERR(folio2) != -ENOENT)
+				end = folio->index;
 			goto out;
+		}
 
-		split_at2 = folio_page(folio2, (end_idx - folio2->index));
-		folio_split_or_unmap(folio2, split_at2, min_order);
-out:
+		/* Already at the minimum order, nothing to split */
+		if (folio_order(folio2) == min_order)
+			goto out_put;
+
+		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
+
+		/* Split failed, keep the straddler intact */
+		if (folio_split_or_unmap(folio2, split_at2, min_order))
+			end = folio2->index;
+
+out_put:
 		folio_unlock(folio2);
 		folio_put(folio2);
-no_split:
+out:
+		if (pend)
+			*pend = end;
 		return true;
 	}
 	if (folio_test_dirty(folio))
@@ -421,11 +458,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
 	if (!IS_ERR(folio)) {
 		same_folio = lend < folio_next_pos(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
+		truncate_inode_partial_folio(folio, lstart, lend, &start,
+					     same_folio ? &end : NULL);
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -435,8 +469,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
 						FGP_LOCK, 0);
 		if (!IS_ERR(folio)) {
-			if (!truncate_inode_partial_folio(folio, lstart, lend))
-				end = folio->index;
+			truncate_inode_partial_folio(folio, lstart, lend,
+						     NULL, &end);
 			folio_unlock(folio);
 			folio_put(folio);
 		}
-- 
2.52.0

