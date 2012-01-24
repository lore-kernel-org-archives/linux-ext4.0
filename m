From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Tue, 24 Jan 2012 10:32:06 -0700
Message-ID: <E7A109F0-FD6C-4CA4-8B55-6FB12D809896@dilger.ca>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com> <20120124133436.GA18136@quack.suse.cz>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Robin Dong <hao.bigrat@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:16165 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab2AXRbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jan 2012 12:31:48 -0500
In-Reply-To: <20120124133436.GA18136@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-24, at 6:34, Jan Kara <jack@suse.cz> wrote:
> On Mon 23-01-12 20:51:53, Robin Dong wrote:
>> After the bigalloc-feature is completed in ext4, we could have much more
>> big size of block-group (also bigger continuous space), but the extent
>> structure of files now limit the extent size below 128MB, which is not
>> optimal.
> 
>  It is not optimal but does it really make difference? I.e. what
> improvement do you expect from enlarging extents from 128MB to say 4GB (or
> do you expect to be consistently able to allocate continguous chunks larger
> than 4GB?)? All you save is a single read of an indirect block... Is that
> really worth the complications with another extent format? But maybe I miss
> some benefit.

What I'm (somewhat) interested in is increasing the maximum file size. IMHO, I think it would be better to do this with a larger block size (similar to bigalloc, but actually handling large blocks as a side benefit) since this will reduce the allocation overhead as well. 

Even if the blocksize is only 64kB, that would allow files up to 256TB, and filesystems up to 2^64 bytes without the complexity of changing the extent format (which Ted looked at once and thought was difficult).  Since Robin and Ted already did most of that work for bigalloc, I think the remaining effort would be manageable, especially if mmap is disabled on such a filesystem. 

Increasing the maximum extent size may have some small benefit, but I don't think it would be noticeable, and would rarely be used due to fragmentation and such. A single index block with 128MB extents can already address over 16GB, and with large blocks this increases with the square of the blocksize (larger extents * more extents per index block).

Cheers, Andreas

>> We could solve the problem by creating a new extent format to support
>> larger extent size, which looks like this:
>> 
>> struct ext4_extent2 {
>>    __le64    ee_block;    /* first logical block extent covers */
>>    __le64    ee_start;            /* starting physical block */
>>    __le32    ee_len;        /* number of blocks covered by extent */
>>    __le32    ee_flags;    /* flags and future extension */
>> };
>> 
>> struct ext4_extent2_idx {
>>    __le64    ei_block;            /* index covers logical blocks from 'block' */
>>    __le64    ei_leaf;            /* pointer to the physical block of the next level */
>>    __le32    ei_flags;            /* flags and future extension */
>>    __le32    ei_unused;    /* padding */
>> };
>> 
>> I think we could keep the structure of ext4_extent_header and add new
>> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.
>> 
>> The new extent format could support 16TB continuous space and larger volumes.
>> 
>> What's your opinion?
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
