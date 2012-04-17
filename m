From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 00:53:35 +0800
Message-ID: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f66.google.com ([209.85.160.66]:36088 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2DQQrV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Apr 2012 12:47:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

fallocate is a useful system call because it can preallocate some disk blocks
for a file and keep blocks contiguous.  However, it has a defect that file
system will convert an uninitialized extent to be an initialized when the user
wants to write some data to this file, because file system create an
unititalized extent while it preallocates some blocks in fallocate (e.g. ext4).
Especially, it causes a severe degradation when the user tries to do some
random write operations, which frequently modifies the metadata of this file.
We meet this problem in our product system at Taobao.  Last month, in ext4
workshop, we discussed this problem and the Google faces the same problem.  So
a new flag, FALLOC_FL_NO_HIDE_STALE, is added in order to solve this problem.
When this flag is set, file system will create an inititalized extent for this
file.  So it avoids the conversion from uninitialized to initialized.  If users
want to use this flag, they must guarantee that file has been initialized by
themselves before it is read at the same offset.  This flag is added in vfs so
that other file systems can also support this flag to improve the performance.

I try to make ext4 support this new flag, and run a simple test in my own
desktop to verify it.  The machine has a Intel(R) Core(TM)2 Duo CPU E8400, 4G
memory and a WDC WD1600AAJS-75M0A0 160G SATA disk.  I use the following script
to tset the performance.

#/bin/sh
mkfs.ext4 ${DEVICE}
mount -t ext4 ${DEVICE} ${TARGET}
fallocate -l 27262976 ${TARGET}/test # the size of the file is 256M (*)
time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/sda1/test_256M \
	conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
	2>/dev/null; done

* I write a wrapper program to call fallocate(2) with FALLOC_FL_NO_HIDE_STALE
  flag because the userspace tool doesn't support the new flag.

The result:
	w/o 		w/
real	1m16.043s	0m17.946s	-76.4%
user	0m0.195s	0m0.192s	-1.54%
sys	0m0.468s	0m0.462s	-1.28%

Obviously, this flag will bring an secure issue because the malicious user
could use this flag to get other user's data if (s)he doesn't do a
initialization before reading this file.  Thus, a sysctl parameter
'fs.falloc_no_hide_stale' is defined in order to let administrator to determine
whether or not this flag is enabled.  Currently, this flag is disabled by
default.  I am not sure whether this is enough or not.  Another option is that
a new Kconfig entry is created to remove this flag during the kernel is
complied.  So any suggestions or comments are appreciated.

Regards,
Zheng

Zheng Liu (3):
      vfs: add FALLOC_FL_NO_HIDE_STALE flag in fallocate
      vfs: add security check for _NO_HIDE_STALE flag
      ext4: add FALLOC_FL_NO_HIDE_STALE support

 fs/ext4/extents.c      |    7 +++++--
 fs/open.c              |   12 +++++++++++-
 include/linux/falloc.h |    5 +++++
 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |   10 ++++++++++
 5 files changed, 32 insertions(+), 3 deletions(-)
