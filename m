From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.17
Date: Wed, 4 Apr 2018 09:51:57 -0400
Message-ID: <20180404135157.GA20723@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to e40ff213898502d299351cc2fe1e350cd186f0d3:

  ext4: force revalidation of directory pointer after seekdir(2) (2018-04-01 23:21:03 -0400)

----------------------------------------------------------------
Cleanups and bugfixes for ext4, including some fixes to make ext4 more
robust against maliciously crafted file system images.  (I still don't
recommend that container folks hold any delusions that mounting
arbitary images that can be crafted by malicious attackers should be
considered sane thing to do, though!)

----------------------------------------------------------------
Eric Biggers (1):
      ext4: limit xattr size to INT_MAX

Eric Sandeen (1):
      ext4: don't complain about incorrect features when probing

Eryu Guan (2):
      ext4: protect i_disksize update by i_data_sem in direct write path
      ext4: update i_disksize if direct write past ondisk size

Goldwyn Rodrigues (1):
      ext4: use generic_writepages instead of __writepage/write_cache_pages

Jiri Slaby (1):
      ext4: fix offset overflow on 32-bit archs in ext4_iomap_begin()

Nikolay Borisov (1):
      ext4: remove EXT4_STATE_DIOREAD_LOCK flag

Theodore Ts'o (15):
      ext4: add tracepoints for shutdown and file system errors
      jbd2: clarify bad journal block checksum message
      ext4: shutdown should not prevent get_write_access
      ext4: eliminate sleep from shutdown ioctl
      ext4: pass -ESHUTDOWN code to jbd2 layer
      jbd2: if the journal is aborted then don't allow update of the log tail
      ext4: don't update checksum of new initialized bitmaps
      ext4: add validity checks for bitmap block numbers
      ext4: fail ext4_iget for root directory if unallocated
      ext4: always initialize the crc32c checksum driver
      ext4: don't allow r/w mounts if metadata blocks overlap the superblock
      ext4: move call to ext4_error() into ext4_xattr_check_block()
      ext4: add bounds checking to ext4_xattr_find_entry()
      ext4: add extra checks to ext4_xattr_block_get()
      ext4: force revalidation of directory pointer after seekdir(2)

Tyson Nottingham (6):
      ext4: null out kobject* during sysfs cleanup
      ext4: remove unused parameters in sysfs code
      ext4: simplify kobject usage
      ext4: show more binary mount options in procfs
      ext4: omit init_itable=n in procfs when disabled
      ext4: don't show data=<mode> option if defaulted

zhenwei.pi (1):
      ext4: fix comments in ext4_swap_extents()

 fs/ext4/balloc.c            |  19 +++++++--
 fs/ext4/dir.c               |   8 ++--
 fs/ext4/ext4.h              |  17 ---------
 fs/ext4/ext4_jbd2.c         |   7 ----
 fs/ext4/extents.c           |  23 ++++-------
 fs/ext4/ialloc.c            |  54 +++++---------------------
 fs/ext4/inode.c             |  42 +++++++-------------
 fs/ext4/ioctl.c             |  13 ++-----
 fs/ext4/move_extent.c       |   4 --
 fs/ext4/super.c             |  65 ++++++++++++++++++++-----------
 fs/ext4/sysfs.c             |  72 ++++++++++++----------------------
 fs/ext4/xattr.c             | 121 +++++++++++++++++++++++++++++++++-------------------------
 fs/ext4/xattr.h             |  11 ++++++
 fs/jbd2/journal.c           |  30 +++++++++++----
 fs/jbd2/recovery.c          |   4 +-
 include/trace/events/ext4.h |  43 +++++++++++++++++++++
 16 files changed, 269 insertions(+), 264 deletions(-)
