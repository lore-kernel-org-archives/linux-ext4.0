From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 3.15
Date: Sun, 20 Apr 2014 22:32:08 -0400
Message-ID: <nsx4n1nbefr.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51098 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaDUCcM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Apr 2014 22:32:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit d15e03104eb9a4f8e244ab6ed3ca5a107e46db13:

  Merge tag 'xfs-for-linus-3.15-rc1' of git://oss.sgi.com/xfs/xfs (2014-04-04 15:50:08 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 0a04b248532b358b27a8da050642da6f5f304b03:

  ext4: disable COLLAPSE_RANGE for bigalloc (2014-04-19 16:38:21 -0400)

----------------------------------------------------------------
These are regression and bug fixes for ext4.

We had a number of new features in ext4 during this merge window
(ZERO_RANGE and COLLAPSE_RANGE fallocate modes, renameat, etc.) so
there were many more regression and bug fixes this time around.  It
didn't help that xfstests hadn't been fully updated to fully stress
test COLLAPSE_RANGE until after -rc1.

----------------------------------------------------------------
Azat Khuzhin (2):
      ext4: initialize multi-block allocator before checking block descriptors
      ext4: fix ext4_count_free_clusters() with EXT4FS_DEBUG and bigalloc enabled

Chen Gang (1):
      ext4: fix 64-bit number truncation warning

Dmitry Monakhov (2):
      ext4: fix error handling in ext4_ext_shift_extents
      ext4: always check ext4_ext_find_extent result

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Lukas Czerner (10):
      ext4: remove unnecessary check for APPEND and IMMUTABLE
      fs: prevent doing FALLOC_FL_ZERO_RANGE on append only file
      fs: move falloc collapse range check into the filesystem methods
      fs: disallow all fallocate operation on active swapfile
      ext4: use truncate_pagecache() in collapse range
      ext4: use filemap_write_and_wait_range() correctly in collapse range
      ext4: fix removing status extents in ext4_collapse_range()
      ext4: no need to truncate pagecache twice in collapse range
      ext4: discard preallocations after removing space
      ext4: fix extent merging in ext4_ext_shift_path_extents()

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Namjae Jeon (3):
      ext4: fix COLLAPSE_RANGE test failure in data journalling mode
      ext4: fix COLLAPSE_RANGE failure with 1KB block size
      ext4: disable COLLAPSE_RANGE for bigalloc

Theodore Ts'o (6):
      ext4: update PF_MEMALLOC handling in ext4_write_inode()
      ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()
      ext4: use i_size_read in ext4_unaligned_aio()
      ext4: COLLAPSE_RANGE only works on extent-based files
      ext4: remove temporary shim used to merge COLLAPSE_RANGE and ZERO_RANGE
      ext4: use EINVAL if not a regular file in ext4_collapse_range()

Younger Liu (1):
      ext4: return ENOMEM rather than EIO when find_###_page() fails

Zheng Liu (1):
      ext4: fix byte order problems introduced by the COLLAPSE_RANGE patches

jon ernst (2):
      ext4: silence sparse check warning for function ext4_trim_extent
      ext4: enforce we are operating on a regular file in ext4_zero_range()

 fs/ceph/file.c              |   3 --
 fs/ext4/balloc.c            |   2 +-
 fs/ext4/ext4.h              |  17 -------
 fs/ext4/extents.c           | 109 ++++++++++++++++++++++++++++++-------------
 fs/ext4/extents_status.c    |   2 +-
 fs/ext4/file.c              |   2 +-
 fs/ext4/inode.c             |  53 +++++++++++----------
 fs/ext4/mballoc.c           |  18 +++++--
 fs/ext4/page-io.c           |   5 +-
 fs/ext4/super.c             |  51 ++++++++++----------
 fs/ext4/xattr.c             |  23 +++++++--
 fs/open.c                   |  21 ++++-----
 fs/xfs/xfs_file.c           |  10 +++-
 include/trace/events/ext4.h |   9 ----
 14 files changed, 188 insertions(+), 137 deletions(-)
