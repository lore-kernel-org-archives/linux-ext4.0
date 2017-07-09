From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.13
Date: Sat, 8 Jul 2017 22:52:30 -0400
Message-ID: <20170709025230.wveh6ch6m24djr7r@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 67a7d5f561f469ad2fa5154d2888258ab8e6df7c:

  ext4: fix fdatasync(2) after extent manipulation operations (2017-05-29 13:24:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to ff95015648df445999c8483270905f7d3dec51e1:

  ext4: fix spelling mistake: "prellocated" -> "preallocated" (2017-07-06 15:28:45 -0400)

----------------------------------------------------------------
The first major feature for ext4 this merge window is the largedir
feature, which allows ext4 directories to support over 2 billion
directory entries (assuming ~64 byte file names; in practice, users
will run into practical performance limits first.)  This feature was
originally written by the Lustre team, and credit goes to Artem
Blagodarenko from Seagate for getting this feature upstream.

The second major major feature allows ext4 to support extended
attribute values up to 64k.  This feature was also originally from
Lustre, and has been enhanced by Tahsin Erdogan from Google with a
deduplication feature so that if multiple files have the same xattr
value (for example, Windows ACL's stored by Samba), only one copy will
be stored on disk for encoding and caching efficiency.

We also have the usual set of bug fixes, cleanups, and optimizations.

----------------------------------------------------------------
Alexander Potapenko (1):
      fs: generic_block_bmap(): initialize all of the fields in the temp bh

Andreas Dilger (1):
      ext4: xattr-in-inode support

Artem Blagodarenko (1):
      ext4: add largedir feature

Chao Yu (1):
      ext4: check return value of kstrtoull correctly in reserved_clusters_store

Colin Ian King (1):
      ext4: fix spelling mistake: "prellocated" -> "preallocated"

Daeho Jeong (1):
      ext4: send parallel discards on commit completions

Darrick J. Wong (1):
      ext4: fix off-by-one fsmap error on 1k block filesystems

Eric Biggers (3):
      ext4: forbid encrypting root directory
      ext4: don't bother checking for encryption key in ->mmap()
      ext4: require key for truncate(2) of encrypted file

Jan Kara (1):
      ext4: avoid unnecessary stalls in ext4_evict_inode()

Khazhismel Kumykov (1):
      ext4: return EIO on read error in ext4_find_entry

Tahsin Erdogan (34):
      ext4: fix lockdep warning about recursive inode locking
      ext4: lock inode before calling ext4_orphan_add()
      ext4: do not set posix acls on xattr inodes
      ext4: attach jinode after creation of xattr inode
      ext4: ea_inode owner should be the same as the inode owner
      ext4: call journal revoke when freeing ea_inode blocks
      ext4: fix ref counting for ea_inode
      ext4: extended attribute value size limit is enforced by vfs
      ext4: change ext4_xattr_inode_iget() signature
      ext4: clean up ext4_xattr_inode_get()
      ext4: add missing le32_to_cpu(e_value_inum) conversions
      ext4: ext4_xattr_value_same() should return false for external data
      ext4: fix ext4_xattr_make_inode_space() value size calculation
      ext4: fix ext4_xattr_move_to_block()
      ext4: fix ext4_xattr_cmp()
      ext4: fix credits calculation for xattr inode
      ext4: retry storing value in external inode with xattr block too
      ext4: ext4_xattr_delete_inode() should return accurate errors
      ext4: improve journal credit handling in set xattr paths
      ext4: modify ext4_xattr_ino_array to hold struct inode *
      ext4: move struct ext4_xattr_inode_array to xattr.h
      mbcache: make mbcache naming more generic
      ext2, ext4: make mb block cache names more explicit
      ext4: add ext4_is_quota_file()
      ext4: cleanup transaction restarts during inode deletion
      ext4: xattr inode deduplication
      quota: add get_inode_usage callback to transfer multi-inode charges
      ext4: reserve space for xattr entries/names
      ext4: eliminate xattr entry e_hash recalculation for removes
      ext4: strong binding of xattr inode references
      ext4: add nombcache mount option
      ext4: change fast symlink test to not rely on i_blocks
      ext4: skip ext4_init_security() and encryption on ea_inodes
      ext4: fix __ext4_new_inode() journal credits calculation

Theodore Ts'o (1):
      ext4: return EFSBADCRC if a bad checksum error is found in ext4_find_entry()

 fs/buffer.c                    |    8 +-
 fs/crypto/policy.c             |    1 +
 fs/ext2/ext2.h                 |    2 +-
 fs/ext2/super.c                |   16 +-
 fs/ext2/xattr.c                |   48 +-
 fs/ext4/acl.c                  |   21 +-
 fs/ext4/ext4.h                 |   63 ++-
 fs/ext4/ext4_jbd2.h            |   23 +-
 fs/ext4/extents.c              |    3 +-
 fs/ext4/file.c                 |    7 -
 fs/ext4/fsmap.c                |    4 +
 fs/ext4/ialloc.c               |   76 ++-
 fs/ext4/indirect.c             |    3 +-
 fs/ext4/inline.c               |    2 +-
 fs/ext4/inode.c                |   92 ++--
 fs/ext4/ioctl.c                |   10 +-
 fs/ext4/mballoc.c              |  145 ++++--
 fs/ext4/mballoc.h              |    6 +-
 fs/ext4/migrate.c              |    2 +-
 fs/ext4/move_extent.c          |    2 +-
 fs/ext4/namei.c                |  131 ++++--
 fs/ext4/super.c                |  109 ++++-
 fs/ext4/sysfs.c                |    2 +-
 fs/ext4/xattr.c                | 1771 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 fs/ext4/xattr.h                |   35 +-
 fs/mbcache.c                   |   52 +-
 fs/quota/dquot.c               |   16 +-
 include/linux/fscrypt_common.h |    3 +
 include/linux/mbcache.h        |   11 +-
 include/linux/quota.h          |    2 +
 30 files changed, 2117 insertions(+), 549 deletions(-)
