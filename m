From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 unlink performance
Date: Wed, 19 Nov 2008 16:18:40 -0500
Message-ID: <20081119211840.GA8021@mit.edu>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu> <20081115204423.GA4671@untroubled.org> <20081116005610.GI22948@mit.edu> <20081117004330.GC3436@webber.adilger.int> <20081119024021.GA10185@mit.edu> <20081119181000.GD3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48434 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743AbYKSVS5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Nov 2008 16:18:57 -0500
Content-Disposition: inline
In-Reply-To: <20081119181000.GD3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 19, 2008 at 12:10:01PM -0600, Andreas Dilger wrote:
> 
> That may be a side-effect of the mballoc per-CPU cache again, where
> files being written in the same subdirectory are spread apart because
> of the write thread being rescheduled to different cores.
> 

It would be good for us to get confirmation one way or another about
this theory.  Bruce, if you have multiple CPU's (or cores on your
system --- i.e., cat /proc/cpuinfo reports multiple processors), can
you try unpacking your tarball on a test ext4 filesystem using
something like:

    taskset 1 tar xjf /path/to/my/tarball.tar.bz2

The "taskset 1" will bind the tar process to only run on a single
processors.  If that significantly changes the time to do run rm -rf,
can you save a raw e2image using that workload?  That would be very
useful indeed.

Alternatively, if you don't have the taskset command handy, you can
also add maxcpus=1 to the kernel boot command-line, which will force
the system to only use one cpu.  Using taskset is much more
convenient, though.

Thanks!!

						- Ted
