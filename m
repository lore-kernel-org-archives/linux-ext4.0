From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 00/10] ext4: Bunch of DIO/AIO fixes V3
Date: Mon, 24 Sep 2012 15:44:10 +0400
Message-ID: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52474 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2IXLo3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:29 -0400
Received: by lbbgj3 with SMTP id gj3so6549331lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are number of races exist caused by lack of synchronization
between DIO workers in flight and truncate/fsync/punch_hole routines
This patch series try to optimize and fix existing DIO/AIO code

I observe significant performance improvements for big SMP hosts
performind DIO for single file.

Testcases which helps me to catch this type of bugs was posted here
http://www.spinics.net/lists/linux-fsdevel/msg58312.html
or available on my github repo:
https://github.com/dmonakhov/xfstests/tree/ce8e3adab629b2a9be8ba2e73db7dad49eb46614
plese run 286,287,288

TOC:
# first two are cleanups
ext4: ext4_inode_info diet
ext4: give i_aiodio_unwritten more appropriate name
# Cleanup and bug fixes
ext4: fix unwritten counter leakage
ext4: completed_io locking cleanup V3
ext4: serialize dio nonlocked reads with defrag workers V3
ext4: punch_hole should wait for DIO writers
ext4: serialize unlocked dio reads with truncate
ext4: endless truncate due to nonlocked dio readers V2
ext4: serialize truncate with owerwrite DIO workers V2
ext4: fix ext_remove_space for punch_hole case

Changes from V2:
 Fix use-after-free for queued end_io_work.

 fs/ext4/ext4.h        |   33 ++++++++++---
 fs/ext4/extents.c     |   88 +++++++++++++++++++++++-------------
 fs/ext4/file.c        |    9 ---
 fs/ext4/fsync.c       |   85 -----------------------------------
 fs/ext4/indirect.c    |   19 ++++++-
 fs/ext4/inode.c       |   49 ++++++++------------
 fs/ext4/move_extent.c |    8 +++
 fs/ext4/page-io.c     |  121 +++++++++++++++++++++++++++++---------------------
 fs/ext4/super.c       |    3 -
 10 files changed, 201 insertions(+), 216 deletions(-)
