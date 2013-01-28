From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/4] xfstests: seek data/hole and hole punching improvements
Date: Mon, 28 Jan 2013 15:32:47 +0800
Message-ID: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3A1HUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 02:20:21 -0500
Received: by mail-pb0-f46.google.com with SMTP id mc17so650801pbc.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 23:20:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is my first try to improve seek data/hole and hole punching test
cases in xfstests.  The key issue in 255 and 285 is that they assume that
all file systems that are tested support unwritten extent preallocation.
Before 3.8 kernel it is correct.  But now ext4 file system has ability
to seek data/hole and punch a hole for a file w/o unwritten extent.  So
it is time to improve these test cases.

In this patch series it calls _require_xfs_io_falloc in 255 and 285 to
make sure that unwritten extent is supprted by tested file system.  A
new argument '-t' is added into seek_sanity_test to check a file system
that supports seek data/hole or not.  In the mean time _require_seek_data_hole
is defined to be used by all tests.

Further two new test cases are created to test seek data/hole and hole
punching w/o unwritten extent, which do the same thing like 255 and 285
except that they don't do some test cases which are related to unwritten
extent.

Any comments or feedbacks are welcome.

Thanks,
						- Zheng

Zheng Liu (4):
  xfstests: check unwritten extent preallocation in 255
  xfstests: 295: test fallocate hole punching for all file systems
  xfstests: check llseek(2) SEEK_DATA/HOLE and unwritten extent
    preallocation in 285
  xfstests: 296: add a seek data/hole test w/o unwritten extent

 255                    |   3 +-
 285                    |   7 +-
 295                    |  68 +++++++++++
 295.out                | 307 +++++++++++++++++++++++++++++++++++++++++++++++++
 296                    |  57 +++++++++
 296.out                |   1 +
 common.rc              |  12 ++
 group                  |   2 +
 src/seek_sanity_test.c |  46 ++++++--
 9 files changed, 491 insertions(+), 12 deletions(-)
 mode change 100644 => 100755 285
 create mode 100755 295
 create mode 100644 295.out
 create mode 100755 296
 create mode 100644 296.out

-- 
1.7.12.rc2.18.g61b472e

