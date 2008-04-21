From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 23:58:44 +0200
Message-ID: <480D0E14.1040306@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>	<200804211812.16994.rjw@sisk.pl>	<alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <20080421.133940.52972455.davem@davemloft.net> <480D04A2.5000006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, rjw@sisk.pl,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au, paulmck@us.ibm.com,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:48599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYDUV67 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 17:58:59 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1913851fgb.17
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 14:58:57 -0700 (PDT)
In-Reply-To: <480D04A2.5000006@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Leaving untouched.

On 04/21/2008 11:18 PM, Jiri Slaby wrote:
> On 04/21/2008 10:39 PM, David Miller wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Mon, 21 Apr 2008 09:54:07 -0700 (PDT)
>>
>>> What I find interesting is that at least for me, I have the SLAB 
>>> bucket size for nf_conntrack_expect being 208 bytes. And the 
>>> *biggest* merge by far after 2.6.25 so far has been networking (and 
>>> conntrack in particular)
>>>
>>> Is that a smoking gun? Not necessarily. But it *is* intriguing. But 
>>> there are other possible clashes (the 192-byte bucket has several 
>>> different suspects, and not all of them are in networking).1
>>
>> I think you might be onto something here.
>>
>> The "mask" member of struct nf_conntrack_expect could be reasonably
>> all 1's like the value reported in the crash that begins this
>> thread.
>>
>> Do we know the offset within the object at which this all 1's
>> value is found?
>>
>> My rough calculations show that on 32-bit that expect->mask member is
>> at offset 56 and on 64-bit it should be at offset 72.  Does that
>> match up to the offset of the filp or whatever bit being corrupted?
> 
> dentry.d_name.name is 56 on 64-bit (my memcmp crashes)
> dentry.d_hash.next is 24 (crashed at least 3 times here, rafael's one)
> dentry.d_op is 136 (crash below)

file.f_mapping is 176 (the another one from -rc8-mm2)

the one at:
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/9008289.html

Having slub_debug enabled, tomorrow will be results, I guess...

> It's spreading :/.
> 
> ---------- Forwarded message ----------
> From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date: 21.4.2008 11:14
> Subject: BUG: unable to handle kernel NULL pointer at d_free+0x18/0x80
> To: Kernel development list <linux-kernel@vger.kernel.org>
> 
> 
> Hello
> 
>  This oops appeared in my log - unsure how it is related to my DVB-T
>  tuner test before.
>  But I've also seen another weird resume with some similar crash.
> 
>  Happens with 2.6.25 - commit 48a86f548fb74928f9a466f52527e83fecdb4575
>  (T61, 2GB)
> 
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000110
>  IP: [d_free+24/128] d_free+0x18/0x80
>  PGD 0
>  Oops: 0000 [1] PREEMPT SMP
>  CPU 0
>  Modules linked in: usb_storage dvb_usb_af9015 dvb_usb_dibusb_common
>  dib3000mc dibx000_common dvb_usb dvb_core tun nls_iso8859_2 nls_cp852
>  vfat fat i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
>  xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
>  x_tables bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4
>  sunrpc binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput
>  kvm_intel kvm snd_hda_intel arc4 ecb snd_seq_oss crypto_blkcipher
>  snd_seq_midi_event snd_seq cryptomgr snd_seq_device snd_pcm_oss
>  crypto_algapi iwl3945 mac80211 e1000e psmouse snd_mixer_oss rtc_cmos
>  evdev rtc_core thinkpad_acpi video snd_pcm mmc_block sdhci mmc_core
>  snd_timer iTCO_wdt iTCO_vendor_support battery backlight nvram rtc_lib
>  i2c_i801 i2c_core ac snd soundcore snd_page_alloc intel_agp output
>  serio_raw cfg80211 button uhci_hcd ohci_hcd ehci_hcd usbcore [last
>  unloaded: dvb_core]
>  Pid: 210, comm: kswapd0 Not tainted 2.6.25 #56
>  RIP: 0010:[d_free+24/128]  [d_free+24/128] d_free+0x18/0x80
>  RSP: 0018:ffff81007ced9cf0  EFLAGS: 00010206
>  RAX: 00000000000000f0 RBX: ffff8100202723d8 RCX: 0000000000000132
>  RDX: 0000000000005e5d RSI: ffff81007ced4048 RDI: ffff8100202723d8
>  RBP: ffff81007ced9d00 R08: 0000000000000002 R09: d37a6f4de9bd37a7
>  R10: 0000000000000000 R11: 0000000000000000 R12: ffff8100202723d8
>  R13: ffff81007c9329d8 R14: ffff8100202723e0 R15: 0000000000000029
>  FS:  0000000000000000(0000) GS:ffffffff81486000(0000) 
> knlGS:0000000000000000
>  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>  CR2: 0000000000000110 CR3: 0000000001001000 CR4: 00000000000026e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process kswapd0 (pid: 210, threadinfo ffff81007ced8000, task 
> ffff81007ced4000)
>  Stack:  ffff8100202723d8 ffff81007b7e73d8 ffff81007ced9d20 
> ffffffff810cb3eb
>   ffff8100202723d8 0000000000000000 ffff81007ced9d40 ffffffff810cb4d5
>   ffff8100202723d8 ffff8100202723d8 ffff81007ced9d80 ffffffff810cb642
>  Call Trace:
>   [d_kill+59/96] d_kill+0x3b/0x60
>   [prune_one_dentry+197/240] prune_one_dentry+0xc5/0xf0
>   [prune_dcache+322/512] prune_dcache+0x142/0x200
>   [shrink_dcache_memory+65/80] shrink_dcache_memory+0x41/0x50
>   [shrink_slab+274/480] shrink_slab+0x112/0x1e0
>   [kswapd+1232/1552] kswapd+0x4d0/0x610
>   [isolate_pages_global+0/64] ? isolate_pages_global+0x0/0x40
>   [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>   [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
>   [kswapd+0/1552] ? kswapd+0x0/0x610
>   [kthread+73/144] kthread+0x49/0x90
>   [child_rip+10/18] child_rip+0xa/0x12
>   [restore_args+0/48] ? restore_args+0x0/0x30
>   [kthread+0/144] ? kthread+0x0/0x90
>   [child_rip+0/18] ? child_rip+0x0/0x12
> 
> 
>  Code: 95 49 81 e8 ab ff 21 00 5b 41 5c c9 c3 66 0f 1f 44 00 00 55 48
>  89 e5 53 48 89 fb 48 83 ec 08 48 8b 87 b8 00 00 00 48 85 c0 74 0b <48>
>  8b 40 20 48 85 c0 74 02 ff d0 48 83 7b 50 00 74 1e 48 8d bb
>  RIP  [d_free+24/128] d_free+0x18/0x80
>   RSP <ffff81007ced9cf0>
>  CR2: 0000000000000110
>  ---[ end trace ca143223eefdc828 ]---
