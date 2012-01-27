From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Fri, 27 Jan 2012 11:19:04 +1100
Message-ID: <20120127001904.GB15102@dastard>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
 <20120125224847.GT15102@dastard>
 <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robin Dong <hao.bigrat@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27712 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab2A0ATI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 19:19:08 -0500
Content-Disposition: inline
In-Reply-To: <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 25, 2012 at 04:03:09PM -0700, Andreas Dilger wrote:
> On 2012-01-25, at 3:48 PM, Dave Chinner wrote:
> > On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
> >> Hi Ted, Andreas and the list,
> >> 
> >> After the bigalloc-feature is completed in ext4, we could have much more
> >> big size of block-group (also bigger continuous space), but the extent
> >> structure of files now limit the extent size below 128MB, which is not
> >> optimal.
> >> 
> >> We could solve the problem by creating a new extent format to support
> >> larger extent size, which looks like this:
> >> 
> >> struct ext4_extent2 {
> >> 	__le64	ee_block;	/* first logical block extent covers */
> >> 	__le64	ee_start;	        /* starting physical block */
> >> 	__le32	ee_len;		/* number of blocks covered by extent */
> >> 	__le32	ee_flags;	/* flags and future extension */
> >> };
> >> 
> >> struct ext4_extent2_idx {
> >> 	__le64	ei_block;	        /* index covers logical blocks from 'block' */
> >> 	__le64	ei_leaf;	        /* pointer to the physical block of the next level */
> >> 	__le32	ei_flags;	        /* flags and future extension */
> >> 	__le32	ei_unused;	/* padding */
> >> };
> >> 
> >> I think we could keep the structure of ext4_extent_header and add new
> >> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.
> >> 
> >> The new extent format could support 16TB continuous space and larger volumes.
> >> 
> >> What's your opinion?
> > 
> > Just use XFS.
> 
> Thanks for your troll.
>
> If you have something actually useful to contribute, please feel free to post.
> Otherwise, this is a list for ext4 development.

You can chose to see my comment as a troll, but it has a serious
message. If that is your use case is for large multi-TB files, then
why wouldn't you just use a filesystem that was designed for files
that large from the ground up rather than try to extend a filesystem
that is already struggling with file sizes that it already supports?
Not to mention that very few people even need this functionality,
and those that do right now are using XFS.

Indeed, on current measures, a 15.95TB file on ext4 takes 330s to
allocate on my test rig, while XFS will do it under *35
milliseconds*. What's the point of increasing the maximum file size
when it when it takes so long to allocate or free the space? If you
can't make the allocation and freeing scale first to the existing
file size limits, there's little point in introducing support for
larger files.

And as an ext4 user, all I want is from ext4 to be stable like ext3
is stable, not have it continually destabilised by the addition of
incompatible feature after incompatible feature.  Indeed, I can't
use ext4 in the places I'm using ext3 right now because ext4 is not
very resilient in the face of 20 system crashes a day. I generally
find that ext4 filesystems are irretrievable corrupted within a
week.  In comparison, I have ext3 filesystems have lasted more than
3 years under such workloads without any corruptions occurring.

So the long form of my 3-word comment is effectively: "If you need
multi-TB files, then use the filesystem most appropriate for that
workload instead of trying to make ext4 more complex and unstable
than it already is".

> I don't encourage XFS users to switch to ext4 (or ZFS, for that matter, since
> ZFS can do a lot of things that just aren't possible for XFS, and is now
> available for Linux) on your mailing lists, and I'd appreciate the same
> courtesy here...

Sorry, I didn't realise that I'm not aren't allowed to tell ext4
people to use the filesystem most appropriate to their requirements.
Extending ext4 is not the right solution to every problem.

I say stuff like this w.r.t. "don't use XFS for that" or "XFS will
never support that" all the time on the XFS lists and IRC channels,
and nobody thinks that it is out of place. If you want to pop up and
say that "you should use ext4 for that" on the XFS lists then you
are welcome to do so. Such comments generally results in an
informative technical discussion of the pros and cons of why
something is or is not suited to the given requirement without
anyone being called a troll.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
