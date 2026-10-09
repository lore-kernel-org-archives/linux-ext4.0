Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A081A4ACC9B;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542250; cv=none; b=sLNtqoYZ1ytYvj9MwGQIN9DR7iPWeMGz/8MidgGB4hkm7+KDESImTAoQBZ8KbslCAoCw+u+vVoSonLOENUB6JuHFqlACzacRkVi2kyveADR7iq33dscXf3ZEM/6zE6NAO7QL2Pxs3TXtHy2BM7gzpC/QXzdHw8p/bCOmHaBZJFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542250; c=relaxed/simple;
	bh=hSGpi235DQGSGAvGqnG6v8VbyzNR5Q57Og3zcf8NXrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EGWusR4wI8SWz3EZptq5Wib/1f4K14JQvL6ThIvbTOCPPkBkoLs6063L0O9fEjtlqAR1A9wAOlJWcqORhohMaDdesW6BNR+gzkf6FmTdMRX8ahvQW0Pe/jMQ/A7Tl2Dt+kB0h0g2mjuSKYO7o5/n96+nDX4QM1lBkeaHzArQZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZV50NVzYQv2k;
	Fri,  9 Oct 2026 18:36:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DE5AB40574;
	Fri,  9 Oct 2026 18:37:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S4;
	Fri, 09 Oct 2026 18:37:18 +0800 (CST)
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
Subject: [PATCH v7 00/31] ext4: use iomap for regular file's buffered I/O path
Date: Fri,  9 Oct 2026 18:30:01 +0800
Message-ID: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S4
X-Coremail-Antispam: 1UD129KBjvAXoW3CF4DGr43Kr4kCw4fJw13urg_yoW8Jry5Co
	WSva1Uur1UAry5JFZakFWDCr47J3s2kr1fArW8WrykGF92qF47GayxC3y3Gay3Gw4Fyr43
	J34UA3W2gF4DJF1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRRKZX5UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi all,

This is v7 of the series converting ext4's buffered I/O path from
buffer_head to iomap. This iteration doesn't have significant changes
since v6. It just fixes bugs pointed out by Sashiko, improves commit
messages and comments to prevent false positives from Sashiko as well
as some small optimizations. Rebased on 7.3-rc4 (93f51579e7df). Besides,
I noticed that my V6 has already been merged into the ext4 dev branch.
If you'd like me to send separate follow-up patches, just let me know.

You can get commits here:

 https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v7/

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

This is a patch set that fixes this issue and is awaiting upstream:

 https://lore.kernel.org/linux-mm/20260928120833.3440834-1-yi.zhang@huaweicloud.com/

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


Changes since v6:
 - Rebased on 7.3-rc4 (93f51579e7df).
 - Collects RVB labels from Ojaswin.
 - Drop patch 03 "ext4: skip ordered I/O wait when zeroing beyond
   i_disksize block" in v6, since this optimization is not safe under
   concurrent writeback and file extending.
 - In patch 06, add comments about passing empty @handle parameter for
   ext4_map_blocks() and simplify the error return paths.
 - In patch 07, add missing check_block_validity() while returning
   unwritten blocks.
 - In patch 08, explicitly handle the newly added zero return value from
   ext4_map_blocks() when meeting a hole during block allocation in
   mpage_map_one_extent().
 - Add patch 14, ensure there are enough credits for unwritten extents
   to unwritten extents conversion on the iomap writeback completion
   path.
 - In patch 15, add retry limitation on block allocation during
   writeback.
 - In patch 19, add printing of the pblk for the file mapping.
 - In patch 21, use clear_and_wake_up_bit() instead of open coding.
 - In patch 22, Optimize the pending I/O writeback logic for the
   blocksize < PAGE_SIZE case, to avoid an unnecessary separate
   submission when the writeback range and the pending range are in the
   same page. (Ojaswin)
 - In patch 25, fix the issue where i_disksize is not updated when
   performing a block-aligned zero range in synchronous mode.
 - In patch 27, check disksize when setting the DISKSIZE_GROW_PENDING bit
   because we drop the previous optimization in ext4_block_zero_eof() in
   patch 03 (v6), we need a reliable i_disksize when setting this bit.
 - In patch 28, only emit the wait disksize pending trace when the bit is
   actually set.
 - Improve commit messages in patches 04, 13 and 26 to prevent false
   positives from Sashiko.

v6:     https://lore.kernel.org/linux-ext4/20260903123543.2302999-1-yi.zhang@huaweicloud.com/
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
  ext4: rework handle credit accounting for unwritten extent conversion
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
 fs/ext4/extents.c           |  105 ++-
 fs/ext4/file.c              |   20 +-
 fs/ext4/ialloc.c            |    1 +
 fs/ext4/inode.c             | 1194 +++++++++++++++++++++++++++++++----
 fs/ext4/migrate.c           |    2 +
 fs/ext4/move_extent.c       |   11 +
 fs/ext4/page-io.c           |  201 ++++++
 fs/ext4/super.c             |   38 +-
 include/trace/events/ext4.h |  209 ++++++
 12 files changed, 1715 insertions(+), 164 deletions(-)

-- 
2.52.0

