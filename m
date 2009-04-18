From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Sat, 18 Apr 2009 09:28:21 +0200
Message-ID: <1240039701.6298.12.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
	 <20090417180906.GA8363@amit-x200.pnq.redhat.com>
	 <20090417201342.GF26479@mit.edu>
	 <20090418060312.GA10943@amit-x200.pnq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amit Shah <amit.shah@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35953 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751053AbZDRH23 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 03:28:29 -0400
In-Reply-To: <20090418060312.GA10943@amit-x200.pnq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2009-04-18 at 11:33 +0530, Amit Shah wrote:
> On (Fri) Apr 17 2009 [16:13:42], Theodore Tso wrote:
> > On Fri, Apr 17, 2009 at 11:39:06PM +0530, Amit Shah wrote:
> > > # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> > > 
> > > filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> > > ext3-guarded	85		97	459		90
> > > ext3-writeback 86		95	140		94
> > > ext3-ordered	86		96	277		95
> > > 
> > > Running the test in single user mode, I get the following results:
> > > 
> > > # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> > > 
> > > filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> > > ext3-guarded	84		86	163		91
> > > ext3-writeback 84		88	217		91
> > > ext3-ordered	84		86	226		91
> > 
> > 
> > The difference between guarded and writeback in chunk-4096 looking at
> > your desktop timings and your single user times is.... surprising. 
> 
> Surely. I re-ran the guarded test immediately after that one and got a
> time of 353s with the desktop. Another run much latergave me a 189s time,
> so it seems to vary quite a lot. Initially when I was getting high
> numbers, I thought it could be related to the IO scheduler but looks like
> it's just some background tasks trying to get cpu or io time. Of course,
> the whole system becomes sluggish once these tests start.
> 
> > In particular, the fact that the guarded time is 3 times longer than
> > ext3-writeback when the desktop is running, and 20% faster in single
> > user mode.  Are these results reproducible?  And do you have any
> > thoughts as to what might be causing them?
> 
> I initially thought there was something but I also got lower numbers
> (189s), so I can't really say what it is even though I call sync before
> starting the tests.

Probably because you're swapping heavily, and that is perturbing your
test?  With my setup, 3GB ram + 2GB swap, I can't even run the 4GB test
without an mmap() failure/abort, but with 3GB size, box swaps insanely.

(If I drop file size to 2GB, I see zip difference for all three mounts
modes.  4k chunk time is ~27s for all three.  Actually, all numbers
emitted are around 27s.)

	-Mike

