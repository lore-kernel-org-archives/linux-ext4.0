Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE3F36AB49;
	Fri, 27 Mar 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607678; cv=none; b=OjikFedseEK0j5yXDL3DqXQ/a7ZmIt+OiPzuLfK+4PXdGCjqIiL9TvTSmoH5uaOFoLvuroVen9T+qtNuovYKBHsBtSwDZPjdUDBVLKI2z8ljVK1E6xncLZqFtSZORTq2t/GwODHy4P2q/t5QhRojTwbUw409KUFDwdWdUUQHx9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607678; c=relaxed/simple;
	bh=V3PreLzrVvDLTjjrE1mubL6PrtDZTq5KlDCUt1cAzaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u6xNHFynwgn5Yn+JJTm1/8qbHG4NUg7yT2mkBbF27uNxFNRh/yAgshNsItJZprmLIt3hzM44FV7iIH4C7A1LPZZsmskBjfF9/GupdkJFyY6smXr84GccUIXk2fd+AUwokMLk2K2cIIlaRVlycsKc1jqMRvr5dwbAzJkTKMxAeUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhxpL1WGszYQtw6;
	Fri, 27 Mar 2026 18:34:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C6F7A40594;
	Fri, 27 Mar 2026 18:34:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S4;
	Fri, 27 Mar 2026 18:34:29 +0800 (CST)
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
Subject: [PATCH v4 00/13] ext4: refactor partial block zero-out for iomap conversion
Date: Fri, 27 Mar 2026 18:29:26 +0800
Message-ID: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1xKr1xJFWDKFWDCrW8tFb_yoW7JrWfpF
	W3tw1Fgr4xG39F9an7Ga1xJ3WSgwn3XF48GrWfG34DZ3yUZryxCFs7K3WF9FWUKrWfG3Wj
	qF42y34UWF1DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Changes since v3:
 - In patch 04, fix the comments of ext4_block_zero_range().
 - Add patch 09, ensure zeroed partial blocks are persisted in SYNC mode
   for ext4_punch_hole() and ext4_zero_range(), This can resolve the
   breaks in the guarantee of data-ordered mode caused by patch 05, as
   pointed out by Sashiko.
 - Add patch 10, unify the inconsistent SYNC mode checks in all
   fallocate paths.
 - In patch 12, fix two issues related to updating the file size in
   error paths, as pointed out by Sashiko.

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

v3: https://lore.kernel.org/linux-ext4/20260326111054.907252-1-yi.zhang@huaweicloud.com/
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

Zhang Yi (13):
  ext4: add did_zero output parameter to ext4_block_zero_page_range()
  ext4: rename and extend ext4_block_truncate_page()
  ext4: factor out journalled block zeroing range
  ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
  ext4: move ordered data handling out of ext4_block_do_zero_range()
  ext4: remove handle parameters from zero partial block functions
  ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
  ext4: move zero partial block range functions out of active handle
  ext4: ensure zeroed partial blocks are persisted in SYNC mode
  ext4: unify SYNC mode checks in fallocate paths
  ext4: remove ctime/mtime update from ext4_alloc_file_blocks()
  ext4: move pagecache_isize_extended() out of active handle
  ext4: zero post-EOF partial block before appending write

 fs/ext4/ext4.h    |   5 +-
 fs/ext4/extents.c | 163 ++++++++++++++-------------
 fs/ext4/file.c    |  17 +++
 fs/ext4/inode.c   | 273 +++++++++++++++++++++++++++++-----------------
 4 files changed, 278 insertions(+), 180 deletions(-)

-- 
2.52.0

