From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/6][REPOST] ext{2,3,4}: tighten inheritance and setting of inode flags
Date: Wed,  3 Dec 2008 19:54:57 +0000
Message-ID: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2862 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbYLCUBt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 15:01:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series prevents the inheritance and setting of flags that are
inappropriate for specific inode types.

Flags which should be inherited are listed explicitly so as to prevent
future flags being overlooked and inherited by accident.

It introduces a function to mask flags based on the inode type and uses
it in inode creation and the SETFLAGS ioctl to help prevent future
inconsistency.

Patches 1-3 fix the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Patches 4-6 fix a related problem with non-regular file/dir inodes
inheriting inappropriate flags, discovered while testing. For example,
on an unpatched system, the following sequence will create an
un(re)movable device node:

mkdir a
chattr +a a
touch a/a
mknod a/b c 1 3
chattr -a a a/a

All attempts to delete, move or modify a/b will fail. Fsck will report
there is a problem but will not fix it.

Diffstat from linux-next:
 fs/ext2/ialloc.c        |    8 ++------
 fs/ext2/ioctl.c         |    3 +--
 fs/ext3/ialloc.c        |    8 ++------
 fs/ext3/ioctl.c         |    3 +--
 fs/ext4/ext4.h          |   25 +++++++++++++++++++++++++
 fs/ext4/ialloc.c        |   14 +++++---------
 fs/ext4/ioctl.c         |    3 +--
 include/linux/ext2_fs.h |   24 ++++++++++++++++++++++++
 include/linux/ext3_fs.h |   24 ++++++++++++++++++++++++
 9 files changed, 85 insertions(+), 27 deletions(-)
