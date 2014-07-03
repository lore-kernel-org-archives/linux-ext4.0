From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Thu, 3 Jul 2014 09:43:38 -0400
Message-ID: <20140703134338.GE2374@thunk.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	David Jander <david@protonic.nl>, linux-ext4@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43125 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbaGCNnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jul 2014 09:43:47 -0400
Content-Disposition: inline
In-Reply-To: <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2014 at 10:55:11AM +0200, Matteo Croce wrote:
> 2014-07-01 10:42 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> 
> I have a Samsung SSD 840 PRO

Matteo,

For you, you said you were seeing these problems on 3.15.  Was it
*not* happening for you when you used an older kernel?  If so, that
would help us try to provide the basis of trying to do a bisection
search.


Using the kvm-xfstests infrastructure, I've been trying to reproduce
the problem as follows:

./kvm-xfstests  --no-log -c 4k generic/075 ; e2fsck -p /dev/heap/test-4k ; e2fsck -f /dev/heap/test-4k 

xfstests geneeric/075 runs fsx which does a fair amount of block
allocation deallocations, and then after the test finishes, it first
replays the journal (e2fsck -p) and then forces a fsck run on the
test disk that I use for the run.

After I launch this, in a separate window, I do this:

	sleep 60  ; killall qemu-system-x86_64 

This kills the qemu process midway through the fsx test, and then I
see if I can find a problem.  I haven't had a chance to automate this
yet, and it is my intention to try to set this up where I can run this
on a ramdisk or a SSD, so I can more closely approximate what people
are reporting on flash-based media.

So far, I haven't been able to reproduce the problem.  If after doing
a large number of times, it can't be reproduced (especially if it
can't be reproduced on an SSD), then it would lead us to believe that
one of two things is the cause.  (a) The CACHE FLUSH command isn't
properly getting sent to the device in some cases, or (b) there really
is a hardware problem with the flash device in question.

Cheers,

						- Ted
