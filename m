From: Vivek Goyal <vgoyal@redhat.com>
Subject: fsync serialization on ext4 with blkio throttling (Was: Re: [PATCH
 0/8][V2] blk-throttle: Throttle buffered WRITEs in balance_dirty_pages())
Date: Thu, 30 Jun 2011 16:04:59 -0400
Message-ID: <20110630200459.GI27889@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110629004219.GP32466@dastard>
 <20110629015336.GA19082@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, andrea@betterlinux.com,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1F3UFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 16:05:09 -0400
Content-Disposition: inline
In-Reply-To: <20110629015336.GA19082@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 09:53:36PM -0400, Vivek Goyal wrote:

[..]
> > FYI, filesystem development cycles are slow and engineers are
> > conservative because of the absolute requirement for data integrity.
> > Hence we tend to focus development on problems that users are
> > reporting (i.e. known pain points) or functionality they have
> > requested.
> > 
> > In this case, block throttling works OK on most filesystems out of
> > the box, but it has some known problems. If there are people out
> > there hitting these known problems then they'll report them, we'll
> > hear about them and they'll eventually get fixed.
> > 
> > However, if no-one is reporting problems related to block throttling
> > then it either works well enough for the existing user base or
> > nobody is using the functionality. Either way we don't need to spend
> > time on optimising the filesystem for such functionality.
> > 
> > So while you may be skeptical about whether filesystems will be
> > changed, it really comes down to behaviour in real-world
> > deployments. If what we already have is good enough, then we don't
> > need to spend resources on fixing problems no-one is seeing...
>

[CC linux-ext4 list]

Dave,

Just another example where serialization is taking place with ext4.

I created a group with 1MB/s write limit and ran tedso's fsync tester
program with little modification. I used write() system call instead
of pwrite() so that file size grows. This program basically writes
1MB of data and then fsync's it and then measures the fsync time.

I ran two instances of prgram in two groups on two separate files. One
instances is throttled to 1MB/s and other is in root group unthrottled.

Unthrottled program gets serialized behind throttled one. Following
are fsync times.

Throttled instance	Unthrottled Instance
------------------ 	--------------------
fsync time: 1.0051	fsync time: 1.0067
fsync time: 1.0049	fsync time: 1.0075
fsync time: 1.0048	fsync time: 1.0063
fsync time: 1.0073	fsync time: 1.0062
fsync time: 1.0070	fsync time: 1.0078
fsync time: 1.0032	fsync time: 1.0049
fsync time: 0.0154	fsync time: 1.0068
fsync time: 0.0137	fsync time: 1.0048

Without any throttling both the instances do fine
-------------------------------------------------
Throttled instance	Unthrottled Instance
------------------ 	--------------------
fsync time: 0.0139	fsync time: 0.0162
fsync time: 0.0132	fsync time: 0.0156
fsync time: 0.0149	fsync time: 0.0169
fsync time: 0.0165	fsync time: 0.0152
fsync time: 0.0188	fsync time: 0.0135
fsync time: 0.0137	fsync time: 0.0142
fsync time: 0.0148	fsync time: 0.0149
fsync time: 0.0168	fsync time: 0.0163
fsync time: 0.0153	fsync time: 0.0143

So when we are inreasing the size of file and fsyncing it, other
unthrottled instances of similar activities will get throttled
behind it.

IMHO, this is a problem and should be fixed. If filesystem can fix it great.
But if not, then we should consider the option of throttling buffered writes 
in balance_dirty_pages().

Following is the test program.

/*
 *  * fsync-tester.c
 *
 * Written by Theodore Ts'o, 3/21/09.
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#define SIZE (1024*1024)

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
        return ((tv1->tv_sec - tv2->tv_sec) +
                ((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

int main(int argc, char **argv)
{
        int     fd;
        struct timeval tv, tv2;
        char buf[SIZE];

        fd = open("fsync-tester.tst-file", O_WRONLY|O_CREAT);
        if (fd < 0) {
                perror("open");
                exit(1);
        }
        memset(buf, 'a', SIZE);
        while (1) {
                write(fd, buf, SIZE);
                gettimeofday(&tv, NULL);
                fsync(fd);
                gettimeofday(&tv2, NULL);
                printf("fsync time: %5.4f\n", timeval_subtract(&tv2,
&tv));
                sleep(1);
        }
}

Thanks
Vivek
