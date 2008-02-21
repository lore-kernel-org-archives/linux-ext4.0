From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Thu, 21 Feb 2008 10:40:24 -0600
Message-ID: <47BDA978.7060403@redhat.com>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com> <20080221140546.GF14614@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbYBUQkr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 11:40:47 -0500
In-Reply-To: <20080221140546.GF14614@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Feb 20, 2008 at 12:46:57PM -0600, Eric Sandeen wrote:
>> Theodore Tso wrote:
>>> The big news here is that extents branch is sufficiently finished that
>>> I've promoted it to the next branch.
>> Hey, that's great news.  :)
>>
>> Out of curiosity; what is the plan for behavior when finding symlinks
>> with the extents flag set?  Last I checked e2fsprogs-interim, they got
>> clobbered.  Is that on the TODO before extents support goes "live?"
> 
> Right now on e2fpsrogs 'next' the extents flag being set on symlinks,
> block/char devices (in general inodes for which
> ext2fs_has_valid_blocks returns NULL) are ignored.  I need to make
> sure this does the right thing with long symlinks --- and I'd argue
> that given that long symlinks can only *ever* be one block long, it's
> pointless to use the extents format, since it's just too complicated,
> and I *think* that's what the kernel code is doing, but I need to
> check to be sure.

After the patches I sent a couple days ago, which Aneesh then collapsed
into the ext4_new_inode logic, that should be the case (for both types
of symlinks)

> Eventually I'll add code to mainline to clear EXTENTS_FL from inodes
> that shouldn't have it, but the kernel patches need to hit mainline first.

Ok, but my concern is what happens to those long symlinks when they
really truly are in extents format.  One option is to say "hey it was
ext4DEV, deal with it" and nuke the symlink, but if possible, converting
back to the proper format would be nice.

> ...

> So one question which Eric you'll want to consider is at what point
> you want to switch the FC users from e2fsprogs-interim to the
> bleeding-edge e2fsprogs mainline code, since eventually this is the
> branch that will have blk64_t support.

Well, honestly I haven't even put -interim into rawhide yet, although
I'm fairly close to that (or -next, whichever makes the most sense)

In my testing a few days ago, e2fsck from -interim blew away the long
symlinks, and I didn't want to foist that upon the folks using ext4dev
today...

> One related question is whether we want to try to get support for full
> 64-bit physical block numbers into ext4.  I think there were some
> rough draft patches floating about, but IIRC they didn't
> simultaneously support the 48-bit extent format.  The e2fsprogs
> mainline implementation of extents makes it fairly easy to support new
> extents formats --- it's minimal code changes in a single file,
> lib/ext2fs/extents.c, and made sure all of the infrastructure was
> present to make this easy --- but I believe that trying to support
> multiple formats in the kernel given the current ext4 code would be
> fairly invasive.  Given the timeline, I'm assuming that our current
> path is that we aren't planning on pushing full 64-bit physical block
> support into the extents format for what we hope will make it into the
> next round of enterprise kernels, but I thought I should throw out the
> question so we make the decision one way or the other, explicitly.

I too had assumed that 48 bits would be it for now; it should be
sufficient for a good while.  I guess what I'd like to see if a usable
ext4 out there in the near future, with stuff added on later as
necessary; delalloc, flex_bg (if that doesn't make 2.6.25...) etc.

Oh, speaking of all this - what do you think the criteria are for
dropping the "dev" from ext4dev?  How do we decide that it's cooked
enough?  :)

Thanks,
-Eric
