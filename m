From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 0/4] e2image -b option to pass superblock number
Date: Mon, 26 Jun 2017 19:58:42 +0300
Message-ID: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: alexey.lyashkov@gmail.com, artem.blagodarenko@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34113 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbdGDM2K (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jul 2017 08:28:10 -0400
Received: by mail-lf0-f65.google.com with SMTP id g21so17660396lfk.1
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jul 2017 05:28:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There was a discussion about possibility of using
superblock backup for creating images with e2image.

https://www.spinics.net/lists/linux-ext4/msg30583.html

Now our customer faced with situation then it would be
useful to have image file from partition with broken
superblock.

Here is set of patches that adds this functionality.

Artem Blagodarenko (4):
  ext2fs: opening filesystem code refactoring
  e2image: add -b option to use supperblock backup
  tests: add test for e2image -b option
  man: add -b option to e2image

 e2fsck/unix.c               |   28 +++-------------------------
 lib/ext2fs/ext2fs.h         |    4 ++++
 lib/ext2fs/openfs.c         |   32 ++++++++++++++++++++++++++++++++
 misc/dumpe2fs.c             |   17 +++--------------
 misc/e2image.8.in           |   15 +++++++++++++++
 misc/e2image.c              |   38 ++++++++++++++++++++++++++++++++------
 tests/i_zero_super/expect   |   22 ++++++++++++++++++++++
 tests/i_zero_super/image.gz |  Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |   36 ++++++++++++++++++++++++++++++++++++
 9 files changed, 147 insertions(+), 45 deletions(-)
 create mode 100644 tests/i_zero_super/expect
 create mode 100644 tests/i_zero_super/image.gz
 create mode 100644 tests/i_zero_super/script
