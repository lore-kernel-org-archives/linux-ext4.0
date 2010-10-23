From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 0/6] ext4: use the bio layer directly
Date: Sat, 23 Oct 2010 16:40:14 -0400
Message-ID: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47008 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0JWUk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 16:40:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This set of patches passes xfstests for both 1k and 4k block sizes.  For
streaming I/O writes, it reduces the number of block I/O queue
submissions by a factor of 1024 in the ideal case.  (i.e., instead of
submitting 4k requests at a time, we can now submit up to 512k writes at
a time, a 128 factor of improvement.)

Lockstat measurements by Eric Whitney show that the block I/O request
queue lock is the top cause of scalability problems in ext4:

	http://free.linux.hp.com/~enw/ext4/2.6.35/

This patch should resolve these issues, as well as reducing ext4's CPU
overhead for large buffered streaming writes by a significant amount.

	     	   	    	      	     - Ted

P.S.  In a recent e-mail to me, akpm commented that it was a little sad
that most modern filesystems don't like the core functions offered by
the VFS and "go it alone".  I'm of the strong belief that the fact that
ext4 was using as much of the "core functions" as it did was responsible
for why we lagged some of the other modern file systems on the FFSB
benchmark scores.  I wonder if it might be useful to consider taking
parts of fs/ext4/page-io.c and trying to make a higher level interface
that could be easily adopted by other basic filesytstems to improve
their performance.

To play devil's advocate for a moment, the fact that btrfs has special
needs because of its fs-level snapshots probably rules it out, and I'm
not sure this is something that would ever be of interest to XFS, since
they have something much more sophisticated.  And perhaps it doesn't
matter that much whether filesystems that exist primarily for
compatibility (hfs, vfat, etc.) need to have high
performance/scalability characteristics.

On the other hand, one nice thing about the fs/ext4/page-io.c interface
is that it should be relatively easy to take something which calls
block_write_full_page(), and change it to call what is today named
ext4_bio_write_page().  All it needs to do is pass a ext4_io_submit
structure to successive calls to ext4_bio_write_page(), and then call
(what today is named) ext4_io_submit() when it is done.  So minimal
changes to client file system code, and hopefully impressive
improvements in performance.

Just a thought....


Theodore Ts'o (6):
  ext4: call mpage_da_submit_io() from mpage_da_map_blocks()
  ext4: simplify ext4_writepage()
  ext4: inline ext4_writepage() into mpage_da_submit_io()
  ext4: inline walk_page_buffers() into mpage_da_submit_io
  ext4: move mpage_put_bnr_to_bhs()'s functionality to
    mpage_da_submit_io()
  ext4: use bio layer instead of buffer layer in mpage_da_submit_io

 fs/ext4/Makefile  |    2 +-
 fs/ext4/ext4.h    |   36 +++++-
 fs/ext4/extents.c |    4 +-
 fs/ext4/inode.c   |  432 +++++++++++++++++++----------------------------------
 fs/ext4/page-io.c |  426 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |    8 +-
 6 files changed, 624 insertions(+), 284 deletions(-)
 create mode 100644 fs/ext4/page-io.c

