From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 30 Jan 2012 09:07:05 +1100
Message-ID: <20120129220705.GE15102@dastard>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
 <20120125224847.GT15102@dastard>
 <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
 <20120127001904.GB15102@dastard>
 <4F22B436.9070306@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Robin Dong <hao.bigrat@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:25017 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab2A2WHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jan 2012 17:07:09 -0500
Content-Disposition: inline
In-Reply-To: <4F22B436.9070306@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 27, 2012 at 10:27:02PM +0800, Tao Ma wrote:
> Hi Dave,
> On 01/27/2012 08:19 AM, Dave Chinner wrote:
> > On Wed, Jan 25, 2012 at 04:03:09PM -0700, Andreas Dilger wrote:
> >> On 2012-01-25, at 3:48 PM, Dave Chinner wrote:
> >>> On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
> >>>> Hi Ted, Andreas and the list,
> >>>>
> >>>> After the bigalloc-feature is completed in ext4, we could have much more
> >>>> big size of block-group (also bigger continuous space), but the extent
> >>>> structure of files now limit the extent size below 128MB, which is not
> >>>> optimal.

.....

> >>>> The new extent format could support 16TB continuous space and larger volumes.
> >>>>
> >>>> What's your opinion?
> >>>
> >>> Just use XFS.
> >>
> >> Thanks for your troll.
> >>
> >> If you have something actually useful to contribute, please feel free to post.
> >> Otherwise, this is a list for ext4 development.
> > 
> > You can chose to see my comment as a troll, but it has a serious
> > message. If that is your use case is for large multi-TB files, then
> > why wouldn't you just use a filesystem that was designed for files
> > that large from the ground up rather than try to extend a filesystem
> > that is already struggling with file sizes that it already supports?
> > Not to mention that very few people even need this functionality,
> > and those that do right now are using XFS.
> Robin is one of my colleague. And to be frank, ext4 works well currently
> in our product system. And we'd like to see it grows to fit our future
> need also.

Sure. But at the expense of the average user? ext4 is supposed to be
primarily the Linux desktop filesystem, yet all I see is people
trying to make it something for big, bigger and biggest. Bigalloc,
new extent formats, no-journal mode, dioread_nolock, COW snapshots,
secure delete, etc. It's a list of features that are somewhat
incompatible with each other that are useful to only a handful of
vendors or companies. Most have no relevance at all to the uses of
the majority of ext4 users.

This is what I'm getting at - I don't object to adding functionality
that is generically useful and applies to all filesystem configs,
but that's not what is happening. ext4 appears to have a development
mindset of "if we don't support X, then we can do Y" and I don't
think that serves the ext4 users very well at all.

BTW, if you think that is a harsh criticism, just reflect on the
insanity of the recent "we can support 64k block sizes if we just
disable mmap" discussion. Yes, that's great for Lustre, but it is
useless for everyone else...

> I think it helps both the community and our employer. Having
> said that, another reason why we don't consider of XFS as our choice is
> that we don't think we have the ability to maintain 2 file systems in
> our product system.

That's your choice as a product vendor, not mine as an ext4 user....

> > Indeed, on current measures, a 15.95TB file on ext4 takes 330s to
> > allocate on my test rig, while XFS will do it under *35
> > milliseconds*. What's the point of increasing the maximum file size
> > when it when it takes so long to allocate or free the space? If you
> > can't make the allocation and freeing scale first to the existing
> > file size limits, there's little point in introducing support for
> > larger files.
> I think your test case here is biased since you used the most successful
> story from XFS. Yes, bitmap-based file system is a little bit hard to
> allocate a very large file if the bitmap is scattered all over the disk,

Which is the case whenever the filesytem has been used for a while.
I did those tests on a pristine, empty filesystem, so the speed of
allocation only goes down from there. bitmap based allocation
degrades much, much faster than extent-tree based allocation,
especially when you have to search for the free space to allocation
from....

Indeed, how do you plan to test such large files robustly when it
takes so long to allocate the space to them? I mean, I can easily
test large files on XFS because of how quickly allocation occurs. I
can easily fragment free space and test large fragmented files
bcause of how quickly allocation occurs. But if the same test that
take a minute to run on XFS take 4 orders of magnitude longer on
ext4, just how good is your test coverage going to be? What about
when you have different filesystem block sizes, or different mount
options, or doing it concurrently with an online resize? 

IOWs, the slowness of the allocation greatly limits the ability to
test such a feature at the scale it is designed to support.  That's
my big, overriding concern - with ext4 allocation being so slow, we
can't really test large files with enough thoroughness *right now*.
Increasing the file size is only going to make that problem worse
and that, to me, is a show stopper. If you can't test it properly,
then the change should not be made.

> but I don't think ext4 can't fill the gap of this test case in the
> future. Let us wait and see. :)

How do you plan to fix it? If there isn't a plan, or it involves a
major on-disk format change, then aren't we back to square one about
adding intrusive, complex and destablising features to a filesystem
that people are relying to be stable?

> > And as an ext4 user, all I want is from ext4 to be stable like ext3
> > is stable, not have it continually destabilised by the addition of
> > incompatible feature after incompatible feature.  Indeed, I can't
> > use ext4 in the places I'm using ext3 right now because ext4 is not
> > very resilient in the face of 20 system crashes a day. I generally
> > find that ext4 filesystems are irretrievable corrupted within a
> > week.  In comparison, I have ext3 filesystems have lasted more than
> > 3 years under such workloads without any corruptions occurring.
> OK, so next time when you see the corruption, please at least send it to
> the mail list so that ext4 developers can have the chance of seeing it.
> Complaint doesn't improve it.

I won't be reporting corruptions because I stopped using ext4 more
than 6 months ago on these machines after the last batch of
unreproducable, unrepairable corruptions that occurred.  I couldn't
get anything from the corpses (I do know how to analyse a corrupt
ext4 filesystem), so there really wasn't anything to report....

Generally speaking, the first sign of problems was a corrupted
binary or missing or empty file. The filesystem never complained or
detected corruption at runtime. By that stage, the original cause of
the corruption was unfindable because the problems may have happened
many crashes ago and been propagated further. running e2fsck at that
point generally resulted in a mess with lots of stuff ending in
lost+found and multiply linked blocks being duplicated all over the
place. IOWs, an unrecoverable mess.

> > So the long form of my 3-word comment is effectively: "If you need
> > multi-TB files, then use the filesystem most appropriate for that
> > workload instead of trying to make ext4 more complex and unstable
> > than it already is".
> I have read and watched the talk you gave in this year's LCA, your
> assumption about ext4 may be a little frightening, but it is good for
> the ext4 community. In your talk "xfs is much slower than ext4 in
> 2009-2010 for meta-intensive workload", and now it works much faster. So
> why do you think ext4 can't be improved also like xfs?

Because all of the XFS changes talked about in that talk did not
change the on-disk format at all. They are *software-only* changes
and are completely transparent to users. They are even the default
behaviours now, so users with 10 year old XFS filesystems will also
benefit from them. And they can go back to their old kernels if they
don't like the new kernels, too...

We know that the problems ext4 has are much, much deeper and as this
thread shows require significant on-disk format changes to solve.
And they will only benefit those that have new filesystems or make
their old filesystems incompatible with old kernels. IOWs, the
changes being proposed don't help solve problems on all the existing
filesystems transparently.  That's a *major* difference between
where XFS was 2 years ago and where ext4 is now.

Sure, given enough time and resources, any problem is solvable. But
really, do ext4 users really need a new, incompatible, difficult to
test on-disk formats to solve problems that most people will never
hit on their desktop and server systems before they migrate them to
BTRFS?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
