From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [GIT PULL] ext4 update
Date: Mon, 25 Feb 2008 17:47:23 -0500
Message-ID: <E1JTm6V-00022E-0N@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52240 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761292AbYBYWsg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2008 17:48:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

To get a number of ext4 bug fixes for 2.6.25.

Thanks,

                                                - Ted

Akinobu Mita (1):
      ext4: add missing ext4_journal_stop()

Andi Kleen (1):
      Remove incorrect BKL comments in ext4

Aneesh Kumar K.V (8):
      ext4: Fix locking hierarchy violation in ext4_fallocate()
      ext4: Don't leave behind a half-created inode if ext4_mkdir() fails
      ext4: Fix memory and buffer head leak in callers to ext4_ext_find_extent()
      ext4: Get journal write access before modifying the extent tree
      ext4: Don't claim block from group which has corrupt bitmap
      ext4: Don't mark filesystem error if fallocate fails
      ext4: set EXT4_EXTENTS_FL only for directory and regular files
      ext4: ext4_find_next_zero_bit needs an aligned address on some arch

Mingming Cao (1):
      ext4: Fix BUG when writing to an unitialized extent

Theodore Ts'o (1):
      ext4: Don't use ext4_dec_count() if not needed

Valerie Clement (2):
      ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
      ext4: modify block allocation algorithm for the last group

 fs/ext4/dir.c                   |    2 +-
 fs/ext4/extents.c               |   59 +++++++++++++++++++---------
 fs/ext4/ialloc.c                |   22 +++++++---
 fs/ext4/inode.c                 |   56 +++++++++++++++++++++++++--
 fs/ext4/mballoc.c               |   80 +++++++++++++++++++++++++++------------
 fs/ext4/migrate.c               |    5 ++
 fs/ext4/namei.c                 |   18 +++-----
 fs/ext4/resize.c                |    1 +
 include/linux/ext4_fs_extents.h |    1 +
 9 files changed, 177 insertions(+), 67 deletions(-)
