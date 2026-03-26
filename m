Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15C34DB56;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523755; cv=none; b=b7XC4Be0UXrOGAacl6/dnMG8t7InwSAWm02nsNaCVKz3hm1mADj38VwSB7bajrttMFDwADYWDKDEV8PnT2itzmfXvRnIoC7Hx5GvsDHdcMVp8sjbZPo/PRRidWkzzlHI1uTbJrlwYxq7i1X4vLQxuyd39m4ER1t0me7yPkglqok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523755; c=relaxed/simple;
	bh=Hxc8UH8WPI8wcqXMrD03NNoiKWXOjOhhiVA6fSKslf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kjve3Cddy1vZqzPnzUUVsk5/f7oCExuw7SqUA+8/+72LSOvorinCCVRWWRB8XW35QPoBCW8QV0MeEUY2SpooNJiVM2yBrxWHyRJvZG+TVAag/4hh6HGQpPkV8q4wUgfQfd1B9zSi7D2PoQnjUGp5HX4PwTyr45i8aKLAYPPf2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhLlx32M9zKHMJr;
	Thu, 26 Mar 2026 19:15:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8E66D40576;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S4;
	Thu, 26 Mar 2026 19:15:47 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 00/11] ext4: refactor partial block zero-out for iomap conversion
Date: Thu, 26 Mar 2026 19:10:43 +0800
Message-ID: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4kZrWxKFyxXr1kXw4fKrg_yoWrAF1fpF
	Wakw1S9r4xG39F9a97Ca1xX3WS9wn3WF4rGrW3G34UZ3yUZF1xCF4kK3WF9FWUKrWfG3Wj
	qF4jya4UGF1DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Changes since v2:
 - Drop patch 02 in v2 because it will not be used in the later iomap
   conversion.
 - In patch 08, modify ext4_alloc_file_blocks() to zero out EOF block
   when new_size is larger than old_size, preventing the exposure of
   stale data when the user performs fallocate starting within the
   old_size. This was pointed out by Sashiko.
 - In patch 08, add checks for the return value of
   ext4_block_zero_eof().
 - Add patches 09 and 10, move pagecache_isize_extended() out of an
   active journal handle as well to prevent opposite lock ordering.
   This was pointed out by Sashiko.
 - In patch 11, add a check for IOCB_NOWAIT, which was also pointed out
   by Sashiko.

Changes since v1:
 - In patch 04, rename ext4_block_get_zero_range() to
   ext4_load_tail_bh() and drop the unused 'length' parameter as Jan
   suggested.
 - In patch 06, modify the commit message, add another reason to drop
   data=ordered mode when zeroing partial blocks in ext4_punch_hole()
   and ext4_punch_hole() as Jan pointed out.
 - In patch 10, modify the commit message, explain the race condition
   between the buffered write and mmap write that pointed out by Jan.
 - Collect reviewed tags from Jan.

v2: https://lore.kernel.org/linux-ext4/20260325072850.3997161-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-ext4/20260310014101.4140698-1-yi.zhang@huaweicloud.com/

Original cover letter:

This patch series extracted from my iomap conversion v2 series[1]. It
refactors the ext4 zero partial block code path in preparation for
converting buffered I/O to the iomap infrastructure. The main changes
are:

[1] https://lore.kernel.org/linux-ext4/20260203062523.3869120-1-yi.zhang@huawei.com/

1. Introduce ext4_block_zero_eof(): Extend and rename
   ext4_block_truncate_page() to handle post-EOF partial block zeroing
   for both append writes and truncate operations.
2. Separate ordered data handling: Move data=ordered mode handling from
   __ext4_block_zero_page_range to ext4_block_zero_eof(). Only truncate
   and post-EOF append write/fallocate paths need ordered data mode,
   hole punching and zero range paths don't need ordered data handling.
3. Split journal mode handling: Extract
   ext4_block_journalled_zero_range() from
   __ext4_block_zero_page_range() for data=journal mode, leaving
   ext4_block_do_zero_range() for data=ordered/writeback modes.
4. Refactor ext4_alloc_file_blocks(): Change parameters to loff_t byte
   granularity to simplify callers and prepares removing the zero call
   from the allocation loop for unaligned append writes.
5. Remove handle parameters: Stop passing handle_t * to zero functions.
   Make ext4_block_journalled_zero_range() start its own handle, and
   move zero operations outside active handles. This is required because
   iomap uses "folio lock -> transaction start" lock ordering, opposite
   to the current lock ordering.
6. Centralize zeroing in ext4_write_checks(): Move all post-EOF partial
   block zeroing to ext4_write_checks() so it applies to both regular
   buffered writes and the upcoming iomap path.

Thanks
Yi.

Zhang Yi (11):
  ext4: add did_zero output parameter to ext4_block_zero_page_range()
  ext4: rename and extend ext4_block_truncate_page()
  ext4: factor out journalled block zeroing range
  ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
  ext4: move ordered data handling out of ext4_block_do_zero_range()
  ext4: remove handle parameters from zero partial block functions
  ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
  ext4: move zero partial block range functions out of active handle
  ext4: remove ctime/mtime update from ext4_alloc_file_blocks()
  ext4: move pagecache_isize_extended() out of active handle
  ext4: zero post-EOF partial block before appending write

 fs/ext4/ext4.h    |   5 +-
 fs/ext4/extents.c | 154 +++++++++++++--------------
 fs/ext4/file.c    |  17 +++
 fs/ext4/inode.c   | 262 ++++++++++++++++++++++++++++------------------
 4 files changed, 260 insertions(+), 178 deletions(-)

-- 
2.52.0

