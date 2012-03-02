From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Fri, 02 Mar 2012 15:04:48 -0600
Message-ID: <4F5135F0.6090100@redhat.com>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab2CBVEz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 16:04:55 -0500
In-Reply-To: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/2/12 3:00 PM, Theodore Ts'o wrote:
> I spent an hour talking to architecture guy from a major flash
> manufacturer, who makes everything from SSD's to SD cards to eMMC
> devices, and he said a few things that were interesting.
> 
> One is that he would actually be very happy if we send lots of extra
> trim commands; in particular, he would actually *like* us to send trims
> at unlink/commit time, *and* trims periodically via FITRIM.  The reason
> for that is because that way, if the disk is busy, it would be OK if he
> dropped the TRIM on the floor, knowing that he would get another bite at
> the apple later on.  But, if the disk has time to process the trim, he
> he would be able to use that information as quickly as possible.

Is that within spec?

> One of the other things we talked about was it would be really nice if
> we could send TRIM commands at journal checkpoint time, and perhaps send
> checkpoints more aggressively (although the requirement to send a
> SYNCHORNIZE CACHE command may make this be too expensive, unless we have
> ways of reliably knowing when the disk is idle, since unlike the
> enterprise server case, when ext4 is used in a mobile device, the fs
> accesses patterns tend to have more gaps where this sort of maintenance
> can take place).
> 
> We also talked about ways that we might right some application notes so
> that handset OEM's understood how to use mke2fs parameters to optimize
> their file systems for different types of flash systems, and perhaps
> ways that the eMMC spec could be enhanced so that key parameters such as
> erase block size, flash page size, and translation table granularity
> could be passed back to the block layer, and made available to file
> system and mkfs.

Now that would be nice.  Could some of this just be piggybacked on the
existing preferred_io_size-type geometry interfaces?  

-Eric

> Anyway, going back to TRIM, I suspect that efforts to optimize out TRIM
> requests may not make as much sense once we have devices with are SATA
> 3.1 complaint, when we will have a queuable TRIM command.  Also,
> presumably SATA 3.1 compliance devices are less likely to have
> disastrous firmware bugs that make TRIM such a performance dog, and in
> fact they may be devices that would very much like as much TRIM
> information as we are willing to send to them.
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

