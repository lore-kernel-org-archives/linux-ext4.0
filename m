From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext3 improvements, cleanups, reiserfs fix
Date: Mon, 7 Apr 2014 23:49:30 +0200
Message-ID: <20140407214930.GA31152@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get various cleanups for ext2, ext3, udf, isofs, a documentation update
for quota, and a fix of a race in reiserfs readdir implementation.

Top of the tree is 01d8885785a6. The full shortlog is:

Dan Carpenter (2):
      ext3: remove unneeded check in ext3_ordered_writepage()
      ext3: remove an unneeded check in ext3_new_blocks()

Eric Sandeen (1):
      ext3: explicitly remove inode from orphan list after failed direct io

Fabian Frederick (6):
      fs: udf: parse_options: blocksize check
      udf: Add __init macro to init_inodecache
      ext2: Add __init macro to init_inodecache
      ext3: Add __init macro to init_inodecache
      fs/quota/Kconfig: Update filesystems
      fs/isofs/inode.c add __init to init_inodecache()

Jakub Sitnicki (1):
      ext2: acl: remove unneeded include of linux/capability.h

Jan Kara (3):
      ext3: Update PF_MEMALLOC handling in ext3_write_inode()
      ext3: Update outdated comment before ext3_ordered_writepage()
      ext3: Speedup WB_SYNC_ALL pass

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Rashika Kheria (3):
      fs: Mark function as static in ext2/xattr_security.c
      fs: Mark function as static in ext3/dir.c
      fs: Mark function as static in ext3/xattr_security.c

ZhangZhen (1):
      ext2/3: use prandom_u32() instead of get_random_bytes()

The diffstat is

 fs/ext2/acl.c            |  1 -
 fs/ext2/ialloc.c         |  2 +-
 fs/ext2/super.c          |  2 +-
 fs/ext2/xattr_security.c |  4 +--
 fs/ext3/balloc.c         |  5 +--
 fs/ext3/dir.c            |  2 +-
 fs/ext3/ialloc.c         |  2 +-
 fs/ext3/inode.c          | 86 ++++++++++++++----------------------------------
 fs/ext3/super.c          |  2 +-
 fs/ext3/xattr_security.c |  5 +--
 fs/isofs/inode.c         |  2 +-
 fs/quota/Kconfig         |  7 ++--
 fs/reiserfs/dir.c        |  6 ++--
 fs/udf/super.c           |  8 +++--
 14 files changed, 51 insertions(+), 83 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
