From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Thu, 24 Feb 2011 09:59:56 +0100
Message-ID: <20110224085956.GF16661@bitwizard.nl>
References: <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl> <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca> <20110223231739.GS2924@thunk.org> <B80C0D24-033B-4B17-98C5-1645E3651FCD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:53577 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753699Ab1BXI76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 03:59:58 -0500
Content-Disposition: inline
In-Reply-To: <B80C0D24-033B-4B17-98C5-1645E3651FCD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 05:41:31PM -0700, Andreas Dilger wrote:
> On 2011-02-23, at 4:17 PM, Ted Ts'o wrote:
> > On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:
> >> 
> >> If you have the opportunity, I wonder whether the entire need for
> >> tdb can be avoided in your case by using swap and the icount
> >> optimization patches previously posted?  
> > 
> > Unfortunately, there are people who are still using 32-bit CPU's, so
> > no, swap is not a solution here.
> 

> I agree it isn't a solution in all cases, but avoiding GB-sized
> realloc() in the code was certainly enough to fix problems for the
> original people who hit them.  It likely also avoids a lot of
> memcpy() (depending on how realloc is implemented).

So, assuming that the biggest alloc is 1Gb. 
Assuming that we realloc (I haven't seen the code), at twice
the size every time, we'll alloc 1M, then 2M then 4M etc. up to 1G. 

In the last case we'll realloc the 512M pointer to a 1G region. Note
that this requires a contiguous 1G area of free addressing space
within the 3G total available addressing space. But let's ignore that
problem for now.

So for the 1G alloc we'll have to memcpy 512Mb of existing data.
The previous one required a memcpy of 256Mb etc etc. The total is
just under 1G. 

So you're proposing to optimize out a memcpy of 1G of my main memory.

When it boots, my system says: pIII_sse  :  4884.000 MB/sec

So it can handle xor at almost 5G/second. It should be able to do
memcpy (xor with a bunch of zeroes) at that speed. But lets assume
that the libc guys are stupid and mangaged to make it 10 times slower.

So you're proposing to optimize out 1G of memcopy at 0.5G/second or
two seconds of CPU time on an fsck that takes over 24
hours. Congratulations! You've made e2fsck about 0.0023 percent
faster!

Andreas, I really value your efforts to improve e2fsck. But optmizing
code can be done by looking at the code and saying: "this looks
inefficient, lets fix it up". However you're quickly going to be
spending time on optimizations that don't really matter.

(My second computer was a DOS 3.x machine. DOS came with a utility
called "sort". It does what you expect from a DOS program: It refuses
to sort datafiles larger than 64k. So I rewrote it. Turns out my
implementation was 100 times slower in reading in the dataset than the
original version. I did manage to sort 100 times faster than the
original version. End result? Mine was 10 times faster than the
original. They optimized something that didn't matter. I just read
some decades-old literature on sorting and implemented that).h

I firmly believe that a factor of ten performance improvement can be
achieved for fsck for my filesystem. It should be possible to fsck the
filesystem in 3.3 hours.

There are a total of 342M inodes. That's 87Gb. reading that at a
leasurely 50M/second gives us 1700 seconds, or half an hour. (it
should be possible to do better: I have 4 drives each doing 90M/sec,
allowing a total of over 300M/sec).

Then I have 2.7T of data. With old ext2/ext3 that requires indirect
blocks worth 2.7G of data. reading that at 10M/sec (it will be
shattered) requires 270 seconds or 5 minutes.

I have quite a lot of directories. So those might take some time.  The
cputime of actually doing the checks should be possible to overlap
with the IO.

Anyway, although in theory 10x should be possible, I expect that 5x is
a more realistic goal.

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
