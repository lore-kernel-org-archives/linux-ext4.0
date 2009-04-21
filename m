From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: 32TB ext4 fsck times
Date: Tue, 21 Apr 2009 15:31:18 -0400
Message-ID: <49EE1F06.5040508@redhat.com>
References: <10039.1240286799@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZDUTbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 15:31:20 -0400
In-Reply-To: <10039.1240286799@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
> Now that 64-bit e2fsck can run to completion on a (newly-minted, never
> mounted) filesystem, here are some numbers. They must be taken with
> a large grain of salt of course, given the unrealistict situation, but
> they might be reasonable lower bounds of what one might expect.
>
> First, the disks are 300GB SCSI 15K rpm - there are 28 disks per RAID
> controller and they are striped into 2TiB volumes (that's a limitation
> of the hardware). 16 of these volumes are striped together using LVM, to
> make a 32TiB volume.
>
> The machine is a four-slot quad core AMD box with 128GB of memory and
> dual-port FC adapters.
>   
Certainly a great configuration for this test....

> The filesystem was created with default values for everything, except
> that the resize_inode feature is turned off. I cleared caches before the
> run.
>
> # time e2fsck -n -f /dev/mapper/bigvg-bigvol
> e2fsck 1.41.4-64bit (17-Apr-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/mapper/bigvg-bigvol: 11/2050768896 files (0.0% non-contiguous), 128808243/8203075584 blocks
>
> real	23m13.725s
> user	23m8.172s
> sys	0m4.323s
>   

I am a bit surprised to see it run so slowly on an empty file system. 
Not an apples to apples comparison, but on my f10 desktop with the older 
fsck, I can fsck an empty 1TB S-ATA drive in just 23 seconds. An array 
should get much better streaming bandwidth but be relatively slower for 
random reads. I wonder if we are much seekier than we should be? Not 
prefetching as much?

ric


> Most of the time (about 22 minutes) is in pass 5. I was taking snapshots
> of
>
>      /proc/<pid of e2fsck>/statm
>
> every 10 seconds during the run[1]. It starts out like this:
>
>
> 27798 3293 217 42 0 3983 0
> 609328 585760 263 42 0 585506 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 752059 728469 272 42 0 728237 0
> 717255 693666 273 42 0 693433 0
> 717255 693666 273 42 0 693433 0
> 717255 693666 273 42 0 693433 0
> ....
>
> and stays at that level for most of the run (the drop occurs a short
> time after pass 5 starts). Here is what it looks like at the end:
>
> ....
> 717255 693666 273 42 0 693433 0
> 717255 693666 273 42 0 693433 0
> 717255 693666 273 42 0 693433 0
> 717499 693910 273 42 0 693677 0
> 717499 693910 273 42 0 693677 0
> 717499 693910 273 42 0 693677 0
>
>
> So in this very simple case, memory required tops out at about 3 GB for the
> 32Tib filesystem, or 0.4 bytes per block.
>
> Nick
>
>
> [1] The numbers are numbers of pages. The format is described in
> Documentation/filesystems/proc.txt:
>
> Table 1-2: Contents of the statm files (as of 2.6.8-rc3)
> ..............................................................................
>  Field    Content
>  size     total program size (pages)		(same as VmSize in status)
>  resident size of memory portions (pages)	(same as VmRSS in status)
>  shared   number of pages that are shared	(i.e. backed by a file)
>  trs      number of pages that are 'code'	(not including libs; broken,
> 							includes data segment)
>  lrs      number of pages of library		(always 0 on 2.6)
>  drs      number of pages of data/stack		(including libs; broken,
> 							includes library text)
>  dt       number of dirty pages			(always 0 on 2.6)
> ..............................................................................
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

