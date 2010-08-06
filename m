From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3] Batched discard support
Date: Fri,  6 Aug 2010 13:31:13 +0200
Message-ID: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
Cc: dmonakhov@openvz.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0HFLcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 07:32:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

because people were worried about possibly long stalls appearing
when FITRIM ioctl is working, I have changed the FITRIM interface
as Dimitry suggested. Now you can choose whether to trim whole
file system or just a part of it, resp. you can specify the range
of Bytes to trim.

To be specific you can create something like this:

int main(int argc, char **argv)
{
	int fd;
	uint64_t range[3];

	range[0] = 40960;
	range[1] = 134217728;
	range[2] = 4096;

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (ioctl(fd, FITRIM, range)) {
		if (errno == EOPNOTSUPP)
			fprintf(stderr, "FITRIM not supported\n");
		else
			perror("FITRIM");
		return 1;
	}

	return 0;
}

Range items have following meaning:

range[0] - (start) first Byte to trim
range[1] - (len) number of Bytes to trim from start
range[2] - (minlen) minimum extent length to trim, free extents shorter
than this number of Bytes will be ignored. This number will be rounded
up to the block size.

So in my example it will trim all free extents from block 10 of first
alloc. group to block 10 of second alloc. group, assuming we have
block_size = 4096.

Also, when you want to trim the whole fs, you can simply pass NULL
instead of range into the ioctl, or you can specify the range correctly
to cover the whole fs.

Regards
-Lukas

[PATCH 1/3] Add ioctl FITRIM.
[PATCH 2/3] Add batched discard support for ext3
[PATCH 3/3] Add batched discard support for ext4

 fs/ext3/balloc.c        |  249 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 fs/ext4/ext4.h          |    2 +
 fs/ext4/mballoc.c       |  194 ++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c         |    1 +
 fs/ioctl.c              |   34 +++++++
 include/linux/ext3_fs.h |    1 +
 include/linux/fs.h      |    2 +
 8 files changed, 484 insertions(+), 0 deletions(-)
