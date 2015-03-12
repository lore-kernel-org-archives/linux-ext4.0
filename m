From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 0/4] e2fsprogs: reserve more special inodes
Date: Thu, 12 Mar 2015 19:20:11 +0300
Message-ID: <20150312161341.17173.96760.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:46411 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbbCLQUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 12:20:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All reserved special inodes are used for various features (some of them
never been implemented in mainline). This patchset add option for reserving
more special inodes at mkfs time and option to reseze2fs for relocating
first inodes in existing filesystem and reserving them for special usage.

No changes in layout are required because index of first normal inode already
stored in superblock.

[ this is preparation for adding project quota feature ]

---

Konstantin Khlebnikov (4):
      resize2fs: allocate ext2_resize_t outside of resize_fs
      resize2fs: add option -I for reserving more special inodes
      mke2fs: add options extended option for changing first inode
      e2fsprogs: add test for mke2fs -E first_inode and resize2fs -I


 misc/mke2fs.8.in              |    8 +
 misc/mke2fs.c                 |   18 +++
 resize/main.c                 |   60 +++++++-
 resize/resize2fs.8.in         |    8 +
 resize/resize2fs.c            |   94 +++++++++----
 resize/resize2fs.h            |   10 +
 tests/r_resize_special/expect |  292 +++++++++++++++++++++++++++++++++++++++++
 tests/r_resize_special/name   |    1 
 tests/r_resize_special/script |   47 +++++++
 9 files changed, 497 insertions(+), 41 deletions(-)
 create mode 100644 tests/r_resize_special/expect
 create mode 100644 tests/r_resize_special/name
 create mode 100644 tests/r_resize_special/script

--
Signature
