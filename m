From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 00/11] ext4: Bunch of DIO/AIO fixes V4
Date: Fri, 28 Sep 2012 19:44:00 +0400
Message-ID: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2I1PoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 11:44:19 -0400
Received: by bkcjk13 with SMTP id jk13so3591549bkc.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2012 08:44:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are number of races exist caused by lack of synchronization
between DIO/AIO workers and truncate/fsync/punch_hole routines
This patch series try to optimize and fix existing DIO/AIO code

I observe significant performance improvements for big SMP hosts.

Testcases which helps me to catch this type of bugs was posted here
http://www.spinics.net/lists/linux-fsdevel/msg58312.html
or available on my github repo:
https://github.com/dmonakhov/xfstests/tree/ce8e3adab629b2a9be8ba2e73db7dad49eb46614
plese run 286,287,288

TOC:
# first two are cleanups
ext4: ext4_inode_info diet
ext4: give i_aiodio_unwritten more appropriate name
# Bugfixes and improvements
ext4: fix unwritten counter leakage
ext4: completed_io locking cleanup V4
ext4: remove ext4_end_io()
ext4: serialize dio nonlocked reads with defrag workers V3
ext4: serialize unlocked dio reads with truncate
ext4: endless truncate due to nonlocked dio readers V2
ext4: serialize truncate with owerwrite DIO workers V2
# Nasty panch_hole regressions
ext4: punch_hole should wait for DIO writers V2
ext4: fix ext_remove_space for punch_hole case

Changes from V3:
	- satisfy ./checkpatch.pl rules
 	- Rework 'completed_io locking cleanup'
	- fix mistype in 'serialize dio nonlocked reads with defrag workers V3'
	- add extra inode's flag checks to 'punch_hole should wait for DIO'
Changes from V2:
	Fix use-after-free for queued end_io_work.

 fs/ext4/ext4.h        |   36 +++++++-
 fs/ext4/extents.c     |   92 ++++++++++++++--------
 fs/ext4/file.c        |    6 -
 fs/ext4/fsync.c       |   81 --------------------
 fs/ext4/indirect.c    |   18 +++-
 fs/ext4/inode.c       |   49 +++++-------
 fs/ext4/move_extent.c |    8 +
 fs/ext4/page-io.c     |  202 ++++++++++++++++++++++++++++++--------------------
 fs/ext4/super.c       |    3
 9 files changed, 262 insertions(+), 235 deletions(-)

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
