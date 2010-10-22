From: Felipe Franciosi <felipe@paradoxo.org>
Subject: Re: Committing changes to an ext3_inode structure
Date: Sat, 23 Oct 2010 00:32:55 +0100
Message-ID: <051A3ECE-175F-4C4D-AFE0-BDFDD5C92CA2@paradoxo.org>
References: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org> <B25FFA22-5EBF-472C-B030-22617E4539DE@dilger.ca> <AANLkTinZB5Qv1H-Dt0CQgVFF2_W85NwEdJN3M7nOw-Qo@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39785 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0JVXdA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 19:33:00 -0400
Received: by wyf28 with SMTP id 28so1424123wyf.19
        for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 16:32:59 -0700 (PDT)
In-Reply-To: <AANLkTinZB5Qv1H-Dt0CQgVFF2_W85NwEdJN3M7nOw-Qo@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Greg and Andreas,

Thanks for the replies.

I've read about migration in ext4, but never really touched the code  
because as I understand there is a lot of conceptual differences in  
the inode structure, block allocation and other metadata in general.  
I'm stuck to this (2.6.20) kernel, though (as there are other people  
working on the machine for quite a while and they are not keen to  
upgrade it), and the rest of my work was already done in ext3 anyway.

I will look into the code you pointed out and see if I can get any  
clues out of it. Otherwise I shall bother you again. =)

My problem is pretty much what I said: I am probably doing something  
wrong, but I have no idea how to commit the changes to an struct  
ext3_inode back to disk. Maybe I should actually be modifying  
something else, like a struct ext3_inode_info.

As I said, I also tried to modify the datablock of the inode table  
directly on the disk (and committing the changes, syncing, remounting,  
etc), but maybe because I am marking the inode dirty, the cache gets  
written back to disk and overwriting my changes after I do the  
alteration.

Cheers,
Felipe

On 19 Oct 2010, at 23:55, Greg Freemyer wrote:

> On Tue, Oct 19, 2010 at 5:56 PM, Andreas Dilger <adilger@dilger.ca>  
> wrote:
>> On 2010-10-19, at 09:23, Felipe Franciosi wrote:
>>> I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and  
>>> evaluate different methods for migrating datablocks for a given  
>>> inode on the fly.
>>>
>>> I have created an ioctl call that implements some verifications  
>>> and invokes a function I wrote in balloc.c for such migration.
>>
>> Are you aware that there already is the ability to do on-the-fly  
>> migration of files in ext4?  This was developed quite some time ago  
>> and is in ext4 in newer kernels (not sure of the exact version,  
>> maybe 2.6.32 or so).
>>
>> I would strongly recommend that you investigate that code, since it  
>> could definitely use some good testing/inspection/enhancement (as  
>> needed).  It is in fs/ext4/migrate.c, though I'm not sure where the  
>> user-space tools are located (maybe e2fsprogs?).
>>
>> Cheers, Andreas
>
> I'm not familiar with that code, I'm curious what it does?
>
> But there is also the EXT4_IOC_MOVE_EXT ioctl which is called by
> e4defrag primarily.
>
> The code is in fs/ext4/move_extent.c
>
> The concept is you allocate new blocks in a donor inode.  Once you
> have that done, then EXT4_IOC_MOVE_EXT will move the data from the
> original data blocks to the new ones and replace the old original
> blocks with the new donor blocks.
>
> All done on the fly.
>
> Greg

