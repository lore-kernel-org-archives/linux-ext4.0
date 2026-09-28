Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D7A329C40;
	Mon, 28 Sep 2026 12:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597829; cv=none; b=orthKbDbm3cZJKkhGMqPLWUcMMr474Vlk4AsG2QHhwrit5/mrxS7engnTYqTqnfNhoteqnc8WxAQmM6mbUhJIOu8Wt8jT50fgEKWAhqigNzeRczmu3MtzdnD+SCloxvf/8gxblQXnftMe3PPu9oC/7D4eLd7ANlP38LLaGuFMnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597829; c=relaxed/simple;
	bh=J36R2ZfoXgea5zjipx/MgICD+wTczok4EUO217B0EKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MlyvZ1xlBxA30OU8kA7ZfYZauNZMCmej3Jy2nS2Jil3ID9NQhJ0mE/am7QS4M49tQiDRffmrF2xmMQ2j3CVLiVuRWFCA/uimOPBuxTP54q/9KgISNzHTtdQuOaTRVY6fN77npJXwE8w/6SyqwXYAl6b2s11UOCMieMIkwIs0KEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4htgJp2ZcMzKHMZW;
	Mon, 28 Sep 2026 20:16:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5B3C840577;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S4;
	Mon, 28 Sep 2026 20:16:59 +0800 (CST)
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
Subject: [PATCH v5 0/4] mm/truncate: fix data loss when truncating straddling large folios
Date: Mon, 28 Sep 2026 20:08:29 +0800
Message-ID: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S4
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1xXryUKF1fury7ZFW7CFg_yoW7ZF15pF
	ZIg3s8Kr1kW397Crs7Aa1UWr1YqayfJFW7Aas3Gwn7CFs0vF1jkr4fKw4ruayUKrn7C340
	qF1jva1q9a4DJrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRl_MsUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hello,

This is the fifth version fixing data loss when truncating straddling
large folios caught on the upcomming ext4 + iomap buffered I/O
conversion.

When truncate_inode_pages_range() punches a hole or truncates a file,
truncate_inode_partial_folio() splits a large folio so that the caller
can drop the in-range sub-folios while keeping the out-of-range tail
intact.  This series fixes three distinct problems in that path that
can each lose the valid out-of-range tail of a straddling folio, plus a
follow-up that clarifies the return value semantics.

Patch 01 aligns the truncation boundaries inwards to the mapping minimum
folio order in truncate_inode_pages_range().  With a non-zero min_order,
folio_split() stops at min_order instead of order 0, so a boundary
computed at page granularity can land inside a min-order-aligned
sub-folio and the truncate loop drops that whole chunk, valid tail
included, causing data loss.

Patch 02 looks the end-edge straddler up by its page index through
__filemap_get_folio() in truncate_inode_partial_folio().  After the
first split the straddler is unlocked and only transiently ref'd in the
page cache, so the page pointer derived from the original folio can be
freed and reallocated as a different folio in the same mapping, and the
mapping check cannot catch it, which may cause incorrect splitting and
potential data loss.

Patch 03 reworks the contract between truncate_inode_partial_folio() and
its callers.  If the second split of the straddler fails, the function
reported success unconditionally, and the leftover incorrect end
position could cause the truncate loop to drop that valid tail.  After
rework, it tells the caller the exact page range safe to discard via new
pstart/pend out-parameters, so the truncate loop never touches a
straddling folio that still holds valid out-of-range data.

Patch 04 clarifies the return value semantics to "at least one split
succeeded", which is all the shmem caller needs to decide whether to
reset its scan loop.

The second patch fixes a pre-existing race issue that is reachable
today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
folio that carries no filesystem private data, so they are not reachable
on current filesystems.  They were found while developing the upcoming
ext4 iomap buffered I/O path. [1]

In addition, another two pre-existing issues were found during the
development of this series:

 - On 32-bit systems with a non-zero min_order filesystem, truncating or
   any operation operation involving folio_next_index() on the folio
   containing MAX_LFS_FILESIZE can cause the index calculation to
   overflow, posing an unpredictable risk. [2]
 - In shmem, at the last call site of truncate_inode_partial_folio() in
   shmem_undo_range(), the restart-loop check is wrong, which leaves
   split sub-folios behind. [3]

These two issues need to be fixed separately.

Thanks,
Yi.

[1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
[2] https://lore.kernel.org/linux-mm/5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com/
[3] https://lore.kernel.org/linux-mm/5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv/


v4-v5:
 - Collects RVB labels from Jan, Brian and Zi Yan.
 - In patch 1, move the initialization of the min_order variable to
   the top, which looks nicer. (Zi Yan)
 - In patch 3, replace the leftover folio_test_large() check with a
   check of whether the folio's order equals min_order, so as to
   determine whether the folio needs to be split. (Zi Yan)

v3->v4:
 - Move the patch that fixes data loss when min_order is non-zero to the
   first patch position, aligning start and end in
   truncate_inode_pages_range(). (Zi Yan)
 - Add patch 2, fixing the invalid folio2 issue under concurrency when
   truncate_inode_partial_folio() splits at the end position. Use
   __filemap_get_folio() to obtain a reliable folio2. (Jan Kara)

v2->v3:
 - Rework the folio2 validity check logic to fix the invalid
   folio->index issue. (sashiko)
 - Clarify the pstart and pend setting logic and the corresponding
   comments to make it more readable. (Brian, Joanne)
 - Split the patch into 3 small patches. (Zi Yan)

v1->v2:
 - Export pstart as a new parameter so that the generic and shmem
   truncate paths don't need to recompute the start value from the
   return value. (Brian)
 - When min_order is non-zero, align [pstart, pend] to the inner
   boundaries of the folio to ensure they do not point into the middle
   of a large folio, which could otherwise cause valid data within the
   folio to be incorrectly cleared. (Joanne)

v4: https://lore.kernel.org/linux-mm/20260922110703.468389-1-yi.zhang@huaweicloud.com/
v3: https://lore.kernel.org/linux-mm/20260916092450.654408-1-yi.zhang@huaweicloud.com/
v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/


Zhang Yi (4):
  mm/truncate: align truncation boundaries to mapping minimum folio
    order
  mm/truncate: look up the end-edge straddler by index
  mm/truncate: fix data loss when splitting straddling large folios
    fails
  mm/truncate: clarify return value of truncate_inode_partial_folio()

 mm/internal.h |   4 +-
 mm/shmem.c    |  13 ++---
 mm/truncate.c | 131 +++++++++++++++++++++++++++++++++-----------------
 3 files changed, 93 insertions(+), 55 deletions(-)

-- 
2.52.0

