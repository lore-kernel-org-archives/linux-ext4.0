From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Custom driver FS brokenness at 4GB?
Date: Thu, 28 May 2015 11:43:56 -0600
Message-ID: <4DDF59F1-C0CA-43E2-BB66-4868A09C3081@dilger.ca>
References: <5565CD0D.4080408@gmail.com> <20150528105931.GA31813@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Rob Harris <rob.harris@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34129 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbbE1Rn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2015 13:43:59 -0400
Received: by pdbki1 with SMTP id ki1so46731678pdb.1
        for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 10:43:59 -0700 (PDT)
In-Reply-To: <20150528105931.GA31813@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 28, 2015, at 4:59 AM, Jan Kara <jack@suse.cz> wrote:
> 
> On Wed 27-05-15 09:56:29, Rob Harris wrote:
>> Greetings. I have an odd issue and need some ideas of where to go
>> next -- I'm out of hair to rip out.
>> 
>> I'm writing a custom block device driver talking to some custom RAID
>> hardware (>32TB) using DMA scatter-gather, with no partitions and am
>> using make_request() to service all the BIO requests to simplify
>> debugging. I have the driver working to the point where using DD
>> against the block device seems to work fine (I'm setting
>> iflag|oflag=direct to ensure it's writing to the disk). I also have
>> the blk_queue set to only request a single 4k I/O per BIO (again to
>> simplify debugging for now.) Also, again to debug, I have a mutex
>> wrapping the entire make_request call to ensure that only a single
>> request is being serviced at a time. So, this should be as "simple"
>> as I can make the environment to debug this problem.
>> 
>> Once the driver is loaded, when I try to create a file system (ext4
>> but the same thing happens with xfs) it seems like there is some
>> corruption occurring, but only when I set the sector size of the
>> block device over 4GB. For instance, when I set the size to 4G, I
>> can mkfs.ext4, but after 2 or 3 mount/umounts the FS refuses to
>> mount anymore and the kernel log complains that the journal is
>> missing. This was discovered running this loop...
>  Hard to tell exactly but with 4GB being 32-bit limit, I would first look
> for some int / unsigned int number overflow. You could possibly better
> debug this when writing some pattern via DD that is different for each
> block to verify that each block indeed lands in the expected location...

We have a tool "llverdev" which does exactly this - write a pattern
to each block in the block device (or in sparse regions covering the
device) with a timestamp and block number to track down sources of
block addressing errors:

http://git.hpdd.intel.com/fs/lustre-release.git/blob/HEAD:/lustre/utils/llverdev.c

Cheers, Andreas

> 								Honza
>> 
>> #!/bin/sh
>> COUNT=4032
>> 
>> while [ 1 ] ; do
>> 
>> figlet ${COUNT}
>> 
>> ( umount /mnt ; rmmod smc ) || true
>> modprobe smc capacity_in_mb=${COUNT} debug=1
>> mkfs.ext4 -m 0 /dev/smcd
>> 
>> mount /dev/smcd /mnt
>> cp count_512m.dat /mnt/test
>> umount /mnt
>> mount /dev/smcd /mnt
>> umount /mnt
>> mount /dev/smcd /mnt
>> cmp count_512m.dat /mnt/test
>> umount /mnt
>> mount /dev/smcd /mnt # ***
>> sync
>> umount /mnt
>> mount /dev/smcd /mnt
>> sleep 1
>> umount /mnt
>> 
>> COUNT=$(( COUNT + 64 ))
>> sleep 1
>> 
>> done
>> 
>> Sometimes I'll get in the kernel log:
>> May 27 09:39:01 febtober kernel: [64547.304695] EXT4-fs (smcd):
>> ext4_check_descriptors: Checksum for group 0 failed (7009!=0)
>> May 27 09:39:01 febtober kernel: [64547.305744] EXT4-fs (smcd):
>> group descriptors corrupted!
>> 
>> Others I'll get:
>> May 27 09:46:49 ryftone-smcdrv kernel: [65014.342850] EXT4-fs
>> (smcd): no journal found
>> 
>> 
>> I've seen this loop fail as early as COUNT=4096, but as late as
>> COUNT=4220; removing the sync changes the behavior.
>> When it fails, it usually does so on the 3rd mount (***).
>> FYI, I effectively call: set_capacity( disk, capacity_in_mb * 2048
>> ); ( 2048 * 512b (kernel sector) = 1M )
>> 
>> Another example: if I set the sector count of the disk to 16G, I can
>> run mkfs.ext4 but the first mount fails and I see May 27 09:07:27
>> febtober kernel: [62653.269387] EXT4-fs (smcd):
>> ext4_check_descriptors: Block bitmap for group 0 not in group (block
>> 4294967295)!
>> 
>> But, again, if I set the sector size < 4G, everything seems fine. I
>> can currently DD read and write across that 4G boundary without
>> issue -- it's ONLY the filesystem accesses. My gut is screaming
>> there's 32/64 bit overflow condition somewhere but for the life of
>> me I can't find it. Is there something I need to set to tell the
>> block layer I have a 64-bit addressible device? set_capacity is
>> always the number of LINUX KERNEL sectors (not what I set
>> blk_queue_logical|physical_block_size to) correct?
>> 
>> I'm currently on 3.16.0 (Ubuntu 14.04.2 LTS) if it matters.
>> 
>> Any help/pointers would be greatly appreciated.
>> 
>> --Rob Harris
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





