From: Lukas Czerner <lczerner@redhat.com>
Subject: Ext4: batched discard support - simplified version
Date: Wed,  7 Jul 2010 09:53:30 +0200
Message-ID: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Cc: lczerner@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: eshishki@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0GGHyB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 03:54:01 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o677s1ZQ026202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jul 2010 03:54:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi all,

since my last post I have done some more testing with various SSD's and the
trend is clear. Trim performance is getting better and the performance loss
without trim is getting lower. So I have decided to abandon the initial idea
to track free blocks within some internal data structure - it takes time and
memory.

Today there are some SSD's which performance does not seems to degrade over
the time (writes). I have filled those devices up to 200% and still did not
seen any performance loss. On the other hand, there are still some devices
which shows about 300% performance degradation, so I suppose TRIM will be
still needed for some time.

You can try it out with the simple program attached below. Just create ext4
fs, mount it with -o discard and invoke attached program on ext4 mount point.

>From my experience the time needed to trim whole file system is strongly device
dependent. It may take few seconds on one device up to one minute on another,
under the heavy io load the time to trim whole fs gets longer.

There are two pathes:

[PATCH 1/2] Add ioctl FITRIM.
 fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

[PATCH 2/2] Add batched discard support for ext4
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c   |    1 +
 3 files changed, 118 insertions(+), 11 deletions(-)

Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>


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
