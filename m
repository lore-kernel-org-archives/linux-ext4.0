Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0B49DB86;
	Thu,  3 Sep 2026 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788436672; cv=none; b=pzkMviej7SqTrmLRpAsAVvaGRClVVXskzGiUWHpZHOa6kRmS+a91dtD2xMdt8rXVcSPlURNRA3HTq/v622ZP9QS4hcmO3N9eQ2IIXsdw4+qnhusUOnWVFqPho8VFWavke0Wx3D1Buv+aSl87R8kqSEh4FyPz6eKmlqRNQYXOUqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788436672; c=relaxed/simple;
	bh=Ym9cZQCQXaA1mhOA+5Wx6YDq8hSLJZXE6XlfgcEbzC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZF5v8Lh1BgRCmcHTp/iJugqcdKFTP1pAPutOwHLHXQgh8I4p3M6APF/Da0kame/pSMSnWMLXfPOJsiN1mIs1ZyoJLMz1YpopnTaDxx+YtpQYsxvpkuoRutejHN6J0XXZXB2u4Bn8uL2WiWe59OskR++iAIbqLGwkw91ayoi3tcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbJ3R6FxTzKHMZZ;
	Thu,  3 Sep 2026 19:56:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7855F4058D;
	Thu,  3 Sep 2026 19:57:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAnDgmeYJlqCapnAg--.29796S4;
	Thu, 03 Sep 2026 19:57:29 +0800 (CST)
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
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [RFC PATCH] mm/truncate: fix data loss when splitting fails in truncate_inode_partial_folio()
Date: Thu,  3 Sep 2026 19:50:18 +0800
Message-ID: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnDgmeYJlqCapnAg--.29796S4
X-Coremail-Antispam: 1UD129KBjvJXoW3ur45XFWxWFWrAr15ZF1kZrb_yoWDCry5pa
	yUK3sxJrZ5Ww4jkr17uF4UXw4Yyas3XFWUAFyxGwnxCFn0qw17KF1Ut3W8KFW3Jr97Za4F
	qF1jyFW7W3WUJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUUl1kUUUUU=
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
filemap_release_folio() -> iomap_release_folio() returns false on a
dirty folio and folio_split() aborts with -EBUSY before any split,
leaving the straddler safely unsplit. The bug is only reachable on paths
that produce dirty large folios without filesystem private data, and it
was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
attached.

Rework the contract so the caller is told where to stop instead of
silently truncating the straddler:

  - Return true only when a split occurred, false otherwise. This
    clarifies the existing confusing return value semantics.

  - Add an optional out-parameter pgoff_t *end, set to the index of the
    folio that contains @lend and must be kept by the caller's loop. It
    is only written when the folio actually straddles @lend. On the
    success path it defaults to the page index of the end edge and is
    refined to folio2->index when the second split fails to isolate the
    tail.

  - Rename the byte-range parameters start/end to lstart/lend to avoid
    clashing with the new @end output and to separate byte offsets from
    folio indices.

Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
only when the folio straddles lend. After all, no caller discards a
straddling folio anymore, the in-range cleanly-split sub-folios below it
are still dropped.

Suggested-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/internal.h |  4 ++--
 mm/shmem.c    | 12 +++++------
 mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
 3 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 68db5abd0a4c..db7d9d9fb5c9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
-		loff_t end);
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+		loff_t lend, pgoff_t *end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
diff --git a/mm/shmem.c b/mm/shmem.c
index 89a1495e55f7..cc1548ff509a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1175,11 +1175,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	if (folio) {
 		same_folio = lend < folio_next_pos(folio);
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
+		if (!truncate_inode_partial_folio(folio, lstart, lend,
+						  same_folio ? &end : NULL))
 			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -1189,8 +1187,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
 	if (folio) {
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend))
-			end = folio->index;
+		truncate_inode_partial_folio(folio, lstart, lend, &end);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
@@ -1258,7 +1255,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
-				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+				} else if (truncate_inode_partial_folio(folio,
+							lstart, lend, NULL)) {
 					/*
 					 * If we split a page, reset the loop so
 					 * that we pick up the new sub pages.
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..2ebb00f6c379 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
- * folio that's within the [start, end] range, and then split the folio if
+ * folio that's within the [lstart, lend] range, and then split the folio if
  * it's large.  split_page_range() will discard pages which now lie beyond
  * i_size, and we rely on the caller to discard pages which lie within a
  * newly created hole.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * When @end non-NULL, set to the index of the folio that contains @lend
+ * and must be kept by the caller's truncate loop.  Return %true if the
+ * folio was split, %false otherwise, in which case the folio is dropped or
+ * may still straddle the range, so the caller must not discard it.
  */
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+				  loff_t lend, pgoff_t *end)
 {
 	loff_t pos = folio_pos(folio);
 	size_t size = folio_size(folio);
@@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	struct page *split_at, *split_at2;
 	unsigned int min_order;
 
-	if (pos < start)
-		offset = start - pos;
+	if (end && pos + size > (u64)lend)
+		*end = folio->index;
+
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
 
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		return false;
 	}
 
 	/*
@@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
-		return true;
+		return false;
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
@@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		bool tail_isolated = true;
+
+		if (end)
+			*end = (pos + offset + length) >> PAGE_SHIFT;
 
 		if (offset + length == size)
 			goto no_split;
@@ -273,24 +283,28 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
+		if (!folio_trylock(folio2)) {
+			tail_isolated = false;
 			goto out;
+		}
 
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
+		    folio2->mapping == folio->mapping &&
+		    folio_split_or_unmap(folio2, split_at2, min_order))
+			tail_isolated = false;
 
 		folio_unlock(folio2);
 out:
+		if (!tail_isolated && end)
+			*end = folio2->index;
 		folio_put(folio2);
 no_split:
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
@@ -413,11 +427,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
 	if (!IS_ERR(folio)) {
 		same_folio = lend < folio_next_pos(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
+		if (!truncate_inode_partial_folio(folio, lstart, lend,
+						  same_folio ? &end : NULL))
 			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -427,8 +439,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
 						FGP_LOCK, 0);
 		if (!IS_ERR(folio)) {
-			if (!truncate_inode_partial_folio(folio, lstart, lend))
-				end = folio->index;
+			truncate_inode_partial_folio(folio, lstart, lend, &end);
 			folio_unlock(folio);
 			folio_put(folio);
 		}
-- 
2.52.0

