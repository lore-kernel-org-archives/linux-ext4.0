From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: Repeatable ext4 oops with 3.6.0 (regression)
Date: Thu, 04 Oct 2012 12:12:11 -0400
Message-ID: <1349367131.37541.47.camel@zaphod.localdomain>
References: <pan.2012.10.02.11.19.55.793436@googlemail.com>
	 <20121002133642.GD22777@quack.suse.cz>
	 <pan.2012.10.02.14.31.57.530230@googlemail.com>
	 <20121004130119.GH4641@quack.suse.cz> <506DABDD.7090105@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10438 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2JDQNh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2012 12:13:37 -0400
In-Reply-To: <506DABDD.7090105@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2012-10-04 at 17:31 +0200, Holger Hoffst=C3=A4tte wrote:
> On 04.10.2012 15:01, Jan Kara wrote:
> >   dmesg after boot doesn't help us. It is a dump of a kernel intern=
al
> > buffer of messages so it is cleared after reboot. I had hoped the m=
achine
>=20
> Yeah, I know and was wondering why you'd want that. Sorry,
> misunderstanding. Maybe for memory layout for something..
>=20
> Anyway I reproduced again and while the segfault is always the same
> (in libgio, same address etc) one problem is that the oops does not s=
how
> up immediately but seems to be delayed (?) after the initial corrupti=
on
> (pool[2970]: segfault ..) which is why the syslog file also shows oth=
er
> random processes oopsing - often the running shell, cron, or nscd.
> In the one below I caused "the real oops" by running 'du'.
> Curiously, if the first corruption doesn't kill the system, I can the=
n
> subsequently run gthumb (at least for a moment).
>=20
> So armed with multiple running shells I finally managed to save the d=
mesg
> to NFS. It doesn't get any more complete than this and again shows th=
e
> ext4 stacktrace from before. So maybe it really is generic kmem corru=
ption
> and ext4 looking at symlinks/inodes is just the victim.
>=20
> Holger
>=20
>=20
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.6.0 (root@hho) (gcc version 4.6.3 (Gen=
too 4.6.3 p1.6, pie-0.5.2) ) #1 SMP Mon Oct 1 20:26:09 CEST 2012
<snip>

> [  106.642962] BUG: unable to handle kernel paging request at 0900000=
0
> [  106.642967] IP: [<c01c0238>] __kmalloc+0x88/0x150
> [  106.642974] *pde =3D 00000000=20
> [  106.642977] Oops: 0000 [#1] SMP=20
> [  106.642979] Modules linked in: nfsv4 auth_rpcgss radeon drm_kms_he=
lper ttm drm i2c_algo_bit nfs lockd sunrpc dm_mod snd_hda_codec_analog =
coretemp kvm_intel kvm ehci_hcd i2c_i801 i2c_core sr_mod cdrom uhci_hcd=
 usbcore snd_hda_intel usb_common snd_hda_codec e1000e snd_pcm snd_page=
_alloc snd_timer thinkpad_acpi snd video
> [  106.643003] Pid: 2983, comm: du Not tainted 3.6.0 #1 LENOVO 20087J=
G/20087JG
> [  106.643006] EIP: 0060:[<c01c0238>] EFLAGS: 00210206 CPU: 0
> [  106.643008] EIP is at __kmalloc+0x88/0x150
> [  106.643010] EAX: 00000000 EBX: 09000000 ECX: 0000ebcb EDX: 0000ebc=
a
> [  106.643011] ESI: f5802380 EDI: 09000000 EBP: f154fe10 ESP: f154fde=
4
> [  106.643013]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  106.643014] CR0: 8005003b CR2: 09000000 CR3: 31541000 CR4: 000007d=
0
> [  106.643016] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 0000000=
0
> [  106.643017] DR6: ffff0ff0 DR7: 00000400
> [  106.643019] Process du (pid: 2983, ti=3Df154e000 task=3Df5329b90 t=
ask.ti=3Df154e000)
> [  106.643020] Stack:
> [  106.643020]  0000000b 09000000 0000ebca c024e3e0 0000ebcb 70636f6d=
 c0236ed9 000080d0
