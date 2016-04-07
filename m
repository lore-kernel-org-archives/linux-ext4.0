From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.6
Date: Thu, 7 Apr 2016 14:36:27 -0400
Message-ID: <20160407183627.GA2369@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 243d50678583100855862bc084b8b307eea67f68:

  Merge branch 'overlayfs-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs (2016-03-22 13:11:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to c325a67c72903e1cc30e990a15ce745bda0dbfde:

  ext4: ignore quota mount options if the quota feature is enabled (2016-04-03 17:03:37 -0400)

----------------------------------------------------------------
These changes contains a fix for overlayfs interacting with some
(badly behaved) dentry code in various file systems.  These have been
reviewed by Al and the respective file system mtinainers and are going
through the ext4 tree for convenience.

This also has a few ext4 encryption bug fixes that were discovered in
Android testing (yes, we will need to get these sync'ed up with the
fs/crypto code; I'll take care of that).  It also has some bug fixes
and a change to ignore the legacy quota options to allow for xfstests
regression testing of ext4's internal quota feature and to be more
consistent with how xfs handles this case.

----------------------------------------------------------------
Dan Carpenter (1):
      ext4 crypto: fix some error handling

Filipe Manana (1):
      btrfs: fix crash/invalid memory access on fsync when using overlayfs

Jan Kara (1):
      ext4: retry block allocation for failed DIO and DAX writes

Miklos Szeredi (4):
      fs: add file_dentry()
      nfs: use file_dentry()
      ext4: use dget_parent() in ext4_file_open()
      ext4: use file_dentry()

Theodore Ts'o (7):
      ext4: check if in-inode xattr is corrupted in ext4_expand_extra_isize_ea()
      ext4 crypto: don't let data integrity writebacks fail with ENOMEM
      ext4 crypto: use dget_parent() in ext4_d_revalidate()
      ext4: allow readdir()'s of large empty directories to be interrupted
      ext4: add lockdep annotations for i_data_sem
      ext4: avoid calling dquot_get_next_id() if quota is not enabled
      ext4: ignore quota mount options if the quota feature is enabled

 fs/btrfs/file.c        |  2 +-
 fs/dcache.c            |  5 ++++-
 fs/ext4/crypto.c       | 49 +++++++++++++++++++++++++++++--------------------
 fs/ext4/dir.c          |  5 +++++
 fs/ext4/ext4.h         | 29 +++++++++++++++++++++++++++--
 fs/ext4/file.c         | 12 ++++++++----
 fs/ext4/inode.c        | 58 ++++++++++++++++++++++++++++------------------------------
 fs/ext4/move_extent.c  | 11 +++++++++--
 fs/ext4/namei.c        |  5 +++++
 fs/ext4/page-io.c      | 14 +++++++++++++-
 fs/ext4/readpage.c     |  2 +-
 fs/ext4/super.c        | 61 +++++++++++++++++++++++++++++++++++++++++++++++--------------
 fs/ext4/xattr.c        | 32 ++++++++++++++++++++++++++++----
 fs/nfs/dir.c           |  6 +++---
 fs/nfs/inode.c         |  2 +-
 fs/nfs/nfs4file.c      |  4 ++--
 fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
 include/linux/dcache.h | 10 ++++++++++
 include/linux/fs.h     | 10 ++++++++++
 19 files changed, 264 insertions(+), 86 deletions(-)
