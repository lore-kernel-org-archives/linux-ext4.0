From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 0/4] e2fsprogs: project quota
Date: Fri, 13 Mar 2015 19:00:06 +0300
Message-ID: <20150313155012.14281.80292.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44483 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbbCMQAL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 12:00:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Projects quota allows to enforce disk quota for several subtrees or eve=
n
individual files on the filesystem. Each inode is marked with project-i=
d
(independently from uid and gid) and accounted into corresponding proje=
ct
quota. New files inherits project id from directory where they are crea=
ted.

This patchset adds required support into mkfs, fsck, tune2fs, debugfs, =
chattr and lsattr.

All patches are available at github:
https://github.com/koct9i/linux --branch project
https://github.com/koct9i/e2fsprogs --branch project
https://github.com/koct9i/quota-tools --branch project

Ext4 layout
-----------

Project id introduce ro-compatible feature 'project'.

Inode project id is stored in place of obsolete field 'i_faddr' (that t=
rick was
suggested by Darrick J. Wong in previous discussions of project quota).
Linux never used that field and fsck checks that it contains zero.

Quota information is stored in reserved/special inode =E2=84=9611.
=46or symmetry with other quotas inode number is stored in superblock.

By default only 10 inodes are reserved for special usage.
After this patch mkfs will reserve 20 inodes if feature project is enab=
led.
I've add option to resize2fs to reserve more inodes in existing filests=
rem.
(See patchset [PATCH RFC v1 0/4] e2fsprogs: reserve more special inodes=
)

=46or now project quota supports only modern 'hidden' journaled mode.

---

Konstantin Khlebnikov (4):
      e2fsprogs: introduce project id feature
      e2fsprogs: add project quota support
      e2fsprogs: add tests for project quota
      e2fsprogs: add project id into lsattr and chattr


 debugfs/debugfs.c           |   40 ++++++++---
 debugfs/quota.c             |    8 +-
 debugfs/set_fields.c        |    4 +
 e2fsck/pass1.c              |   14 +++-
 e2fsck/pass2.c              |    3 +
 e2fsck/quota.c              |   11 +++
 e2fsck/unix.c               |   25 ++++---
 lib/e2p/Makefile.in         |    5 +
 lib/e2p/e2p.h               |    2 +
 lib/e2p/feature.c           |    2 +
 lib/e2p/ls.c                |    3 +
 lib/e2p/project.c           |   55 +++++++++++++++
 lib/ext2fs/ext2_fs.h        |   19 ++++-
 lib/ext2fs/ext2fs.h         |    3 +
 lib/ext2fs/swapfs.c         |    3 +
 lib/ext2fs/tst_inode_size.c |    2 -
 lib/ext2fs/tst_super_size.c |    3 +
 lib/quota/mkquota.c         |   42 ++++++++++--
 lib/quota/quotaio.c         |   23 ++++--
 lib/quota/quotaio.h         |    7 +-
 misc/chattr.1.in            |    7 ++
 misc/chattr.c               |   34 +++++++++
 misc/ext4.5.in              |    7 ++
 misc/lsattr.1.in            |    5 +
 misc/lsattr.c               |   19 +++++
 misc/mke2fs.8.in            |    5 +
 misc/mke2fs.c               |   26 ++++++-
 misc/tune2fs.8.in           |    9 ++
 misc/tune2fs.c              |   77 +++++++++++++++++++--
 tests/m_project/expect.1    |  156 +++++++++++++++++++++++++++++++++++=
++++++++
 tests/m_project/script      |    7 ++
 tests/t_project_1on/expect  |   66 ++++++++++++++++++
 tests/t_project_1on/name    |    1=20
 tests/t_project_1on/script  |   68 +++++++++++++++++++
 tests/t_project_2off/expect |   78 ++++++++++++++++++++++
 tests/t_project_2off/name   |    1=20
 tests/t_project_2off/script |   54 +++++++++++++++
 37 files changed, 821 insertions(+), 73 deletions(-)
 create mode 100644 lib/e2p/project.c
 create mode 100644 tests/m_project/expect.1
 create mode 100644 tests/m_project/script
 create mode 100644 tests/t_project_1on/expect
 create mode 100644 tests/t_project_1on/name
 create mode 100644 tests/t_project_1on/script
 create mode 100644 tests/t_project_2off/expect
 create mode 100644 tests/t_project_2off/name
 create mode 100644 tests/t_project_2off/script

--
Signature
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
