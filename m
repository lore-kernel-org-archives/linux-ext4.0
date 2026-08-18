Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E003D6479
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 04:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787028272; cv=none; b=LJY9JMu7I4Tt6ghUFgJ3tdARFhmMwcb8eWheKg2Hkho2SxNv/xThG+e0bL34/sudNR4i8O3lxHFkfVKI7qe1qfsAiJNr3XiImztWFIJt03t7RkiRnYOWxQwxqTyoE3mjE0uKkkE5u/2mVyZSH7Owha85aM/ymaO1uZFR4sm7a2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787028272; c=relaxed/simple;
	bh=ZKzl8vcw/3q6c+JOUPZqprzUo4AILywdzoBsnPUcXDs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=k0c+yLAWHspBOcWyde0JahfToFFZpEGmnXARV2oV9RbZ7s9wpPWmY2Y7cIeExrwJsZZHAKBZCqWEhlQNhcpMPkiHszAp3OGpEQOC0Lyh33zma5ZIja/BUMn5Xl3E2nkJUX9RqJ6Bz6B7Jh1snnRA2AiujXwXJ0F4W7KMFLHQrIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=SxNq4ORn; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="SxNq4ORn"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67I4iJfD006909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 00:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1787028261; bh=RSkhsBMFXdUgxRsn7aitxLaArKxB6LzMKXTJj90c2Hc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=SxNq4ORnmHwFx5oGlG3w1k/2qjMIjPGJml2gl0PSrRlMZUANFTu8rI/NyzbZHMAVs
	 3MSUNj8QH5PcwnATjfu8Z+Fjd90DCnl7g4dLXBIcEdJQYI+61KebRaHIY3emuBLwmg
	 NP1Ok2MI4nhqA45J0GP2MCfcU93UxHxe66TvhlPvYwLuamPKkHwwKD7JYttOe2y2zj
	 qawKSbX87JCvf4At4Bz9j1o6ffbyk80OKeWpoy/IHhQjvv69sV4Qt32U0NJF1SfemX
	 1Sag8QQsVSqSLauI1LuXXRKDiZzeE9mG9+ee/emB8cCeq4Hg/uU5txVYNmYTs/zz8R
	 LxHlVY0oSz0JA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 088CEF6C772; Tue, 18 Aug 2026 00:43:19 -0400 (EDT)
Date: Tue, 18 Aug 2026 00:43:18 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] ext4 changes for 7.3-rc1
Message-ID: <aoPivgtbvFQk6aYD@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc1

for you to fetch changes up to 9091c97be34083587a75db174aab51551d8e8543:

  ext4: fix estimate extent index blocks in ext4_ext_index_trans_blocks() (2026-08-06 22:52:28 -0400)

----------------------------------------------------------------
Various ext4 updates for 7.3-rc1, including:

* Improve performance by allowing parallel DIO writes when we were
  previously being overly conservative when checking whether it was safe
  to avoid requiring an exclusive lock
* Improve the performance of ext4_mb_prefetch() used by fallocate() by
  avoiding work when it is not needed
* Remove the unnecessary custom end_io function ext4_end_buffer_io_sync()
* Improve performance when performing an overwrite to an already uptodate folio
* Clean up how we handle deallocating EA inodes to avoid a potential
  lock ordering issue when there is a failed mount while an EA inode is
  still being evicted.
* Use str_plural() instead of a custom macro
* Avoid soft lockups or RCU stalls if there are many busy buffers
  (caused by heavy I/O) while checkpointing
* Use scoped NOFS when starting a handle in nojournal mode
* Align fields in handle structure to optimize setting and getting
  the h_type and h_line_no fields
* Fix documentation of the meta_bg block group layout
* Bug fixes, including
   - Fix a potential out-of-bounds read in ext4_read_inline_dir()
   - Fix a potential deadlock when concurrent xattr operations are racing
     with each other when some of the xattrs are using the ea_inode feature.
   - Fix a spurious warning with data=journal that can be triggered when
     writeback races with remounting the file system read-only
   - Fix a potential deadlock when EXT4_IOC_MIGRATE races with a file system
     freeze operation
   - Make sure all in-flight direct I/O operations are complete before
     falling back to buffered I/O.
   - Handle IOCB_NOWAIT properly when performing a extending DAX write
   - Prevent potentially sleeping on a block allocation when
     IOCB_NOWAIT is set
   - Fix potential races when racing an inline data write with a page fault
   - Propagate errors when adding or removing extent ranges
     during a fast commit replay
   - Avoid trying to expand an inode's extra size when it is being
     evicted to avoid a number of corner case or deadlocks
   - Avoid spurious error when retrying inode extra size expansion
   - Fix corner cases where we underestimate the number of journal
     credits needed
   - Avoid hangs/crashes/WARNINGS caused by maliciously corrupted
     file systems
   - Don't issue spurious orphan clean message on RO file systems
   - Avoid leaving the file system in an inconsistent state after a
     crash when a WRITE_ZEROS in progress converting an unwritten
     extent to a written extent
   - Handle WRITE_ZEROS correctly when there are some partially dirtied
     regions in the page cache
   - Pass errors during zero-rage, truncate, or punch hole to the caller
     if ext4_get_block() fails
   - Wait for writeback to finish when triggered by zero-range or
     zero-range for those devices that require stable writes
   - If the reserved gid superblock field is set, set the reserved gid
     instead of the reserved uid

