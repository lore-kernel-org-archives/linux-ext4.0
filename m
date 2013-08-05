From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v5 0/2] e2fsprogs: dump a sparse file in debugfs
Date: Mon,  5 Aug 2013 13:43:38 +0800
Message-ID: <1375681420-15384-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33954 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HEFne (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 01:43:34 -0400
Received: by mail-pa0-f44.google.com with SMTP id jh10so2845995pab.31
        for <linux-ext4@vger.kernel.org>; Sun, 04 Aug 2013 22:43:33 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the fifth try to support to dump a sparse file in debugfs.  In this
patch series the only change is to rebase the patch set against e2fsprogs
1.42.8.

v5 <- v4:
 - rebase against e2fsprogs 1.42.8

v4 <- v3:
 - call ext2fs_llseek() in dump_file to seek to the next data because of better
   portability

v3 <- v2:
 - use extent interfaces to handle extent-based file in seek_data/hole function
 - call ext2fs_file_llseek() to retrieve current offset in dump_file()

v2 <- v1:
 - split original patch into two parts.
 - make code clearly according to Ted's suggestions

Regards,
						- Zheng

Zheng Liu (2):
  libext2fs: introduce lseek SEEK_DATA/HOLE
  debugfs: dump a sparse file

 debugfs/dump.c            |   48 +++++++++--
 lib/ext2fs/ext2_err.et.in |    6 ++
 lib/ext2fs/ext2fs.h       |    3 +
 lib/ext2fs/fileio.c       |  208 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 254 insertions(+), 11 deletions(-)

-- 
1.7.9.7

