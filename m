From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 4.18
Date: Sun, 8 Jul 2018 01:02:21 -0400
Message-ID: <20180708050221.GA5947@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 4f2f76f751433908364ccff82f437a57d0e6e9b7:

  ext4: fix fencepost error in check for inode count overflow during resize (2018-05-25 12:51:25 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to a17712c8e4be4fa5404d20e9cd3b2b21eae7bc56:

  ext4: check superblock mapped prior to committing (2018-07-02 18:45:18 -0400)

----------------------------------------------------------------
Bug fixes for ext4; most of which relate to vulnerabilities where a
maliciously crafted file system image can result in a kernel OOPS or
hang.  At least one fix addresses an inline data bug could be
triggered by userspace without the need of a crafted file system
(although it does require that the inline data feature be enabled).

----------------------------------------------------------------
Jon Derrick (1):
      ext4: check superblock mapped prior to committing

Theodore Ts'o (14):
      ext4: add warn_on_error mount option
      ext4: add corruption check in ext4_xattr_set_entry()
      ext4: always verify the magic number in xattr blocks
      ext4: always check block group bounds in ext4_init_block_bitmap()
      ext4: make sure bitmaps and the inode table don't overlap with bg descriptors
      ext4: only look at the bg_flags field if it is valid
      ext4: verify the depth of extent tree in ext4_find_extent()
      ext4: include the illegal physical block in the bad map ext4_error msg
      ext4: clear i_data in ext4_inode_info when removing inline data
      ext4: never move the system.data xattr out of the inode body
      jbd2: don't mark block as modified if the handle is out of credits
      ext4: avoid running out of journal credits when appending to an inline file
      ext4: add more inode number paranoia checks
      ext4: add more mount time checks of the superblock

 fs/ext4/balloc.c       | 21 +++++++++++++--------
 fs/ext4/ext4.h         |  9 +--------
 fs/ext4/ext4_extents.h |  1 +
 fs/ext4/extents.c      |  6 ++++++
 fs/ext4/ialloc.c       | 14 ++++++++++++--
 fs/ext4/inline.c       | 39 ++-------------------------------------
 fs/ext4/inode.c        |  7 ++++---
 fs/ext4/mballoc.c      |  6 ++++--
 fs/ext4/super.c        | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/xattr.c        | 40 ++++++++++++++++++----------------------
 fs/jbd2/transaction.c  |  9 ++++++++-
 11 files changed, 155 insertions(+), 96 deletions(-)
