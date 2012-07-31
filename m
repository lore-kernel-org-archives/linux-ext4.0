From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Serious bug?
Date: Mon, 30 Jul 2012 21:29:47 -0500
Message-ID: <5017431B.3080202@redhat.com>
References: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2GaC3v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 22:29:51 -0400
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/30/12 9:17 PM, Nelson, John R wrote:
> Hi,
>  I created a big 400GB file image and formatted it with mkfs.ext4. the format failed with

What kernel are you running on for starters?  And how did you create that file image, is it sparse, preallocated, or pre-written?
 
> Warning: could not erase sector 2: Attempt to write block to filesystem resulted in short write

That's from zap-sector() in main(), happens very early, before much else goes on.

Does mkfs.ext4 -K (to prevent hole punching in the file) succeed?

-Eric

> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=0 blocks, Stripe width=0 blocks
> 26214400 inodes, 104857600 blocks
> 5242880 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=4294967296
> 3200 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks: 
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
>         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
>         102400000
> 
> Allocating group tables: done                            
> Warning: could not read block 0: Attempt to read block from filesystem resulted in short read
> Warning: could not erase sector 0: Attempt to write block to filesystem resulted in short write
> mkfs.ext4: Attempt to write block to filesystem resulted in short write while zeroing block 104857584 at end of filesystem
> Writing inode tables: done                            
> Creating journal (32768 blocks): mkfs.ext4: Attempt to write block to filesystem resulted in short write 
>         while trying to create journal
> john@john-K53E:~$ 
> 
> i then checked my dmesg and found error on my sda3 partition
> [  119.578077] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 53, depth: 2 pblock 0

snip

> [  119.585130] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 108, depth: 2 pblock 0
> 
> i deleted the image and rebooted and fsck was forced, but i didnt find any errors. But im not sure why this is happening. and please note this. the iblock in my log continues all the way down to 924.
> 
> John Nelson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

