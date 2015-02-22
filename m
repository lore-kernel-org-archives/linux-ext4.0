From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.20-rc1
Date: Sun, 22 Feb 2015 18:01:04 -0500
Message-ID: <20150222230104.GA16515@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbBVXBH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Feb 2015 18:01:07 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 3b421b80be635d696848b72d3c7700a0e5ee3414:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2015-01-06 14:05:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 6f30b7e37a8239f9d27db626a1d3427bc7951908:

  ext4: fix indirect punch hole corruption (2015-02-14 20:08:51 -0500)

----------------------------------------------------------------
Ext4 bug fixes for 3.20.  We also reserved code points for encryption
and read-only images (for which the implementation is mostly just the
reserved code point for a read-only feature :-)

----------------------------------------------------------------
Darrick J. Wong (2):
      jbd2: complain about descriptor block checksum errors
      ext4: support read-only images

Eric Sandeen (2):
      ext4: remove duplicate remount check for JOURNAL_CHECKSUM change
      ext4: ignore journal checksum on remount; don't fail

Jan Mrazek (1):
      ext4: change to use setup_timer() instead of init_timer()

Omar Sandoval (1):
      ext4: fix indirect punch hole corruption

Theodore Ts'o (1):
      ext4: reserve codepoints used by the ext4 encryption feature

Xiaoguang Wang (1):
      ext4: fix mmap data corruption in nodelalloc mode when blocksize < pagesize

 fs/ext4/ext4.h     |  18 ++++++++---
 fs/ext4/indirect.c | 105 +++++++++++++++++++++++++++++++++++++++++--------------------
 fs/ext4/inode.c    |   7 +++++
 fs/ext4/super.c    |  31 ++++++++----------
 fs/jbd2/recovery.c |   3 ++
 5 files changed, 108 insertions(+), 56 deletions(-)
