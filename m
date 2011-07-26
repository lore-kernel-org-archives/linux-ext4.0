From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38372] unable to handle kernel NULL pointer dereference in ext3
Date: Tue, 26 Jul 2011 08:16:39 GMT
Message-ID: <201107260816.p6Q8Gd0X007915@demeter1.kernel.org>
References: <bug-38372-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:44761 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1GZIQk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 04:16:40 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6Q8Gdmx007916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 08:16:39 GMT
In-Reply-To: <bug-38372-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38372


Rob de Wit <rdewit@wise-guys.nl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Platform|All                         |x86-64




--- Comment #2 from Rob de Wit <rdewit@wise-guys.nl>  2011-07-26 08:16:36 ---
Seems this is related to disk-scheduler rather than ext3, but I can't fix the
assignee.

Another dump from another host. Both hosts seem to crash at /dev/sdd which is a 
Intel SSD disk


BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff811e870d>] rb_insert_color+0x17/0xd9
PGD a8ecf3067 PUD 103c94067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/block/sdd/queue/scheduler
CPU 2 
Modules linked in: netconsole fuse ip6t_LOG ipt_REJECT ipt_LOG xt_limit
xt_state
 xt_mark ip6table_mangle iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_
conntrack nf_defrag_ipv4 iptable_filter ip_tables ip6table_filter ip6_tables
[la
st unloaded: netconsole]

Pid: 8179, comm: zsh Tainted: G   M        2.6.39.2 #7 Supermicro X8DTU/X8DTU
RIP: 0010:[<ffffffff811e870d>]  [<ffffffff811e870d>] rb_insert_color+0x17/0xd9
RSP: 0000:ffff880ddc33bca8  EFLAGS: 00010246
RAX: ffff88000d8f9500 RBX: ffff88053a66d1c8 RCX: 0000000000000000
RDX: ffff88053a66d1d0 RSI: ffff880470912d40 RDI: ffff88000d8f9508
RBP: 0000000000000000 R08: 0000000043a5870e R09: 000000000e0e6473
R10: 000000006563746d R11: 000000006573656c R12: ffff88000d8f9508
R13: ffff880470912d40 R14: 0000000000000007 R15: ffff88000d974440
FS:  0000000000000000(0000) GS:ffff88103fc80000(0063) knlGS:00000000f75c56c0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000bf5913000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process zsh (pid: 8179, threadinfo ffff880ddc33a000, task ffff880cbb5c7990)
Stack:
 ffff88053a66d1c8 ffff8806d0ab8084 ffff880470912d40 00000000c179a694
 0000000000000007 ffffffff8110d1f5 ffff8806d0ab8084 ffff881036438a50
 ffff8806d0ab808441 56 41 55 49 89 f5 41 54 49 89 fc 55 53 e9 9e 00 00 00 48 83 
e5 fc 
 8b 45 10 48 39 c3 75 41 48 8b 45 08 48 85 c0 74 08 48 8b 10 
RIP  [<ffffffff811e870d>] rb_insert_color+0x17/0xd9
 RSP <ffff880ddc33bca8>
CR2: 0000000000000010
---[ end trace 24f924cfeeb1298a ]---

cat /proc/scsi/scsi 

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2002FYPS-0 Rev: 04.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST31000340NS     Rev: SN06
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD20EARS-00M Rev: 51.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: INTEL SSDSA2M080 Rev: 2CV1
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: DVD-ROM UJDA780  Rev: 1.50
  Type:   CD-ROM                           ANSI  SCSI revision: 05


lspci

00:00.0 Host bridge: Intel Corp.: Unknown device 3406 (rev 13)
00:01.0 PCI bridge: Intel Corp.: Unknown device 3408 (rev 13)
00:03.0 PCI bridge: Intel Corp.: Unknown device 340a (rev 13)
00:05.0 PCI bridge: Intel Corp.: Unknown device 340c (rev 13)
00:06.0 PCI bridge: Intel Corp.: Unknown device 340d (rev 13)
00:07.0 PCI bridge: Intel Corp.: Unknown device 340e (rev 13)
00:09.0 PCI bridge: Intel Corp.: Unknown device 3410 (rev 13)
00:14.0 PIC: Intel Corp.: Unknown device 342e (rev 13)
00:14.1 PIC: Intel Corp.: Unknown device 3422 (rev 13)
00:14.2 PIC: Intel Corp.: Unknown device 3423 (rev 13)
00:14.3 PIC: Intel Corp.: Unknown device 3438 (rev 13)
00:16.0 System peripheral: Intel Corp.: Unknown device 3430 (rev 13)
00:16.1 System peripheral: Intel Corp.: Unknown device 3431 (rev 13)
00:16.2 System peripheral: Intel Corp.: Unknown device 3432 (rev 13)
00:16.3 System peripheral: Intel Corp.: Unknown device 3433 (rev 13)
00:16.4 System peripheral: Intel Corp.: Unknown device 3429 (rev 13)
00:16.5 System peripheral: Intel Corp.: Unknown device 342a (rev 13)
00:16.6 System peripheral: Intel Corp.: Unknown device 342b (rev 13)
00:16.7 System peripheral: Intel Corp.: Unknown device 342c (rev 13)
00:1a.0 USB Controller: Intel Corp.: Unknown device 3a37
00:1a.1 USB Controller: Intel Corp.: Unknown device 3a38
00:1a.2 USB Controller: Intel Corp.: Unknown device 3a39
00:1a.7 USB Controller: Intel Corp.: Unknown device 3a3c
00:1d.0 USB Controller: Intel Corp.: Unknown device 3a34
00:1d.1 USB Controller: Intel Corp.: Unknown device 3a35
00:1d.2 USB Controller: Intel Corp.: Unknown device 3a36
00:1d.7 USB Controller: Intel Corp.: Unknown device 3a3a
00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corp.: Unknown device 3a16
00:1f.2 Class 0106: Intel Corp.: Unknown device 3a22
00:1f.3 SMBus: Intel Corp.: Unknown device 3a30
01:00.0 Ethernet controller: Intel Corp.: Unknown device 10c9 (rev 01)
01:00.1 Ethernet controller: Intel Corp.: Unknown device 10c9 (rev 01)
07:01.0 VGA compatible controller: Matrox Graphics, Inc.: Unknown device 0532
(rev 0a)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
