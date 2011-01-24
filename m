From: Tao Ma <tm@tao.ma>
Subject: Re: speed up group trim
Date: Mon, 24 Jan 2011 10:07:55 +0800
Message-ID: <4D3CDEFB.4010102@tao.ma>
References: <1295577131-3778-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com> <CD6D9488-48B7-4964-97DF-76B985FC8FAF@dilger.ca> <4D3A9604.1040001@tao.ma> <B0539BCD-0D34-4463-8B4B-94910B6E3833@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47648 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751788Ab1AXCIx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 21:08:53 -0500
In-Reply-To: <B0539BCD-0D34-4463-8B4B-94910B6E3833@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/24/2011 09:33 AM, Andreas Dilger wrote:
> On 2011-01-22, at 01:32, Tao Ma wrote:
>> On 01/22/2011 01:53 AM, Andreas Dilger wrote:
>>> Actually, I had another idea which might speed up trim operations significantly.  If the kernel keeps a bit in ext4_group_info->bb_state that indicates whether this group has any freed blocks since it last had a trim operation sent to it, then the kernel can completely avoid doing anything for that group.  This isn't just avoiding the need to scan the bitmap for free ranges, but more importantly it avoids sending the TRIM/UNMAP operation to the disk for free ranges that were previously trimmed in the backing storage.
>>
>> It looks good.
>> Just an extra point. we have to store 'minlen' passed in by fstrim_range. So if the user first try minlen=1mb, and then we give them the number we have trimmed. If he isn't satisfied, he can try minlen=512kb again. In this case we have to check with the old 'minlen' and retry again if minlen<  old_minlen.
>
> Maybe I missed something, but why would one run with minlen=1MB and then run again with minlen=512kB?  I can't see why running this command twice would be better than running it a single time with minlen=512kB, if the hardware actually supports that.
>
I don't know either. But that is the user's choice of 'minlen' and we 
can't provent them from doing like that.

Here is a scenario:
1. run with minlen=1mb, he got that only 1G get trimmed. but the free 
space is more than 3gb actually because of the fragmentation.
2. So he decide to run with minlen=512kb or even smaller len to see 
whether more space can be trimmed.

Is it possible? I guess the answer is yes.

Regards,
Tao
>>> Something like:
>>>
>>> #define EXT4_GROUP_INFO_NEED_TRIM_BIT	1
>>>
>>> /* Note that bit clear means a trim is needed, so that a newly mounted
>>> * filesystem assumes that holes the group need to be trimmed. */
>>> #define EXT4_MB_GRP_NEED_TRIM(grp)	\
>>> 	(!test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,&((grp)->bb_state)))
>>>
>>>
>>> When calling the TRIM ioctl it can check EXT4_MB_GRP_NEED_TRIM(grp) and skip that group if it hasn't changed since last time.  Otherwise, it should call EXT4_MB_GRP_DONE_TRIM(grp) before doing the actual trim, so it is not racy with another process freeing blocks in that group.
>>>
>>> In release_blocks_on_commit() it should call EXT4_MB_GRP_MUST_TRIM() to mark that the group needs to be trimmed again, since blocks were freed in the group.
>>>
>>> This can potentially avoid a huge number of TRIMs to the disk, if this is run periodically (e.g. every day) and the filesystem is not remounted all the time, and does not undergo huge allocate/free/allocate cycles during daily use.
>>>
>>> It would even be possible to store this bit on-disk ext4_group_desc->bg_flags to avoid the initial "assume every group needs to be trimmed" operation, if that ends up to be a significant factor.  However, that can be done later once some numbers are measured on how significant the initial-mount overhead is.  It is also not free, since it will cause disk IO to set/clear this bit.
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

