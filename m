Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DCE2989BC
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776438876; cv=none; b=BBzlMZ9PBhW0OsUFozJwR/pp/tVa/1Ucu8GpGyV0T9L7iFHhvME/OXrG2PvaoJvHVp2C41QNgkblfQtI/hGZ7XApGNluY8YMUrRijZcpcJdjtmnTsr91n+25GrMwQb+I+mSxQaEo7YJB9XmQLl/gevpY+qQjs53aQYlzC+9ADgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776438876; c=relaxed/simple;
	bh=o0UJ+gc5WHEzlj1JkE/KZChTlTpklXU12GQ7rXrZVvY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pbft25AO/LfYOGkR1U75wNpnjQwtpBDluW8VJLv77R9ye3Y2W1SAdQwM+O8bcJtWgLmHD1yeVVXHdZmuIoOEGkkcPE44JyX5XhYGKWMEy+KSeQd3IEII5uxQeWYnf7nnhK0bossqDnyqsws/PD/LbOxOjVpDgxcdr5s0/qMqKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XD9EjQnp; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XD9EjQnp"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63HFENSw013891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 11:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776438864; bh=EKHVeJD9dY7hQy8W1IlIYquK7wolhNCE4s2J1NMSI9Y=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XD9EjQnpQWm7jPXVBmwAljneZJN2F3vOk5NDRO2PIHty7Z8S8X1kqi49N+PwNZleM
	 kg0ZogRxFoaXGK6TNMNTwt02FXGievegEh5zxflY/LBbiS1WVfo5WB3JttW93mCa6y
	 VA2OF4MIEbCecO9hK/bqky2dNWF4jcw5n2EdwPMnZcUlP4LtWmKvdm9Lrpp5GXNSkZ
	 rloibSruwESKhRrAbOEN6HjDwxg6RbPqqMVhtv/2A//1oNS3o3Xw11rMYD22k9sE50
	 Uiy9nlR++7it3jSeJMiwkEzvDMJj2EyN6iG7tgQDoEDbdkxagxYiPfA8uXXNjaJeQJ
	 I3k8h+AQ8Gq0g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3490B2E00D6; Fri, 17 Apr 2026 11:14:23 -0400 (EDT)
Date: Fri, 17 Apr 2026 11:14:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] ext4 changes for 7.1-rc1
Message-ID: <20260417151423.GA1808289@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9ee29d20aab228adfb02ca93f87fb53c56c2f3af:

  ext4: always drain queued discard work in ext4_mb_release() (2026-03-27 23:39:10 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linux-7.0-rc1

for you to fetch changes up to 981fcc5674e67158d24d23e841523eccba19d0e7:

  jbd2: fix deadlock in jbd2_journal_cancel_revoke() (2026-04-09 22:09:39 -0400)

----------------------------------------------------------------
Various clean ups and bug fixes in ext4 for 7.1:

  * Refactor code paths involved with partial block zero-out in
    prearation for converting ext4 to use iomap for buffered writes.
  * Remove use of d_alloc() from ext4 in preparation for the deprecation
    of this interface.
  * Replace some J_ASSERTS with a journal abort so we can avoid a kernel
    panic for a localized file system error
  * Simplify various code paths in mballoc, move_extent, and fast commit
  * Fix rare deadlock in jbd2_journal_cancel_revoke() that can be
    triggered by generic/013 when blocksize < pagesize.
  * Fix memory leak when releasing an extended attribute when its
    value is stored in an ea_inode
  * Fix various potential kunit test bugs in fs/ext4/extents.c
  * Fix potential out-of-bounds access in check_xattr() with a corrupted
    file system
  * Make the jbd2_inode dirty range tracking safe for lockless reads
  * Avoid a WARN_ON when writeback files due to a corrupted file system;
    we already print an ext4 warning indicatign that data will be lost,
    so the WARN_ON is not necessary and doesn't add any new information

----------------------------------------------------------------
David Laight (1):
      ext4: fix diagnostic printf formats

Deepanshu Kartikey (2):
      ext4: unmap invalidated folios from page tables in mpage_release_unused_pages()
      ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access

Guoqing Jiang (1):
      ext4: remove tl argument from ext4_fc_replay_{add,del}_range

Julia Lawall (1):
      ext4/move_extent: use folio_next_pos()

Li Chen (5):
      ext4: remove unused i_fc_wait
      jbd2: add jinode dirty range accessors
      ext4: use jbd2 jinode dirty range accessor
      ocfs2: use jbd2 jinode dirty range accessor
      jbd2: store jinode dirty range in PAGE_SIZE units

Milos Nikic (2):
      jbd2: gracefully abort instead of panicking on unlocked buffer
      jbd2: gracefully abort on transaction state corruptions

NeilBrown (3):
      ext4: split __ext4_add_entry() out of ext4_add_entry()
      ext4: add ext4_fc_eligible()
      ext4: move dcache manipulation out of __ext4_link()

Philipp Hahn (1):
      ext4: prefer IS_ERR_OR_NULL over manual NULL check

Sohei Koyama (1):
      ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()

Weixie Cui (1):
      ext4: simplify mballoc preallocation size rounding for small files

Ye Bin (5):
      ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
      ext4: call deactivate_super() in extents_kunit_exit()
      ext4: fix the error handling process in extents_kunit_init).
      ext4: fix possible null-ptr-deref in extents_kunit_exit()
      ext4: fix possible null-ptr-deref in mbt_kunit_exit()

Zhang Yi (14):
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
      jbd2: fix deadlock in jbd2_journal_cancel_revoke()

 fs/ext4/ext4.h         |  14 +--
 fs/ext4/extents-test.c |  60 +++++++---
 fs/ext4/extents.c      | 163 +++++++++++++-------------
 fs/ext4/fast_commit.c  |  89 ++++-----------
 fs/ext4/file.c         |  17 +++
 fs/ext4/inode.c        | 304 ++++++++++++++++++++++++++++++++-----------------
 fs/ext4/mballoc-test.c |   6 +-
 fs/ext4/mballoc.c      |  26 ++---
 fs/ext4/move_extent.c  |   4 +-
 fs/ext4/namei.c        |  48 ++++----
 fs/ext4/super.c        |  16 ++-
 fs/ext4/symlink.c      |   2 +-
 fs/ext4/xattr.c        |   6 +-
 fs/jbd2/commit.c       |  55 ++++++---
 fs/jbd2/journal.c      |   5 +-
 fs/jbd2/revoke.c       |   8 +-
 fs/jbd2/transaction.c  | 142 +++++++++++++++++------
 fs/ocfs2/journal.c     |   9 +-
 include/linux/jbd2.h   |  38 +++++--
 19 files changed, 628 insertions(+), 384 deletions(-)
