From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/9] ext4: Bunch of DIO/AIO fixes V2
Date: Thu, 13 Sep 2012 19:01:05 +0400
Message-ID: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51413 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2IMPBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 11:01:20 -0400
Received: by lbbgj3 with SMTP id gj3so2024059lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are number of races exist caused by lack of synchronization
between DIO workers in flight and truncate/fsync/punch_hole routines
This patch series try to optimize and fix existing DIO/AIO code.

This patch-set survives after all my tests(except fsdefrag)
I observe significant performance improvements for big SMP hosts
performind DIO for single file.

TOC:
# first one is simply a cleanup
ext4: ext4_inode_info diet
# Cleanup and bug fixes
ext4: completed_io locking cleanup V2
ext4: serialize dio nonlocked reads with defrag workers V3
ext4: punch_hole should wait for DIO writers
ext4: serialize unlocked dio reads with truncate
ext4: endless truncate due to nonlocked dio readers V2
ext4: serialize truncate with owerwrite DIO workers V2
# Nasty panch_hole regressions
ext4: fix ext_remove_space for punch_hole case
ext4: fix ext4_ext_remove_space tree traversal

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

 ext4.h        |   27 +++++++++++++++----
 extents.c     |   82 ++++++++++++++++++++++++++++++++--------------------------
 fsync.c       |   47 +++++++++++----------------------
 indirect.c    |   17 +++++++++---
 inode.c       |   49 ++++++++++++++--------------------
 move_extent.c |    8 +++++
 page-io.c     |   76 ++++++++++++++---------------------------------------
 super.c       |    1
 8 files changed, 148 insertions(+), 159 deletions(-)

