From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Quota, ext2, ext3 and some other changes for
 2.6.33-rc1
Date: Thu, 10 Dec 2009 15:08:27 +0100
Message-ID: <20091210140826.GB3696@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZLKUpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 15:45:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for=
_linus

  to get:

Alexey Dobriyan (1):
      const: struct quota_format_ops

Alexey Fisher (2):
      ext2: Unify log messages in ext2
      ext3: Unify log messages in ext3

Christoph Hellwig (4):
      vfs: Implement proper O_SYNC semantics
      kill wait_on_page_writeback_range
      afs: remove manual O_SYNC handling
      ubifs: remove manual O_SYNC handling

Eric Sandeen (3):
      ext3: journal all modifications in ext3_xattr_set_handle
      ext3: Don't update the superblock in ext3_statfs()
      ext3: make "norecovery" an alias for "noload"

Jan Blunck (1):
      ext2: Explicitly assign values to on-disk enum of filetypes

Jan Kara (7):
      zisofs: Implement reading of compressed files when PAGE_CACHE_SIZ=
E > compress block size
      quota: Fix WARN_ON in lookup_one_len
      quota: Move definition of QFMT_OCFS2 to linux/quota.h
      quota: Implement quota format with 64-bit space and inode limits
      ext3: Support for vfsv1 quota format
      ext4: Support for 64-bit quota format
      ext3: Fix data / filesystem corruption when write fails to copy d=
ata

J=E9r=E9my Cochoy (1):
      ext2: fix comment in ext2_find_entry about return values

Roel Kluin (1):
      ext3: PTR_ERR return of wrong pointer in setup_new_group_blocks()

Stephen Hemminger (1):
      ext2: clear uptodate flag on super block I/O error

The diffstat is

 Documentation/filesystems/ext3.txt |    4 +-
 Documentation/filesystems/vfs.txt  |    2 +-
 arch/alpha/include/asm/fcntl.h     |   19 +-
 arch/blackfin/include/asm/fcntl.h  |    2 -
 arch/mips/include/asm/fcntl.h      |   17 +-
 arch/mips/kernel/kspd.c            |    1 +
 arch/mips/loongson/common/mem.c    |    2 +-
 arch/mips/mm/cache.c               |    2 +-
 arch/parisc/include/asm/fcntl.h    |    5 +-
 arch/sparc/include/asm/fcntl.h     |   19 +-
 arch/x86/mm/pat.c                  |    3 +-
 drivers/char/mem.c                 |    6 +-
 drivers/usb/gadget/file_storage.c  |    2 +-
 fs/afs/write.c                     |    8 -
 fs/btrfs/file.c                    |    4 +-
 fs/cifs/dir.c                      |    3 +-
 fs/cifs/file.c                     |    6 +-
 fs/ext2/dir.c                      |    4 +-
 fs/ext2/ext2.h                     |    2 +-
 fs/ext2/inode.c                    |    6 +-
 fs/ext2/super.c                    |  184 ++++++++-----
 fs/ext2/xip.c                      |    5 +-
 fs/ext3/inode.c                    |   18 +-
 fs/ext3/resize.c                   |    2 +-
 fs/ext3/super.c                    |  468 +++++++++++++++++-----------=
---
 fs/ext3/xattr.c                    |    7 +-
 fs/ext4/super.c                    |   30 ++-
 fs/isofs/compress.c                |  533 +++++++++++++++++++---------=
--------
 fs/isofs/rock.c                    |    3 +-
 fs/jbd2/commit.c                   |    2 +-
 fs/namei.c                         |    9 +
 fs/nfs/file.c                      |    4 +-
 fs/nfs/write.c                     |    2 +-
 fs/ocfs2/file.c                    |    2 +-
 fs/ocfs2/quota.h                   |    4 -
 fs/ocfs2/quota_local.c             |    2 +-
 fs/quota/Kconfig                   |    8 +-
 fs/quota/dquot.c                   |    2 +
 fs/quota/quota_v1.c                |    2 +-
 fs/quota/quota_v2.c                |  167 +++++++++---
 fs/quota/quotaio_v2.h              |   19 +-
 fs/sync.c                          |   13 +-
 fs/ubifs/file.c                    |   13 +-
 fs/xfs/linux-2.6/xfs_lrw.c         |    2 +-
 include/asm-generic/fcntl.h        |   25 ++-
 include/linux/ext2_fs.h            |   16 +-
 include/linux/ext3_fs.h            |    2 +
 include/linux/fs.h                 |    2 -
 include/linux/quota.h              |    6 +-
 mm/filemap.c                       |   49 +---
 sound/core/rawmidi.c               |    2 +-
 51 files changed, 1001 insertions(+), 719 deletions(-)

							Thanks
								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
