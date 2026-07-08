Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFF93C09E4;
	Wed,  8 Jul 2026 06:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492133; cv=none; b=DrAyDTMMrxEQzUs1h5o8MuxLEH6WTSdn/7aHKEzGO8hJYT5CWr51aEUiwFgVn83sQ37g7iX2ZZvx9vs/Vklgk5/nhM/nj1l4MMSpn6IdyvAUdsNNRxdoIhKYKndLwWUp11s8zRGmibw7pXfJJAG13VmoIzlXrXI7paK1+GDoFvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492133; c=relaxed/simple;
	bh=kFUHzHOFceIo51iRdG1X9EV/IUe67BQ/QtVVUHi0vtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J6BPf9mYKGqSIn9s15YcBRMTrzDilgrHtSeI2UahCSgSOm1YHoMadtoLCRXVudpDEUHVgeWgd42GY1OTmxcqA4hBpXOKiNBoNYVJUNlCxBTsZualcukst/SnK+UjiSUHaP66bbzKLtswxuoYD6SsfCYg5ydcGSOg7rZC8evzhbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gw7TQ1NgNzYQtkT;
	Wed,  8 Jul 2026 14:28:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id BF809407BE;
	Wed,  8 Jul 2026 14:28:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3MT7k1q4VPeAQ--.18748S4;
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
Subject: [PATCH v3 0/9] ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES
Date: Wed,  8 Jul 2026 14:20:40 +0800
Message-ID: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCnt3MT7k1q4VPeAQ--.18748S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4rCw1DCr1rZFyxGFy5XFb_yoWruF1Upa
	y5KFZ0qw4DG3sI9a93CF1jgrnYyan7GFWUGrW3KrWjvay5Xr1xCFsagayYvF9rCrs3CF9F
	qF4Yyryjg3WDA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUA8nOUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

This is v3 of the series to fix unaligned edge handling in
FALLOC_FL_WRITE_ZEROES. This version folds in the two pre-existing
fixes around ext4_block_zero_eof() and ext4_load_tail_bh() that Sashiko
reported[1] (they were planned to be sent separately in v2, but due to
dependencies between them, I've combined them into v3), and adds a third
fix to ext4_load_tail_bh() itself for the stable-writes case that
patch 4's reordering exposes[2].

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

[1] https://sashiko.dev/#/patchset/20260701142009.1510104-1-yizhang089%40gmail.com?part=2
[2] https://sashiko.dev/#/patchset/20260707021338.1182268-1-yi.zhang%40huawei.com?part=1

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
 fs/ext4/inode.c   | 56 ++++++++++++++++++++++++++-----
 3 files changed, 122 insertions(+), 23 deletions(-)

-- 
2.52.0

