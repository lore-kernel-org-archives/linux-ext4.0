From: Tao Ma <tm@tao.ma>
Subject: [PATCH 0/2 V2] Fix an e2fsck bug for fallocated extent.
Date: Thu, 17 May 2012 15:16:05 +0800
Message-ID: <1337238967-4704-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46619 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761075Ab2EQHQQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2012 03:16:16 -0400
Received: from [182.92.247.2] (helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SUuwZ-0005vf-Kl
	for linux-ext4@vger.kernel.org; Thu, 17 May 2012 01:16:16 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Hi all,
	This is the V2 for the bug of e2fsck. patch 1 is
the fix and patch 2 is the regression test case.

Tao Ma (2):
  e2fsck: Let end_blk to be the maximum value of u32.
  e2fsck/tests: Add the regression test case for e2fsck.

 lib/ext2fs/extent.c                 |    4 +---
 tests/f_zero_extent_length/expect.1 |    7 +++++++
 tests/f_zero_extent_length/expect.2 |    7 +++++++
 tests/f_zero_extent_length/image.gz |  Bin 0 -> 5102 bytes
 tests/f_zero_extent_length/name     |    1 +
 5 files changed, 16 insertions(+), 3 deletions(-)
 create mode 100644 tests/f_zero_extent_length/expect.1
 create mode 100644 tests/f_zero_extent_length/expect.2
 create mode 100644 tests/f_zero_extent_length/image.gz
 create mode 100644 tests/f_zero_extent_length/name

