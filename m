From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/2 v4] dump a sparse file in debugfs
Date: Fri, 25 Jan 2013 11:39:03 +0800
Message-ID: <1359085145-15490-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35247 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AYDZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 22:25:07 -0500
Received: by mail-pb0-f41.google.com with SMTP id xa7so5815601pbc.14
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 19:25:07 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the fourth try to support to dump a sparse file in debugfs.  In this
patch series the only change is using ext2fs_llseek() in dump_file to get a
better portability.

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

 debugfs/dump.c            |  48 +++++++++--
 lib/ext2fs/ext2_err.et.in |   6 ++
 lib/ext2fs/ext2fs.h       |   3 +
 lib/ext2fs/fileio.c       | 208 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 254 insertions(+), 11 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

