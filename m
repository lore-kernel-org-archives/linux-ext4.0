From: Felipe Franciosi <felipe@paradoxo.org>
Subject: Re: Committing changes to an ext3_inode structure
Date: Sat, 23 Oct 2010 22:58:36 +0100
Message-ID: <0D8120AE-C6A0-4332-B49E-B8AC1FE9F557@paradoxo.org>
References: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org> <AANLkTinV0G_Bf4xc4F6XXivpjXJjkTAOgQ8rHsNts0FH@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43876 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0JWV6k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Oct 2010 17:58:40 -0400
Received: by wyf28 with SMTP id 28so2103809wyf.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Oct 2010 14:58:39 -0700 (PDT)
In-Reply-To: <AANLkTinV0G_Bf4xc4F6XXivpjXJjkTAOgQ8rHsNts0FH@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Amir,

I finally got it working this morning, but thanks for your reply.  
Indeed all I had to do was to modify i_data... I got confused because  
of this:

On the kernel I have (haven't checked other versions), I see:

include/linux/ext3_fs_i.h:
struct ext3_inode_info {
    __le32 i_data[15];   /* unconverted */
    ...
}

include/linux/ext3_fs.h:
struct ext3_inode {
    ...
    __le32 i_block[EXT3_N_BLOCKS};   /* Pointers to blocks */
    ...
}

I never associated the two as being the same, even though I obviously  
knew EXT3_N_BLOCKS is 15, and the comments on ext3_fs_i.h are not very  
useful, are they? :-/
When I glanced at them, I just assumed it was some raw unconverted  
stuff that had nothing to do with what I wanted.

And yes, as you pointed out and as I said late last night, my fears  
were confirmed: my changes were being overwritten by the  
ext3_inode_info later on. :-(

But I'm glad it's (almost) all working now. I had tried to look for  
the code that manipulate inodes (and not buffer_heads), but I was  
overlooking anything related to an ext3_inode_info struct (I had in my  
head that things were related to the ext3_inode struct). After  
checking out the code pointed out to me here in the list (fs/ext4/ 
migrate.c) I finally got it working. Thanks again to Greg and Andreas  
as well.

Regards,
Felipe

On 23 Oct 2010, at 17:48, Amir Goldstein wrote:

> On Tue, Oct 19, 2010 at 5:23 PM, Felipe Franciosi  
> <felipe@paradoxo.org> wrote:
>> Dear all,
>>
>> I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and  
>> evaluate
>> different methods for migrating datablocks for a given inode on the  
>> fly.
>>
>> I have created an ioctl call that implements some verifications and  
>> invokes
>> a function I wrote in balloc.c for such migration.
>>
>> Upon receiving a struct inode*, I retrieve the corresponding iloc  
>> using the
>> ext3_get_inode_iloc() function and then the struct ext3_inode*  
>> using the
>> ext3_raw_inode() on the iloc. I have confirmed the pointer is  
>> correct by
>> printing several ext3_inode relevant fields.
>>
>
> you've complicated things too much.
> all you have to do is modify EXT3_I(inode)->i_data and then call
> ext3_mark_inode_dirty().
> the rest of the iloc and raw inode stuff is taken care of by  
> ext3_put_inode().
>
>> After making my modifications to the i_block array, I am finding it
>> impossible to commit these changes to the inode itself.
>>
>
> that is because your changes are being overriden by the unmodified  
> ei->i_data.
>
>> I have tried different things such as marking the iloc.bh  
>> buffer_head as
>> dirty and submitting it for writing, marking the page as dirty,  
>> etc, but I
>> think I'm missing something more fundamental. Most of my attempts  
>> were
>> planned according to what I've seen inside similar code of  
>> buffer_head
>> manipulation.
>>
>
> maybe you should have looked at code that modifies inodes instead...
>
>> Can anyone shed some light on what I'm missing?
>>
>
> hope this helps,
> Amir.

