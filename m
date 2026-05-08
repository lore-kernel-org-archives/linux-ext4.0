Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857F62CCC5;
	Fri,  8 May 2026 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242566; cv=none; b=n0ucO8XsbowQAYR4vt9fEhoBaOR0fffh1elmjTF4xswiHx+OTCh4eYRDqyRLwepZmvTsZvXwv02l7XLkdKVlHG83JXzcI4uTRVCJoipFO1se1FVRSJqB069GyEM6nN894P5MsoMe/aWNVTm5Mn63BkR0dEY5zCKndHH4sYznfxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242566; c=relaxed/simple;
	bh=falxqjSgtJU5OoekjSpFJgMDwQOEwt8+hPtuMlLhPX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TuTKO0VD3ABhp957pQLzipP9ATjBuAzMuNgtW8DgPzugny0XmwEsgXWCABkgnZAMLEy6TbAz0FSGQ3bFsIRLTBVo2Jd4dSFfE4nCGoVLAiEUHs9SyDAFOC8vkptqhS7ZIRTeac3JhZM4dECLwrmizVFk2NrnIFzDaqpmRsHuO3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TbGA0pz8; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TbGA0pz8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242559; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NWVI2Pca5vyUf9CuT4wxOcKQk4fg2U6TvmcqynkakJw=;
	b=TbGA0pz8pwVkATazJqlnTZT8o5/ajwsv7w+K75VoAHbfIBgJtiY/uzd7e/N7PiPmZz97bxxWdTfoFNDBE43sd/TChxyd6VeCSP+rw4YVfx2U8UFjBAsLXa54DiZYdfQ4q1kCISR6k2/AOks4WR4szIk/idnroa6CAanYNzDpYps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgm8_1778242552;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgm8_1778242552 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:15:59 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	ardb@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH RFC 00/17] ext4/lib-crc: LBS performance part 1 - incremental CRC32c for bitmap checksums
Date: Fri,  8 May 2026 20:15:22 +0800
Message-ID: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Motivation
==========

In [1] we added large block size (LBS) support to ext4.  After enabling
LBS we observed several performance bottlenecks:

  1. Checksum computation (bitmap, extent block, dir block) becomes
     significantly more expensive as the block size grows.
  2. Free-bit searches (_find_next_bit) over large bitmaps become costly.

CRC32c is linear over GF(2), so when a contiguous range of bits in a
buffer is flipped the new checksum can be derived from the old one
without re-scanning the entire buffer:

    New_CRC = Old_CRC ^ CRC(flip_mask << trailing_bits)

This series introduces crc32c_flip_range() in lib/crc and applies it to
ext4's inode and block bitmap checksum paths, reducing checksum overhead
from O(N) to O(log N) per update.

For dir blocks and extent blocks, each modification touches a 12-264
byte region; by computing the CRC of the modified region before and
after the change we can derive the delta to the overall checksum.  A
crc32c_splice() API implementing this approach has been developed
locally and will be posted shortly.

For the _find_next_bit bottleneck under LBS, a per-block-group free
space rb-tree can accelerate lookups.  A local prototype exists and is
still being tested; feedback and alternative approaches are welcome.

[1]: https://lore.kernel.org/all/20251121090654.631996-1-libaokun@huaweicloud.com

Benchmark (full roadmap projection)
====================================

Single-process sequential fallocate of 64K blocks.  All throughput
values are in GB/s; percentages in parentheses show improvement over
the unpatched baseline.  "+crc_splice" and "+free_space_tree" columns
show expected gains from follow-up series (not included here).

  * Blocks per group up to 65528 (default e2fsprogs limit)
   +--------+---------+-----------------+-----------------+---------------------+
   | Blksz  | Before  | +crc_flip_range | +crc_splice     | +free_space_tree    |
   +--------+---------+-----------------+-----------------+---------------------+
   | 1k     | 14.9    | 15.0 (+0.7%)    | 15.2 (+2.0%)    | 15.3 (+2.7%)        |
   | 2k     | 17.5    | 17.8 (+1.7%)    | 18.2 (+4.0%)    | 18.7 (+6.9%)        |
   | 4k     | 16.8    | 17.4 (+3.6%)    | 18.3 (+8.9%)    | 18.4 (+9.5%)        |
   | 8k     | 15.5    | 16.5 (+6.5%)    | 18.3 (+18.1%)   | 18.2 (+17.4%)       |
   | 16k    | 12.6    | 13.2 (+4.8%)    | 15.9 (+26.2%)   | 15.9 (+26.2%)       |
   | 32k    | 8.99    | 9.60 (+6.8%)    | 12.3 (+36.8%)   | 12.5 (+39.0%)       |
   | 64k    | 8.24    | 8.54 (+3.6%)    | 14.0 (+69.9%)   | 19.4 (+135%)        |
   +--------+---------+-----------------+-----------------+---------------------+

  * Blocks per group up to 524288 (e2fsprogs limit lifted)
   +--------+---------+-----------------+-----------------+---------------------+
   | Blksz  | Before  | +crc_flip_range | +crc_splice     | +free_space_tree    |
   +--------+---------+-----------------+-----------------+---------------------+
   | 1k     | 15.0    | 14.9 (-0.7%)    | 15.5 (+3.3%)    | 15.6 (+4.0%)        |
   | 2k     | 17.4    | 17.7 (+1.7%)    | 17.9 (+2.9%)    | 18.2 (+4.6%)        |
   | 4k     | 16.7    | 17.3 (+3.6%)    | 18.4 (+10.2%)   | 18.7 (+12.0%)       |
   | 8k     | 15.7    | 16.4 (+4.5%)    | 19.1 (+21.7%)   | 19.3 (+22.9%)       |
   | 16k    | 13.5    | 15.4 (+14.1%)   | 18.7 (+38.5%)   | 19.0 (+40.7%)       |
   | 32k    | 9.64    | 12.3 (+27.6%)   | 17.7 (+83.5%)   | 17.7 (+83.5%)       |
   | 64k    | 2.84    | 3.17 (+11.6%)   | 3.48 (+22.5%)   | 19.8 (+597%)        |
   +--------+---------+-----------------+-----------------+---------------------+

