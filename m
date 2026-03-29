Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCA134CF
	for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 04:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774760275; cv=none; b=F496P4xi/wwHtpZgzvNsdOVC+nc4K8KPPzFMUv2ItckPyRUjXn+SpGebmWaNmQE4ViO3TmFW5nDfjmp1k5UZ20i9/gChaUFvILu1EzXCV6d59peit5YifCH8OV5K0ToAPs+NaAVokREHxV13qAfgh9AtrsM5ZDuEpus0yxDAg64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774760275; c=relaxed/simple;
	bh=e5imEYik1/CVQSgR0Cz9kEJ99SrjN04D5/TnUHUKIOM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VfgX4dDxJqem1D56C5+re7NHj+pS6ZjZloYU7kuXlZHviIPv1dGK/6o0WmpRIQ2myX6o/gkgydJBwKyZaFZ8vVnMOGyp2Q3gjEkT9NbdEShvk/UGpavxNddqh+9uXcVZKxB3E+vAW068ibZ31HnjEkExWu8haV8DKZWIPgf1w8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=P5Ad3kwQ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="P5Ad3kwQ"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62T4vfUq001813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 29 Mar 2026 00:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774760263; bh=T1WOt+Xd2BaBdxbJ9VRwjRIW1brCuPE2iHU7rYIkpQ0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=P5Ad3kwQCS5BGX5Uu0wLTR02mkT8kEvaGz6MgBdGzhqg3StK3wozLoSCaT6c6SP4r
	 AEEiz1p/FPNuDV7bTE8pm4O54rfjC5VNyQ8arYeUe9pwzNwRYWqnxE7/BeaXVkDDQD
	 HKL1+lrb3soZtdLb09EUIKc3cNn1I7faxgW5i+yXgFhoR8veDKPIWJS4Xk0UAShy7m
	 QS8qIM/prz+3hTs2GeRQd1YIENvJFyqwFFAaknHTS8BKtd0TvQDKB8zTY169CIDu/C
	 yf3lCa0FLdbKgu/r8AWjCG3/4kvXZGsy4YmGIHYWTJVR+Uc4sI8dEKCj2mJIeJc2ZI
	 5Gzfr9un5tn6Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 40FD75FE352D; Sat, 28 Mar 2026 23:57:41 -0500 (CDT)
Date: Sat, 28 Mar 2026 23:57:41 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ext4 fixes for 7.0-rc6
Message-ID: <20260329045741.GA9694@Mac>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.0-rc6

for you to fetch changes up to 9ee29d20aab228adfb02ca93f87fb53c56c2f3af:

  ext4: always drain queued discard work in ext4_mb_release() (2026-03-27 23:39:10 -0400)

----------------------------------------------------------------
Update the MAINTAINERS file to add reviewers for the ext4 file system

Add a test issue an ext4 warning (not a WARN_ON) if there are still
dirty pages attached to an evicted inode.

A lot of ext4 bug fixes including:
   * Fix a number of Syzkaller issues.
   * Fix memory leaks on error paths.
   * Replace some BUG and WARN with EFSCORRUPTED reporting.
   * Fix a potential crash when disabling discard via remount followed
     by an immediate unmount.  (Found by Sashiko)
   * Fix a corner case which could lead to allocating blocks for an
     indirect-mapped inode block numbers > 2**32.
   * Fix a race when reallocating a freed inode that could result in
     a deadlock.
   * Fix a user-after-free in update_super_work when racing with umount.
   * Fix build issues when trying to build ext4's kunit tests as a module
   * Fix a bug where ext4_split_extent_zeroout() could fail to pass
     back an error from ext4_ext_dirty().
   * Avoid allocating blocks from a corrupted block group in
     ext4_mb_find_by_goal().
   * Fix a percpu_counters list corruption BUG triggered by an
     ext4 extents kunit.
   * Fix a potetial crash caused by the fast commit flush path potentially
     accessing the jinode structure before it is fully initialized.
   * Fix fsync(2) in no-journal mode to make sure the dirtied inode is
     write to storage.
   * Fix a bug when in no-journal mode, when ext4 tries to avoid using
     recently deleted inodes, if lazy itable initialization is enabled,
     can lead to an unitialized inode getting skipped and triggering
     an e2fsck complaint.
   * Fix journal credit calculation when setting an xattr when both
     the encryption and ea_inode feeatures are enabled.
   * Fix corner cases which could result in stale xarray tags after
     writeback.
   * Fix generic/475 failures caused by ENOSPC errors while creating
     a symlink when the system crashes resulting to a file system
     inconsistency when replaying the fast commit journal.

----------------------------------------------------------------
Baokun Li (1):
      ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths

Deepanshu Kartikey (1):
      ext4: convert inline data to extents when truncate exceeds inline size

Edward Adam Davis (1):
      ext4: avoid infinite loops caused by residual data

Helen Koike (1):
      ext4: reject mount if bigalloc with s_first_data_block != 0

Jan Kara (4):
      ext4: fix stale xarray tags after writeback
      ext4: make recently_deleted() properly work with lazy itable initialization
      ext4: fix fsync(2) for nojournal mode
      ext4: fix deadlock on inode reallocation

Jiayuan Chen (1):
      ext4: fix use-after-free in update_super_work when racing with umount

Li Chen (1):
      ext4: publish jinode after initialization

Milos Nikic (1):
      jbd2: gracefully abort on checkpointing state corruptions

Ojaswin Mujoo (1):
      ext4: minor fix for ext4_split_extent_zeroout()

Ritesh Harjani (IBM) (1):
      ext4: kunit: extents-test: lix percpu_counters list corruption

Simon Weber (1):
      ext4: fix journal credit check when setting fscrypt context

Tejas Bharambe (1):
      ext4: validate p_idx bounds in ext4_ext_correct_indexes

Theodore Ts'o (3):
      Update MAINTAINERS file to add reviewers for ext4
      ext4: handle wraparound when searching for blocks for indirect mapped blocks
      ext4: always drain queued discard work in ext4_mb_release()

Ye Bin (5):
      ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
      ext4: test if inode's all dirty pages are submitted to disk
      ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
      ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
      ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M

Yuto Ohnuki (1):
      ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio

Zhang Yi (1):
      ext4: do not check fast symlink during orphan recovery

Zqiang (1):
      ext4: fix the might_sleep() warnings in kvfree()

hongao (1):
      ext4: skip split extent recovery on corruption

 MAINTAINERS            |   7 ++-
 fs/ext4/Makefile       |   5 +-
 fs/ext4/crypto.c       |   9 +++-
 fs/ext4/ext4.h         |   6 +++
 fs/ext4/ext4_extents.h |  12 +++++
 fs/ext4/extents-test.c |  12 +++--
 fs/ext4/extents.c      |  80 +++++++++++++++++++++++++-----
 fs/ext4/fast_commit.c  |  17 ++++---
 fs/ext4/fsync.c        |  16 +++++-
 fs/ext4/ialloc.c       |   6 +++
 fs/ext4/inline.c       |  10 +++-
 fs/ext4/inode.c        |  75 ++++++++++++++++++++++------
 fs/ext4/mballoc-test.c |  81 +++++++++++++++---------------
 fs/ext4/mballoc.c      | 132 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/mballoc.h      |  30 +++++++++++
 fs/ext4/page-io.c      |  10 +++-
 fs/ext4/super.c        |  37 +++++++++++---
 fs/ext4/sysfs.c        |  10 +++-
 fs/jbd2/checkpoint.c   |  15 +++++-
 19 files changed, 455 insertions(+), 115 deletions(-)
