From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Tue, 06 Apr 2010 15:04:53 -0400
Message-ID: <x491vesqu5m.fsf@segfault.boston.devel.redhat.com>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
	<20100401194822.GA8401@atrey.karlin.mff.cuni.cz>
	<x49tyrpkjmq.fsf@segfault.boston.devel.redhat.com>
	<20100405174603.GA24493@thunk.org> <20100406182527.GF3029@redhat.com>
	<20100406184505.GL23670@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab0DFTFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Apr 2010 15:05:13 -0400
In-Reply-To: <20100406184505.GL23670@thunk.org> (tytso@mit.edu's message of
	"Tue, 6 Apr 2010 14:45:05 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

>> CFQ currently seems to be preempting any thread doing IO if a request has
>> been marked as metadata. I think this is going to be bad for any other IO
>> going on.
>> 
>> I wrote a small fio script which is doing buffered writes with bs=32K and I
>> am doing fsync on file after every 20 IOs (fsync=20). I am assuming that this
>> something close to writting a small file and then doing fsync on that. 
>> 
>> With that fio script running I launched firefox and measured the
>> time it takes.....  it looks like that firefox launching times have
>> seems to just almost doubled.
>
> Vivek, thanks for pointing this out.  Sounds like we need to think
> carefully about whether the potential unfairness that this patch might
> impose on other workloads sharing the file system dominates the
> improvements that Jeff found when there's only a single workload
> running on the file system.
>
> I'm tentatively leaning towards pulling this patch so we can do more
> testing / benchmarking.   Jeff, any thoughts or comments?

Yeah, pull it.  I just talked this over with Vivek, and looking back at
the blktrace data I think I have another idea that might work and be
less invasive.

Basically, the iozone process is, umm, special.  It does the following
at startup (from memory, so I might've missed a step):

open(fd);
truncate(fd,0);
close(fd)
open(fd);
fsync(fd);

*then* it does I/O.

So, we get a sync cfqq for the iozone process that ends up doing the
metadata lookups.  Then it does the truncate and of course blocks.  At
this point, we are waiting for jbd2 to run to sync out its transaction.
However, we're idling on the iozone cfqq, so it doesn't get a chance to
run for 8ms.

If we instead just pass a hint down to the I/O scheduler on fsync,
similar to the schedule() call for the cpu scheduler, then I think we
can give up our time slice and allow the jbd2 process to run.

I'll report back with my findings.  Vivek, thanks a ton for the careful
(as always) review.

Cheers,
Jeff