Patch Overview
==============

  * Patches 1-3 (lib/crc): Introduce crc32c_flip_range() with O(log N)
    complexity using precomputed GF(2) shift matrices and nibble-indexed
    lookup tables (~9.8KB, fits in L1 cache).  Add kunit tests and
    benchmarks.

  * Patch 4: Fix incorrect free clusters accounting when allocated blocks
    overlap with filesystem metadata on a corrupted filesystem.

  * Patches 5-7: Extract block bitmap checksum helpers, add the
    incremental update wrapper ext4_block_bitmap_csum_set_range(), and
    use it in ext4_mb_mark_context().

  * Patches 8-10: Extract inode bitmap checksum helpers, add
    ext4_inode_bitmap_csum_set_fast(), and use it in ext4_free_inode().

  * Patch 11: Fix missing bg_used_dirs_count update during fast commit
    replay.

  * Patches 12-13: Factor out ext4_might_init_block_bitmap() and merge
    bitmap modification with GDP update under a single group lock in
    ext4_mark_inode_used(), eliminating a race window.

  * Patches 14-15: Rename 'ino' to 'bit' in __ext4_new_inode() for
    clarity, then merge bitmap modification and GDP update under a
    single group lock with incremental CRC.

  * Patches 16-17: Extract ext4_update_inode_group_desc() and
    ext4_get_flex_group() helpers to reduce code duplication.

Testing
=======

"kvm-xfstests -c ext4/all -g auto" has been executed with no new failures.

crc32c_flip_range() micro-benchmark on Intel Xeon (Ice Lake) with
CRC32c hardware acceleration:

  bitmap:      1024  2048  4096  8192  16384  32768  65536
  flip(ns):      48    53    57    63     68     73     78
  full(ns):      45    88   182   357    709   1421   2853
  speedup:     0.9x  1.6x  3.1x  5.6x  10.3x  19.3x  36.3x

Comments and questions are, as always, welcome.

Thanks,
Baokun


Baokun Li (17):
  lib/crc: add crc32c_flip_range() for incremental CRC update
  lib/crc: crc_kunit: add kunit test for crc32c_flip_range()
  lib/crc: crc_kunit: add benchmark for crc32c_flip_range()
  ext4: fix incorrect block bitmap free clusters update on metadata
    overlap
  ext4: extract block bitmap checksum get and store helpers
  ext4: add ext4_block_bitmap_csum_set_range() for incremental checksum
    update
  ext4: use fast incremental CRC update in ext4_mb_mark_context()
  ext4: extract inode bitmap checksum get and store helpers
  ext4: add ext4_inode_bitmap_csum_set_fast() for incremental checksum
    update
  ext4: use fast incremental CRC update in ext4_free_inode()
  ext4: fix missing bg_used_dirs_count update in fast commit replay
  ext4: factor out ext4_might_init_block_bitmap() helper
  ext4: use fast incremental CRC update in ext4_mark_inode_used()
  ext4: rename ino to bit in __ext4_new_inode()
  ext4: use fast incremental CRC update in __ext4_new_inode()
  ext4: extract ext4_update_inode_group_desc() to reduce duplication
  ext4: add ext4_get_flex_group() helper to simplify flex group lookups

 fs/ext4/bitmap.c                | 109 ++++++++--
 fs/ext4/ext4.h                  |  15 +-
 fs/ext4/fast_commit.c           |  13 +-
 fs/ext4/ialloc.c                | 343 ++++++++++++++------------------
 fs/ext4/mballoc.c               |  28 ++-
 fs/ext4/resize.c                |   4 +-
 fs/ext4/super.c                 |   4 +-
 include/linux/crc32.h           |  25 +++
 lib/crc/.gitignore              |   2 +
 lib/crc/Makefile                |  13 +-
 lib/crc/crc32c-incr.c           | 140 +++++++++++++
 lib/crc/gen_crc32c_incr_table.c | 141 +++++++++++++
 lib/crc/tests/crc_kunit.c       | 137 +++++++++++++
 13 files changed, 746 insertions(+), 228 deletions(-)
 create mode 100644 lib/crc/crc32c-incr.c
 create mode 100644 lib/crc/gen_crc32c_incr_table.c

-- 
2.43.7

