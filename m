From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 0/5] e2fsprogs: support quota as first class feature in ext4
Date: Wed, 20 Jul 2011 11:40:01 -0700
Message-ID: <1311187206-30553-1-git-send-email-adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:7413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1GTSk6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 14:40:58 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p6KIeuu4018505
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 11:40:56 -0700
Received: from adityakali.mtv.corp.google.com (adityakali.mtv.corp.google.com [172.18.96.56])
	by wpaz33.hot.corp.google.com with ESMTP id p6KIetnK003296
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 11:40:55 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set is a step towards making quotas as a first class
supported feature in ext4 in addition to the separately sent
kernel patches. This idea is proposed at:
https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4.

This patch set only provides some basic functionality in e2fsprogs
to set quota feature and fix quotas during e2fsck on ext4 filesystem.
This patch set:
1) ports the quota library written by Jan Kara for quota-tools to
e2fsprogs. I have ported most of the quota-library by Jan Kara as-is
(except some readability changes and use of ext2fs library).
2) adds wrapper over the quota library (lib/quota/mkquota.[c|h]) that
provides an interface that can be used by e2fsprogs tools.
3) adds support to mke2fs and tune2fs to enable the quota feature
on ext4 superblock and create user/group quota inodes using the quota
library.
4) adds support for doing quota accounting during full e2fsck scan and
fix the quota inodes.

Following features still need to be implemented:
1) allow support for reading existing quota files
2) allow debugfs to view quota information in the quota inodes
3) report mismatch in existing quotas and computed quotas after
   e2fsck scan (currently, the existing quota inodes are simply
   overwritten with new inodes).

Thanks,
	-Aditya

Aditya Kali (5):
 e2fsprogs: add quota library to e2fsprogs
 e2fsprogs: Make quota as a supported feature
 mke2fs: support creation of filesystem with quota feature
 tune2fs: Add support for turning on quota feature
 e2fsck: check quota accounting during fsck

 MCONFIG.in               |    6 +
 Makefile.in              |    3 +-
 configure                |   32 +++
 configure.in             |   51 ++++
 e2fsck/Makefile.in       |   43 +++--
 e2fsck/e2fsck.h          |    9 +
 e2fsck/message.c         |    2 +
 e2fsck/pass1.c           |   34 +++
 e2fsck/pass1b.c          |    6 +-
 e2fsck/pass2.c           |   16 +-
 e2fsck/pass3.c           |    3 +
 e2fsck/pass4.c           |    1 +
 e2fsck/problem.c         |   20 ++
 e2fsck/problem.h         |    9 +
 e2fsck/quota.c           |   88 +++++++
 e2fsck/super.c           |    5 +
 e2fsck/unix.c            |   17 ++
 lib/ext2fs/ext2fs.h      |    3 +-
 lib/quota/Makefile.in    |  127 ++++++++++
 lib/quota/common.c       |   63 +++++
 lib/quota/common.h       |   78 +++++++
 lib/quota/dqblk_v2.h     |   43 ++++
 lib/quota/mkquota.c      |  400 ++++++++++++++++++++++++++++++++
 lib/quota/mkquota.h      |   66 ++++++
 lib/quota/quota.h        |  190 +++++++++++++++
 lib/quota/quota.pc.in    |   11 +
 lib/quota/quotaio.c      |  359 +++++++++++++++++++++++++++++
 lib/quota/quotaio.h      |  163 +++++++++++++
 lib/quota/quotaio_tree.c |  574 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/quota/quotaio_tree.h |   63 +++++
 lib/quota/quotaio_v2.c   |  314 +++++++++++++++++++++++++
 lib/quota/quotaio_v2.h   |  103 +++++++++
 misc/Makefile.in         |   28 ++-
 misc/mke2fs.8.in         |    5 +
 misc/mke2fs.c            |   21 ++-
 misc/tune2fs.8.in        |   15 ++
 misc/tune2fs.c           |  148 ++++++++++++-
 37 files changed, 3081 insertions(+), 38 deletions(-)

