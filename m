Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677124A8407;
	Thu,  3 Sep 2026 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439384; cv=none; b=AuvtKylfkarnB6HbTTGpai0PtBWvBCTDNajX0xo82vKMBbRjZ4L138rtVvcjMIj3Jp8Atx8dzMQkuB+hH2fWYd4zkdysK1dELVbNC6/cOSd9b4/+cyrbQ7nVAZbbvsQ35Mt+kuQ0IDzZSE04bs8e4KaXtuGY+TnWpRQrJgoM3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439384; c=relaxed/simple;
	bh=1UXiTrqJNMp5nKuecNg0lW8ZDKfLeerpgFVc66APs2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PWfdqCQlTqxEov+izl+K7gSDyLHPyVslb49i+0y4baq04E3ytPZvWmRyKxONwntYPtzuYMuw81DzE9fAmD9rw3LK3u8XYXhaxSkHEIrH7taikA2JWV8wPps4JAv8k2fCmexH5Gf5R4Xqq8QoWUGxEYpcHnLIk8767CE7+QLvrUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3z4SFBzYQv0n;
	Thu,  3 Sep 2026 20:42:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7A9B940B0C;
	Thu,  3 Sep 2026 20:42:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S4;
	Thu, 03 Sep 2026 20:42:50 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v6 00/31] ext4: use iomap for regular file's buffered I/O path
Date: Thu,  3 Sep 2026 20:35:12 +0800
Message-ID: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S4
X-Coremail-Antispam: 1UD129KBjvAXoWfXr1xCr1kWFyxKr1fKrW7urg_yoW8Jw48Go
	WSvw4Uur1UAry5tFZakFWDCr17J3s2kr1fArWrWrWkGFyxtF47Ca4xC3y3Way3Gw4FyFsx
	J348A3W7KFsrJF1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRRbyCPUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi, all

This is v6 of the series converting ext4's buffered I/O path from
buffer_head to iomap. This iteration doesn't have significant changes
since v5. It just fixes bugs pointed out by Sashiko, improves commit
messages and comments to prevent false positives from Sashiko. Rebased
on 7.3-rc1 (45c13f3f9e3b).

You can get commits here:

 https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v6/

Patch 01-02: Simplify truncate operations and drop unnecessary ordered
             I/O when zeroing EOF blocks. This prepares for the iomap
	     conversion.
Patch 03-20: Extend ext4_map_blocks() and implement core iomap buffered
             read/write, writeback, mmap, and partial block zeroing.
Patch 21-29: Handle ordered sequence for zeroing the EOF partial block
             and updating i_disksize when performing file extending on
	     unaligned EOF files.
Patch 30-31: Enable iomap buffered I/O path.

Tests and Performance:

Tested with xfstests-bld using -g auto, fast_commit, and 64k
configurations. No new test failures were observed, aside from the
known occasional failure of generic/127, which is an issue in the
MM large folio split logic and warrants a separate fix.

 https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/

This is a patch that attempts to fix this issue:

 https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/

Performance was tested with FIO on a 4-core virtual machine with an
Intel(R) Xeon(R) Platinum 8380 CPU, backed by a 150GB RAM-backed
virtual-io block device (Since there are no significant changes from
v5, the performance data remains unchanged).

