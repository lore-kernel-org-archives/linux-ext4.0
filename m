From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Drop mapped buffer_head check during page_mkwrite
Date: Wed, 26 Aug 2009 10:44:04 +0530
Message-ID: <20090826051404.GA29215@skywalker.linux.vnet.ibm.com>
References: <1251210179-7634-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090826022445.GA32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55074 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZHZFO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 01:14:57 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7Q5DlJO008827
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:13:47 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7Q5Ew6F434474
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:14:58 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7Q5EvPS022756
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:14:58 +1000
Content-Disposition: inline
In-Reply-To: <20090826022445.GA32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 25, 2009 at 10:24:45PM -0400, Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 07:52:59PM +0530, Aneesh Kumar K.V wrote:
> > Inorder to check whether the buffer_heads are mapped we need
> > to hold page lock. Otherwise a reclaim can cleanup the attached
> > buffer_heads. Instead of taking page lock and check whether
> > buffer_heads are mapped we let the write_begin/write_end callback
> > does the equivalent. It does have a performance impact in that we
> > are doing more work if we the buffer_heads are already mapped.
> 
> I'm not sure I understand the commit description.  From the patch you
> are removing the check to see if all of the buffers are mapped.  But
> the patch isn't moving the check to ext4_write_begin() or
> ext4_write_end().  Are you saying the check is already in
> ext4_write_begin()?  It doesn't seem to be in ext4_write_end().  
> 
> I see that we do call write_page_buffers() in ext4_write_begin(), and
> in do_journal_get_write_access() we do check to see if the buffers are
> present.  But if they aren't, we don't return an error; we just fail
> request journal write access for the buffer head.
> 
> Am I missing something?  This patch doesn't feel complete, or the
> commit description is very confusing....
> 

In page_mkwrite if the blocks are already mapped we need not call
get_block. The purpose of the removed check was to avoid  calling
write_begin/write_end if the pages are already mapped. Which inturn
avoid calling get_block. But in ext4_write_begin -> __block_prepar_write
we make sure the we don't call get_block if the buffer_head is mapped.

The problem with the current code is that since we don't take page lock
before looking at the attached buffer heads, there is a possibility that
the reclaim can free the attached buffer_heads. This actually caused the
below crash.

BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c04feb2b>] walk_page_buffers+0x1b/0x6b
*pdpt = 000000002786a001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:03/0000:03:01.0/local_cpus
Modules linked in: joydev nfs lockd nfs_acl auth_rpcgss bridge stp llc bnep sco
l2cap bluetooth sunrpc ipv6 p4_clockmod dm_multipath uinput ata_generic
pata_acpi qla2xxx e1000 i2c_piix4 scsi_transport_fc pata_serverworks scsi_tgt
serio_raw pcspkr mptspi mptscsih mptbase scsi_transport_spi radeon drm
i2c_algo_bit i2c_core [last unloaded: cpufreq_powersave]

Pid: 26387, comm: bash-shared-map Not tainted (2.6.29.4-1.el6.i686.PAE #1) IBM
eServer BladeCenter HS40 -[883961X]-                     
EIP: 0060:[<c04feb2b>] EFLAGS: 00210246 CPU: 2
EIP is at walk_page_buffers+0x1b/0x6b
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: f6d7933c EDI: 00000000 EBP: e7981d68 ESP: e7981d4c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash-shared-map (pid: 26387, ti=e7980000 task=f2db58d0
task.ti=e7980000)
Stack:
 00200246 00000000 00000000 c04811b4 00001000 f6d7933c 00000800 e7981dac
 c04feed7 00001000 00000000 c04fedc3 c17790e0 0006e05c 00000000 f6d79318
 e78cc780 0004bdfc 00000000 c17790e0 c17790e0 f2c3b328 00000001 c17790e0
Call Trace:
 [<c04811b4>] ? lock_page+0x1f/0x34
 [<c04feed7>] ? ext4_page_mkwrite+0xff/0x178
 [<c04fedc3>] ? ext4_bh_unmapped+0x0/0x15
 [<c0493c28>] ? __do_fault+0x128/0x39b
 [<c04941e1>] ? handle_mm_fault+0x346/0x81e
 [<c042d588>] ? find_busiest_group+0x2af/0x6e8
 [<c0716e70>] ? do_page_fault+0x307/0x7ec
 [<c044d398>] ? clocksource_read+0xc/0xf
 [<c04293a1>] ? update_curr+0x183/0x18b
 [<c044d398>] ? clocksource_read+0xc/0xf
 [<c044d6fa>] ? getnstimeofday+0x59/0xec
 [<c042f297>] ? rebalance_domains+0x6c/0x485
 [<c07151a1>] ? _spin_lock_irq+0x21/0x25
 [<c043e486>] ? run_timer_softirq+0x1ae/0x1c0
 [<c042f6e3>] ? run_rebalance_domains+0x33/0x9d
 [<c043a86c>] ? _local_bh_enable+0x8d/0x9d
 [<c043a9a6>] ? __do_softirq+0x12a/0x139
 [<c043aa1d>] ? do_softirq+0x68/0x7e
 [<c043ab7d>] ? irq_exit+0x54/0x77
 [<c0716b69>] ? do_page_fault+0x0/0x7ec
 [<c07152f7>] ? error_code+0x77/0x7c
Code: 00 8d 65 f4 5b 5e 5f 5d 8d 67 f8 5f c3 90 90 90 55 89 e5 57 56 53 83 ec
10 0f 1f 44 00 00 8b 7d 0c 89 45 ec 89 d3 31 c0 89 4d e8 <8b> 4a 14 eb 39 8b 72
04 3b 45 08 89 75 f0 8d 34 08 73 05 3b 75 
EIP: [<c04feb2b>] walk_page_buffers+0x1b/0x6b SS:ESP 0068:e7981d4c
---[ end trace 8f806517a1c38a37 ]---


-aneesh
