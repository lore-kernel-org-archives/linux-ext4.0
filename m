From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Tue, 9 Feb 2010 01:05:14 GMT
Message-ID: <201002090105.o1915EkF005681@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44024 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0BIBFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 20:05:15 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1915EQA005684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 01:05:14 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231





--- Comment #3 from Franco Broi <franco@fugro-fsi.com.au>  2010-02-09 01:05:11 ---
Just saw this bug on similar hardware running 2.6.32.2
There's an intersting bit of memory corruption from the traceback at the end of
the messages file attached.

Feb  8 17:52:27 echo24 kernel: kernel BUG at fs/inode.c:1343!
Feb  8 17:52:27 echo24 kernel: invalid opcode: 0000 [#1] SMP
Feb  8 17:52:27 echo24 kernel: last sysfs file:
/sys/devices/platform/i5k_amb.0/temp2_input
Feb  8 17:52:27 echo24 kernel: CPU 5
Feb  8 17:52:27 echo24 kernel: Modules linked in: usb_storage nfsd exportfs
mx_driver(P) mx_mcp(P) nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 ext4 jbd2
crc16 dm_multipath uinput e1000e mptsas iTCO_wdt iTCO_vendor_support mptscsih
i2c_i801 i2c_core pcspkr mptbase shpchp i5k_amb ioatdma serio_raw hwmon
scsi_transport_sas dca ata_generic [last unloaded: myri10ge]
Feb  8 17:52:27 echo24 kernel: Pid: 2677, comm: nfsd Tainted: P        W 
2.6.32.2 #1 X7DWE
Feb  8 17:52:27 echo24 kernel: RIP: 0010:[<ffffffff810fdaf9>] 
[<ffffffff810fdaf9>] iput+0x1b/0x66
Feb  8 17:52:27 echo24 kernel: RSP: 0018:ffff88021183fd30  EFLAGS: 00010246
Feb  8 17:52:27 echo24 kernel: RAX: 0000000000000000 RBX: ffff88021b16dbc8 RCX:
00000000002a0024
Feb  8 17:52:27 echo24 kernel: RDX: 0000000000000001 RSI: ffffea00010cdb10 RDI:
ffff88021b16dbc8
Feb  8 17:52:27 echo24 kernel: RBP: ffff88021183fd40 R08: ffff880210cd5d40 R09:
0000000000000003
Feb  8 17:52:27 echo24 kernel: R10: 0000000000000001 R11: ffff88021183fc30 R12:
ffff88021b16db80
Feb  8 17:52:27 echo24 kernel: R13: 0000000000001000 R14: ffff880211f20000 R15:
ffff88022df50e00
Feb  8 17:52:27 echo24 kernel: FS:  0000000000000000(0000)
GS:ffff880028340000(0000) knlGS:0000000000000000
Feb  8 17:52:27 echo24 kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Feb  8 17:52:27 echo24 kernel: CR2: 0000000000736f68 CR3: 0000000210dde000 CR4:
00000000000406e0
Feb  8 17:52:27 echo24 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Feb  8 17:52:27 echo24 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Feb  8 17:52:27 echo24 kernel: Process nfsd (pid: 2677, threadinfo
ffff88021183e000, task ffff880211f19760)
Feb  8 17:52:27 echo24 kernel: Stack:
Feb  8 17:52:27 echo24 kernel: ffff88021183fd50 ffff88014dfc6400
ffff88021183fd60 ffffffff812bdb2e
Feb  8 17:52:27 echo24 kernel: <0> ffff88014dfc6400 ffff88014dfc6410
ffff88021183fd80 ffffffffa01a51c5
Feb  8 17:52:27 echo24 kernel: <0> ffff88021183fd80 ffff88014dfc6400
ffff88021183fdb0 ffffffffa01af5d9
Feb  8 17:52:27 echo24 kernel: Call Trace:
Feb  8 17:52:27 echo24 kernel: [<ffffffff812bdb2e>] sock_release+0x5c/0x6c
Feb  8 17:52:27 echo24 kernel: [<ffffffffa01a51c5>] svc_sock_free+0x45/0x51
[sunrpc]
Feb  8 17:52:27 echo24 kernel: [<ffffffffa01af5d9>] svc_xprt_free+0x3e/0x4e
[sunrpc]
Feb  8 17:52:27 echo24 kernel: [<ffffffffa01af59b>] ? svc_xprt_free+0x0/0x4e
[sunrpc]
Feb  8 17:52:27 echo24 kernel: [<ffffffff811ab411>] kref_put+0x43/0x4f
Feb  8 17:52:27 echo24 kernel: [<ffffffffa01aeaed>] svc_xprt_release+0xc6/0xce
[sunrpc]
Feb  8 17:52:27 echo24 kernel: [<ffffffffa01af2f4>] svc_recv+0x72d/0x78b
[sunrpc]
Feb  8 17:52:27 echo24 kernel: [<ffffffff81049930>] ?
default_wake_function+0x0/0xf
Feb  8 17:52:27 echo24 kernel: [<ffffffffa030f7df>] ? nfsd+0x0/0x133 [nfsd]
Feb  8 17:52:27 echo24 kernel: [<ffffffffa030f87f>] nfsd+0xa0/0x133 [nfsd]
Feb  8 17:52:27 echo24 kernel: [<ffffffff81065541>] kthread+0x7d/0x85
Feb  8 17:52:27 echo24 kernel: [<ffffffff81011cda>] child_rip+0xa/0x20
Feb  8 17:52:27 echo24 kernel: [<ffffffff8101163d>] ? restore_args+0x0/0x30
Feb  8 17:52:27 echo24 kernel: [<ffffffff810654c4>] ? kthread+0x0/0x85
Feb  8 17:52:27 echo24 kernel: [<ffffffff81011cd0>] ? child_rip+0x0/0x20
Feb  8 17:52:27 echo24 kernel: Code: c0 74 d5 48 83 c4 20 5b 41 5c 41 5d 41 5e
c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 50 48 83 bf 10 02 00 00
40 75 04 <0f> 0b eb fe 48 8d 7f 48 48 c7 c6 20 5b 88 81 e8 6f b5 0a 00 85
Feb  8 17:52:27 echo24 kernel: RIP  [<ffffffff810fdaf9>] iput+0x1b/0x66
Feb  8 17:52:27 echo24 kernel: RSP <ffff88021183fd30>
Feb  8 17:52:27 echo24 kernel: ---[ end trace 56313310fcbaf839 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
