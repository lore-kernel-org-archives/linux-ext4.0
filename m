Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BC838550C;
	Mon, 11 May 2026 07:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484513; cv=none; b=OUzpduAeIwsWh2+3cg2gwqJ906N3hVT1I4KRstP8dHY+19lxF5xIwYnQME63c7OXjtiQwU5fv9M0bBx4mSCE6U+pdsqOZ8NXzQljk6TiI2/o33V8dtr0afAsamStO/UYBoruR309/PIoiDu7n/LpXUTQo0/zQ0ojvV0LGnOvboI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484513; c=relaxed/simple;
	bh=suhHhiI+Wrdix7++FjQ52Vr5PRM74MFIKJMXJBrapGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MZEp64L4RW4v8Q/6bBrp7BkJ5Hb7L7IWz8frOAVVNI8thw9ApL6qhiQojhn4zLf+8jeZ9AvH2wPnw7lAUR0OrvfhFmfCdtIu70eUGhhtk9T0SR+dCSjiSa2HWiKkqNi9SNSaHCIIT4royf79yDKuhEiS40Trg8g1UIxKAcSc3pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXT6FcBzYQv1v;
	Mon, 11 May 2026 15:27:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 868194056F;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S4;
	Mon, 11 May 2026 15:28:19 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 00/23] ext4: use iomap for regular file's buffered I/O path
Date: Mon, 11 May 2026 15:23:20 +0800
Message-ID: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S4
X-Coremail-Antispam: 1UD129KBjvJXoW3GrykCFy3XF15Zw18AFy7Wrg_yoWfur1xpF
	Z0kFyftr17X34xuan7uw1xtr1Yvan5XF43WF4rGwn8uayYgF10vF4I9a1Y9FWUGry7A340
	qr12yF18GF1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

This version is a small revision of v3 with no design changes. It fixes
some issues pointed out by Jan and Sashiko, and adds numerous comments
to clarify functionality and key considerations. You can get commits
here:

 https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v4/

Original Cover-letter:
===

This series adds the iomap buffered I/O path support for regular files,
based on the latest upstream kernel. It implements the core iomap APIs
on ext4 and introduces the 'buffered_iomap' mount option to enable the
iomap buffered I/O path. It supports default features, default mount
options and bigalloc feature. However, it does not support online
defragmentation, inline data, fsverify, fscrypt, non-extent inodes, and
data=journal mode, it will fall to buffered_head I/O path automatically
if these features and options are used.

This iomap buffered I/O path is not enabled by default because the
preceding features are not supported. Users can explicitly enable or
disable it via 'buffered_iomap' and 'nobuffered_iomap' mount options.

Key notes
=========

1. Lock ordering difference

   The lock ordering of folio lock and transaction start in the iomap
   path is the opposite of that in the buffer_head path.

2. data=ordered mode is not used

   Two main reasons:
   a) The lock ordering of folio lock and transaction start for
      data=ordered mode is opposite to the iomap path, which would cause
      a deadlock.
   b) The iomap writeback path does not support partial folio submission
      (required by data=ordered mode when block size < folio size, and
      it is currently handled by ext4_bio_write_folio()), which would
      also cause a deadlock.

   To replace data=ordered mode functionality:

   - For append write: Always allocate unwritten extents (dioread_nolock
     behavior) to prevent stale data exposure.

   - For post-EOF partial block zeroing: Issue zeroing I/O immediately
     and asynchronously or synchronously wait for completion before
     updating i_disksize. On ordered I/O completion, set i_disksize to
     i_size to avoid lost updates in the truncate up and append
     fallocate cases. (Jan suggested).

   - For online defragmentation: Not supported yet, needs further
     consideration.

3. Always enable dioread_nolock

   Two main reasons:
   a) Since data=ordered mode cannot be used, allocating written blocks
      directly would expose stale data.
   b) To optimize writeback, we should allocate blocks based on writeback
      length rather than per-folio mapping. Direct written allocation
      would over-allocate blocks.

   dioread_nolock has been the default mount option for many years, and
   Jan pointed out that we may no longer need to disable it, so gradually
   remove this mount option in the future.

Series structure
================

 - Patch 01-03: Simplify truncate operations and prepare for conversion.
 - Patch 04-16: Implement core iomap buffered read/write, writeback,
                mmap, and partial block zeroing paths.
 - Patch 17-21: Handle ordered I/O for zeroing post-EOF partial block.
 - Patch 22-23: Enable iomap buffered I/O path.

Testing and Performance
=======================

Tested with xfstests-bld using -g auto, fast_commit, and 64k
configurations. No new regressions were observed.

For the special case of zeroing post-EOF partial block, I add a new
generic/790 to address this scenario.

  https://lore.kernel.org/fstests/20260428085750.1072612-1-yi.zhang@huaweicloud.com/

Performance tested with fio on a 150 GB memory-backed virtual machine
(no much difference compared to v2 and v3, so no update):

 Buffered write (MiB/s)
 ===

  bs       write cache    uncached write
           bh     iomap   bh      iomap
  1k       423    403     36.3    57
  4k       1067   1093    58.4    61
  64k      4321   6488    869     1206
  1M       4640   7378    3158    4818

 Buffered read (MiB/s)
 ===

  bs       read hole        read pre-cache     read ondisk data
           bh     iomap     bh     iomap       bh      iomap
  1k       635    643       661    653         605     602
  4k       1987   2075      2128   2159        1761    1716
  64k      6068   6267      9472   9545        4475    4451
  1M       5471   6072      8657   9191        4405    4467

Large I/O write performance improved by approximately 30% to 50%.
Read performance showed no significant difference.

