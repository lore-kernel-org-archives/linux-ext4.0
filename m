Return-Path: <SRS0=/7aD=PJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:46489 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfAAVIC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2019 16:08:02 -0500
Received: by mail-io1-f67.google.com with SMTP id v10so23264307ios.13
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2019 13:08:01 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca
Subject: [PATCH v6 0/4] e2image -b option to pass superblock number
Date: Tue,  1 Jan 2019 22:07:33 +0100
Message-Id: <20190101210737.87248-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There was a discussion about possibility of using
superblock backup for creating images with e2image.

https://www.spinics.net/lists/linux-ext4/msg30583.html

Now our customer faced with situation then it would be
useful to have image file from partition with broken
superblock.

Here is set of patches that adds this functionality.

This is 6th version of the patch set.

* If last superblock backup reading is finished with error
of accesing outside the disk, return previous error code.
Some minor code style and comments issues are fixed.

Artem Blagodarenko (4):
  ext2fs: opening filesystem code refactoring
  e2image: add -b and -B options to use supperblock backup
  tests: add test for e2image -b option
  ext2fs: automaticlly open backup superblocks

 e2fsck/e2fsck.h             |   2 -
 e2fsck/message.c            |   3 +-
 e2fsck/unix.c               |  42 ++++---------
 e2fsck/util.c               |  73 -----------------------
 lib/ext2fs/openfs.c         |  41 +++++++++++--
 lib/support/Makefile.in     |   8 ++-
 lib/support/sb_backup.c     | 140 ++++++++++++++++++++++++++++++++++++++++++++
 lib/support/sb_backup.h     |  20 +++++++
 misc/dumpe2fs.c             |  17 +-----
 misc/e2image.8.in           |  33 +++++++++++
 misc/e2image.c              |  50 ++++++++++++++--
 tests/i_zero_super/expect.1 |  22 +++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  11 ++++
 14 files changed, 330 insertions(+), 132 deletions(-)
 create mode 100644 lib/support/sb_backup.c
 create mode 100644 lib/support/sb_backup.h
 create mode 100644 tests/i_zero_super/expect.1
 create mode 100644 tests/i_zero_super/image.gz
 create mode 100644 tests/i_zero_super/script

-- 
2.14.3
