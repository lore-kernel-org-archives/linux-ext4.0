From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 01:17:30 +0200
Message-ID: <480D208A.9050909@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <20080421.133940.52972455.davem@davemloft.net> <480D04A2.5000006@gmail.com> <480D0E14.1040306@gmail.com> <480D147C.90602@gmail.com> <20080421225452.GF9153@linux.vnet.ibm.com> <480D1CF1.7010300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: paulmck@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:45930 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYDUXRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 19:17:45 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2749936fkr.5
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 16:17:43 -0700 (PDT)
In-Reply-To: <480D1CF1.7010300@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/22/2008 01:02 AM, Jiri Slaby wrote:
> On 04/22/2008 12:54 AM, Paul E. McKenney wrote:
>> On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
>>>> Having slub_debug enabled, tomorrow will be results, I guess...

OK, methinks it's tomorrow yet, at least here.

>>> Sorry, one more entry:
>>>
>>> 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)
> 
> Zdenek's is at offset 184.
> 
>>> 00f0000000000000 dentry.d_hash.next (me, offset 24)
>>> ffff81f02003f16c dentry.d_name.name (me, offset 56)
>>>         memory ORed by 000000f000000000
>>> fffff0002004c1b0 file.f_mapping (me, offset 176)
>>>         memory hole, it was something like
>>>         (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
>>> ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
>>>         -1, ~0ULL

The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
give slab a try. Any other clues?

Is this enough?
$ grep SLUB ../my_64/.config
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
$ cat /proc/cmdline
root=/dev/md1 vga=1 ro reboot=a,w slub_debug

BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
IP: [<ffffffff802aca27>] __d_lookup+0x97/0x160
PGD 4510b067 PUD 6768d067 PMD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 0
Modules linked in: test ipv6 tun bitrev arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 rtc_cmos crc32 sr_mod usbhid ohci1394 ehci_hcd 
rtc_core hid ieee1394 floppy cdrom cfg80211 rtc_lib evdev ff_memless
Pid: 18600, comm: git-status Not tainted 2.6.25-mm1_64 #403
RIP: 0010:[<ffffffff802aca27>]  [<ffffffff802aca27>] __d_lookup+0x97/0x160
RSP: 0018:ffff81006096bbf8  EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000012
RDX: ffff8100200f3568 RSI: ffff81006096bd08 RDI: ffff810020c0c880
RBP: ffff81006096bc58 R08: ffff81006096bd08 R09: 000000000000002c
R10: 000000000000002d R11: ffff81006428c200 R12: ffff810021f0a770
R13: 000000001b820c0e R14: ffff810020c0c880 R15: ffff81006096bc28
FS:  00007f2aa905e710(0000) GS:ffffffff80664000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000001 CR3: 0000000008fba000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process git-status (pid: 18600, threadinfo ffff81006096a000, task ffff810007988fc0)
Stack:  ffff81006096bd08 0000000000000009 ffff810020c0c888 000000098026c2fd
  ffff81006428c21c 0000000000000000 0000000000000001 0000000000000001
  ffff81006096be38 ffff81006096be38 ffff81006096bd08 ffff81006096bd18
Call Trace:
  [<ffffffff802a1e85>] do_lookup+0x35/0x220
  [<ffffffff802ad3b8>] ? dput+0x38/0x180
  [<ffffffff802a22c2>] __link_path_walk+0x252/0x1010
  [<ffffffff802911d0>] ? init_object+0x50/0x90
  [<ffffffff802a30ee>] path_walk+0x6e/0xe0
  [<ffffffff802a33b2>] do_path_lookup+0xa2/0x240
  [<ffffffff802a434c>] __user_walk_fd+0x4c/0x80
  [<ffffffff8029ba0b>] vfs_lstat_fd+0x2b/0x70
  [<ffffffff8029bbe3>] ? cp_new_stat+0xe3/0xf0
  [<ffffffff8029bc97>] sys_newlstat+0x27/0x50
  [<ffffffff8020b91b>] system_call_after_swapgs+0x7b/0x80


Code: 48 89 c3 48 8b 55 d0 8b 45 bc 48 85 d2 48 89 45 a8 75 18 eb 5f 0f 1f 80 00 
00 00 00 48 8b 1b 48 89 5d d0 49 8b 07 48 85 c0 74 49 <48> 8b 03 4c 8d 63 e8 0f 
18 08 45 39 6c 24 30 75 e0 4d 39 74 24
RIP  [<ffffffff802aca27>] __d_lookup+0x97/0x160
  RSP <ffff81006096bbf8>
CR2: 0000000000000001
---[ end trace f6b7fa8dcbc7b8f7 ]---