> [  106.643026]  f0de13e4 f154feac f0de13e4 f154fe30 c0236ed9 66b7f4d5=
 267b6df2 f594bc60
> [  106.643030]  f0de13e4 f154feac f421e8c0 f154fe70 c0245c06 f0de13e4=
 f0de13e4 f421e8c0
> [  106.643035] Call Trace:
> [  106.643041]  [<c024e3e0>] ? ext4_follow_link+0x20/0x20
> [  106.643045]  [<c0236ed9>] ? ext4_htree_store_dirent+0x29/0x110
> [  106.643048]  [<c0236ed9>] ext4_htree_store_dirent+0x29/0x110
> [  106.643051]  [<c0245c06>] htree_dirblock_to_tree+0x126/0x1b0
> [  106.643054]  [<c0245cf8>] ext4_htree_fill_tree+0x68/0x1d0
> [  106.643057]  [<c01bfd4d>] ? kmem_cache_alloc+0x9d/0xd0
> [  106.643060]  [<c0236d6b>] ? ext4_readdir+0x71b/0x820
> [  106.643063]  [<c0236bd3>] ext4_readdir+0x583/0x820
> [  106.643066]  [<c01cb52f>] ? cp_new_stat64+0xef/0x110
> [  106.643069]  [<c01d7120>] ? sys_ioctl+0x80/0x80
> [  106.643073]  [<c02a182c>] ? security_file_permission+0x8c/0xa0
> [  106.643075]  [<c01d7120>] ? sys_ioctl+0x80/0x80
> [  106.643078]  [<c01d7435>] vfs_readdir+0xa5/0xd0
> [  106.643080]  [<c01d75e0>] sys_getdents64+0x60/0xc0
> [  106.643084]  [<c04a8bd0>] sysenter_do_call+0x12/0x26
> [  106.643086] Code: 00 00 00 8b 06 64 03 05 74 46 64 c0 8b 50 04 8b =
18 85 db 89 5d d8 0f 84 8c 00 00 00 8b 7d d8 8d 4a 01 8b 46 14 89 4d e4=
 89 55 dc <8b> 04 07 89 45 e0 89 c3 89 f8 8b 3e 64 0f c7 0f 0f 94 c0 84=
 c0
> [  106.643119] EIP: [<c01c0238>] __kmalloc+0x88/0x150 SS:ESP 0068:f15=
4fde4
> [  106.643123] CR2: 0000000009000000
> [  106.643125] ---[ end trace 402b4990fb7385f0 ]---
>=20

This looks a lot like the signature of a crash we've experienced
recently [repeatedly :-(] on a 2.6.38 ubuntu/natty kernel.  It's caused
by the irq stack at the bottom of a per cpu area overflowing over the
per cpu slab caches in the next lower cpus' PCA.  When this occurs,
'kmem -s' in crash will show lots of "invalid page" messages.  Many of
those addresses will be in some cpu's PCAs.

Overflow, in our case, was causes by attempt to remove an exiting task'=
s
apparmor profile when the task has a loooong chain of replacedby
profiles.  Our environment is an openstack nova compute node [thousands
of them, actually -- why upgrading kernel is not an option any time
soon] where an overly simplistic chef recipe is replacing various aa
profiles periodically, resulting in O(1000) replaced by profiles to be
freed, recursively, on the irq stack [rcu deferred processing].

Canonical has reported this bug to the apparmor developers and have a
patch for 2.6.38+ that avoids the problem on profile free by removing
the recursion.  Still doesn't filter duplicate profiles up front so we
do still have the replacedby chain growing w/o bounds until the task is
killed/restarted.

Canonical verified that the bug exists in the mainline kernel in the
past week or so.

Of course, this might be something completely different. =20

Regards,
Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
