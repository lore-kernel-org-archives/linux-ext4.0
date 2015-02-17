From: grantksupport@operamail.com
Subject: Re: gdisk-created Bios Boot Partition created with NO fs,
 reports fs TYPE=ext4.  Bug/why?
Date: Tue, 17 Feb 2015 12:34:18 -0800
Message-ID: <1424205258.2530059.228900773.6DDC8CC7@webmail.messagingengine.com>
References: <1424025536.1061731.227795501.40064DE9@webmail.messagingengine.com>
 <20150216183849.GA11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50531 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbbBQUeT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2015 15:34:19 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 66FC520613
	for <linux-ext4@vger.kernel.org>; Tue, 17 Feb 2015 15:34:18 -0500 (EST)
In-Reply-To: <20150216183849.GA11031@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, Feb 16, 2015, at 10:38 AM, Darrick J. Wong wrote:
> Wiping the partition table doesn't erase filesystem superblocks, so if there
> previously was an sdc1 with an ext4 partition and the new sdc1 starts at the
> same offset, the old fs is still accessible.
...
> wipefs.

Starting with what I had most recently ...

stopping the arrays

	mdadm --stop /dev/md0
	mdadm --stop /dev/md1

zero'ing out the superblocks

	mdadm --zero-superblock /dev/sdc3
	mdadm --zero-superblock /dev/sdd3
	mdadm --zero-superblock /dev/sdc4
	mdadm --zero-superblock /dev/sdd4

wiping the drive details

	wipefs --all --force /dev/sdc1
	wipefs --all --force /dev/sdc2
	wipefs --all --force /dev/sdc3
	wipefs --all --force /dev/sdc4
	wipefs --all --force /dev/sdc
	wipefs --all --force /dev/sdd1
	wipefs --all --force /dev/sdd2
	wipefs --all --force /dev/sdd3
	wipefs --all --force /dev/sdd4
	wipefs --all --force /dev/sdd

creating new partition info

	sgdisk -z /dev/sdc
	sgdisk -o /dev/sdc
	sgdisk -n 1:2048:+1M    -t 1:ef02  -c 1:"BIOS Boot"           /dev/sdc
	sgdisk -n 2:+0M:+300M   -t 2:ef00  -c 2:"EFI System"          /dev/sdc
	sgdisk -p /dev/sdc
		...
		Number  Start (sector)    End (sector)  Size       Code  Name
		   1            2048            4095   1024.0 KiB  EF02  BIOS Boot
		   2            4096          618495   300.0 MiB   EF00  EFI System

replicating to the other drive

	sgdisk -R=/dev/sdd /dev/sdc

& randomizing its GUID

	sgdisk -G /dev/sdd

checking now

	blkid /dev/sdc1
		/dev/sdc1: PARTLABEL="BIOS Boot" PARTUUID="c374b718-3f28-49e8-9d35-452844288233" 
	blkid /dev/sdd1
		/dev/sdd1: PARTLABEL="BIOS Boot" PARTUUID="547ad9ec-3e9c-44a4-ac05-e3f244280675" 

perfect.

thanks

