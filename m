From: tytso@mit.edu
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Tue, 6 Apr 2010 14:45:05 -0400
Message-ID: <20100406184505.GL23670@thunk.org>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
 <20100401194822.GA8401@atrey.karlin.mff.cuni.cz>
 <x49tyrpkjmq.fsf@segfault.boston.devel.redhat.com>
 <20100405174603.GA24493@thunk.org>
 <20100406182527.GF3029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57368 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0DFSpI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Apr 2010 14:45:08 -0400
Content-Disposition: inline
In-Reply-To: <20100406182527.GF3029@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> CFQ currently seems to be preempting any thread doing IO if a request has
> been marked as metadata. I think this is going to be bad for any other IO
> going on.
> 
> I wrote a small fio script which is doing buffered writes with bs=32K and I
> am doing fsync on file after every 20 IOs (fsync=20). I am assuming that this
> something close to writting a small file and then doing fsync on that. 
> 
> With that fio script running I launched firefox and measured the
> time it takes.....  it looks like that firefox launching times have
> seems to just almost doubled.

Vivek, thanks for pointing this out.  Sounds like we need to think
carefully about whether the potential unfairness that this patch might
impose on other workloads sharing the file system dominates the
improvements that Jeff found when there's only a single workload
running on the file system.

I'm tentatively leaning towards pulling this patch so we can do more
testing / benchmarking.   Jeff, any thoughts or comments?

						- Ted
