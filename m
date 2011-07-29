From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Fri, 29 Jul 2011 03:55:30 -0600
Message-ID: <4B7BD8E2-A1F3-4788-9753-20DC78620C5D@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop> <20110727082730.GG20655@tux1.beaverton.ibm.com> <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com> <20110728165615.GI20655@tux1.beaverton.ibm.com> <CAOQ4uxiOpwX2-Nfh9wJ7wSmAnbj9bh1+d9C95-N5D-8saRr6ww@mail.gmail.com> <20110728185730.GJ20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <aedilger@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:41600 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1G2Jzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 05:55:31 -0400
In-Reply-To: <20110728185730.GJ20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-28, at 12:57 PM, Darrick J. Wong wrote:
>>> On Wed, Jul 27, 2011 at 03:16:12AM -0600, Andreas Dilger wrote:
>>>> In the past, the discussion about adding checksums to the index and
>>>> extent blocks was about using an ext4_extent_tail that contained not
>>>> only the checksum of the block, but also a back-pointer to the
>>>> inode/generation of the inode using this block.
>>>> 
>>>> That would allow e2fsck to verify that it is using the correct
>>>> index/extent blocks and not pointing to a stale block that belonged
>>>> to some other inode.
>>>> 
>>>> Since the header and index/extent entries are always 3 *__u32 in size,
>>>> the extent tail can always be 4 * __u32 in size yet only consume a
>>>> single slot in the block. There of course is no reason to put an extent
>>>> tail inside the inode itself.
>>> 
>>> Does anybody have any objection to using crc32c (which we can hardware
>>> accelerate on new Intel boxen) over crc16?  I think it'll be pretty easy
>>> to use some of the reserved space in the group descriptor to store
>>> checksums of the block and inode bitmaps.
>> 
>> On LSF Ted told me i can use 32bit from the group descriptor for exclude
>> bitmap block and that inode and block bitmap checksum would use 16bit each .
> 
> I know;  as far as I know there's still 96 bits of free space in the group
> descriptor, which could be used to crc32 all three bitmaps.  But then that
> leaves the descriptors with no room for further expansion, unless we decide to
> expand them sort of like what was done for inodes.  Do we have a strategy for
> handling continued expansion of metadata objects in ext4?

One reason to stick to crc16 for the block checksums is that this would still
fit inside the ext3_group_desc space, so upgraded filesystems could enable
checksums.

>>> Adding tails to the extent tree blocks seems a bit trickier than that,
>>> but not a big deal, though I guess I'll have to reshuffle
>>> the extent tree to free up space at the end of the block.

I don't think reshuffling is necessary.  It should be OK to add it to blocks
that fit, and skip blocks that don't have enough space.

>>> I was also wondering what people think of adding checksums to directory
>> files?
>>> I think that it's possible to put a checksum in each directory block --
>> for
>>> blocks containing a linear array of actual directory entries, we could
>> zero out
>>> the space past the end of the array and put a checksum at the very end of
>> the
>>> block.  For the dx_node/dx_root blocks, we could probably use the space
>>> occupied by the last dx_entry to store the checksum.  Obviously, we'd have
>> to
>>> move whatever's at the end of the block elsewhere, but then, we have to do
>> that
>>> for the extent tree too.  Basically, the last 4 bytes become the checksum
>> after
>>> whatever's occupying the space is relocated. :)
>>> 
>>> It looks like there's sufficient unused space in ext4_xattr_header to add
>> a
>>> checksum.
>>> 
>>> Also -- should I create separate rocompat feature flags for each metadata
>>> object that I add checksums to?  Or just have one flag that covers them
>> all?
>>> 
>>> Ok, enough crazy ideas for now...
>>> 
>>> --D
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

