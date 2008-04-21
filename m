From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 21:38:17 +0200
Message-ID: <480CED29.4040908@gmail.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <480CC9A4.9090503@gmail.com> <alpine.LFD.1.10.0804211030450.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:27783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYDUTia (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 15:38:30 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1869098fgb.17
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 12:38:28 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804211030450.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/21/2008 07:48 PM, Linus Torvalds wrote:
> And one thing that suspend/resume does, which is not necessarily commonly 
> done during normal operation, is that ifconfig down/up pattern. Maybe 
> there is something broken in general there?

Who knows, unfortunately it seems so.

I've found another two oopses related to this in logs (they are below). Again 
dentry + offsetof(dentry, name) address is broken here and it fires up in 
memcmp. I suspect somebody still uses that bucket (assigned now to dentry) as it 
hasn't ever be freed and overwrites its members.

I also had corrupted include/linux/irq.h file. There was 
irq_has_<some_ugly_utf_char>ction or something like that. I don't remember the 
the exact function name, but compilation failed and it didn't when I compiled 
the kernel for the first time -- I use that tree everyday, the corruption must 
happen that day. Anyway I have no idea if this is related.

BUG: unable to handle kernel paging request at ffff81f02003f16c
IP: [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
PGD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 1
Modules linked in: ppdev parport tun bitrev ipv6 test arc4 ecb crypto_blkcipher 
cryptomgr crypto_algapi ath5k mac80211 crc32 rtc_cmos sr_mod ohci1394 rtc_core 
usbhid rtc_lib ieee1394 cdrom cfg80211 hid usblp ehci_hcd ff_memless floppy 
[last unloaded: vmnet]
Pid: 3710, comm: sensors-applet Tainted: P          2.6.25-rc8-mm2_64 #399
RIP: 0010:[<ffffffff802ad7d5>]  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
RSP: 0018:ffff810057973b98  EFLAGS: 00010246
RAX: 0000000000000017 RBX: ffff81002003f0e0 RCX: 0000000000000017
RDX: 0000000000000017 RSI: ffff81f02003f16c RDI: ffff8100036f7022
RBP: ffff810057973bf8 R08: ffff810057973ca8 R09: 0000000000000000
R10: 00000000000000d8 R11: 0000000000000246 R12: ffff81002003f0c8
R13: 00000000910b9880 R14: ffff810035a5ded8 R15: ffff810057973bc8
FS:  00007f6e2b7266f0(0000) GS:ffff81007d006580(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff81f02003f16c CR3: 000000005788a000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sensors-applet (pid: 3710, threadinfo ffff810057972000, task 
ffff810062ace9e0)
Stack:  ffff810057973ca8 0000000000000017 ffff81002003f0d0 000000176767e000
  ffff8100036f7022 ffffffff8047a695 ffff81002003f0e0 0000000000000001
  ffff810057973e48 ffff810057973e48 ffff810057973ca8 ffff810057973cb8
Call Trace:
  [<ffffffff8047a695>] ? skb_release_data+0x85/0xd0
  [<ffffffff802a2b95>] do_lookup+0x35/0x220
  [<ffffffff802a2fd2>] __link_path_walk+0x252/0x1010
  [<ffffffff8022b4d0>] ? default_wake_function+0x0/0x10
  [<ffffffff802a3dfe>] path_walk+0x6e/0xe0
  [<ffffffff802a40c2>] do_path_lookup+0xa2/0x240
  [<ffffffff802a45c7>] __path_lookup_intent_open+0x67/0xd0
  [<ffffffff802a463c>] path_lookup_open+0xc/0x10
  [<ffffffff802a558a>] do_filp_open+0xaa/0x990
  [<ffffffff80281778>] ? unmap_region+0x138/0x160
  [<ffffffff80296aec>] ? get_unused_fd_flags+0x8c/0x140
  [<ffffffff80296c16>] do_sys_open+0x76/0x110
  [<ffffffff80296cdb>] sys_open+0x1b/0x20
  [<ffffffff8020b88b>] system_call_after_swapgs+0x7b/0x80


Code: 89 e0 48 8b 55 b0 fe 02 eb ae 0f 1f 40 00 8b 45 bc 41 39 44 24 34 75 8d 48 
8b 55 a8 49 8b 74 24 38 48 39 d2 48 8b 7d c0 48 89 d1 <f3> a6 0f 85 72 ff ff ff 
eb bb 90 55 48 89 e5 41 55 49 89 fd 41
RIP  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
  RSP <ffff810057973b98>
CR2: ffff81f02003f16c
---[ end trace 9c63388ed58b7c09 ]---


BUG: unable to handle kernel paging request at fffff0002008493c
IP: [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
PGD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 0
Modules linked in: ipv6 tun bitrev test arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 usbhid ohci1394 rtc_cmos crc32 sr_mod rtc_core 
ehci_hcd hid ieee1394 rtc_lib floppy cdrom cfg80211 ff_memless
Pid: 12427, comm: find Not tainted 2.6.25-rc8-mm2_64 #399
RIP: 0010:[<ffffffff802ad7d5>]  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
RSP: 0018:ffff81001a01bbf8  EFLAGS: 00010246
RAX: 0000000000000010 RBX: ffff8100200848b0 RCX: 0000000000000010
RDX: 0000000000000010 RSI: fffff0002008493c RDI: ffff81003dae9000
RBP: ffff81001a01bc58 R08: ffff81001a01bd08 R09: 0000000000000000
R10: 000000000000003f R11: 0000000000000246 R12: ffff810020084898
R13: 000000009047ba33 R14: ffff810020087d48 R15: ffff81001a01bc28
FS:  00007ff2f3a226f0(0000) GS:ffffffff80657000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffff0002008493c CR3: 000000001d512000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process find (pid: 12427, threadinfo ffff81001a01a000, task ffff81007d210790)
Stack:  ffff81001a01bd08 0000000000000010 ffff8100200848a0 0000001000000001
  ffff81003dae9000 0000000000000082 ffff8100200848b0 0000000000000001
  ffff81001a01be38 ffff81001a01be38 ffff81001a01bd08 ffff81001a01bd18
Call Trace:
  [<ffffffff802a2b95>] do_lookup+0x35/0x220
  [<ffffffff802ae0a8>] ? dput+0x38/0x180
  [<ffffffff802a2fd2>] __link_path_walk+0x252/0x1010
  [<ffffffff802aec77>] ? file_update_time+0xc7/0x130
  [<ffffffff802b2daa>] ? mntput_no_expire+0x2a/0x140
  [<ffffffff802a3dfe>] path_walk+0x6e/0xe0
  [<ffffffff802a40c2>] do_path_lookup+0xa2/0x240
  [<ffffffff802a505c>] __user_walk_fd+0x4c/0x80
  [<ffffffff8029c71b>] vfs_lstat_fd+0x2b/0x70
  [<ffffffff8029c8f3>] ? cp_new_stat+0xe3/0xf0
  [<ffffffff8029c95c>] sys_newfstatat+0x5c/0x80
  [<ffffffff8020b88b>] system_call_after_swapgs+0x7b/0x80


Code: 89 e0 48 8b 55 b0 fe 02 eb ae 0f 1f 40 00 8b 45 bc 41 39 44 24 34 75 8d 48 
8b 55 a8 49 8b 74 24 38 48 39 d2 48 8b 7d c0 48 89 d1 <f3> a6 0f 85 72 ff ff ff 
eb bb 90 55 48 89 e5 41 55 49 89 fd 41
RIP  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
  RSP <ffff81001a01bbf8>
CR2: fffff0002008493c
---[ end trace 1e48f32334002427 ]---
