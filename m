From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.36
Date: Fri, 06 Aug 2010 00:23:49 -0400
Message-ID: <E1OhETF-0005P6-7v@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0HFEXz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 00:23:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus, 

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the latest bug fixes and improvements for the 2.6.36 merge
window.

As you will see from the patch, there are a few files outside of the
ext4/jbd2 directories.  These were coordinated with the OCFS2 and XFS
folks.  In the case of XFS, there was a change made to the direct I/O
code by Christoph Hellwig which had to be coordinated with XFS and ext4
file systems.  So that we could do proper testing on both of our
respective trees, I thought we could best handle by simply having
exactly the same patch dropped into the XFS and ext4 trees, and that git
would handle the merging correctly.  As it turns out I was wrong
(although I'm a bit puzzled about why).

For that reason, the diff stat and the shortlog message below are were
taken between v2.6.35-rc3 and the 'next' branch.  In order to make the
the test merge with your upstream master work out correctly, without
some very confusing conflicts, I did a merge of 40e2e97 into the
for_linus branch.  This resulted in a conflict, which once I resolved,
turned into a resulted nothing showing up when I do a "git diff-tree -cc
HEAD".  (If you do a "git show bbe09ca" you'll see is a null merge with
no diffs.)  And you'll also see that diffs from commit 40e2e97 (from the
xfs tree) and 552ef80 (from the ext4 tree) are identical.

So by merging 40e2e97 into the for_linus tree, and manually assuring
that this merge was resolved by using the ext4 tree's chunks for
fs/ext4/inode.c, it makes the test merge with your upstream go smoothly.

Which is hopefully what you want.  If you want exactly what is shown
below, you can also pull the "next" branch, which omits the merge, and
then you can deal with the merge conflict by hand.  The results should
be the same either way.

Sorry for the confusion...

						- Ted

 fs/direct-io.c              |   26 ++--
 fs/ext4/acl.c               |    1 +
 fs/ext4/balloc.c            |    6 +-
 fs/ext4/block_validity.c    |    8 +-
 fs/ext4/dir.c               |   23 ++--
 fs/ext4/ext4.h              |  152 +++++++++++++++-----
 fs/ext4/ext4_jbd2.c         |   71 ++++++----
 fs/ext4/ext4_jbd2.h         |   56 ++++----
 fs/ext4/extents.c           |   18 +--
 fs/ext4/file.c              |    5 +-
 fs/ext4/ialloc.c            |    4 +-
 fs/ext4/inode.c             |  205 ++++++++++++++-------------
 fs/ext4/mballoc.c           |  153 ++++++++++----------
 fs/ext4/migrate.c           |    2 +-
 fs/ext4/move_extent.c       |   10 +-
 fs/ext4/namei.c             |   40 +-----
 fs/ext4/resize.c            |    8 +-
 fs/ext4/super.c             |  334 ++++++++++++++++++++++++++++++-------------
 fs/ext4/xattr.c             |    3 +-
 fs/jbd2/checkpoint.c        |   18 ++--
 fs/jbd2/commit.c            |   50 ++++---
 fs/jbd2/journal.c           |  121 ++++++++--------
 fs/jbd2/recovery.c          |   10 +-
 fs/jbd2/transaction.c       |  233 ++++++++++++++++++------------
 fs/ocfs2/aops.c             |    7 +-
 fs/ocfs2/journal.c          |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c |    7 +-
 fs/xfs/linux-2.6/xfs_aops.h |    2 +
 include/linux/fs.h          |    3 +-
 include/linux/jbd2.h        |   16 ++-
 include/trace/events/ext4.h |   20 ++-
 31 files changed, 949 insertions(+), 667 deletions(-)

Aditya Kali (1):
      ext4: Adding error check after calling ext4_mb_regular_allocator()

Amir G (1):
      ext4: Fix block bitmap inconsistencies after a crash when deleting files

Andi Kleen (1):
      ext4: remove initialized but not read variables

Christoph Hellwig (2):
      ext4: remove vestiges of nobh support
      direct-io: move aio_complete into ->end_io

Cyrill Gorcunov (1):
      ext4: Fix potential memory leak in ext4_fill_super

Dmitry Monakhov (1):
      ext4: force block allocation on quota_off

Eric Sandeen (6):
      ext4: allocate stripe-multiple IOs on stripe boundaries
      ext4: fix ext4_get_blocks references
      ext4: don't print scary messages for allocation failures post-abort
      jbd2: Make barrier messages less scary
      ext4: fix freeze deadlock under IO
      ext4: re-inline ext4_rec_len_(to|from)_disk functions

Jan Kara (3):
      ext4: update ctime when changing the file's permission by setfacl
      ext4: Always journal quota file modifications
      ext4: Fix dirtying of journalled buffers in data=journal mode

Jiaying Zhang (1):
      ext4: Support discard requests when running in no-journal mode

Joe Perches (1):
      ext4: Remove unnecessary casts of private_data

Theodore Ts'o (20):
      ext4: Clean up s_dirt handling
      ext4: Convert more i_flags references to use accessor functions
      ext4: Add new superblock fields reserved for the Next3 snapshot feature
      ext4: clean up ext4_abort() so __func__ is now implicit
      ext4: Enhance ext4_grp_locked_error() to take block and function numbers
      ext4: Pass line number to ext4_journal_abort_handle()
      ext4: Cleanup ext4_check_dir_entry so __func__ is now implicit
      ext4: Pass line numbers to ext4_error() and friends
      ext4: Save error information to the superblock for analysis
      ext4: Once a day, printk file system error information to dmesg
      ext4: Define s_jnl_backup_type in superblock
      ext4: fix potential NULL dereference while tracing
      jbd2: Remove __GFP_NOFAIL from jbd2 layer
      ext4: Don't error out the fs if the user tries to make a file too big
      ext4: check to make make sure bd_dev is set before dereferencing it
      ext4: drop inode from orphan list if ext4_delete_inode() fails
      ext4: Add mount options in superblock
      jbd2: Use atomic variables to avoid taking t_handle_lock in jbd2_journal_stop
      jbd2: Change j_state_lock to be a rwlock_t
      jbd2: Remove t_handle_lock from start_this_handle()

Toshiyuki Okajima (1):
      ext4: fix EFBIG edge case when writing to large non-extent file

jiayingz@google.com (Jiaying Zhang) (1):
      ext4: move aio completion after unwritten extent conversion

