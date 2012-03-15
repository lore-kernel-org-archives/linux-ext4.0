From: Onkar N Mahajan <onkar.n.mahajan@linux.vnet.ibm.com>
Subject: Re: EXT4-fs error
Date: Thu, 15 Mar 2012 08:18:48 +0530
Message-ID: <1331779728.3351.0.camel@oc4748611672.ibm.com>
References: <CA+WnoXMqBAsbE_o=GYUObSJ8Hu4nzVmJt8Ru5ryeYk6nbaUJsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: manikanta <manikanta4u@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42050 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2COD3l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 23:29:41 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <onkar.n.mahajan@linux.vnet.ibm.com>;
	Thu, 15 Mar 2012 08:59:37 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F3TNtE4161680
	for <linux-ext4@vger.kernel.org>; Thu, 15 Mar 2012 08:59:24 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F8x9mW021554
	for <linux-ext4@vger.kernel.org>; Thu, 15 Mar 2012 14:29:10 +0530
In-Reply-To: <CA+WnoXMqBAsbE_o=GYUObSJ8Hu4nzVmJt8Ru5ryeYk6nbaUJsg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2012-03-13 at 15:09 +0530, manikanta wrote: 
> Hi,
> 
>      I am working on android ICS. I got an EXT4-fs error saying lblock
> 0 mapped to illegal pblock (length 1) and then kernel panic.
> 
> Below are the result of cat /proc/mounts
> 
> rootfs / rootfs ro,relatime 0 0
> tmpfs /dev tmpfs rw,nosuid,relatime,mode=755 0 0
> devpts /dev/pts devpts rw,relatime,mode=600 0 0
> proc /proc proc rw,relatime 0 0
> sysfs /sys sysfs rw,relatime 0 0
> none /acct cgroup rw,relatime,cpuacct 0 0
> tmpfs /mnt/asec tmpfs rw,relatime,mode=755,gid=1000 0 0
> tmpfs /mnt/obb tmpfs rw,relatime,mode=755,gid=1000 0 0
> none /dev/cpuctl cgroup rw,relatime,cpu 0 0
> /dev/block/mmcblk0p14 /system ext4 ro,relatime,user_xattr,barrier=1,data=ordered
>  0 0
> /dev/block/mmcblk0p15 /data ext4 rw,nosuid,nodev,noatime,user_xattr,barrier=1,jo
> urnal_async_commit,data=ordered,noauto_da_alloc 0 0
> /dev/block/mmcblk0p16 /persist ext4 rw,nosuid,nodev,relatime,user_xattr,barrier=
> 1,data=ordered 0 0
> 
> *******************************
> /dev/block/mmcblk0p17 /cache ext4 rw,nosuid,nodev,relatime,user_xattr,barrier=1,
> data=ordered 0 0
> ****************************************
> /dev/block/mmcblk0p11 /efs ext4 rw,nosuid,nodev,relatime,user_xattr,barrier=1,da
> ta=ordered 0 0
> /dev/block/mmcblk0p16 /tombstones ext4 rw,nosuid,nodev,relatime,user_xattr,barri
> er=1,data=ordered 0 0
> /dev/block/mmcblk0p1 /firmware vfat ro,relatime,fmask=0006,dmask=0006,allow_utim
> e=0020,codepage=cp437,iocharset=iso8859-1,shortname=lower,errors=remount-ro 0 0
> /dev/fuse /mnt/sdcard fuse rw,nosuid,nodev,relatime,user_id=1023,group_id=1023,d
> efault_permissions,allow_other 0 0
> 
> Below are the error logs,
> <2>[ 4236.400030] [0:     Thread-980:11795] EXT4-fs error (device
> mmcblk0p17): ext4_map_blocks:1304: inode #2: block 3900: comm
> Thread-980: lblock 0 mapped to illegal pblock (length 1)
> <3>[ 4236.400121] [0:     Thread-980:11795] Aborting journal on device
> mmcblk0p17-8.
> <0>[ 4236.401250] [0:     Thread-980:11795] Kernel panic - not
> syncing: EXT4-fs (device mmcblk0p17): panic forced after error
> <0>[ 4236.401311] [0:     Thread-980:11795]
> <4>[ 4236.401372] [0:     Thread-980:11795] [<c010c6c0>]
> (unwind_backtrace+0x0/0x12c) from [<c07d941c>] (panic+0xa4/0x1e8)
> <4>[ 4236.401464] [0:     Thread-980:11795] [<c07d941c>]
> (panic+0xa4/0x1e8) from [<c02a7f3c>] (ext4_handle_error+0x8c/0x98)
> <4>[ 4236.401525] [0:     Thread-980:11795] [<c02a7f3c>]
> (ext4_handle_error+0x8c/0x98) from [<c02a8268>]
> (ext4_error_inode+0xb8/0xcc)
> <4>[ 4236.401617] [0:     Thread-980:11795] [<c02a8268>]
> (ext4_error_inode+0xb8/0xcc) from [<c028fdec>]
> (__check_block_validity.clone.0+0x68/0x7c)
> <4>[ 4236.401708] [0:     Thread-980:11795] [<c028fdec>]
> (__check_block_validity.clone.0+0x68/0x7c) from [<c028fe90>]
> (ext4_map_blocks+0x90/0x1b8)
> <4>[ 4236.401769] [0:     Thread-980:11795] [<c028fe90>]
> (ext4_map_blocks+0x90/0x1b8) from [<c0288054>]
> (ext4_readdir+0x2b4/0x660)
> <4>[ 4236.401861] [0:     Thread-980:11795] [<c0288054>]
> (ext4_readdir+0x2b4/0x660) from [<c0229540>] (vfs_readdir+0x6c/0xa0)
> <4>[ 4236.401922] [0:     Thread-980:11795] [<c0229540>]
> (vfs_readdir+0x6c/0xa0) from [<c02295d8>] (sys_getdents64+0x64/0xb4)
> <4>[ 4236.402013] [0:     Thread-980:11795] [<c02295d8>]
> (sys_getdents64+0x64/0xb4) from [<c0105ea0>]
> (ret_fast_syscall+0x0/0x30)
> 
> If anyone know about this error, please reply back.
> 
> Regards,
> Manikanta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Can you please send the output of dumpe2fs if possible ?

-- 
Onkar N Mahajan
System Software Engineer,
IBM Linux Technology Center, Bangalore - India

