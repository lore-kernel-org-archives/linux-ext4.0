Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC29F3F4822;
	Tue, 14 Jul 2026 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016555; cv=none; b=g1k+lhNjtimlrC1HFsnOKIgwqHlxVH4hqXLo2M8tG3nT5/wnv8BKUMiTz4h9BxVtUVGrBxcwAC+Sw69s053UITayHXdMxYCKnXQSpXjDPPpaSSbnYoOsUOeRdYTHNBFkkBcCG49zrrgdOGDGEZ1vNxg0547NEQi+KySHNoDaan4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016555; c=relaxed/simple;
	bh=dua65UHhCvnKD//Ux9yiXkMgTLEJoHBRFi7X1vf7MU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dmQCB8rrrbizavKO30CNCmUECVG0/ZxfjsjgPK7XmPTf4a+5UGCSjRc/tZG3B29biUhmxi3qHPXIAiHfM+PNNeB4B+8NSRRxEaTyw/hRRJ2s6EbzVhvcC6ziTWfJZxQJ3f7WMQSK95UWrN1FvK0elKy/U5Iraf1ljQB782fOZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzsPs508dzKHMN1;
	Tue, 14 Jul 2026 16:08:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1A27F40592;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S4;
	Tue, 14 Jul 2026 16:09:03 +0800 (CST)
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
Subject: [PATCH v4 0/9] ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES
Date: Tue, 14 Jul 2026 16:00:35 +0800
Message-ID: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJFWfXrWUGw1xJFW8WFWxWFg_yoWrZw4xpa
	y5Krn8tw4DG343ua93CF10gr1Y93Z7Gay5GrW7KrWUZayUXF1xCFsIga1YvFyDCws3CFy2
	qF45tFyj93WDZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

This is v4 of the series to fix unaligned edge handling in
FALLOC_FL_WRITE_ZEROES. No code changes have been made relative to v3.
This iteration solely adds a comment to document the race condition in
ext4_block_zero_eof() that prevents zeroing of inline inode's tail
block.

Changes since v3:
 - Collect RVB tags from Jan.
 - Add a comment clarifying the race between zeroing the EOF block and
   inline data conversion triggered by mmap write, which occurs without
   holding i_rwsem (Jan suggested).
Changes since v2:
 - Add patch 1 to use FGP_WRITEBEGIN in ext4_load_tail_bh(), fixing a
   pre-existing stable-writes bug exposed by patch 4's reordering.
 - Fold in two pre-existing fixes (now patches 2 and 3) that were
   originally going to be sent separately.
 - Rework patch 9 per Sashiko's review on the orphan list handling
   around the unwritten-to-written conversion.
Changes since v1:
 - Pick up Jan's Reviewed-by on patches 1, 3, and 5.
 - Expand patch 2 to also explain why a clean unwritten buffer returns
   NULL (a lookup-only get_block never sets BH_Mapped for unwritten
   extents), per Jan's review.
 - Drop the last cleanup patch "skip ext4_update_disksize_before_punch()
   in WRITE_ZEROES" because it's wrong.
 - Add a new patch to protect the WRITE_ZEROES crash window by adding
   the inode to the orphan list in the same handle that does the
   unwritten-to-written conversion, and removing it once i_disksize
   has caught up.

v3: https://lore.kernel.org/linux-ext4/20260708062049.1982410-1-yi.zhang@huaweicloud.com/
v2: https://lore.kernel.org/linux-ext4/20260707021338.1182268-1-yi.zhang@huawei.com/
v1: https://lore.kernel.org/linux-ext4/20260701142009.1510104-1-yizhang089@gmail.com/

Origin cover-letter
===================

The current FALLOC_FL_WRITE_ZEROES implementation in ext4 does not
correctly handle unaligned edge blocks. FALLOC_FL_WRITE_ZEROES is needed
to convert the requested range to written extents with zeroed content,
but the existing code only partially zero the edges and never guarantees
that:

  1) edges that are clean unwritten extents or holes get promoted to
     written extents, and
  2) edges that are dirty unwritten or delalloc get their underlying
     extents converted to written before the syscall returns.

Both cases leave the on-disk extent type unwritten, violating the
WRITE_ZEROES contract, and in these cases a subsequent sync buffered
overwrite would still observe pending metadata changes from the
conversion work that should have been completed by WRITE_ZEROES itself.

This series fixes the unaligned edge handling and cleans up a related
redundant i_disksize update. The first three patches are preparatory:
moving ext4_zero_partial_blocks() earlier in ext4_zero_range(),
documenting the return semantics of ext4_load_tail_bh(), and replacing
the single bool output of ext4_zero_partial_blocks() with a per-edge
bitmask (EXT4_PARTIAL_ZERO_START/END). The next two patches fix the two
scenarios above by expanding the aligned allocation range outward for
skipped (clean unwritten or hole) edges, and by writing back
partial-zeroed edges so the underlying extents are converted to written.
The final patch drops the now-redundant
ext4_update_disksize_before_punch() call on the WRITE_ZEROES path, since
WRITE_ZEROES is mutually exclusive with KEEP_SIZE and the i_disksize
update is already handled by ext4_alloc_file_blocks().

Thanks,
Yi.

Discussion Link:
  https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/

Zhang Yi (9):
  ext4: use FGP_WRITEBEGIN for tail block zeroing
  ext4: skip tail block zeroing for inline data files
  ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
  ext4: move partial block zeroing earlier in ext4_zero_range()
  ext4: clarify return semantics of ext4_load_tail_bh()
  ext4: track partial-zero outcome per edge in
    ext4_zero_partial_blocks()
  ext4: zero out whole block for clean edges in WRITE_ZEROES
  ext4: write back partial-zeroed edges in WRITE_ZEROES
  ext4: protect WRITE_ZEROES written extents with orphan list

 fs/ext4/ext4.h    |  5 ++-
 fs/ext4/extents.c | 84 +++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/inode.c   | 61 +++++++++++++++++++++++++++++-----
 3 files changed, 127 insertions(+), 23 deletions(-)

-- 
2.52.0

