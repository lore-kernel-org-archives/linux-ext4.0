From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Mon, 5 Mar 2012 08:00:47 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203050739200.4797@dhcp-27-109.brq.redhat.com>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2CEHAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 02:00:52 -0500
In-Reply-To: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2 Mar 2012, Theodore Ts'o wrote:

> 
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

Hi Ted,

yes, they can do a lot of things behind the curtain, and dropping the
TRIM on the floor is clearly on of it. We do not actually care all that
much, but they should export proper flags accordingly. So if the TRIMs
can be droppend on the floor, of the unmapped regions can be read again
after a power cycle they should not export the "discard zeroes data"
thing. Of course we do not want them to drop every TRIM command as well
:).

I think that we would very much like to enable '-o discard' however it
is still very slow due to the fact that it is nonqueable command and it
take a while to process the command as well. Moreover I have noticed
that some device become 'busy' after they get the TRIM command, hence
the performance is lower for a short period of time after the TRIM.

> 
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

Regarding the eMMC it would also be very nice from them if they stopped
optimize their flashes for FAT, but rather take a more general approach
and advertise which parts of the flash are faster than other :). Also
from what I know, doing frequent discard on those flashes might make
them wear off much faster, because the wear leveling involves copying
data around the flash so they can free the whole erase blocks.

> 
> Anyway, going back to TRIM, I suspect that efforts to optimize out TRIM
> requests may not make as much sense once we have devices with are SATA
> 3.1 complaint, when we will have a queuable TRIM command.  Also,
> presumably SATA 3.1 compliance devices are less likely to have
> disastrous firmware bugs that make TRIM such a performance dog, and in
> fact they may be devices that would very much like as much TRIM
> information as we are willing to send to them.

That is definitely very good news, however those optimization still
makes sense. SSD's are not the only discard capable devices out there,
nor will be the 3.1 compliant SSD's. So we still need some kind of
optimization so that it does not hurt the performance on
thin-provisioned storage, or today's SSD's, right ?

But I definitely agree that we should start looking into enabling the
new SSD's to be more effective and if the frequent discard can help
then, then we could start to look how to enable -o discard for such
device by default. Maybe /sys/block/sda/queue/discard_queuable or
something.

Thanks!
-Lukas

> 
> Regards,
> 
> 						- Ted
> 
