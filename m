From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Mon, 21 Jan 2008 16:00:41 -0700
Message-ID: <20080121230041.GL3180@webber.adilger.int>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
 <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Valerie Henson <val@vahconsulting.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 16, 2008  13:30 -0800, Valerie Henson wrote:
> I have a partial solution that sort of blindly manages the buffer
> cache.  First, the user passes e2fsck a parameter saying how much
> memory is available as buffer cache.  The readahead thread reads
> things in and immediately throws them away so they are only in buffer
> cache (no double-caching).  Then readahead and e2fsck work together so
> that readahead only reads in new blocks when the main thread is done
> with earlier blocks.  The already-used blocks get kicked out of buffer
> cache to make room for the new ones.
>
> What would be nice is to take into account the current total memory
> usage of the whole fsck process and factor that in.  I don't think it
> would be hard to add to the existing cache management framework.
> Thoughts?

I discussed this with Ted at one point also.  This is a generic problem,
not just for readahead, because "fsck" can run multiple e2fsck in parallel
and in case of many large filesystems on a single node this can cause
memory usage problems also.

What I was proposing is that "fsck.{fstype}" be modified to return an
estimated minimum amount of memory needed, and some "desired" amount of
memory (i.e. readahead) to fsck the filesystem, using some parameter like
"fsck.{fstype} --report-memory-needed /dev/XXX".  If this does not
return the output in the expected format, or returns an error then fsck
will assume some amount of memory based on the device size and continue
as it does today.

If the fsck.{fstype} does understand this parameter, then fsck makes a
decision based on devices, parallelism, total RAM (less some amount to
avoid thrashing), then it can call the individual fsck commands with
"--maximum-memory MMM /dev/XXX" so each knows how much cache it can
allocate.  This parameter can also be specified by the user if running
e2fsck directly.

I haven't looked through your patch yet, but I hope to get to it soon.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

