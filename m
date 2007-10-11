From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: uninit block group/mballoc and fsstress
Date: Wed, 10 Oct 2007 17:37:08 -0700
Message-ID: <470D7034.3090105@linux.vnet.ibm.com>
References: <470CFFE3.7080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:34778 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbXJKAgG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 20:36:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9B0a5ZS015663
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 20:36:05 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9B0a4rG490648
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 18:36:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9B0a4F1007946
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 18:36:04 -0600
In-Reply-To: <470CFFE3.7080101@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> I am hitting this with  the below config
>
> mke2fs -j -I 256 -O lazy_bg $dev
>
>
> mount -t ext4dev $dev /mnt/tmp -o "extents,mballoc"
>
> and running fsstress on /mnt/tmp/
I re-ran the test without the mballoc mount option, but with lazy_bg 
enabled, and saw the same error.   Error messages and stack are below.

mke2fs -j -I 256 -O lazy_bg $dev
mount -t ext4dev $dev /mnt/tmp -o "extents"

...

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_dirty_inode: Journal has aborted

EXT4-fs error (device sda7) in ext4_new_blocks_old: Journal has aborted

EXT4-fs error (device sda7) in ext4_dirty_inode: Journal has aborted

EXT4-fs error (device sda7) in ext4_dirty_inode: Journal has aborted

EXT4-fs error (device sda7) in ext4_new_blocks_old: Journal has aborted

EXT4-fs error (device sda7) in ext4_new_blocks_old: Journal has aborted

EXT4-fs error (device sda7) in ext4_dirty_inode: Journal has aborted

EXT4-fs error (device sda7) in ext4_new_blocks_old: Journal has aborted

EXT4-fs error (device sda7) in ext4_dirty_inode: Journal has aborted

EXT4-fs error (device sda7) in ext4_new_blocks_old: Journal has aborted

Unable to handle kernel paging request for data at address 0x00000000

Faulting instruction address: 0xc0000000001af07c

cpu 0x2: Vector: 300 (Data Access) at [c0000000fdf4b9b0]

    pc: c0000000001af07c: .jbd2_journal_commit_transaction+0x11e8/0x1af4

    lr: c0000000001af05c: .jbd2_journal_commit_transaction+0x11c8/0x1af4

    sp: c0000000fdf4bc30

   msr: 8000000000009032

   dar: 0

 dsisr: 40000000

  current = 0xc0000000fc0f47f0

  paca    = 0xc000000000537880

    pid   = 5895, comm = kjournald2

enter ? for help

[c0000000fdf4be00] c0000000001b2994 .kjournald2+0xf4/0x2ac

[c0000000fdf4bf00] c00000000007afcc .kthread+0x84/0xd0

[c0000000fdf4bf90] c000000000027548 .kernel_thread+0x4c/0x68

2:mon>-- 0:conmux-control -- time-stamp -- Oct/10/07 11:28:02 --
-- 0:conmux-control -- time-stamp -- Oct/10/07 14:49:26 --
(bot:conmon-payload) disconnected
