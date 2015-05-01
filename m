From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Null pointer dereference of s_chksum_driver  in ext4_chksum
Date: Fri, 01 May 2015 12:48:59 -0700
Message-ID: <5543D8AB.4030606@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41314 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbbEATtG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2015 15:49:06 -0400
Received: from [10.46.164.140] (i-global254.qualcomm.com [199.106.103.254])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: reddyn@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id E10F41418F1
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2015 19:49:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I am running the 3.10 ( android ) kernel.

I have run into a couple of instances of a null pointer dereference 
occurring in the function ext4_chksum.



This issue seems to be the same one as
https://bugzilla.kernel.org/show_bug.cgi?id=82201

I am not sure if this was ever solved?

Can someone kindly point me in the right direction?

The only patch i found that might be remotely related is the
https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.14/commit/?h=LA.HB.1.1.1_rb1.10&id=9cf666834cffdb450b9b18f3e06c30493cb40ed2

I am not entirely sure if this is the fix for the issue.

Please find additional details below:

This occurred in while dereferencing the sbi->s_chksum_driver member of 
the superblock info.

This occurs during a bootup mount

  10.216919:   <6> EXT4-fs (mmcblk0p22): mounted filesystem with ordered 
data mode. Opts: barrier=1,discard
     10.225032:   <6> SELinux: initialized (dev mmcblk0p22, type ext4), 
uses xattr
     10.235901:   <6> EXT4-fs (mmcblk0p29): Ignoring removed 
nomblk_io_submit option
     10.341141:   <6> Unable to handle kernel NULL pointer dereference 
at virtual address 00000000

The call stack is as below:

                   [<ffffffc000393a54>] ext4_superblock_csum+0x20/0x68
     10.498103: <2>[<ffffffc000393fc8>]ext4_superblock_csum_set+0x20/0x34
     10.504353:   <2> [<ffffffc00039455c>] ext4_commit_super+0x178/0x1f4
     10.510170:   <2> [<ffffffc0003945f4>] save_error_info+0x1c/0x2c
     10.515638:   <2> [<ffffffc000394954>] ext4_error_inode+0x4c/0x13c
     10.521282:   <2> [<ffffffc00037d510>] ext4_map_blocks+0x354/0x398
     10.526924:   <2> [<ffffffc00037e97c>] _ext4_get_block+0xc0/0x160
     10.532479:   <2> [<ffffffc00037ea2c>] ext4_get_block+0x10/0x1c
     10.537863:   <2> [<ffffffc00031e808>] generic_block_bmap+0x34/0x44
     10.543589:   <2> [<ffffffc00037b980>] ext4_bmap+0x78/0xd4
     10.548539:   <2> [<ffffffc00030a2ec>] bmap+0x20/0x2c
     10.553052:   <2> [<ffffffc0003c8ec0>] jbd2_journal_bmap+0x24/0x9c
     10.558695:   <2> [<ffffffc0003c311c>] jread+0x54/0x228
     10.563381:   <2> [<ffffffc0003c3618>] do_one_pass+0x328/0x724
     10.568678:   <2> [<ffffffc0003c3a8c>] jbd2_journal_recover+0x78/0xdc
     10.574580:   <2> [<ffffffc0003c8c80>] jbd2_journal_load+0x154/0x308
     10.580396:   <2> [<ffffffc000398168>] ext4_fill_super+0x1984/0x2470
     10.586211:   <2> [<ffffffc0002f8634>] mount_bdev+0x134/0x1b8
     10.591420:   <2> [<ffffffc000392f18>] ext4_mount+0x10/0x1c
     10.596454:   <2> [<ffffffc0002f8ebc>] mount_fs+0x78/0x174
     10.601404:   <2> [<ffffffc00030f420>] vfs_kern_mount+0x58/0xcc
     10.606785:   <2> [<ffffffc000311748>] do_mount+0x6f0/0x7d4
     10.611819:   <2> [<ffffffc0003118b8>] SyS_mount+0x8c/0xd0
     10.616768:   <6> Code: 9100fff3 f9420000 927ae673 f942340(b9400002)
     10.622935:   <6> ---[ end trace 69fa2927148e4ec2 ]---
     10.627528:   <6> Kernel panic - not syncing: Fatal exception








-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
