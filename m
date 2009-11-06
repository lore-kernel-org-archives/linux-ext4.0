From: Jesper Jensen <linux-ext4_mailinglist@elector.dk>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 06 Nov 2009 17:06:16 +0100
Message-ID: <4AF44978.2000705@elector.dk>
References: <4AF3F82D.50105@elector.dk>	 <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>	 <4AF40D60.1080503@elector.dk>	 <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>	 <20091106140415.GA26342@mit.edu> <1257518636.19442.8.camel@zwerg> <87f94c370911060702n2a853934l816a6be3cb716f4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sonosmtp1.cybercity.dk ([212.242.41.60]:65460 "EHLO
	sonosmtp1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbZKFQGK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 11:06:10 -0500
Received: from [192.168.100.10] (unknown [85.82.22.90])
	by sonosmtp1.cybercity.dk (Postfix) with ESMTP id 522C9B88D
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2009 17:07:17 +0100 (CET)
In-Reply-To: <87f94c370911060702n2a853934l816a6be3cb716f4a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> On Fri, Nov 6, 2009 at 9:43 AM, Alexey Fisher
>> Do _not_ever_ change the disk after crush or what ever you did with it.
>> Make an image of your partition (dd if=/dev/you_partition
>> of=backup_of_partition) and try testdisk (photoreck) and/or sleuthkit.
> 
> Totally agree with Alexey,

Yea, I agree too, now... I kinda did before as well, but I found a 
promising article about how just to mkfs and fsck -b <backup superblock> 
and then you were all set. But it turned out it wasn't as easy as that. :-(

 > but if the virtual drive was using a file
 > and not a partition or full drive, then you can just make a copy of
 > the virtual drive.  Then try to recover from the copy.  Make more
 > copies as you have problems, etc.

It is a full partition/driver, but I'm not 100% sure the virtual drive 
is exactly the same size, since you can't select the entire disk when 
adding it to a virtual machine, you have to type in XX MB/GB, and I 
might have typed a different size this time around.

> The way the work is to scan all the sectors on the drive (of virtual
> drive) and look for file header signatures.  A lot of complex file
> types have those.  And then they either find the file length somehow
> from the internal file header, or they just grab x bytes of contiguous
> data after the header.

Yea, that's what I'm trying to do at the moment, but so far without much 
luck.

Is there a specific signature for the superblocks and backups of those? 
I suppose I could search for that signature. Maybe the re-partitioning 
(by ESXi) has shifted the entire partition some blocks.


Regards
Jesper
