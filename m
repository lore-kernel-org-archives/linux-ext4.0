From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/7] bug fix and add a unit test for inline data in e2fsprogs
Date: Thu, 15 Nov 2012 16:13:22 +0800
Message-ID: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65348 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab2KOIBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:06 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so905780pad.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is some bug fixes and first try to add a unit test for inline data in
e2fsprogs.  This patch set bases against pu branch of e2fsprogs.

Patch 1-5 fix some bugs for inline data in e2fsprogs.

Patch 6 removes some warnings that are reported by make gcc-wall

Patch 7 tries to add a unit test for inline data.

Regards,
						- Zheng
---
Zheng Liu (7)
      libext2fs: rec_len is set incorrect in ext2fs_process_dir_inline_data
      libext2fs: create a new dir with inline data while ino is greater than or equal to th
      libext2fs: wrong loop will cause dir entry is not found in dirsearch command
      libext2fs: return written bytes in ext2fs_try_to_write_inline_data
      libext2fs: fix a typo
      libext2fs: fix some warnings from make gcc-wall
      libext2fs: add a unit test for inline data

 e2fsck/pass1.c           |   2 +-
 lib/ext2fs/Makefile.in   |  10 +-
 lib/ext2fs/dir_iterate.c |   7 +-
 lib/ext2fs/ext2fs.h      |   8 +-
 lib/ext2fs/ext2fsP.h     |   4 +-
 lib/ext2fs/ext_attr.c    |  16 +--
 lib/ext2fs/inline_data.c | 367 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 lib/ext2fs/mkdir.c       |   5 +-
 lib/ext2fs/punch.c       |  12 +-
 9 files changed, 367 insertions(+), 64 deletions(-)
