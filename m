From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Bug 11525] New: Unable to handle paging request at
	ext3_rmdir() and ext4_rmdir() on intentionally corrupted fs
Date: Wed, 10 Sep 2008 08:58:02 -0400
Message-ID: <20080910125802.GK21071@mit.edu>
References: <bug-11525-27@http.bugzilla.kernel.org/> <20080909134627.75bd0a80.akpm@linux-foundation.org> <15802_1220997383_ZZ0K6Y00A5R7LWI2.00_20080909215531.GE21071@mit.edu> <20080910032633.GH8723@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Sami Liedes <sliedes@cc.hut.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54270 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbYIJM6S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 08:58:18 -0400
Content-Disposition: inline
In-Reply-To: <20080910032633.GH8723@lh.kyla.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2008 at 06:26:34AM +0300, Sami Liedes wrote:
> 
> Yes, I can generate those filesystems. However the problem seems to be
> elusive in that I haven't yet been able to reproduce it twice with the
> same filesystem (and even with random filesystems, it every occurs
> once in a while). I'll do some more testing and try to figure out if
> it can be reproduced more easily. Still I can give you some
> filesystems that crashed once, if you wish. They are typically
> something like 600 KiB compressed, and I guess that could be made less
> by zeroing all regular files in the pristine fs before doing the
> fuzzing.

One easy way of doing this is the following:

    e2image -r /dev/hdXX /var/tmp/hdXX.e2i
    dd if=/var/tmp/hdXX.e2i of=/dev/hdXX

Another thing you can do is change your script to add the following
line before the filesystem is mounted:

     e2image -r /dev/hdXX - | bzip2 > /var/tmp/hdXX.e2i

and then if the filesystem fails (i.e., the system oops),
/var/tmp/hdXX.e2i.bz2 will have all of the filesystem metadata
(including directories), such that if you decompress and write out the
filesystem (or what I do when given one of these to examine):

   bunzip2 < hdXX.e2i.bz2 | make-sparse > hdXX.e2i

Said sparse file can now be checked via e2fsck, or mounted using a
loopback mount, etc.

Even if it's not reliably reproducable, if I can get a series of
filesystems which show the problem, using "e2fsck -nf" we can see a
pattern of how the filesystems are corrupted, and that can help narrow
down what might be going on that causes the kernel oops.

Thanks, regards,

     	  	   	    	 	    	   - Ted

/*
 * make-sparse.c --- make a sparse file from stdin
 * 
 * Copyright 2004 by Theodore Ts'o.
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 */

#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

int full_read(int fd, char *buf, size_t count)
{
	int got, total = 0;
	int pass = 0;

	while (count > 0) {
		got = read(fd, buf, count);
		if (got == -1) {
			if ((errno == EINTR) || (errno == EAGAIN)) 
				continue;
			return total ? total : -1;
		}
		if (got == 0) {
			if (pass++ >= 3)
				return total;
			continue;
		}
		pass = 0;
		buf += got;
		total += got;
		count -= got;
	}
	return total;
}

int main(int argc, char **argv)
{
	int fd, got, i;
	char buf[1024];

	if (argc != 2) {
		fprintf(stderr, "Usage: make-sparse out-file\n");
		exit(1);
	}
	fd = open(argv[1], O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0777);
	if (fd < 0) {
		perror(argv[1]);
		exit(1);
	}
	while (1) {
		got = full_read(0, buf, sizeof(buf));
		if (got == 0)
			break;
		if (got == sizeof(buf)) {
			for (i=0; i < sizeof(buf); i++) 
				if (buf[i])
					break;
			if (i == sizeof(buf)) {
				lseek(fd, sizeof(buf), SEEK_CUR);
				continue;
			}
		}
		write(fd, buf, got);
	}
	return 0;
}
		
