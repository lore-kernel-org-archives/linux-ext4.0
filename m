From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: new mballoc patches.
Date: Thu, 13 Sep 2007 08:21:21 +0530
Message-ID: <46E8A5A9.6040105@linux.vnet.ibm.com>
References: <46E651E6.3070107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39389 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbXIMCv4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2007 22:51:56 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8D2prbC011082
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 12:51:53 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8D2ps8s712776
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 12:51:54 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8D3pbrI015386
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 13:51:37 +1000
In-Reply-To: <46E651E6.3070107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I checked the logs today for the fsstress run i found this in my dmesg log. The
same stack trace is repeated for many times


uh! busy PA
Call Trace:
[c0000000efa72fc0] [c00000000000fe30] .show_stack+0x6c/0x1a0 (unreliable)
[c0000000efa73060] [c0000000001954a0] .ext4_mb_discard_group_preallocations+0x208/0x4fc
[c0000000efa73180] [c0000000001957c8] .ext4_mb_discard_preallocations+0x34/0x94
[c0000000efa73220] [c000000000197fc8] .ext4_mb_new_blocks+0x1fc/0x2c0
[c0000000efa733a0] [c00000000018dfb4] .ext4_ext_get_blocks+0x540/0x6f8
[c0000000efa734d0] [c00000000017bfe8] .ext4_get_block+0x12c/0x1b4
[c0000000efa73580] [c000000000109104] .__blockdev_direct_IO+0x554/0xb94
[c0000000efa736b0] [c000000000179b28] .ext4_direct_IO+0x138/0x208
[c0000000efa73790] [c00000000009a314] .generic_file_direct_IO+0x134/0x1a0
[c0000000efa73840] [c00000000009a404] .generic_file_direct_write+0x84/0x150
[c0000000efa73900] [c00000000009bf54] .__generic_file_aio_write_nolock+0x2c4/0x3d4
[c0000000efa73a00] [c00000000009c0e4] .generic_file_aio_write+0x80/0x114
[c0000000efa73ac0] [c000000000175c90] .ext4_file_write+0x2c/0xd4
[c0000000efa73b50] [c0000000000d0cf4] .do_sync_write+0xc4/0x124
[c0000000efa73cf0] [c0000000000d16bc] .vfs_write+0x120/0x1f4
[c0000000efa73d90] [c0000000000d21a8] .sys_write+0x4c/0x8c
[c0000000efa73e30] [c00000000000852c] syscall_exit+0x0/0x40
uh! busy PA
Call Trace:
[c0000000eed76f40] [c00000000000fe30] .show_stack+0x6c/0x1a0 (unreliable)
[c0000000eed76fe0] [c0000000001954a0] .ext4_mb_discard_group_preallocations+0x208/0x4fc
[c0000000eed77100] [c0000000001957c8] .ext4_mb_discard_preallocations+0x34/0x94
[c0000000eed771a0] [c000000000197fc8] .ext4_mb_new_blocks+0x1fc/0x2c0
[c0000000eed77320] [c00000000018dfb4] .ext4_ext_get_blocks+0x540/0x6f8
[c0000000eed77450] [c00000000017bfe8] .ext4_get_block+0x12c/0x1b4
[c0000000eed77500] [c000000000102b0c] .__block_prepare_write+0x194/0x584
[c0000000eed77610] [c000000000102f30] .block_prepare_write+0x34/0x64
[c0000000eed77690] [c00000000017a638] .ext4_prepare_write+0xd8/0x1e0
[c0000000eed77750] [c00000000009ac18] .generic_file_buffered_write+0x310/0x834
[c0000000eed77900] [c00000000009bf88] .__generic_file_aio_write_nolock+0x2f8/0x3d4
[c0000000eed77a00] [c00000000009c0e4] .generic_file_aio_write+0x80/0x114
[c0000000eed77ac0] [c000000000175c90] .ext4_file_write+0x2c/0xd4
[c0000000eed77b50] [c0000000000d0cf4] .do_sync_write+0xc4/0x124
[c0000000eed77cf0] [c0000000000d16bc] .vfs_write+0x120/0x1f4
[c0000000eed77d90] [c0000000000d21a8] .sys_write+0x4c/0x8c
[c0000000eed77e30] [c00000000000852c] syscall_exit+0x0/0x40
uh! busy PA
Call Trace:
[c0000000ec97abe0] [c00000000000fe30] .show_stack+0x6c/0x1a0 (unreliable)
[c0000000ec97ac80] [c0000000001954a0] .ext4_mb_discard_group_preallocations+0x208/0x4fc
[c0000000ec97ada0] [c0000000001957c8] .ext4_mb_discard_preallocations+0x34/0x94
[c0000000ec97ae40] [c000000000197fc8] .ext4_mb_new_blocks+0x1fc/0x2c0
[c0000000ec97afc0] [c0000000001748c0] .ext4_new_block+0x84/0x98
[c0000000ec97b090] [c00000000018a55c] .ext4_ext_new_block+0x5c/0x7c
[c0000000ec97b130] [c00000000018b994] .ext4_ext_create_new_leaf+0x9e4/0xcf4
[c0000000ec97b250] [c00000000018c524] .ext4_ext_insert_extent+0x36c/0x5c4
[c0000000ec97b320] [c00000000018e020] .ext4_ext_get_blocks+0x5ac/0x6f8
[c0000000ec97b450] [c00000000017bfe8] .ext4_get_block+0x12c/0x1b4
[c0000000ec97b500] [c000000000102b0c] .__block_prepare_write+0x194/0x584
[c0000000ec97b610] [c000000000102f30] .block_prepare_write+0x34/0x64
[c0000000ec97b690] [c00000000017a638] .ext4_prepare_write+0xd8/0x1e0
[c0000000ec97b750] [c00000000009ac18] .generic_file_buffered_write+0x310/0x834
[c0000000ec97b900] [c00000000009bf88] .__generic_file_aio_write_nolock+0x2f8/0x3d4
[c0000000ec97ba00] [c00000000009c0e4] .generic_file_aio_write+0x80/0x114
[c0000000ec97bac0] [c000000000175c90] .ext4_file_write+0x2c/0xd4
[c0000000ec97bb50] [c0000000000d0cf4] .do_sync_write+0xc4/0x124
[c0000000ec97bcf0] [c0000000000d16bc] .vfs_write+0x120/0x1f4
[c0000000ec97bd90] [c0000000000d21a8] .sys_write+0x4c/0x8c
[c0000000ec97be30] [c00000000000852c] syscall_exit+0x0/0x4
