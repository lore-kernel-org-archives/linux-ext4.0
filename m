From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH 0 of 4] Check journal inode sanity and recreate journal
Date: Thu, 21 Jun 2007 13:00:07 -0400
Message-ID: <patchbomb.1182445207@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: kalpak@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55949 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbXFURBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:01:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi Kalpak,

        I've broken up your patch and rewritten portions of them to
clean them up.  As I've mentioned before, smaller patches are easier to
review and to cherry pick as necessary.

The changes from your patches are:

1) A smaller set of functionality (just returning the recommended
   default size of the journal) was moved into the library.  This
   eliminated the need to create a number of new libext2fs error codes,
   and it minimized the changes needed to tune2fs and mke2fs.

2) Your changes to sanity check the journal blocks beyond the location
   of the indirect blocks used journal_bmap(); unfortunately
   journal_bmap doesn't verify the validity of the indirect/double
   indirect blocks.  So, I rewrote the checks to use
   ext2fs_block_iterate() instead, which was designed for use by e2fsck.
   It basically was a (very) simplified version of check_blocks() from
   pass1.c.   Your patch also didn't remove the original code which just
   verified the direct blocks, which was no longer necessary, and
   performed the check after the backup blocks and be written out to the
   journal, instead of before deciding to overwrite the journal inode
   with the backup information from the superblock.

Regards,

                                        - Ted

11 files changed, 144 insertions(+), 39 deletions(-)
e2fsck/journal.c              |   67 ++++++++++++++++++++++++++++++-----------
e2fsck/problem.c              |    5 +++
e2fsck/problem.h              |    7 ++++
e2fsck/unix.c                 |   40 ++++++++++++++++++++++++
lib/ext2fs/ext2fs.h           |    1 
lib/ext2fs/mkjournal.c        |   20 ++++++++++++
misc/util.c                   |   23 +++-----------
tests/f_badjourblks/expect.1  |    8 ++++
tests/f_badjourblks/expect.2  |    2 -
tests/f_miss_journal/expect.1 |    8 ++++
tests/f_miss_journal/expect.2 |    2 -
