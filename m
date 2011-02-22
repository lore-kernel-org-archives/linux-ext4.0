From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Tue, 22 Feb 2011 11:20:56 +0100
Message-ID: <20110222102056.GH21917@bitwizard.nl>
References: <20110220090656.GA11402@bitwizard.nl> <20110220170931.GB3017@thunk.org> <20110220193406.GC3017@thunk.org> <20110220215531.GA21917@bitwizard.nl> <20110220222013.GA2849@thunk.org> <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pawe?? Brodacki <pawel.brodacki@googlemail.com>,
	Amir Goldstein <amir73il@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:53968 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751486Ab1BVKU6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 05:20:58 -0500
Content-Disposition: inline
In-Reply-To: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 11:00:02AM -0700, Andreas Dilger wrote:
> On 2011-02-21, at 9:04 AM, Pawe?? Brodacki wrote:
> > 2011/2/21 Amir Goldstein <amir73il@gmail.com>:
> >> One thing I am not sure I understand is (excuse my ignorance) why is the
> >> swap space solution good only for 64bit processors?
> > 
> > It's an address space limit on 32 bit processors. Even with PAE the
> > user space process still won't have access to more than 2^32 bits,
> > that is 4 GiB of memory. Due to practical limitations (e.g. kernel
> > needing some address space) usually a process won't have access to
> > more than 3 GiB.
> 
> Roger,

> are you using the icount allocation reduction patches previously
> posted?  They won't help if you need more than 3GB of address space,
> but they definitely reduce the size of allocations and allow the
> icount data to be swapped.  See the thread "[PATCH]: icount: Replace
> the icount list by a two-level tree".

No I don't think I'm using those patches. (Unless they are in the git head). 

I wouldn't be surprised if I'd need more than 3G of RAM. When I
extrapolated "more than a few days" it was at under 20% of the
filesystem and had already allocated on the order of 800Gb of
memory. Now I'm not entirely sure that this is fair: memory use seems
to go up quickly in the beginning, and then stabilize: as if it has
decided that 800M of memory use is "acceptable" and somehow uses a
different strategy once it hits that limit.

On the other hand, things are going reasonably fast until it starts
hitting the CPU-bottleneck so I might have seen the memory usage
flatten out because it wasn't making any significant progress anymore.

Anyway, I've increased the hash size to 1M, up from 131. The TDB guys
suggested 10k: their TDB code is being used for MUCH larger cases than
they expected....

Succes! It's been running 2 hours, and it's past the half-way point
(i.e. 2.5 times further than previously after 24 hours).  (of pass
1). It currently has 1400Mb of memory allocated. Hope the 3G limit
doesn't hit me before it finishes....

 
> >> If it is common knowledge, do you know of an upper limit (depending on fs size,
> >> no. of inodes, etc)?
> >> 
> > 
> > I vaguely remember some estimation of memory requirements of fsck
> > being given somewhere, but I'm not able to find the posts now :(.
 
> My rule of thumb is about 1 byte of memory per block in the
> filesystem, for "normal" filesystems (i.e. mostly regular files, and
> a small fraction of directories).  For a 3TB filesystem this would
> mean ~768MB of RAM.  One problem is that the current icount
> implementation allocates almost 2x the peak usage when it is
> resizing the array, hence the patch mentioned above for filesystems
> with lots of directories and hard links.

My filesystem is a bit weird: I make an "rsync" copy of all my data
onto it. Then I run a cp -lr to copy the current copy to a copy with
the date in it. Next I run a program that will make a second copy
should the number of links exceed 8000....

In short I have a HUMUGOUS amount of directory entries, and lots and
lots of files. And still in the millions of inodes. (Some of the
filesystems backed up contain that many inodes). 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
