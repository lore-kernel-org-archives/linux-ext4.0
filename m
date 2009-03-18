From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Tue, 17 Mar 2009 23:18:04 -0500
Message-ID: <49C075FC.6070404@redhat.com>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZCRESu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 00:18:50 -0400
In-Reply-To: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
> this mode, we force all delayed allocation blocks involved with the
> to-be-commited transaction to be allocated, and then flushed out to
> disk before the transaction is commited.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Haven't really looked into the cause yet but I was playing with this,
and ran:

# rm -f bigfile smallfile; dd if=/dev/zero of=bigfile bs=1M count=8192;
echo boo > smallfile; time /root/fsync smallfile; time /root/fsync bigfile

which resulted in:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
IP: [<ffffffffa02a6de1>] alloc_on_commit_callback+0x27/0x7f [ext4]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:0c.0/0000:02:00.0/irq
CPU 1
Modules linked in: ext4 jbd2 crc16 ipt_MASQUERADE iptable_nat nf_nat
bridge stp llc autofs4 sunrpc ipv6 cpufreq_ondemand powernow_k8
freq_table xfs exportfs video output sbs sbshc parport_pc lp parport tg3
serio_raw pata_amd k8temp hwmon pata_acpi ata_generic i2c_nforce2
i2c_core pcspkr qla2xxx scsi_transport_fc scsi_tgt shpchp mptspi
mptscsih mptbase scsi_transport_spi [last unloaded: ext4]
Pid: 5011, comm: kjournald2 Not tainted 2.6.29-rc8 #3 ProLiant DL145 G2
RIP: 0010:[<ffffffffa02a6de1>]  [<ffffffffa02a6de1>]
alloc_on_commit_callback+0x27/0x7f [ext4]
RSP: 0018:ffff88013c847d20  EFLAGS: 00010246
RAX: 000000000000025f RBX: 0000000000000000 RCX: 0000000000000001
RDX: 000000000000025f RSI: ffff88013ec91d00 RDI: ffff880137cedb8c
RBP: ffff88013c847d50 R08: ffff880000011580 R09: ffffffff81029cc2
R10: ffff880131744448 R11: ffff88010fd28070 R12: ffff880137ced824
R13: ffff880137ced800 R14: ffff880137cedb8c R15: 0000000000000000
FS:  00007fd21065b6e0(0000) GS:ffff88013fc01f80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000060 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald2 (pid: 5011, threadinfo ffff88013c846000, task
ffff880131744410)
Stack:
 0000000000006449 0000000000000000 ffff880137ced824 ffff8800bf426230
 ffff880137ced800 ffff88013ec91d00 ffff88013c847ea0 ffffffffa00e2024
 ffff88013c847dc0 ffff8801199001c0 ffffffff815013a0 000017594c782cbd
Call Trace:
 [<ffffffffa00e2024>] jbd2_journal_commit_transaction+0xff7/0x105b [jbd2]
 [<ffffffffa00e597e>] kjournald2+0xe6/0x235 [jbd2]
 [<ffffffff8105b4f7>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa00e5898>] ? kjournald2+0x0/0x235 [jbd2]
 [<ffffffff8105b389>] kthread+0x49/0x78
 [<ffffffff8101251a>] child_rip+0xa/0x20
 [<ffffffff81029cc2>] ? native_load_tls+0xf/0x29
 [<ffffffff8105b340>] ? kthread+0x0/0x78
 [<ffffffff81012510>] ? child_rip+0x0/0x20
Code: 41 5d c9 c3 55 48 89 e5 41 57 41 56 4c 8d b7 8c 03 00 00 41 55 49
89 fd 41 54 53 48 83 ec 08 4c 8b 7f 48 4c 89 f7 e8 84 ee 0a e1 <49> 8b
5f 60 48 83 eb 10 4c 8b 63 10 eb 1f e8 39 36 d8 e0 90 48
RIP  [<ffffffffa02a6de1>] alloc_on_commit_callback+0x27/0x7f [ext4]
 RSP <ffff88013c847d20>
CR2: 0000000000000060
---[ end trace 7c7cc83cb0a81eef ]---
