From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: mkfs'ing a 48-bit fs... or not.
Date: Mon, 3 Oct 2011 23:31:34 -0600
Message-ID: <A556DFD3-DFDC-4BC3-8E20-53DB4C72EDA2@gmail.com>
References: <4E8A2F3F.30700@sandeen.net> <20111004040033.GM6684@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@sandeen.net>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50061 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1JDFax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2011 01:30:53 -0400
Received: by ywb5 with SMTP id 5so122733ywb.19
        for <linux-ext4@vger.kernel.org>; Mon, 03 Oct 2011 22:30:53 -0700 (PDT)
In-Reply-To: <20111004040033.GM6684@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-03, at 10:00 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Oct 03, 2011 at 04:55:11PM -0500, Eric Sandeen wrote:
>> Has anyone tried mke2fs at its limits?  The latest git tree seems to fail in several ways.
>> (Richard Jones reported the initial failure)
>> 
>> # truncate --size 1152921504606846976 reallybigfile 
>> # mke2fs -t ext4 reallybigfile
>> 
>> first,
>> 
>> Warning: the fs_type huge is not defined in mke2fs.conf
>> 
>> (when types "big" and "huge" got added, they never got a mke2fs.conf update?)
> 
> It used to be that an undefined file system type didn't flag an error.
> It now does, so we should have definitions for them in mke2fs.conf.
> 
>> reallybigfile: Not enough space to build proposed filesystem while setting up superblock

Isn't there also a problem with the number of block group descriptor blocks in the first group, if meta_bg is not used?  With 64-byte group descriptors per 128MB group this is 1024 bytes of descriptors for 2GB of blocks, or 128MB of descriptors for 256TB of blocks.  At this point group 0 is full of primary block descriptors and group 1 is full of backup descriptors, and we are out of luck to make a larger filesystem. 

That is only 2^48 bytes, not 2^48 blocks (2^60 bytes), so it means meta_bg needs to get into more testing, and online resize with flex_bg needs to move forward. 

>> because:
>> 
>>        fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
>>                ext2fs_blocks_count(super) - super->s_first_data_block,
>>                EXT2_BLOCKS_PER_GROUP(super));
>>        if (fs->group_desc_count == 0) {
>>                retval = EXT2_ET_TOOSMALL;
>> 
>> The div64_ceil returns > 2^32 (2^33, actually), and the cast to blk_t
>> (which should be dgrp_t?) turns that into a 0.
> 
> Yep, that should be dgrp_t.  Oops.
> 
>> Trying it with "-O bigalloc" (which should be automatic at this size,
>> I think?) just goes away for a very long time, I'm not sure what it's
>> thinking about, or if it's in a loop somewhere (looking now).
> 
> Well, we probably do want to engage bigalloc automatically, at some
> point (I want to wait until bigalloc is in commonly used kernels, at
> least for community distro's).  I'm not sure what the best cluster
> size to pick by default should be, though.  16k?  64k?
> 
>                                                  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
