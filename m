From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 0/4] e2image -b option to pass superblock number
Date: Thu, 16 Nov 2017 16:55:42 +0300
Message-ID: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:53853 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935116AbdKPNzw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Nov 2017 08:55:52 -0500
Received: by mail-lf0-f66.google.com with SMTP id 73so15957611lfu.10
        for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2017 05:55:51 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There was a discussion about possibility of using
superblock backup for creating images with e2image.

https://www.spinics.net/lists/linux-ext4/msg30583.html

Now our customer faced with situation then it would be
useful to have image file from partition with broken
superblock.

Here is set of patches that adds this functionality.

This is the second version of the patch set. Changes since v1:
* code style fixes
* moving common code to ext2fs_open2
* added  "-B blocksize" option
* fixes in test script

Artem Blagodarenko (4):
  ext2fs: opening filesystem code refactoring
  e2image: add -b option to use supperblock backup
  tests: add test for e2image -b option
  man: add -b option to e2image

 e2fsck/unix.c               |  28 +++-------------------------
 lib/ext2fs/openfs.c         |  36 +++++++++++++++++++++++++++++++++++-
 misc/dumpe2fs.c             |  17 +++--------------
 misc/e2image.8.in           |  32 ++++++++++++++++++++++++++++++++
 misc/e2image.c              |  44 ++++++++++++++++++++++++++++++++++++++------
 tests/i_zero_super/expect   |  22 ++++++++++++++++++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  33 +++++++++++++++++++++++++++++++++
 8 files changed, 166 insertions(+), 46 deletions(-)
 create mode 100644 tests/i_zero_super/expect
 create mode 100644 tests/i_zero_super/image.gz
 create mode 100644 tests/i_zero_super/script

-- 
2.13.6 (Apple Git-96)