Write perf tests (MiB/s)
========================

  Sync  : 1 = fsync() after each write
  OW    : 1 = overwrite existing blocks
  Dnc   : 1 = RWF_DONTCACHE used

  #1    : only write page cache, no writeback
  #2    : writeback triggered (set dirty_background_bytes = 100MB and
          dirty_bytes = 200MB)


  Config                   BS       ext4+bh   ext4+iomap    delta
  ---------------------------------------------------------------
  Sync=0 OW=0 Dnc=0 (#1)   1k          41.8         42.0    ~0%
  Sync=0 OW=0 Dnc=0 (#1)   4k           170          176    +4%
  Sync=0 OW=0 Dnc=0 (#1)   64k         1816         1981    +9%
  Sync=0 OW=0 Dnc=0 (#1)   1m          4295         5780   +35%

  Sync=0 OW=0 Dnc=0 (#2)   1k          42.6         43.2    +2%
  Sync=0 OW=0 Dnc=0 (#2)   4k           137          140    +2%
  Sync=0 OW=0 Dnc=0 (#2)   64k          734          957   +30%
  Sync=0 OW=0 Dnc=0 (#2)   1m          1460         1683   +15%

  Sync=0 OW=0 Dnc=1        1k          14.6         15.0    +3%
  Sync=0 OW=0 Dnc=1        4k          67.9         61.9    -9%
  Sync=0 OW=0 Dnc=1        64k          415          698   +68%
  Sync=0 OW=0 Dnc=1        1m          1404         2883  +105%

  Sync=1 OW=0 Dnc=0        1k          0.71         0.60   -15%
  Sync=1 OW=0 Dnc=0        4k          2.04         1.89    -7%
  Sync=1 OW=0 Dnc=0        64k         32.6         32.4    -1%
  Sync=1 OW=0 Dnc=0        1m           253          277   +10%

  Sync=0 OW=1 Dnc=0 (#1)   1k          19.1         21.0   +10%
  Sync=0 OW=1 Dnc=0 (#1)   4k           164          179    +9%
  Sync=0 OW=1 Dnc=0 (#1)   64k         1776         1867    +5%
  Sync=0 OW=1 Dnc=0 (#1)   1m          4105         4879   +19%

  Sync=0 OW=1 Dnc=0 (#2)   1k          19.9         21.6    +8%
  Sync=0 OW=1 Dnc=0 (#2)   4k           148          157    +6%
  Sync=0 OW=1 Dnc=0 (#2)   64k          843          840    ~0%
  Sync=0 OW=1 Dnc=0 (#2)   1m          1579         1806   +14%

  Sync=0 OW=1 Dnc=1        1k          17.4         17.9    +3%
  Sync=0 OW=1 Dnc=1        4k          80.4         87.7    +9%
  Sync=0 OW=1 Dnc=1        64k          806          923   +14%
  Sync=0 OW=1 Dnc=1        1m          1070         1122    +5%

  Sync=1 OW=1 Dnc=0        1k          0.82         0.82     0%
  Sync=1 OW=1 Dnc=0        4k          3.55         3.56    ~0%
  Sync=1 OW=1 Dnc=0        64k         48.4         49.8    +3%
  Sync=1 OW=1 Dnc=0        1m           325          336    +4%


Read tests (MiB/s)
==================

  READ HOLE           : read of a hole
  READ DATA           : read of file data without pre-exists page cache
  READ PRECACHED DATA : read of file data with warm page cache

  Scenario                 BS       ext4+bh   ext4+iomap    delta
  ---------------------------------------------------------------
  READ HOLE                1k          46.6         47.1    +1%
  READ HOLE                4k           189          198    +5%
  READ HOLE                64k         2011         2116    +5%
  READ HOLE                1m          4538         4684    +3%

  READ DATA                1k          44.6         50.4   +13%
  READ DATA                4k           178          182    +2%
  READ DATA                64k          741          768    +4%
  READ DATA                1m          1143         1210    +6%

  READ PRECACHED DATA      1k          50.8         50.7    ~0%
  READ PRECACHED DATA      4k           179          173    -3%
  READ PRECACHED DATA      64k         2009         1989    -1%
  READ PRECACHED DATA      1m          6296         6294    ~0%

Large I/O scenarios show significant write performance improvement,
while small I/O in synchronous and non-cached scenarios experience a
slight regression. Read performance shows no significant difference.


Changes since v5:
 - Rebased on 7.3-rc1 (45c13f3f9e3b).
 - Drop patch "ext4: simplify error handling in ext4_setattr()" in v5,
   since posix_acl_chmod() may return a non-fatal error.
 - In patch 03, add a comment to explain why it's safe to read
   i_disksize without holding i_data_sem, preventing false positive from
   sashiko.
 - In patch 05, return immediately if ext4_map_query_blocks() returns an
   error in ext4_map_blocks().
 - In patch 09, drop the changes in ext4_convert_unwritten_extents()
   that continue extent conversion when a hole is encountered, because a
   hole is unexpected and could lead to data corruption.
 - In patch 15, use umin() instead of min_t() to prevent truncation
   during 'blk_end' calculation. Use WRITE_ONCE() when setting
   i_disksize during writeback, since there are several places reading
   it without i_data_sem. Update the commit message to explain the
   delayed initialization of i_rsv_conversion_work and
   i_rsv_conversion_list.
 - In patch 16, move the ext4_inode_buffered_iomap() check after the
   inline check in the mmap fault handler, to prepare for future inline
   data support.
 - Drop patch "ext4: tolerate unexpected holes in
   ext4_convert_unwritten_extents()" because encountering a hole during
   unwritten-to-written conversion in writeback is still unexpected and
   could lead to data corruption.
 - Add patch 18 to fix a data corruption issue caused by concurrent
   partial folio punch hole and writeback, when block size is smaller
   than folio size and the folio has no iomap ifs attached.
 - In patch 22, inherit the sync mode when submitting zeroed EOF blocks
   during writeback.
 - In patch 25, replace filemap_fdatawrite_range() +
   ext4_iomap_wait_disksize_pending() with just
   filemap_write_and_wait_range() in ext4_iomap_sync_zeroed_eof(), to
   avoid returning too early.
 - In patch 26, tighten the WARN_ON_ONCE guard in
   ext4_destroy_inode() to skip the check when the filesystem is in an
   error or emergency state, since pending blocks may not have been
   written back if the filesystem was shut down via EXT4_IOC_SHUTDOWN.
   Drop the emergency-state cleanup in ext4_iomap_writepages() as it's
   no longer needed.
 - In patch 28, drop the i_size print in the ext4_iomap_disksize_pending
   trace event class, because it's unsafe to query i_size in interrupt
   context.
 - In patch 29, move trace_ext4_iomap_wb_disksize_pending_complete()
   from ext4_iomap_end_bio() to ext4_iomap_finish_ioend(), for the same
   reason (unsafe to query i_size in interrupt context).
 - In patch 30, drop the WARN_ON_ONCE in the ext4_inode_buffered_iomap()
   check during writeback, because an ongoing writeback can race with a
   concurrent journal flag change that alters the buffered I/O writeback
   mode.
 - Improve commit messages in patches 04, 14, 22, 23, 24, 25, and 26 to
   prevent false positives from Sashiko.

v5:     https://lore.kernel.org/linux-ext4/20260814093331.1703882-1-yi.zhang@huaweicloud.com/
v4:     https://lore.kernel.org/linux-ext4/20260511072344.191271-1-yi.zhang@huaweicloud.com/
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


Original Cover-letter
=====================

This series adds the iomap buffered I/O path support for regular files.
It implements the core iomap APIs on ext4 and introduces the
'buffered_iomap' mount option to enable the iomap buffered I/O path.
This supports default features, default mount options and bigalloc
feature. However, this does not support online defragmentation, inline
data, fsverify, fscrypt, non-extent inodes, and data=journal mode, we
will fall to buffered_head I/O path automatically if these features and
options are used.

This iomap buffered I/O path is not enabled by default because the
preceding features are not supported. Users can explicitly enable or
disable it via 'buffered_iomap' and 'nobuffered_iomap' mount options.

Key considerations

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

   - For post-EOF partial block zeroing, mark the inode as
     DISKSIZE_GROW_PENDING after zeroing the EOF block, and postpone
     updating i_disksize to i_size until the zeroed block has been
     written to disk or discarded (Suggested by Jan).

     Tradeoffs:
     1) i_disksize must be updated from io_end processing, so this
        mechanism is restricted to the buffered I/O iomap path due to
        locking constraints. This limitation will eventually go away
	once everything is converted to iomap.
     2) After a crash, i_disksize may be updated while the file content
        shows zeros. This is acceptable for simplicity and does not
	break any existing guarantees.

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


Zhang Yi (31):
  ext4: simplify size updating in ext4_setattr()
  ext4: factor out ext4_truncate_[up|down]()
  ext4: skip ordered I/O wait when zeroing beyond i_disksize block
  ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
  ext4: recheck extent status tree before block allocation
  ext4: fix orig_mlen initialization in ext4_map_blocks()
  ext4: allow ext4_map_blocks() to start its own transaction handle
  ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten
    extents
  ext4: skip block allocation for holes in the data submission path
  ext4: add iomap address space operations for buffered I/O
  ext4: implement buffered read path using iomap
  ext4: pass out extent seq counter when mapping da blocks
  ext4: do not use data=ordered mode for inodes using buffered iomap
    path
  ext4: implement buffered write path using iomap
  ext4: implement writeback path using iomap
  ext4: implement mmap path using iomap
  ext4: implement partial block zero range path using iomap
  ext4: drain writeback before removing extents on the iomap path
  ext4: add block mapping tracepoints for iomap buffered I/O path
  ext4: disable online defrag when inode using iomap buffered I/O path
  ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
  ext4: submit and wait for pending disksize-grow I/O on writeback
  ext4: advance i_disksize to i_size upon disksize-grow I/O completion
  ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
  ext4: submit and wait for disksize-grow I/O in fallocate paths
  ext4: clear DISKSIZE_GROW_PENDING on truncate or error
  ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
  ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
  ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
  ext4: partially enable iomap for the buffered I/O path of regular
    files
  ext4: introduce a mount option for iomap buffered I/O path

 fs/ext4/ext4.h              |   83 ++-
 fs/ext4/ext4_jbd2.c         |    8 +-
 fs/ext4/ext4_jbd2.h         |    7 +-
 fs/ext4/extents.c           |   51 +-
 fs/ext4/file.c              |   20 +-
 fs/ext4/ialloc.c            |    1 +
 fs/ext4/inode.c             | 1174 +++++++++++++++++++++++++++++++----
 fs/ext4/migrate.c           |    2 +
 fs/ext4/move_extent.c       |   11 +
 fs/ext4/page-io.c           |  201 ++++++
 fs/ext4/super.c             |   38 +-
 include/trace/events/ext4.h |  207 ++++++
 12 files changed, 1658 insertions(+), 145 deletions(-)

-- 
2.52.0

