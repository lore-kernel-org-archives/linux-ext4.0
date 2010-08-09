From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Crash after umount'ing a disconnected disk and JBD: recovery
 failed (Re: extfs reliability)
Date: Mon, 9 Aug 2010 15:32:44 -0400
Message-ID: <20100809193243.GH3635@thunk.org>
References: <20100804180325.GL9453@thunk.org>
 <4C5B1137.1070001@vlnb.net>
 <20100805211758.GA12358@thunk.org>
 <4C5C0CE2.7030009@vlnb.net>
 <20100806181042.GB24583@thunk.org>
 <4C604CE0.9040808@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43069 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0HITcr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Aug 2010 15:32:47 -0400
Content-Disposition: inline
In-Reply-To: <4C604CE0.9040808@vlnb.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 10:45:52PM +0400, Vladislav Bolkhovitin wrote:
> 
> Well, I'm not complaining, I'm reporting.
> 
> I can't say where is the problem. And I really would *not* say that
> activation of the hung tasks detector is normal. A correct timeout
> should be set by default, not after manual user intervention.

The root cause of your issues is that very few people tend to use
disks that can randomly appear and disappear due to links appearing
and disappearing.  So it doesn't get much testing, and in the case of
USB, for example, if you pull the USB stick out, the pending I/O's
error out immediately.  The hung tasks detector has no idea that the
iSCSI and FC drivers will not immediately error out the I/O's, but
will wait some amount of time.  You could say the iSCSI and FC drivers
should change the hung tasks timeout if they happen to be in use, but
maybe the sysadmin _wants_ the hung tasks detector to be a smaller
value.  In any case, it's not my code, and if you want to complain at
the folks who do the iSCSI driver, feel free.

> >>It's next to the message on which you originally replied. It was
> >>about ext3, but this time I saw it with ext4.
> >
> >Can you resend, and with a new and specific subject line that is
> >helpful for finding it, and just that one message?
> 
> See http://lkml.org/lkml/2010/7/29/222 and
> http://lkml.org/lkml/2010/7/29/325.

My bet the problem is that iSCSI driver and/or the buffer cache array
doesn't do the right thing with data in the buffer cache which is
didn't actually make it out to the disk (when the I/O finally timed
out), so there is some old data in the buffer cache which doesn't
reflect what is on the disk.

I suspect that if you run the following command after you umount the
disk, and recover the disk, before you mount the disk again, you run
this command (source attached) on the block device, the journal
recovery should no longer fail.  Can you try this experiment?  If we
see that this solves the problem, then we can force a buffer cache
flush at mount-time, so that it happens automatically.

						- Ted

/*
 * flushb.c --- This routine flushes the disk buffers for a disk
 *
 * Copyright 1997, 2000, by Theodore Ts'o.
 *
 * WARNING: use of flushb on some older 2.2 kernels on a heavily loaded
 * system will corrupt filesystems.  This program is not really useful
 * beyond for benchmarking scripts.
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include "../misc/nls-enable.h"

/* For Linux, define BLKFLSBUF if necessary */
#if (!defined(BLKFLSBUF) && defined(__linux__))
#define BLKFLSBUF	_IO(0x12,97)	/* flush buffer cache */
#endif

const char *progname;

static void usage(void)
{
	fprintf(stderr, _("Usage: %s disk\n"), progname);
	exit(1);
}

int main(int argc, char **argv)
{
	int	fd;

	progname = argv[0];
	if (argc != 2)
		usage();

	fd = open(argv[1], O_RDONLY, 0);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	/*
	 * Note: to reread the partition table, use the ioctl
	 * BLKRRPART instead of BLKFSLBUF.
	 */
#ifdef BLKFLSBUF
	if (ioctl(fd, BLKFLSBUF, 0) < 0) {
		perror("ioctl BLKFLSBUF");
		exit(1);
	}
	return 0;
#else
	fprintf(stderr,
		_("BLKFLSBUF ioctl not supported!  Can't flush buffers.\n"));
	return 1;
#endif
}

