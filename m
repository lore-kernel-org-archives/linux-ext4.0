From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH, RFC 3/3] ext4: use the O_HOT and O_COLD open flags to influence inode allocation
Date: Thu, 19 Apr 2012 16:55:11 -0600
Message-ID: <38626BFC-A2BB-468D-8297-51F7A887859F@whamcloud.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu> <1334863211-19504-4-git-send-email-tytso@mit.edu> <4F906B58.604@redhat.com> <20120419195909.GG6317@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120419195909.GG6317@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2012-04-19, at 1:59 PM, Ted Ts'o wrote:
> On Thu, Apr 19, 2012 at 02:45:28PM -0500, Eric Sandeen wrote:
>> 
>> I'm curious to know how this will work for example on a linear device
>> make up of rotational devices (possibly a concat of raids, etc).
>> 
>> At least for dm, it will be still marked as rotational,
>> but the relative speed of regions of the linear device can't be inferred from the offset within the device.
> 
> Hmm, good point.  We need a way to determine whether this is some kind
> of glued-together dm thing versus a plain-old HDD.

I would posit that in a majority of cases that low-address blocks
are much more likely to be "fast" than high-address blocks.  This
is true for RAID-0,1,5,6, most LVs built atop those devices (since
they are allocated from low-to-high offset order).

It is true that some less common configurations (the above dm-concat)
may not follow this rule, but in that case the filesystem is not
worse off compared to not having this information at all.

>> Do we really have enough information about the storage under us to
>> know what parts are "fast" and what parts are "slow?"
> 
> Well, plain and simple HDD's are still quite common; not everyone
> drops in an intermediate dm layer.  I view dm as being similar to
> enterprise storage arrays where we will need to pass down an explicit
> hint with block ranges down to the storage device.  However, it's
> going to be a long time before we get that part of the interface
> plumbed in.
> 
> In the meantime, it would be nice if we had something that worked in
> the common case of plain old stupid HDD's --- we just need a way of
> determining that's what we are dealing with.

Also, if the admin knows (or can control) what these hints mean, then
they can configure the storage explicitly to match the usage.  I've
long been a proponent of configuring LVs with hybrid SSD+HDD storage,
so that ext4 can allocate inodes + directories on the SSD part of each
flex_bg, and files on the RAID-6 part of the flex_bg.  This kind of
API would allow files to be hinted similarly.

While having flexible kernel APIs that allowed the upper layers to
understand the underlying layout would be great, I also don't imagine
that this will arrive any time soon.  It will also take userspace and
application support to be able to leverage that, and we have to start
somewhere.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




