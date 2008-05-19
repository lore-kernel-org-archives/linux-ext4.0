From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4-fs error (device sdb): ext4_mb_generate_buddy: EXT4-fs:
	group 1: 912 blocks in bitmap, 898 in gd
Date: Mon, 19 May 2008 13:53:46 +0530
Message-ID: <20080519082346.GA27661@skywalker>
References: <20080517203625.GA18235@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:56858 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbYESIX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 04:23:59 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4J8NqGj014373
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 13:53:52 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4J8Nfjo1454158
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 13:53:41 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4J8MQr6010289
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 13:52:26 +0530
Received: from skywalker ([9.124.35.26])
	by d28av03.in.ibm.com (8.13.1/8.12.11) with ESMTP id m4J8MK0B010086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2008 13:52:26 +0530
Content-Disposition: inline
In-Reply-To: <20080517203625.GA18235@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming,

On Sun, May 18, 2008 at 02:06:26AM +0530, Aneesh Kumar K.V wrote:
> After almost 15 minutes into the test
> 
> dd if=/dev/zero of=test bs=1M count=51200
> 
> Ext4 file system mounted with -o noextents gives me 
> 
> 
> EXT4-fs error (device sdb): ext4_mb_generate_buddy: EXT4-fs: group 1: 912 blocks in bitmap, 898 in gd
> 
> Call Trace:
> [c0000000e64f6ac0] [c00000000000fbe0] .show_stack+0x70/0x1bc (unreliable)
> [c0000000e64f6b70] [c0000000001a0674] .ext4_error+0x74/0x9c
> [c0000000e64f6c10] [c0000000001ad490] .ext4_mb_init_cache+0x5d0/0x95c
> [c0000000e64f6d80] [c0000000001aeb04] .ext4_mb_load_buddy+0x24c/0x350
> [c0000000e64f6e30] [c0000000001b04d0] .ext4_mb_regular_allocator+0x4fc/0xe08
> [c0000000e64f6f70] [c0000000001b3acc] .ext4_mb_new_blocks+0x158/0x700
> [c0000000e64f7040] [c000000000191f58] .ext4_new_blocks+0xc4/0xf8
> [c0000000e64f7140] [c0000000001963dc] .ext4_get_blocks_handle+0x444/0xb60
> [c0000000e64f7320] [c000000000196c50] .ext4_get_blocks_wrap+0x158/0x1cc
> [c0000000e64f73f0] [c000000000196fd8] .ext4_get_block+0xd0/0x140
> [c0000000e64f74b0] [c000000000112804] .__block_prepare_write+0x1f8/0x4a8
> [c0000000e64f75f0] [c000000000112bc0] .block_write_begin+0xa8/0x13c
> [c0000000e64f76b0] [c000000000198cf0] .ext4_write_begin+0x128/0x240
> [c0000000e64f77b0] [c0000000000a941c] .generic_file_buffered_write+0x154/0x708
> [c0000000e64f78f0] [c0000000000a9d48] .__generic_file_aio_write_nolock+0x378/0x3ec
> [c0000000e64f79f0] [c0000000000a9e3c] .generic_file_aio_write+0x80/0x114
> [c0000000e64f7ab0] [c000000000192d60] .ext4_file_write+0xc8/0x180
> [c0000000e64f7b60] [c0000000000e3a3c] .do_sync_write+0xc4/0x124
> [c0000000e64f7cf0] [c0000000000e4264] .vfs_write+0xd8/0x1bc
> [c0000000e64f7d90] [c0000000000e4be0] .sys_write+0x4c/0x8c
> [c0000000e64f7e30] [c00000000000872c] syscall_exit+0x0/0x40
> 

I guess the below patch needs more testing. Can you make sure it is not
pushed upstream soon.

ext4-use-inode-preallocation-with-noextents.patch

-aneesh
