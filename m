From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Sat, 07 Feb 2009 13:20:48 -0500
Message-ID: <498DD100.3000700@redhat.com>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu> <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com> <498B084F.2060608@redhat.com> <20090205164803.GM8945@mit.edu> <87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com> <20090205221809.GD9814@mit.edu> <87r62aidh8.fsf@frosties.localdomain> <20090207155151.GE29213@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38478 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZBGSVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Feb 2009 13:21:12 -0500
In-Reply-To: <20090207155151.GE29213@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, Feb 07, 2009 at 02:27:31PM +0100, Goswin von Brederlow wrote:
>   
>> I see the following scenario:
>>
>> 1) The filesystem / thin-provision gets corrupted somehow. fs bug,
>> hardware, whatever.
>>
>> 2) The thin-provision thinks a block is free while the FS thinks it is
>> in use. Make it a meta data block so it really matters.
>>
>> 3) The thin-provision still has the mapping and data of the block and
>> hasn't reused the block yet. On read the device will return the
>> correct data as long as the block is not reused. This seems to be a
>> valid implementation for a thin-provision device.
>>     
>
> That's highly unlikely, actually.  Once you tell the thin-provisioning
> device that the block is not in use, they will delete the mapping from
> their mapping structures.  So it's highly unlikely you will be able to
> recover once you send the TRIM command.
>   

For SCSI, that is actually not unlikely since the spec does not require 
you to actually do anything with the command - they can simply be 
ignored, so the original data will stay there unchanged.

If it is unmapped (in SCSI speak), and you read that sector, the storage 
device must return consistent contents for each subsequent read.

Ric

>   
>> 4) fsck will find no error but future writes will reuse the block on
>> the thin-provision device overwriting the data and causing
>> catastrophic FS corruption.
>>     
>
> The way this can happen today is if the bitmap block gets corrupted,
> and so a block which is in use gets used by another inode.  So now you
> have a filesystem block overwritten by a data block from an inode ---
> so you have potentially catastrophic FS corruption, even before you
> issue the ATA TRIM command.  This can happen to day, and in practice,
> it is extremely rare.  So permit me for being highly dubious about
> your claim this is going to happen more often with thin-provisioned
> devices.
>
>   
>> So I think a fsck pass to check FS used blocks against hardware used
>> blocks is essential if the FS does support thin-provisioned devices.
>>     
>
> The filesystem might not even know whether or not a thin-provisioned
> device is in use.  The OS may not even know whether the device is
> thin-provisioned.  So ultiamtely, it's not up to the FS...
>
> 		      		       	      - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

