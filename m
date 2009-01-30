From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Fri, 30 Jan 2009 08:21:14 -0500
Message-ID: <E1LStJ4-0007DW-Gz@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36219 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZA3O4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jan 2009 09:56:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git fo=
r_linus

to grab regressions and bug fixes for ext4.  Nearly all of these are
-stable candidates once they hit mainline.  Thanks!!

   	     	       	   	       	   - Ted

Simon Holm Th=C3=B8gersen (1):
      ext4: fix wrong use of do_div

Thadeu Lima de Souza Cascardo (1):
      ext4: Fix building with EXT4FS_DEBUG

Theodore Ts'o (7):
      ext4: only use i_size_high for regular files
      ext4: Add sanity check to make_indexed_dir
      ext3: Add sanity check to make_indexed_dir
      jbd2: On a __journal_expect() assertion failure printk "JBD2", no=
t "EXT3-fs"
      ext4: Fix ext4_free_blocks() w/o a journal when files have indire=
ct blocks
      ext4: Initialize the new group descriptor when resizing the files=
ystem
      ext4: Remove bogus BUG() check in ext4_bmap()

 fs/ext3/namei.c      |   20 ++++++++++++++------
 fs/ext4/balloc.c     |    6 +++---
 fs/ext4/ext4.h       |    7 +++++--
 fs/ext4/extents.c    |    2 +-
 fs/ext4/inode.c      |    9 +++------
 fs/ext4/mballoc.c    |    2 +-
 fs/ext4/namei.c      |   21 +++++++++++++++------
 fs/ext4/resize.c     |    3 ++-
 fs/jbd2/journal.c    |    6 +++---
 include/linux/jbd2.h |    3 ++-
 10 files changed, 49 insertions(+), 30 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
