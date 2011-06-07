From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 23:17:28 -0600
Message-ID: <BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com> <20110606205512.GE20818@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44934 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1FGFRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 01:17:34 -0400
In-Reply-To: <20110606205512.GE20818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-06, at 2:55 PM, Ted Ts'o wrote:
> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
>>> For one reason, a snapshot file format is currently an indirect file
>>> and big_alloc doesn't support indirect mapped files.
>>> I am not saying it cannot be done, but if it does, there would be
>>> several obstacles to cross.
>> 
>> I know I'm kind of just throwing a bomb out here, but I am very concerned
>> about the ever-growing feature (in)compatibility matrix in ext4.
> 
> bigalloc doesn't support indirect blocks mainly because it was faster
> to get things working if I didn't have to worry about indirect blocks.
> It wouldn't be _that_ hard to make bigalloc work on indirect blocks.
> I'll get around to it at some point.

My main concern isn't about whether bigalloc grows support for indirect-
mapped files, but rather the opposite - that snapshots gain support for
extent-mapped files.  In fact, since extent-mapped files can be 16TB in
size, it might make sense that the snapshots are _always_ extent-mapped
files, and we don't need to deal with the new block-mapped files with
4-triple-indirect blocks layout at all?  Since snapshots are only going
into ext4, and ext4 + e2fsprogs already support extents, there wouldn't
be any issue about compatibility?

The only concern might be that mapping fragmented files into extents is
more effort, which makes me wonder about whether we should introduce the
"block-mapped extents" that I proposed in the past, to allow efficient
mapping of files (or parts thereof) that are highly fragmented, but still
keeping the benefits of extents (internal redundancy, 48-bit physical
block numbers, and while we are adding a new extent format it could be
designed to add 48-bit logical block numbers.

In another email Amir G. wrote:
> Andreas Dilger wrote:

>> I'd be a lot more confident in its acceptance if there was at least a design for how to move forward with this feature for filesystems with extents and 64bit support. I'd be happy with some co-requirement that bigalloc is needed for filesystems larger than 2^32 blocks (for example), so that there is never a need to have a snapshot with more than 2^32 blocks.
>> 
>> Doing this design work may point out some other solution which does not require the 4*triple-indirect block hack in the first place, and will improve the code in the long run.
> 
> The design in this case is quite one-way-to-go - that is defining a
> new extent format with 48bit logical addresses.

Agreed.  Is this something in your upcoming development plans, or just a
feature that might be implemented some day?

> There are 2 reasons I used the 4 tind blocks hack:
> 1. Historic - the patches come from next3 which needed 16TB volume support
> 2. KISS - I don't know if you noticed, but the amount of lines in this
>    hack is very small. both for ext4 and for libext2, the blk_to_path logic
>    for indirect mapped files is very easy to modify, which makes the patch
>    very easy to review.

Cheers, Andreas





