From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 64bit filesystem questions
Date: Fri, 10 Jun 2011 10:19:05 -0600
Message-ID: <7CFF213A-00F5-4E6B-A31C-F17FAA2FFB04@dilger.ca>
References: <4DF0DA54.1080005@cfl.rr.com> <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca> <4DF23611.7000307@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49697 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FJQTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 12:19:08 -0400
In-Reply-To: <4DF23611.7000307@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-10, at 9:19 AM, Phillip Susi wrote:
> On 6/9/2011 8:08 PM, Andreas Dilger wrote:
>> There is only a single block pointer for each bitmap per group.  That said,
>> with flex_bg this is mostly meaningless, since the bitmaps do not have to
>> be located in the group, and a flex group is the same as a virtual group
>> that is {flex_bg_factor} times as large.
> 
> Of course there is only a single pointer because there is only a single bitmap.  What does this have to do with limiting the block count to 8 * blocksize?

I think in the presence of flex_bg this issue is moot.

>>> 3)  Why does 64bit disable the resize inode?
>> 
>> Because the on-disk format of the resize inode is only suitable for 32-bit
>> filesystems (it is an indirect-block mapped file and cannot reserve blocks
>> beyond 2^32).  The "future" way to resize filesystems is using the META_BG
>> feature, but the ability to use it has not been integrated into the kernel
>> or e2fsprogs yet.
> 
> Ahh, right... no indirect blocks.  Couldn't and shouldn't the resize inode just use extents instead?  Also I thought that META_BG was an idea that eventually become FLEX_BG and has been dropped?

META_BG also reduces the number of group descriptor blocks needed for the table.

Normally (without META_BG) each group descriptor table has a full copy of all
group descriptor blocks, and it has to be allocated contiguously on disk.
With META_BG, there are only 2 backups of each GDT block, and it is spread
around the filesystem, so there is not a need to allocate huge chunks of space.

Once we get a filesystem up to 256TB in size the size of the GDT will be larger
than a whole group (more than 128MB per GDT) and it will not be possible to
create a larger filesystem without META_BG.


Cheers, Andreas





