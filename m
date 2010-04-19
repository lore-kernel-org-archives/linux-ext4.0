From: Lukas Czerner <lczerner@redhat.com>
Subject: Ext4: batched discard support
Date: Mon, 19 Apr 2010 12:55:25 +0200
Message-ID: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0DSKzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 06:55:42 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3JAtfMN007695
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 06:55:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I would like to present a new way to deal with TRIM in ext4 file system.
The current solution is not ideal because of its bad performance impact.
So basic idea to improve things is to avoid discarding every time some
blocks are freed. and instead batching is together into bigger trims,
which tends to be more effective.

The basic idea behind my discard support is to create an ioctl which
walks through all the free extents in each allocating group and discard
those extents. As an addition to improve its performance one can specify
minimum free extent length, so ioctl will not bother with shorter extents.

This of course means, that with each invocation the ioctl must walk
through whole file system, checking and discarding free extents, which
is not very efficient. The best way to avoid this is to keep track of
deleted (freed) blocks. Then the ioctl have to trim just those free
extents which were recently freed.

In order to implement this I have added new bitmap into ext4_group_info
(bb_bitmap_deleted) which stores recently freed blocks. The ioctl then
walk through bb_bitmap_deleted, compare deleted extents with free
extents trim them and then removes it from the bb_bitmap_deleted. 

But you may notice, that there is one problem. bb_bitmap_deleted does
not survive umount. To bypass the problem the first ioctl call have to
walk through whole file system trimming all free extents. But there is a
better solution to this problem. The bb_bitmap_deleted can be stored on
disk an can be restored in mount time along with other bitmaps, but I
think it is a quite big change and should be discussed further.

I have also benchmarked it a little. You can find results here:

people.redhat.com/jmoyer/discard/ext4_batched_discard/

comparison with current solution included. Keep in mind that ideal ioctl
invocation interval is yet to be determined, so in benchmark I have used
the performance-worst scenario - without any sleep between execution.


There are two patches for this. The first one just creates file system
independent ioctl for this and the second one it the batched discard
support itself.

I will very much appreciate any comment on this, your opinions, ideas to
make this better etc. Thanks.

If you want to try it, just create EXT4 file system mount it and invoke
ioctl on the mount point. You can use following code for this (I have
taken this from xfs patch for the same thing). You can also see some
debugging messages, but you may want to set EXT4FS_DEBUG for this.

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/ioctl.h>

#define FITRIM		_IOWR('X', 121, int)

int main(int argc, char **argv)
{
	int minsize = 4096;
	int fd;

	if (argc != 2) {
		fprintf(stderr, "usage: %s mountpoint\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (ioctl(fd, FITRIM, &minsize)) {
		if (errno == EOPNOTSUPP)
			fprintf(stderr, "TRIM not supported\n");
		else
			perror("EXT4_IOC_TRIM");
		return 1;
	}

	return 0;
}

 fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

 fs/ext4/ext4.h    |    4 +
 fs/ext4/mballoc.c |  207 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/super.c   |    1 +
 3 files changed, 202 insertions(+), 10 deletions(-)
