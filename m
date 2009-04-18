From: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Sat, 18 Apr 2009 11:33:12 +0530
Message-ID: <20090418060312.GA10943__26915.3418289081$1240034767$gmane$org@amit-x200.pnq.redhat.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com> <20090417180906.GA8363@amit-x200.pnq.redhat.com> <20090417201342.GF26479@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZDRGDm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 02:03:42 -0400
Content-Disposition: inline
In-Reply-To: <20090417201342.GF26479@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On (Fri) Apr 17 2009 [16:13:42], Theodore Tso wrote:
> On Fri, Apr 17, 2009 at 11:39:06PM +0530, Amit Shah wrote:
> > # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> > 
> > filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> > ext3-guarded	85		97	459		90
> > ext3-writeback 86		95	140		94
> > ext3-ordered	86		96	277		95
> > 
> > Running the test in single user mode, I get the following results:
> > 
> > # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> > 
> > filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> > ext3-guarded	84		86	163		91
> > ext3-writeback 84		88	217		91
> > ext3-ordered	84		86	226		91
> 
> 
> The difference between guarded and writeback in chunk-4096 looking at
> your desktop timings and your single user times is.... surprising. 

Surely. I re-ran the guarded test immediately after that one and got a
time of 353s with the desktop. Another run much latergave me a 189s time,
so it seems to vary quite a lot. Initially when I was getting high
numbers, I thought it could be related to the IO scheduler but looks like
it's just some background tasks trying to get cpu or io time. Of course,
the whole system becomes sluggish once these tests start.

> In particular, the fact that the guarded time is 3 times longer than
> ext3-writeback when the desktop is running, and 20% faster in single
> user mode.  Are these results reproducible?  And do you have any
> thoughts as to what might be causing them?

I initially thought there was something but I also got lower numbers
(189s), so I can't really say what it is even though I call sync before
starting the tests.

		Amit