Changes since v3:
 - Rebased on the latest upstream kernel.
 - Improve commit messages for patches 07-23 to clarify functionality
   and key considerations.
 - Move the patches that enables IOMAP to the end of this series.
 - Patch 02: Move ext4_set_inode_size() declarations from ext4.h into
   inode.c, move truncate_pagecache() and ext4_truncate() to
   ext4_truncate_down() as Jan suggested.
 - Patch 08: Add check for non-extent inodes in the non-delalloc write
   path, and clarify the reason why we don't need to truncate blocks on
   short writes. (Pointed out by sashiko)
 - Patch 09: Fix the issue where DATA_ERR_ABORT fails to work in
   overwrite scenarios. Replace iomap_finish_ioends() with
   iomap_finish_ioend() during end_io to prevent might_sleep() being
   called in interrupt context. (Pointed out by sashiko)
 - Patch 11: Fix underflow of the nr_blks variable. (Pointed out by
   sashiko)
 - Patch 17: Factor out ext4_iomap_submit_zero_block() helper to handle
   ordered mode after zeroing a post-EOF partial block in the iomap
   path, also add comments.
 - Patch 18: Fix off-by-one in ext4_iomap_wb_ordered_wait() and clarify
   why a single i_ordered_len tracker suffices. (Pointed out by sashiko)
 - Patch 19: Fix an issue where the correct file size may be lost due to
   a missing memory barrier. (Pointed out by sashiko)
 - Patch 20: Change the logic for waiting on ordered I/Os in the insert
   range and collapse range from asynchronous to synchronous.
 - Patch 21: Allow per-inode journal mode changes but disallow per-inode
   extent type changes, add comments of restrictions on using iomap.

Changes since v2:
 - Rebased on the latest upstream kernel (7.1-rc1).
 - Added patches 01-03 to simplify truncate operations.
 - Added patch 13 to fix incorrect did_zero parameter in
   iomap_zero_range().
 - Added patches 19-22 to handle ordered I/O for zeroing post-EOF
   partial block.
 - Minor code and comment optimizations.

Changes since v1:
 - Rebase this series on linux-next 20260122.
 - Refactor partial block zero range, stop passing handle to
   ext4_block_truncate_page() and ext4_zero_partial_blocks(), and move
   partial block zeroing operation outside an active journal transaction
   to prevent potential deadlocks because of the lock ordering of folio
   and transaction start.
 - Clarify the lock ordering of folio lock and transaction start, update
   the comments accordingly.
 - Fix some issues related to fast commit, pollute post-EOF folio.
 - Some minor code and comments optimizations.

v3:     https://lore.kernel.org/linux-ext4/20260422021042.4157510-1-yi.zhang@huaweicloud.com/
v2:     https://lore.kernel.org/linux-ext4/20260203062523.3869120-1-yi.zhang@huawei.com/
v1:     https://lore.kernel.org/linux-ext4/20241022111059.2566137-1-yi.zhang@huaweicloud.com/
RFC v4: https://lore.kernel.org/linux-ext4/20240410142948.2817554-1-yi.zhang@huaweicloud.com/
RFC v3: https://lore.kernel.org/linux-ext4/20240127015825.1608160-1-yi.zhang@huaweicloud.com/
RFC v2: https://lore.kernel.org/linux-ext4/20240102123918.799062-1-yi.zhang@huaweicloud.com/
RFC v1: https://lore.kernel.org/linux-ext4/20231123125121.4064694-1-yi.zhang@huaweicloud.com/

Comments and suggestions are welcome!

Thanks,
Yi.

Zhang Yi (23):
  ext4: simplify size updating in ext4_setattr()
  ext4: factor out ext4_truncate_[up|down]()
  ext4: simplify error handling in ext4_setattr()
  ext4: add iomap address space operations for buffered I/O
  ext4: implement buffered read path using iomap
  ext4: pass out extent seq counter when mapping da blocks
  ext4: do not use data=ordered mode for inodes using buffered iomap
    path
  ext4: implement buffered write path using iomap
  ext4: implement writeback path using iomap
  ext4: implement mmap path using iomap
  iomap: correct the range of a partial dirty clear
  iomap: support invalidating partial folios
  iomap: fix incorrect did_zero setting in iomap_zero_iter()
  ext4: implement partial block zero range path using iomap
  ext4: add block mapping tracepoints for iomap buffered I/O path
  ext4: disable online defrag when inode using iomap buffered I/O path
  ext4: submit zeroed post-EOF data immediately in the iomap buffered
    I/O path
  ext4: wait for ordered I/O in the iomap buffered I/O path
  ext4: update i_disksize to i_size on ordered I/O completion
  ext4: wait for ordered I/O to complete during insert and collapse
    range
  ext4: add tracepoints for ordered I/O in the iomap buffered I/O path
  ext4: partially enable iomap for the buffered I/O path of regular
    files
  ext4: introduce a mount option for iomap buffered I/O path

 fs/ext4/ext4.h              |   57 +-
 fs/ext4/ext4_jbd2.c         |    8 +-
 fs/ext4/ext4_jbd2.h         |    7 +-
 fs/ext4/extents.c           |   18 +
 fs/ext4/file.c              |   20 +-
 fs/ext4/ialloc.c            |    1 +
 fs/ext4/inode.c             | 1040 ++++++++++++++++++++++++++++++-----
 fs/ext4/migrate.c           |    2 +
 fs/ext4/move_extent.c       |   11 +
 fs/ext4/page-io.c           |  210 +++++++
 fs/ext4/super.c             |   55 +-
 fs/iomap/buffered-io.c      |   22 +-
 fs/iomap/ioend.c            |    3 +-
 include/linux/iomap.h       |    1 +
 include/trace/events/ext4.h |  142 +++++
 15 files changed, 1446 insertions(+), 151 deletions(-)

-- 
2.52.0

