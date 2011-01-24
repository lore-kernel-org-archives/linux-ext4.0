From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: speed up group trim
Date: Mon, 24 Jan 2011 11:51:36 -0700
Message-ID: <C2FEF4DB-531E-4541-8332-A8845396EAC7@dilger.ca>
References: <1295577131-3778-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com> <CD6D9488-48B7-4964-97DF-76B985FC8FAF@dilger.ca> <4D3A9604.1040001@tao.ma> <B0539BCD-0D34-4463-8B4B-94910B6E3833@dilger.ca> <4D3CDEFB.4010102@tao.ma> <alpine.LFD.2.00.1101241417560.3090@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32007 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AXSvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 13:51:37 -0500
In-Reply-To: <alpine.LFD.2.00.1101241417560.3090@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-24, at 06:39, Lukas Czerner wrote:
>> I don't know either. But that is the user's choice of 'minlen' and we can't
>> provent them from doing like that.
>> 
>> Here is a scenario:
>> 1. run with minlen=1mb, he got that only 1G get trimmed. but the free space is
>> more than 3gb actually because of the fragmentation.
>> 2. So he decide to run with minlen=512kb or even smaller len to see whether
>> more space can be trimmed.
>> 
>> Is it possible? I guess the answer is yes.
> 
> Hi,
> 
> I think that this is actually quite useful *feature*. I can imagine that
> people might want to run FITRIM with bigger minlen (megabytes or tens of
> megabytes) weekly, as it is much faster, especially on fragmented
> filesystem. Then, they might want to run FITRIM with smaller minlen (4kB)
> monthly to reclaim even the smaller (or all of them) extents.
> 
> But I like Andreas' idea, it should improve FITRIM performance
> significantly (since we are doing mkfs trim). Minlen can be stored in
> high bits of bb_state as number of blocks.

I'd rather just add a proper field in ext4_group_info to store the length.  I don't think this will change the actual memory usage, since this is already a fairly large and odd-sized structure.

>>>>> Something like:
>>>>> 
>>>>> #define EXT4_GROUP_INFO_NEED_TRIM_BIT	1
>>>>> 
>>>>> /* Note that bit clear means a trim is needed, so that a newly mounted
>>>>> * filesystem assumes that holes the group need to be trimmed. */
>>>>> #define EXT4_MB_GRP_NEED_TRIM(grp)	\
>>>>> 	(!test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,&((grp)->bb_state)))
>>>>> 
>>>>> 
>>>>> When calling the TRIM ioctl it can check EXT4_MB_GRP_NEED_TRIM(grp) and
>>>>> skip that group if it hasn't changed since last time.  Otherwise, it
>>>>> should call EXT4_MB_GRP_DONE_TRIM(grp) before doing the actual trim, so
>>>>> it is not racy with another process freeing blocks in that group.
>>>>> 
>>>>> In release_blocks_on_commit() it should call EXT4_MB_GRP_MUST_TRIM() to
>>>>> mark that the group needs to be trimmed again, since blocks were freed
>>>>> in the group.
>>>>> 
>>>>> This can potentially avoid a huge number of TRIMs to the disk, if this
>>>>> is run periodically (e.g. every day) and the filesystem is not remounted
>>>>> all the time, and does not undergo huge allocate/free/allocate cycles
>>>>> during daily use.
>>>>> 
>>>>> It would even be possible to store this bit on-disk
>>>>> ext4_group_desc->bg_flags to avoid the initial "assume every group needs
>>>>> to be trimmed" operation, if that ends up to be a significant factor.
>>>>> However, that can be done later once some numbers are measured on how
>>>>> significant the initial-mount overhead is.  It is also not free, since
>>>>> it will cause disk IO to set/clear this bit.
>>>>> 
>>>>> Cheers, Andreas
>>>>> 
>>>>> 
>>>>> 
>>>>> 
>>>>> 
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> 
>>> 
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
>> 
> 
> -- 


Cheers, Andreas





