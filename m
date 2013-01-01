From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Tue,  1 Jan 2013 20:30:13 +0800
Message-ID: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40646 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3AAMQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 07:16:55 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so7523827pad.24
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2013 04:16:55 -0800 (PST)
CC: George Spelvin <linux@horizon.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently when we use dump command in debugfs to dump a file, all extents will
be dumped to a new file no matter whether these extents are written or not.  If
we want to dump a sparse file, it will waste time to fill zero into the file.
This patch series tries to avoid to dump unwritten extent.

v2 <- v1:
  - split original patch into two parts.
  - make code clearly according to Ted's suggestions

Here is the first version:
  http://patchwork.ozlabs.org/patch/199303/

Regards,
						- Zheng

Zheng Liu (2):
  debugfs: fixup the hard-coded buffer length in dump_file
  debugfs: dump a sparse file as a new sparse file

 debugfs/dump.c      | 25 ++++++++++++++++++++++---
 lib/ext2fs/ext2fs.h |  3 +++
 lib/ext2fs/fileio.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 64 insertions(+), 14 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

