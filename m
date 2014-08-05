From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug updates for 3.17
Date: Mon, 4 Aug 2014 23:11:32 -0400
Message-ID: <20140805031132.GA16323@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaHEDLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2014 23:11:35 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 86f0afd463215fc3e58020493482faa4ac3a4d69:

  ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct (2014-07-30 22:17:17 -0400)

----------------------------------------------------------------
Bug fixes and clean ups for the 3.17 merge window

----------------------------------------------------------------
Darrick J. Wong (1):
      ext4: check inline directory before converting

Dmitry Monakhov (3):
      ext4: add i_data_sem sanity check
      ext4: use correct depth value
      ext4: fix incorrect locking in move_extent_per_page

Lukas Czerner (1):
      ext4: fix punch hole on files with indirect mapping

Namjae Jeon (1):
      ext4: fix COLLAPSE RANGE test for bigalloc file systems

Theodore Ts'o (3):
      ext4: rearrange initialization to fix EXT4FS_DEBUG
      ext4: remove metadata reservation checks
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct

Xiaoguang Wang (1):
      ext4: fix wrong size computation in ext4_mb_normalize_request()

Zhang Zhen (1):
      ext4: remove readpage() check in ext4_mmap_file()

Zheng Liu (1):
      ext4: make ext4_has_inline_data() as a inline function

 fs/ext4/balloc.c      |   1 -
 fs/ext4/dir.c         |  25 ++++++
 fs/ext4/ext4.h        |  14 +++-
 fs/ext4/extents.c     |  14 ++--
 fs/ext4/file.c        |   4 -
 fs/ext4/indirect.c    | 281 +++++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/ext4/inline.c      |  18 +++--
 fs/ext4/inode.c       | 130 ++----------------------------
 fs/ext4/mballoc.c     |  41 ++++++----
 fs/ext4/migrate.c     |   7 ++
 fs/ext4/move_extent.c |   3 +-
 fs/ext4/super.c       |  88 +++++++++------------
 12 files changed, 333 insertions(+), 293 deletions(-)
