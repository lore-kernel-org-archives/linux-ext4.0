From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.12
Date: Sun, 11 Jun 2017 14:41:13 -0400
Message-ID: <20170611184113.tkkuofuvugkdb5dw@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 08332893e37af6ae779367e78e444f8f9571511d:

  Linux 4.12-rc2 (2017-05-21 19:30:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 67a7d5f561f469ad2fa5154d2888258ab8e6df7c:

  ext4: fix fdatasync(2) after extent manipulation operations (2017-05-29 13:24:55 -0400)

----------------------------------------------------------------
Fix various bug fixes in ext4 caused by races and memory allocation
failures.

----------------------------------------------------------------
Eric Biggers (3):
      ext4: fix off-by-one error when writing back pages before dio read
      ext4: remove unused d_name argument from ext4_search_dir() et al.
      ext4: remove redundant check for encrypted file on dio write path

Eryu Guan (1):
      ext4: fix off-by-one on max nr_pages in ext4_find_unwritten_pgoff()

Jan Kara (6):
      ext4: clear lockdep subtype for quota files on quota off
      ext4: fix SEEK_HOLE
      ext4: fix off-by-in in loop termination in ext4_find_unwritten_pgoff()
      ext4: fix data corruption with EXT4_GET_BLOCKS_ZERO
      ext4: fix data corruption for mmap writes
      ext4: fix fdatasync(2) after extent manipulation operations

Konstantin Khlebnikov (2):
      ext4: handle the rest of ext4_mb_load_buddy() ENOMEM errors
      ext4: keep existing extra fields when inode expands

Tahsin Erdogan (2):
      jbd2: preserve original nofs flag during journal restart
      ext4: fix quota charging for shared xattr blocks

 fs/ext4/acl.c            |  4 ++++
 fs/ext4/ext4.h           |  2 --
 fs/ext4/extents.c        | 85 ++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 fs/ext4/file.c           | 54 ++++++++++++++++--------------------------------------
 fs/ext4/inline.c         |  5 ++---
 fs/ext4/inode.c          | 30 ++++++++++++++++++++++--------
 fs/ext4/mballoc.c        | 23 ++++++++++++++---------
 fs/ext4/namei.c          | 13 +++++--------
 fs/ext4/super.c          | 17 ++++++++---------
 fs/ext4/xattr.c          |  8 ++++++++
 fs/jbd2/transaction.c    |  6 ++++++
 fs/quota/dquot.c         | 16 ++++++++++++++++
 include/linux/quotaops.h |  6 ++++++
 13 files changed, 149 insertions(+), 120 deletions(-)
