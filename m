From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Wed, 23 Apr 2008 08:53:02 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com>
 <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYDWPyc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 11:54:32 -0400
In-Reply-To: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 23 Apr 2008, Zdenek Kabelac wrote:
>=20
> This time I've got slightly larger mess with some other oopses - I'm
> not sure if they are just a consequence of the PM bad commit - or the=
y
> are a separate issue ?

Goodie, two of the backtraces (the parent-is-sleeping warning and the=20
immediately subsequent oops) look like the same thing that should alrea=
dy=20
be fixed in current -git. But there is some interesting stuff there..

> (SPIN LOCK already disabled is my personal trace ooops which is just
> checking if the spin_lock_irq is already called with disabled irq - i=
n
> this place probably irqsave version should be used instead, otherwice
> it's not properly restored)

Yes, that's interesting to see.

>  Booting processor 1/1 ip 6000
>  Initializing CPU#1
>  Calibrating delay using timer specific routine.. 4390.79 BogoMIPS (l=
pj=3D7314872)
>  CPU: L1 I cache: 32K, L1 D cache: 32K
>  CPU: L2 cache: 4096K
>  CPU: Physical Processor ID: 0
>  CPU: Processor Core ID: 1
>  x86: PAT support disabled.
>  SPIN IRQ ALREADY DISABLED
>  Pid: 0, comm: swapper Not tainted 2.6.25 #57
>=20
>  Call Trace:
>   [_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
>   [lock_ipi_call_lock+16/32] lock_ipi_call_lock+0x10/0x20
>  CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
> [start_secondary+68/206] start_secondary+0x44/0xce

This is indeed an interesting issue: arch/x86/kernel/smpboot.c does an =
IPI=20
call to start_secondary, and yes, it looks suspicious to have that=20
lock_ipi_call_lock there (and in particular the unlock_ipi_call_lock th=
at=20
enables interrupts within it). Ingo?

But the really interesting one is the later kmalloc() debugging trigger=
s,=20
because this one is, I suspect, very much a sign of the memory corrupti=
on=20
bug you see.=20

There's two reasons that make me say that:

 - the callback is in networking code and wireless, which was one of th=
e=20
   possible suspects.

 - the padding pattern which *should* have been POISON_INUSE (0x5a) has=
=20
   been overwritten with:

   Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
   ....
   Padding 0xffff8100201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b a5 kkkkkkkkkkkkkkk=A5
   Padding 0xffff8100201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00 =
81 ff ff =CC=CC=CC=CC=CC=CC=CC=CC......=FF=FF
   Padding 0xffff8100201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 =
05 00 00 =CDp..=FF=FF=FF=FF....s...
   Padding 0xffff8100201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff =
ff ff ff =B6TX.....=D5q&.=FF=FF=FF=FF
   Padding 0xffff8100201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01 =
00 00 00 ....|....TX.....

   which in turn is interesting because it very much looks like SLUB=20
   re-used a page for something else (the values that things got=20
   overwritten by are largely SLUB's own poison bytes: 6b is POISON_FRE=
E,=20
   the a5 at the end of the list of 6b's is POISON_END, while cc is=20
   SLUB_RED_ACTIVE).

To me, that pattern looks like an order-3 allocation (correct: that's w=
hat=20
kmalloc-4096 is supposed to be using!) got released, and the stuff at t=
he=20
end (with slub debugging, there's only room for 7 4096-byte allocations=
=20
there, so 71b0 is past the end) in that SLUB debug info.

The first word of that busy allocation is ffff8100201a0000, which is al=
so=20
the base pointer to the whole order-3 page ("Free pointer"), followed b=
y=20
the SLAB tracking data.

Looks like possibly a double free to me (with the first free caused the=
=20
page to be re-used, the second free is the one that triggers the debug=20
message). But maybe Pekka or Christoph are better at reading those oops=
es.

Now, the first slab debug trigger then does:

   FIX kmalloc-4096: Restoring 0xffff8100201a0000-0xffff8100201a7e16=3D=
0x5a

to "restore" the data to its expected values, which is why the *second*=
=20
one triggers, because now the allocation that was re-used got overwritt=
en=20
with that free pattern, and then you get more complaints about *that*, =
and=20
the skb pointers themselves now have bogus data in them (overwritten=20
twice: first with 0x5a, to restore the first one, then with 0xcc for th=
e=20
second warning.

So then the subsequent "general protection fault" is just because of bo=
gus=20
skb pointers due to the still-in-use allocation being overwritten by al=
l=20
these poison values.

And finally, the stuff at the very end (BUG: sleeping function called f=
rom=20
invalid context and the SPIN IRQ one) are just warnings because we kill=
ed=20
a process in a critical section, so all the preempt and irq flags are j=
ust=20
wrong. Those can be ignored entirely.

But what is interesting is that this does look networking-related. I=20
suspect it's the suspend/resume that triggers something with the=20
dev_open() thing, which re-uses an already-free'd pointer or whatever. =
I=20
have no clue about exactly what goes wrong, but I really would suspect=20
that whole "network device down/up" sequence during the suspend.

I've left the kernel trace appended, since I added a few more people to=
=20
the discussion.

		Linus

---
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> BUG kmalloc-4096: Padding overwritten. 0x0000000000000000-0x00000000f=
fffffff
> ---------------------------------------------------------------------=
--------
>=20
> INFO: Slab 0xffffe20000c09c00 used=3D7 fp=3D0x0000000000000000 flags=3D=
0x2200000004083
> Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
>=20
> Call Trace:
>  [slab_err+167/192] slab_err+0xa7/0xc0
>  [__free_pages_ok+420/1216] ? __free_pages_ok+0x1a4/0x4c0
>  [kernel_map_pages+168/368] ? kernel_map_pages+0xa8/0x170
>  [add_partial+33/112] ? add_partial+0x21/0x70
>  [slab_pad_check+287/368] slab_pad_check+0x11f/0x170
>  [check_slab+34/112] check_slab+0x22/0x70
>  [__slab_free+458/944] __slab_free+0x1ca/0x3b0
>  [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
>  [kfree+180/304] kfree+0xb4/0x130
>  [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
>  [skb_release_data+133/208] skb_release_data+0x85/0xd0
>  [skb_release_all+158/240] skb_release_all+0x9e/0xf0
>  [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
>  [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x9=
40
>  [kfree_skb+23/64] kfree_skb+0x17/0x40
>  [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x1=
30
>  [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
>  [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
>  [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
>  [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
>  [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
>  [dev_open+121/176] dev_open+0x79/0xb0
>  [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
>  [do_setlink+524/928] do_setlink+0x20c/0x3a0
>  [_read_unlock+48/96] ? _read_unlock+0x30/0x60
>  [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
>  [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
>  [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
>  [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
>  [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
>  [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
>  [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
>  [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
>  [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
>  [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
>  [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
>  [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
>  [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
>  [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x8=
0
>=20
>  Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
>  Padding 0xffff8100201a0010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
>  Padding 0xffff8100201a0020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
> ........... a lots of these .......
>  Padding 0xffff8100201a7190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
>  Padding 0xffff8100201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b a5 kkkkkkkkkkkkkkk=A5
>  Padding 0xffff8100201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00 =
81 ff ff =CC=CC=CC=CC=CC=CC=CC=CC......=FF=FF
>  Padding 0xffff8100201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 =
05 00 00 =CDp..=FF=FF=FF=FF....s...
>  Padding 0xffff8100201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff =
ff ff ff =B6TX.....=D5q&.=FF=FF=FF=FF
>  Padding 0xffff8100201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01 =
00 00 00 ....|....TX.....
>  Padding 0xffff8100201a71f0:  5a 5a 5a 5a 5a 5a 5a 5a        ZZZZZZZZ
> FIX kmalloc-4096: Restoring 0xffff8100201a0000-0xffff8100201a7e16=3D0=
x5a
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> BUG kmalloc-4096: Redzone overwritten
> ---------------------------------------------------------------------=
--------
>=20
> INFO: 0xffff8100201a2048-0xffff8100201a204f. First byte 0x5a instead =
of 0xcc
> INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=3D11936128522583413382 cpu=3D=
1515870810 pid=3D1515870810
> INFO: Freed in 0x5a5a5a5a5a5a5a5a age=3D11936128522583413382 cpu=3D15=
15870810 pid=3D1515870810
> INFO: Slab 0xffffe20000c09c00 used=3D7 fp=3D0x0000000000000000 flags=3D=
0x2200000004083
> INFO: Object 0xffff8100201a1048 @offset=3D4168 fp=3D0x5a5a5a5a5a5a5a5=
a
>=20
> Bytes b4 0xffff8100201a1038:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1048:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1058:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1068:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1078:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1088:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a1098:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a10a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8100201a10b8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a ZZZZZZZZZZZZZZZZ
>  Redzone 0xffff8100201a2048:  5a 5a 5a 5a 5a 5a 5a 5a        ZZZZZZZZ
>  Padding 0xffff8100201a2088:  5a 5a 5a 5a 5a 5a 5a 5a        ZZZZZZZZ
> Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
>=20
> Call Trace:
>  [print_trailer+330/448] print_trailer+0x14a/0x1c0
>  [check_bytes_and_report+293/384] check_bytes_and_report+0x125/0x180
>  [check_object+102/624] check_object+0x66/0x270
>  [__slab_free+683/944] __slab_free+0x2ab/0x3b0
>  [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
>  [kfree+180/304] kfree+0xb4/0x130
>  [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
>  [skb_release_data+133/208] skb_release_data+0x85/0xd0
>  [skb_release_all+158/240] skb_release_all+0x9e/0xf0
>  [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
>  [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x9=
40
>  [kfree_skb+23/64] kfree_skb+0x17/0x40
>  [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x1=
30
>  [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
>  [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
>  [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
>  [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
>  [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
>  [dev_open+121/176] dev_open+0x79/0xb0
>  [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
>  [do_setlink+524/928] do_setlink+0x20c/0x3a0
>  [_read_unlock+48/96] ? _read_unlock+0x30/0x60
>  [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
>  [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
>  [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
>  [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
>  [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
>  [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
>  [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
>  [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
>  [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
>  [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
>  [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
>  [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
>  [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
>  [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x8=
0
>=20
> FIX kmalloc-4096: Restoring 0xffff8100201a2048-0xffff8100201a204f=3D0=
xcc
>=20
> general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
> CPU 1
> Modules linked in: nls_iso8859_2 nls_cp852 vfat fat i915 drm
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
> bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
> binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
> snd_hda_intel snd_seq_oss arc4 snd_seq_midi_event ecb snd_seq
> crypto_blkcipher cryptomgr snd_seq_device crypto_algapi snd_pcm_oss
> iwl3945 snd_mixer_oss snd_pcm mac80211 video thinkpad_acpi psmouse
> snd_timer backlight i2c_i801 rtc_cmos snd rtc_core iTCO_wdt evdev
> i2c_core cfg80211 soundcore nvram snd_page_alloc e1000e output
> mmc_block serio_raw rtc_lib iTCO_vendor_support sdhci mmc_core ac
> battery intel_agp button uhci_hcd ohci_hcd ehci_hcd usbcore [last
> unloaded: microcode]
> Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
> RIP: 0010:[put_page+14/256]  [put_page+14/256] put_page+0xe/0x100
> RSP: 0018:ffff81007c3bb5f8  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 5a5a5a5a5a5a5a5a RCX: 0000000000000000
> RDX: ffff8100201a5d28 RSI: 00000000201a516c RDI: 5a5a5a5a5a5a5a5a
> RBP: ffff81007c3bb618 R08: ffff81007d355bd0 R09: ffff81006a96b0d8
> R10: ffffe200027f8820 R11: ffff81006a96b000 R12: ffff81006a96b3c0
> R13: ffff81007d352ba0 R14: ffff81007d351f00 R15: ffff81007d355bd0
> FS:  00007f59fb63e780(0000) GS:ffff81007e02e190(0000) knlGS:000000000=
0000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003a6cf6ade0 CR3: 0000000073960000 CR4: 00000000000026a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process NetworkManager (pid: 2621, threadinfo ffff81007c3ba000, task
> ffff81007245c000)
> Stack:  0000000000000001 ffff81006a96b3c0 ffff81007d352ba0 ffff81007d=
351f00
>  ffff81007c3bb638 ffffffff812671fb ffff81006a96b3c0 00000000000000b1
>  ffff81007c3bb658 ffffffff81267bee ffff81007d351f00 ffff81006a96b3c0
> Call Trace:
>  [skb_release_data+171/208] skb_release_data+0xab/0xd0
>  [skb_release_all+158/240] skb_release_all+0x9e/0xf0
>  [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
>  [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x9=
40
>  [kfree_skb+23/64] kfree_skb+0x17/0x40
>  [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x1=
30
>  [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
>  [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
>  [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
>  [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
>  [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
>  [dev_open+121/176] dev_open+0x79/0xb0
>  [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
>  [do_setlink+524/928] do_setlink+0x20c/0x3a0
>  [_read_unlock+48/96] ? _read_unlock+0x30/0x60
>  [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
>  [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
>  [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
>  [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
>  [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
>  [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
>  [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
>  [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
>  [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
>  [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
>  [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
>  [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
>  [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
>  [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x8=
0
>=20
>=20
> Code: ff 41 54 9d eb e4 48 8b 47 10 0f 1f 00 e9 62 ff ff ff 66 66 2e
> 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb <48=
>
> 8b 07 f6 c4 40 75 26 8b 4f 08 85 c9 75 0b 0f 0b eb fe 0f 1f
> RIP  [put_page+14/256] put_page+0xe/0x100
>  RSP <ffff81007c3bb5f8>
> ---[ end trace ca143223eefdc828 ]---
> SPIN IRQ ALREADY DISABLED
> Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
>=20
> Call Trace:
>  [_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
>  [exit_signals+85/304] exit_signals+0x55/0x130
>  [do_exit+133/2192] do_exit+0x85/0x890
>  [rotate_reclaimable_page+211/240] ? rotate_reclaimable_page+0xd3/0xf=
0
>  [do_unblank_screen+29/368] ? do_unblank_screen+0x1d/0x170
>  [oops_end+136/144] oops_end+0x88/0x90
>  [die+94/144] die+0x5e/0x90
>  [do_general_protection+344/368] do_general_protection+0x158/0x170
>  [error_exit+0/169] error_exit+0x0/0xa9
>  [put_page+14/256] ? put_page+0xe/0x100
>  [skb_release_data+171/208] ? skb_release_data+0xab/0xd0
>  [skb_release_all+158/240] ? skb_release_all+0x9e/0xf0
>  [__kfree_skb+17/160] ? __kfree_skb+0x11/0xa0
>  [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x9=
40
>  [kfree_skb+23/64] ? kfree_skb+0x17/0x40
>  [_end+510638598/2109230024] ? :iwl3945:iwl3945_rx_queue_reset+0xae/0=
x130
>  [_end+510662510/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x3a6/0x9=
40
>  [_end+510613961/2109230024] ? :iwl3945:__iwl3945_up+0x91/0x640
>  [_end+510616880/2109230024] ? :iwl3945:iwl3945_mac_start+0x568/0x790
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
>  [_end+510327174/2109230024] ? :mac80211:ieee80211_open+0x13e/0x590
>  [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
>  [dev_open+121/176] ? dev_open+0x79/0xb0
>  [dev_change_flags+153/464] ? dev_change_flags+0x99/0x1d0
>  [do_setlink+524/928] ? do_setlink+0x20c/0x3a0
>  [_read_unlock+48/96] ? _read_unlock+0x30/0x60
>  [rtnl_setlink+269/336] ? rtnl_setlink+0x10d/0x150
>  [rtnetlink_rcv_msg+397/576] ? rtnetlink_rcv_msg+0x18d/0x240
>  [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
>  [netlink_rcv_skb+137/176] ? netlink_rcv_skb+0x89/0xb0
>  [rtnetlink_rcv+41/64] ? rtnetlink_rcv+0x29/0x40
>  [netlink_unicast+709/736] ? netlink_unicast+0x2c5/0x2e0
>  [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
>  [netlink_sendmsg+498/752] ? netlink_sendmsg+0x1f2/0x2f0
>  [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
>  [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
>  [sys_sendmsg+393/800] ? sys_sendmsg+0x189/0x320
>  [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0=
x80
>=20
> note: NetworkManager[2621] exited with preempt_count 1
> BUG: sleeping function called from invalid context at kernel/rwsem.c:=
21
> in_atomic():1, irqs_disabled():0
> INFO: lockdep is turned off.
> Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
>=20
> Call Trace:
>  [__debug_show_held_locks+35/48] ? __debug_show_held_locks+0x23/0x30
>  [__might_sleep+209/256] __might_sleep+0xd1/0x100
>  [down_read+32/112] down_read+0x20/0x70
>  [futex_wake+60/304] futex_wake+0x3c/0x130
>  [sprintf+104/112] ? sprintf+0x68/0x70
>  [do_futex+159/3440] do_futex+0x9f/0xd70
>  [_spin_unlock_irqrestore+133/144] ? _spin_unlock_irqrestore+0x85/0x9=
0
>  [release_console_sem+524/544] ? release_console_sem+0x20c/0x220
>  [vprintk+1008/1232] ? vprintk+0x3f0/0x4d0
>  [sys_futex+180/320] sys_futex+0xb4/0x140
>  [acct_collect+435/496] ? acct_collect+0x1b3/0x1f0
>  [acct_collect+435/496] ? acct_collect+0x1b3/0x1f0
>  [mm_release+142/160] mm_release+0x8e/0xa0
>  [exit_mm+29/304] exit_mm+0x1d/0x130
>  [do_exit+461/2192] do_exit+0x1cd/0x890
>  [rotate_reclaimable_page+211/240] ? rotate_reclaimable_page+0xd3/0xf=
0
>  [do_unblank_screen+29/368] ? do_unblank_screen+0x1d/0x170
>  [oops_end+136/144] oops_end+0x88/0x90
>  [die+94/144] die+0x5e/0x90
>  [do_general_protection+344/368] do_general_protection+0x158/0x170
>  [error_exit+0/169] error_exit+0x0/0xa9
>  [put_page+14/256] ? put_page+0xe/0x100
>  [skb_release_data+171/208] ? skb_release_data+0xab/0xd0
>  [skb_release_all+158/240] ? skb_release_all+0x9e/0xf0
>  [__kfree_skb+17/160] ? __kfree_skb+0x11/0xa0
>  [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x9=
40
>  [kfree_skb+23/64] ? kfree_skb+0x17/0x40
>  [_end+510638598/2109230024] ? :iwl3945:iwl3945_rx_queue_reset+0xae/0=
x130
>  [_end+510662510/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x3a6/0x9=
40
>  [_end+510613961/2109230024] ? :iwl3945:__iwl3945_up+0x91/0x640
>  [_end+510616880/2109230024] ? :iwl3945:iwl3945_mac_start+0x568/0x790
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
>  [_end+510327174/2109230024] ? :mac80211:ieee80211_open+0x13e/0x590
>  [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
>  [dev_open+121/176] ? dev_open+0x79/0xb0
>  [dev_change_flags+153/464] ? dev_change_flags+0x99/0x1d0
>  [do_setlink+524/928] ? do_setlink+0x20c/0x3a0
>  [_read_unlock+48/96] ? _read_unlock+0x30/0x60
>  [rtnl_setlink+269/336] ? rtnl_setlink+0x10d/0x150
>  [rtnetlink_rcv_msg+397/576] ? rtnetlink_rcv_msg+0x18d/0x240
>  [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
>  [netlink_rcv_skb+137/176] ? netlink_rcv_skb+0x89/0xb0
>  [rtnetlink_rcv+41/64] ? rtnetlink_rcv+0x29/0x40
>  [netlink_unicast+709/736] ? netlink_unicast+0x2c5/0x2e0
>  [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
>  [netlink_sendmsg+498/752] ? netlink_sendmsg+0x1f2/0x2f0
>  [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
>  [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
>  [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
>  [sys_sendmsg+393/800] ? sys_sendmsg+0x189/0x320
>  [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0=
x80
>=20
> NetworkManager used greatest stack depth: 2928 bytes left
> eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
> ACPI: \_SB_.GDCK - undocking
> usb 1-4: USB disconnect, address 4
> ACPI: \_SB_.GDCK - docking
> usb 1-4: new high speed USB device using ehci_hcd and address 5
> usb 1-4: configuration #1 chosen from 1 choice
> hub 1-4:1.0: USB hub found
> hub 1-4:1.0: 4 ports detected
> usb 1-4: New USB device found, idVendor=3D04b3, idProduct=3D4485
> usb 1-4: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D=
0
> SysRq : Emergency Sync
> Emergency Sync complete
> SysRq : Emergency Remount R/O
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
