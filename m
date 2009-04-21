From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 32TB ext4 fsck times
Date: Tue, 21 Apr 2009 14:38:58 -0500
Message-ID: <49EE20D2.1070601@redhat.com>
References: <10039.1240286799@gamaville.dokosmarshall.org> <49EE1F06.5040508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbZDUTjF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 15:39:05 -0400
In-Reply-To: <49EE1F06.5040508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> Nick Dokos wrote:
>> Now that 64-bit e2fsck can run to completion on a (newly-minted, never
>> mounted) filesystem, here are some numbers. They must be taken with
>> a large grain of salt of course, given the unrealistict situation, but
>> they might be reasonable lower bounds of what one might expect.
>>
>> First, the disks are 300GB SCSI 15K rpm - there are 28 disks per RAID
>> controller and they are striped into 2TiB volumes (that's a limitation
>> of the hardware). 16 of these volumes are striped together using LVM, to
>> make a 32TiB volume.
>>
>> The machine is a four-slot quad core AMD box with 128GB of memory and
>> dual-port FC adapters.
>>   
> Certainly a great configuration for this test....
> 
>> The filesystem was created with default values for everything, except
>> that the resize_inode feature is turned off. I cleared caches before the
>> run.
>>
>> # time e2fsck -n -f /dev/mapper/bigvg-bigvol
>> e2fsck 1.41.4-64bit (17-Apr-2009)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> /dev/mapper/bigvg-bigvol: 11/2050768896 files (0.0% non-contiguous), 128808243/8203075584 blocks
>>
>> real	23m13.725s
>> user	23m8.172s
>> sys	0m4.323s
>>   
> 
> I am a bit surprised to see it run so slowly on an empty file system. 
> Not an apples to apples comparison, but on my f10 desktop with the older 
> fsck, I can fsck an empty 1TB S-ATA drive in just 23 seconds. An array 
> should get much better streaming bandwidth but be relatively slower for 
> random reads. I wonder if we are much seekier than we should be? Not 
> prefetching as much?

Nick, running this under blktrace would be interesting.  Just tracking
completions is probably sufficient, use the "-a complete" option....

-Eric
