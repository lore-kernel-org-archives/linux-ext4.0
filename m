From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 0/4] e2image -b option to pass superblock number
Date: Mon,  4 Dec 2017 22:35:26 +0300
Message-ID: <20171204193530.54888-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38285 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdLDTfh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 14:35:37 -0500
Received: by mail-lf0-f68.google.com with SMTP id e137so20540116lfg.5
        for <linux-ext4@vger.kernel.org>; Mon, 04 Dec 2017 11:35:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There was a discussion about possibility of using
superblock backup for creating images with e2image.

https://www.spinics.net/lists/linux-ext4/msg30583.html

Now our customer faced with situation then it would be
useful to have image file from partition with broken
superblock.

Here is set of patches that adds this functionality.

This is third version of the patch set. Changes since v2:
* Moved ext2fs_try_open_fs() deletions
* automatically try to open the backup superblocks
* Options are sorted in alphabetical order
* run_e2fsck is used for test
* manual is added into the patch that adds this option

Artem Blagodarenko (4):
  ext2fs: opening filesystem code refactoring
  e2image: add -b option to use supperblock backup
  tests: add test for e2image -b option
  ext2fs: automaticlly open backup superblocks

 e2fsck/e2fsck.h             |   2 -
 e2fsck/message.c            |   3 +-
 e2fsck/unix.c               |  44 +++++--------
 e2fsck/util.c               |  73 ---------------------
 lib/ext2fs/ext2fs.h         |   8 +++
 lib/ext2fs/openfs.c         | 152 +++++++++++++++++++++++++++++++++++++++++++-
 misc/dumpe2fs.c             |  17 +----
 misc/e2image.8.in           |  32 ++++++++++
 misc/e2image.c              |  50 +++++++++++++--
 tests/i_zero_super/expect.1 |  22 +++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  11 ++++
 12 files changed, 288 insertions(+), 126 deletions(-)
 create mode 100644 tests/i_zero_super/expect.1
 create mode 100644 tests/i_zero_super/image.gz
 create mode 100644 tests/i_zero_super/script

-- 
2.13.6 (Apple Git-96)
