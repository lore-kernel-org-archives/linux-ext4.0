From: Sebastian Rasmussen <sebras@gmail.com>
Subject: [PATCH 0/3] e2fsprogs: Fixes typos in code and docs.
Date: Sat, 14 Oct 2017 20:44:53 +0200
Message-ID: <20171014184456.17602-1-sebras@gmail.com>
Cc: linux-ext4@vger.kernel.org, Sebastian Rasmussen <sebras@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43697 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdJNSpE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Oct 2017 14:45:04 -0400
Received: by mail-lf0-f68.google.com with SMTP id a16so12894492lfk.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Oct 2017 11:45:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While reading the manpage for resize2fs I came a across a typo,
so I fixed it along with other typos in user-visible error
messages and docs. The next patch addresses non-user visible
typos, i.e. in code comments or docs aimed at developers.

Finally, for completeness, I fixed any typos in changelogs and
release notes. Perhaps you prefer these old files to be kept
untouched, so that patch is separate.

Since this is my first patch to e2fsprogs, so please advice
me if I've made a mistake or two somewhere.

 / Sebastian

PS. When updating translations it is Swedish, not Sweedish. :)

Sebastian Rasmussen (3):
  Fix typos in error messages and documentation.
  Fix typos in code comments and developer docs.
  Fix historic typos in changelogs and release notes.

 INSTALL                            |   2 +-
 INSTALL.elfbin                     |   2 +-
 RELEASE-NOTES                      | 388 ++++++++++++++++++-------------------
 TODO                               |   4 +-
 aclocal.m4                         |   4 +-
 configure.ac                       |   6 +-
 contrib/add_ext4_encrypt.c         |   2 +-
 contrib/android/basefs_allocator.c |   2 +-
 contrib/android/perms.c            |   4 +-
 debian/changelog                   | 154 +++++++--------
 debian/rules                       |   2 +-
 debian/uuid-dev.README.Debian      |   4 +-
 debugfs/Makefile.in                |   2 +-
 debugfs/debugfs.8.in               |   2 +-
 debugfs/htree.c                    |   2 +-
 debugfs/logdump.c                  |   2 +-
 debugfs/set_fields.c               |   2 +-
 debugfs/util.c                     |   2 +-
 doc/libext2fs.texinfo              |  14 +-
 e2fsck/CHANGES                     |   2 +-
 e2fsck/e2fsck.conf.5.in            |   8 +-
 e2fsck/message.c                   |   2 +-
 e2fsck/pass1.c                     |   6 +-
 e2fsck/pass1b.c                    |   2 +-
 e2fsck/pass2.c                     |   4 +-
 e2fsck/pass3.c                     |   2 +-
 e2fsck/pass5.c                     |   2 +-
 e2fsck/problem.c                   |   6 +-
 e2fsck/problem.h                   |  10 +-
 e2fsck/recovery.c                  |   4 +-
 e2fsck/region.c                    |   2 +-
 e2fsck/revoke.c                    |   2 +-
 e2fsck/unix.c                      |   2 +-
 e2fsck/util.c                      |   2 +-
 ext2ed/README                      |   6 +-
 ext2ed/dir_com.c                   |   2 +-
 ext2ed/disk.c                      |   4 +-
 ext2ed/doc/ext2ed-design.sgml      |  12 +-
 ext2ed/doc/ext2fs-overview.sgml    |   8 +-
 ext2ed/doc/user-guide.sgml         |   6 +-
 ext2ed/ext2.descriptors            |   2 +-
 ext2ed/ext2ed.conf.in              |   4 +-
 ext2ed/ext2ed.h                    |   4 +-
 ext2ed/general_com.c               |   4 +-
 ext2ed/init.c                      |   8 +-
 ext2ed/main.c                      |  10 +-
 intl/dcigettext.c                  |   2 +-
 intl/l10nflist.c                   |   2 +-
 intl/libgettext.h                  |   2 +-
 intl/xsize.h                       |   2 +-
 lib/blkid/dev.c                    |   2 +-
 lib/blkid/libblkid.3.in            |   2 +-
 lib/blkid/probe.h                  |   2 +-
 lib/blkid/tag.c                    |   2 +-
 lib/e2p/e2p.pc.in                  |   2 +-
 lib/et/com_err.texinfo             |   4 +-
 lib/et/com_right.c                 |   2 +-
 lib/et/test_cases/heimdal2.c       |   2 +-
 lib/et/test_cases/heimdal2.et      |   2 +-
 lib/ext2fs/Makefile.in             |   2 +-
 lib/ext2fs/alloc_tables.c          |   2 +-
 lib/ext2fs/bb_inode.c              |   2 +-
 lib/ext2fs/bitops.c                |   2 +-
 lib/ext2fs/blkmap64_rb.c           |   2 +-
 lib/ext2fs/ext2_fs.h               |   4 +-
 lib/ext2fs/ext2fs.h                |   4 +-
 lib/ext2fs/ext3_extents.h          |   2 +-
 lib/ext2fs/get_pathname.c          |   2 +-
 lib/ext2fs/inline_data.c           |   8 +-
 lib/ext2fs/inode.c                 |   2 +-
 lib/ext2fs/nt_io.c                 |   8 +-
 lib/ext2fs/rbtree.h                |   2 +-
 lib/ext2fs/res_gdt.c               |   2 +-
 lib/ext2fs/tdb.c                   |  14 +-
 lib/ext2fs/undo_io.c               |   2 +-
 lib/ss/ct_c.sed                    |   4 +-
 lib/support/profile.c              |   2 +-
 lib/support/profile_helpers.c      |   2 +-
 lib/support/quotaio.h              |   2 +-
 lib/support/quotaio_tree.h         |   2 +-
 lib/uuid/gen_uuid_nt.c             |   2 +-
 lib/uuid/uuid_compare.3.in         |   2 +-
 lib/uuid/uuid_generate.3.in        |   4 +-
 misc/Makefile.in                   |   2 +-
 misc/chattr.1.in                   |   2 +-
 misc/create_inode.c                |   2 +-
 misc/e2image.c                     |   2 +-
 misc/e4crypt.c                     |   2 +-
 misc/e4defrag.c                    |   4 +-
 misc/findsuper.c                   |   4 +-
 misc/fsck.c                        |   2 +-
 misc/fsck.h                        |   2 +-
 misc/logsave.c                     |   2 +-
 misc/mke2fs.8.in                   |   2 +-
 misc/mke2fs.c                      |   2 +-
 misc/mke2fs.conf.5.in              |   2 +-
 misc/tune2fs.h                     |   4 +-
 resize/extent.c                    |   2 +-
 resize/main.c                      |   2 +-
 resize/online.c                    |   2 +-
 resize/resize2fs.8.in              |   2 +-
 resize/resize2fs.c                 |  14 +-
 resize/resize2fs.h                 |   2 +-
 resize/sim_progress.c              |   2 +-
 resize/test_extent.c               |   2 +-
 util/gen-tarball.in                |   2 +-
 util/subst.c                       |   2 +-
 util/symlinks.c                    |   2 +-
 108 files changed, 451 insertions(+), 451 deletions(-)

-- 
2.14.2
