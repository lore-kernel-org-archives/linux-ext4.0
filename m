From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Tue, 22 Jan 2008 14:38:30 +1100
Message-ID: <20080122033830.GR155259@sgi.com>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilg
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37410 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbYAVDjO (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2008 22:39:14 -0500
Content-Disposition: inline
In-Reply-To: <20080121230041.GL3180@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2008 at 04:00:41PM -0700, Andreas Dilger wrote:
> On Jan 16, 2008  13:30 -0800, Valerie Henson wrote:
> > I have a partial solution that sort of blindly manages the buffer
> > cache.  First, the user passes e2fsck a parameter saying how much
> > memory is available as buffer cache.  The readahead thread reads
> > things in and immediately throws them away so they are only in buffer
> > cache (no double-caching).  Then readahead and e2fsck work together so
> > that readahead only reads in new blocks when the main thread is done
> > with earlier blocks.  The already-used blocks get kicked out of buffer
> > cache to make room for the new ones.
> >
> > What would be nice is to take into account the current total memory
> > usage of the whole fsck process and factor that in.  I don't think it
> > would be hard to add to the existing cache management framework.
> > Thoughts?
> 
> I discussed this with Ted at one point also.  This is a generic problem,
> not just for readahead, because "fsck" can run multiple e2fsck in parallel
> and in case of many large filesystems on a single node this can cause
> memory usage problems also.
> 
> What I was proposing is that "fsck.{fstype}" be modified to return an
> estimated minimum amount of memory needed, and some "desired" amount of
> memory (i.e. readahead) to fsck the filesystem, using some parameter like
> "fsck.{fstype} --report-memory-needed /dev/XXX".  If this does not
> return the output in the expected format, or returns an error then fsck
> will assume some amount of memory based on the device size and continue
> as it does today.

And while fsck is running, some other program runs that uses
memory and blows your carefully calculated paramters to smithereens?

I think there is a clear need for applications to be able to
register a callback from the kernel to indicate that the machine as
a whole is running out of memory and that the application should
trim it's caches to reduce memory utilisation.

Perhaps instead of swapping immediately, a SIGLOWMEM could be sent
to a processes that aren't masking the signal followed by a short
grace period to allow the processes to free up some memory before
swapping out pages from that process?

With this sort of feedback, the fsck process can scale back it's
readahead and remove cached info that is not critical to what it
is currently doing and thereby prevent readahead thrashing as
memory usage of the fsck process itself grows.

Another example where this could be useful is to tell browsers to
release some of their cache rather than having the VM swap it out.

IMO, a scheme like this will be far more reliable than trying to
guess what the optimal settings are going to be over the whole
lifetime of a process....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