----------------------------------------------------------------
Aditya Prakash Srivastava (3):
      ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
      ext4: use fsdata to track inline data write state and fix race
      ext4: cleanup unused CONVERT_INLINE_DATA flag

Baokun Li (9):
      ext4: reject mount if clusters/inodes per group are not 8-aligned
      ext4: reduce max cluster size to match documented 256MB limit
      ext4: reject mount if inodes per group is not a multiple of inodes per block
      ext4: prevent sleeping allocation in NOWAIT write path
      ext4: drain in-flight DIO before buffered write fallback
      ext4: skip overwrite check for aligned non-extending DIO writes
      ext4: base unaligned DIO lock decision on partial block zeroing
      ext4: use kiocb_modified instead of file_modified in DIO/DAX write path
      ext4: fix NOWAIT semantic violation in DAX extending writes

Bohdan Trach (2):
      ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
      ext4: get ext4_group_desc in ext4_mb_prefetch only when necessary

Eric Biggers (1):
      ext4: don't enable DAX on new encrypted files

Gerald Yang (1):
      ext4: clear stale xarray tags on folios skipped during writeback

Guanghui Yang (3):
      ext4: propagate errors from fast commit range replay
      ext4: clear error before retrying inode xattr space fallback
      ext4: fix buffer_head leak in ext4_init_orphan_info

Jan Kara (4):
      ext4: fix spurious message about orphan cleanup on RO fs
      ext4: teach ext4_meta_trans_blocks() about number of allocated extents
      ext4: fix transaction overflow during writeback
      ext4: fix estimate extent index blocks in ext4_ext_index_trans_blocks()

Jia Zhu (2):
      buffer: avoid tail commit walk for uptodate folios
      ext4: avoid tail write_begin walk for uptodate folios

Jiazi Liu (1):
      ext4: fix incorrect function call when initializing s_resgid

Joshua Crofts (1):
      ext4: use str_plural() instead of custom macro

Junzhe Yu (1):
      ext4: guard against NULL s_group_info in ext4_get_group_info

Matthew Wilcox (Oracle) (1):
      ext4: remove ext4_end_buffer_io_sync()

Matthias Goergens (1):
      ext4: stop retrying saturated xattr cache entries

Max Kellermann (2):
      jbd2: check need_resched() when skipping busy checkpoint buffers
      jbd2: bound shrinker scans by examined checkpoint buffers

Theodore Ts'o (2):
      ext4: enable scoped NOFS when starting a handle in nojournal mode
      jbd2: align h_type and h_line_no in the handle structure on byte boundaries

Xiang Mei (2):
      ext4: fix out-of-bounds read in ext4_read_inline_dir()
      ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()

Yao Kai (1):
      ext4: validate readdir offset before accessing dirent

Yun Zhou (8):
      ext4: fix circular lock dependency in ext4_ext_migrate
      ext4: skip extra isize expansion during mount to prevent deadlock
      ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
      ext4: introduce ext4_put_ea_inode() for safe deferred iput
      ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
      ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
      fs: add iput_if_not_last() helper
      ext4: validate EA inode i_nlink in ext4_xattr_inode_iget

Zhang Yi (10):
      ext4: use FGP_WRITEBEGIN for tail block zeroing
      ext4: skip tail block zeroing for inline data files
      ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
      ext4: move partial block zeroing earlier in ext4_zero_range()
      ext4: clarify return semantics of ext4_load_tail_bh()
      ext4: track partial-zero outcome per edge in ext4_zero_partial_blocks()
      ext4: zero out whole block for clean edges in WRITE_ZEROES
      ext4: write back partial-zeroed edges in WRITE_ZEROES
      ext4: export converted block count from ext4_convert_unwritten_extents()
      ext4: protect WRITE_ZEROES written extents with orphan list

dardaoe (1):
      Documentation: ext4: fix block_group layout when meta_bg is enabled

 Documentation/filesystems/ext4/group_descr.rst |   9 +-
 fs/buffer.c                                    |   3 +
 fs/ext4/balloc.c                               |   4 +
 fs/ext4/crypto.c                               |  40 ++---
 fs/ext4/dir.c                                  |  20 ++-
 fs/ext4/ext4.h                                 |  40 +++--
 fs/ext4/ext4_jbd2.c                            |  36 +++--
 fs/ext4/ext4_jbd2.h                            |   6 +-
 fs/ext4/extents.c                              | 182 +++++++++++++++++-----
 fs/ext4/fast_commit.c                          |  37 ++---
 fs/ext4/file.c                                 | 151 +++++++++++++------
 fs/ext4/ialloc.c                               |   4 +
 fs/ext4/inline.c                               |  38 +++--
 fs/ext4/inode.c                                | 207 +++++++++++++++++++-------
 fs/ext4/mballoc.c                              |  21 +--
 fs/ext4/migrate.c                              |   3 +-
 fs/ext4/namei.c                                |   2 +
 fs/ext4/orphan.c                               |  17 ++-
 fs/ext4/super.c                                |  32 +++-
 fs/ext4/xattr.c                                | 178 +++++++++++-----------
 fs/ext4/xattr.h                                |   9 +-
 fs/jbd2/checkpoint.c                           |  28 ++--
 fs/jbd2/journal.c                              |   1 +
 include/linux/fs.h                             |  15 ++
 include/linux/jbd2.h                           |  11 +-
 25 files changed, 734 insertions(+), 360 deletions(-)
