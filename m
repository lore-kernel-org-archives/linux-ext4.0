Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9169430FC1A
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787619; cv=none; b=PwCv3LJnwa+20iCBGVCASWbn7LZQCrSBGcfKOh9apG3nWZvX6CFAJILGIMsi6xOLx7kcNWGz3G4dqC3jApWikyv0E53trllXvJQoTeDk8UFJ7/SS28XqExTY/PRqH25e1L/tmT/IFVjWUaXS0pmnzxC/hQ/Cp0vr0R05L+8ZNd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787619; c=relaxed/simple;
	bh=C9VwVVAIC87BALFIB26HsMCHw2km0VZd0AYByMtDNno=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g1MTTNkp0u8nQMKDh4njKohXEC18W6Sm25eJ4FOTV39oa2T6HJ4neX1CDVVhRTFcW7PFQn6Ss1CSa9/Q04N9QjAoBK00DfA2UZj5+US930dc5nJ1VQ2BFlvkTn5H2pDmVBbChKIIxqFrx3A9Ho4ouRyP+Et1HTNJ4T5Vuc98u48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CHkp6wPT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CHkp6wPT"
Received: from trampoline.thunk.org (pool-173-48-112-62.bstnma.fios.verizon.net [173.48.112.62])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65ID01Fd018723
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 09:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781787604; bh=hq3ZjnHxbr/R5UiNYSKdDmQfEmNOHC49mE2XplW0Sss=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CHkp6wPT9J1yiic7r7QAvfHt5HsUKrBmubsc0nm6MbknsTDjXz/uOcps6v24lGdiN
	 X2xByNrw4sgR3h7mGMepEUo6ZQuERMqR7ItH7sh3t+QGKiFoBvk2pDJp8V5pL7ZCFL
	 179cVBgqFm83y8OOelOjhYwBcn9nQekA1HkkOdOak5sDAplrL7nSpliWkPfVKclEPJ
	 jPsSV9nOioN1jQUUl6krN8MqjhSZYbpVO+9HTs4CCiOXqDC3N18RzHSaqkvpGTbYuU
	 cJnBVm8zREeacLXFLhME0Jy2YtuH/XkwuWiB0YATMPShbM69KT9jumJi20iNUv2Gze
	 Wn4he/BrXIY+w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id CED382E2AAC; Thu, 18 Jun 2026 09:00:01 -0400 (EDT)
Date: Thu, 18 Jun 2026 09:00:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] ext4 changes for 7.2-rc1
Message-ID: <ajPrqTd4FaxlpYPs@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 5200f5f493f79f14bbdc349e402a40dfb32f23c8:

  Linux 7.1-rc4 (2026-05-17 13:59:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.2-rc1

for you to fetch changes up to c143957520c6c9b5cd72e0de8b52b814f0c576fe:

  ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT (2026-06-10 10:53:50 -0400)

----------------------------------------------------------------
Various ext4 updates for 7.2-rc1:

* A major rework of the fast commit mechanism to avoid lock
  contention and deadlocks.  We also export snapshot statistics
  in /proc/fs/ext4/*/fc_info.
* Performance optimization for directory hash computation by
  processing input in 4-byte chunks and removing function pointers,
  along with new KUnit tests for directory hash.
* Cleanups in JBD2 to remove special slabs and use kmalloc() instead.
* Various bug fixes, including:
   - Early validation of donor superblock in EXT4_IOC_MOVE_EXT to avoid
     cross-fs deadlock
   - Fix for a kernel BUG in ext4_write_inline_data_end under
     data=journal
   - Fix for a NULL dereference in jbd2_journal_dirty_metadata when
     handle is aborted
   - Fix for an underflow in JBD2 fast commit block initialization check
   - Fix for LOGFLUSH shutdown ordering to ensure ordered data writeback
   - Miscellaneous fixes for error path return values and KUnit assertions.

----------------------------------------------------------------
Abdellah Ouhbi (1):
      ext4: Use %pe to print PTR_ERR()

Aditya Prakash Srivastava (1):
      ext4: fix kernel BUG in ext4_write_inline_data_end

Deepanshu Kartikey (1):
      jbd2: check for aborted handle in jbd2_journal_dirty_metadata()

Guan-Chun Wu (2):
      ext4: add Kunit coverage for directory hash computation
      ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers

Hongling Zeng (1):
      ext4: fix ERR_PTR(0) in ext4_mkdir()

Junrui Luo (1):
      jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()

Li Chen (8):
      ext4: fix fast commit wait/wake bit mapping on 64-bit
      ext4: fast commit: snapshot inode state before writing log
      ext4: lockdep: handle i_data_sem subclassing for special inodes
      ext4: fast commit: avoid waiting for FC_COMMITTING
      ext4: fast commit: avoid self-deadlock in inode snapshotting
      ext4: fast commit: avoid i_data_sem by dropping ext4_map_blocks() in snapshots
      ext4: fast commit: add lock_updates tracepoint
      ext4: fast commit: export snapshot stats in fc_info

Matthew Wilcox (Oracle) (2):
      ext4: remove mention of PageWriteback
      jbd2: remove special jbd2 slabs

Ryota Sakamoto (1):
      ext4: replace KUnit tests for memcmp() with KUNIT_ASSERT_MEMEQ()

Yun Zhou (1):
      ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT

Zhang Yi (1):
      ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback

 fs/ext4/Makefile            |   2 +-
 fs/ext4/ext4.h              |  93 ++++-
 fs/ext4/extents.c           |   4 +-
 fs/ext4/fast_commit.c       | 784 ++++++++++++++++++++++++++++++++---------
 fs/ext4/hash-test.c         | 567 +++++++++++++++++++++++++++++
 fs/ext4/hash.c              |  68 ++--
 fs/ext4/inode.c             |  54 ++-
 fs/ext4/ioctl.c             |  15 +-
 fs/ext4/mballoc-test.c      |   9 +-
 fs/ext4/namei.c             |   6 +-
 fs/ext4/page-io.c           |   2 +-
 fs/ext4/super.c             |  13 +-
 fs/jbd2/commit.c            |   8 +-
 fs/jbd2/journal.c           | 127 +------
 fs/jbd2/transaction.c       |  17 +-
 include/linux/jbd2.h        |   3 -
 include/trace/events/ext4.h |  61 ++++
 17 files changed, 1495 insertions(+), 338 deletions(-)
 create mode 100644 fs/ext4/hash-test.c
