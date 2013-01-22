From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/2 v3] dump a sparse file in debugfs
Date: Tue, 22 Jan 2013 17:11:31 +0800
Message-ID: <1358845893-24640-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51405 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3AVI5u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 03:57:50 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so2021146pbb.41
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 00:57:49 -0800 (PST)
CC: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

This is the third try to support to dump a sparse file in debugfs.  In this
patch series ext2fs_file_llseek_data/hole() functions are defined to let the
caller seek to the next data/hole directly.  Meanwhile in dump_file() it is
changed to handle sparse file.

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

