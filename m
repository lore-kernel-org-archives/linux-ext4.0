From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3 v. 8] Ext3/Ext4 Batched discard support
Date: Fri, 24 Sep 2010 17:35:56 +0200
Message-ID: <1285342559-16424-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com, snitzer@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0IXPgc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Sep 2010 11:36:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

since it has been a while from my last post, I have rebased patches to
cleanly apply to the newest kernel. Also there have been some changes
regarding blkdev_issue_discard() and its helpers, I have changed patches
to use the new helper (ext4_issue_discard() for ext4) and new format of
sb_issue_discard() (in ext3).

Also in order to give the user better control over the discard I have
changed FITRIM ioctl to return the exact amount of discarded Bytes, so
the user will know how much space has been reclaimed to wear-leveling.

SHORT DESCRIPTION:
==================

Batched discard adds ability to discard free space on mounded filesystem,
in order to avoid using current discard implementation which discards
recently freed blocks. This approach may on some devices (it depends on
how efficient is the device wear-leveling algorithm) result in huge
performance loss.

Batched discard can be invoked from user-space through FITRIM ioctl on
the whole, or just a part, of file system. With this approach we are
searching for continuous free blocks bigger than defined through ioctl
to discard them. So, since we are searching for big continuous extents
it is much more efficient than current approach and it gives user fine
grained control over how much disk space will be reclaimed for
wear-leveling and what impact will it have on performance.


I have attached source code for example application which uses FITRIM
to discard just a part or whole filesystem. Since FITRIM is filesystem
independent ioctl it can be used by any filesystem which supports it.

Usage: fstrim [-s start] [-l length] [-m minimum-extent] [-v] directory
        -s Starting Byte to discard from
        -l Number of Bytes to discard from the start
        -m Minimum extent length to discard
        -v Verbose - prints out number of really discarded Bytes

---
a1edaf3 ext3: Add batched discard support
4ed7168 ext4: Add batched discard support
88f8c20 Add ioctl FITRIM.

 fs/ext3/balloc.c        |  251 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 fs/ext4/ext4.h          |    2 +
 fs/ext4/mballoc.c       |  191 +++++++++++++++++++++++++++++++++++
 fs/ext4/super.c         |    1 +
 fs/ioctl.c              |   39 +++++++
 include/linux/ext3_fs.h |    1 +
 include/linux/fs.h      |    2 +
 8 files changed, 488 insertions(+), 0 deletions(-)

