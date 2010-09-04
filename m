From: Justin Mattock <justinmattock@gmail.com>
Subject: BUG ext4_inode_cache: Padding overwritten. 0xffff88000008fe00-0xffff88000008fe32
Date: Sat, 4 Sep 2010 04:39:20 +0000
Message-ID: <AANLkTin1XDdJisP9vTS8tax3yfgJLO+BpX2XqZOOV5RU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45072 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0IDEjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Sep 2010 00:39:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Im not sure if theres already assigned to this or not...  but noticed
this in dmesg..
only thing I remember was building glibc, and looking into an issue
with it, suspended a few times and such..

[13299.426905] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[13299.426913] BUG ext4_inode_cache: Padding overwritten.
0xffff88000008fe00-0xffff88000008fe32
[13299.426919] --------------------------------------------------------=
---------------------
[13299.426922]
[13299.426928] INFO: Slab 0xffffea0000001ea0 objects=3D13 used=3D11
fp=3D0xffff88000008d798 flags=3D0x4081
[13299.426936] Pid: 17044, comm: rm Tainted: G   M
2.6.36-rc3-00001-gb0425ef #2
[13299.426942] Call Trace:
[13299.426955]  [<ffffffff810e3a5c>] slab_err+0x89/0x95
[13299.426966]  [<ffffffff8109c5fe>] ? call_rcu_sched+0x10/0x12
[13299.426974]  [<ffffffff8109c609>] ? call_rcu+0x9/0xb
[13299.426982]  [<ffffffff810e48b9>] slab_pad_check.part.46+0xc0/0xf7
[13299.426991]  [<ffffffff8114c1b9>] ? ext4_destroy_inode+0x96/0x9d
[13299.426999]  [<ffffffff810e4984>] check_slab+0x94/0x9a
[13299.427008]  [<ffffffff813e5c38>] __slab_free+0x15e/0x342
[13299.427008]  [<ffffffff810e4f34>] kmem_cache_free+0x96/0xed
[13299.427008]  [<ffffffff8114c1b9>] ext4_destroy_inode+0x96/0x9d
[13299.427008]  [<ffffffff81114fd9>] ? __fsnotify_inode_delete+0x9/0xb
[13299.427008]  [<ffffffff810fd046>] ? __destroy_inode+0x27/0x76
[13299.427008]  [<ffffffff810fd4fb>] destroy_inode+0x2a/0x3f
[13299.427008]  [<ffffffff810fd948>] iput+0x223/0x228
[13299.427008]  [<ffffffff810f4bcb>] do_unlinkat+0x118/0x16b
[13299.427008]  [<ffffffff810ee3ad>] ? sys_newfstatat+0x25/0x2e
[13299.427008]  [<ffffffff81094841>] ? audit_syscall_entry+0x1d1/0x1fd
[13299.427008]  [<ffffffff810f641e>] sys_unlinkat+0x24/0x26
[13299.427008]  [<ffffffff81027602>] system_call_fastpath+0x16/0x1b
[13299.427008]  Padding 0xffff88000008fb8b:  00 ad 4e ad de ff ff ff
ff 00 00 00 00 ff ff ff .=ADN=AD=DE=FF=FF=FF=FF....=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fb9b:  ff ff ff ff ff a0 fb 08
00 00 88 ff ff a0 fb 08 =FF=FF=FF=FF=FF.=FB....=FF=FF.=FB.
[13299.427008]  Padding 0xffff88000008fbab:  00 00 88 ff ff 00 00 00
00 00 00 00 00 b8 fb 08 ...=FF=FF........=B8=FB.
[13299.427008]  Padding 0xffff88000008fbbb:  00 00 88 ff ff b8 fb 08
00 00 88 ff ff 00 00 00 ...=FF=FF=B8=FB....=FF=FF...
[13299.427008]  Padding 0xffff88000008fbcb:  00 00 00 00 00 25 53 d9
92 00 00 00 00 00 00 00 .....%S=D9........
[13299.427008]  Padding 0xffff88000008fbdb:  00 00 00 00 00 00 00 00
00 00 00 00 00 d9 59 bb .............=D9Y=BB
[13299.427008]  Padding 0xffff88000008fbeb:  00 01 00 00 00 00 00 00
00 00 00 00 00 10 1a b7 ...............=B7
[13299.427008]  Padding 0xffff88000008fbfb:  2e 00 88 ff ff ff ff ff
ff ff ff ff ff ff ff ff ...=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fc0b:  ff ff ff ff ff 00 00 00
00 00 00 00 00 00 00 00 =FF=FF=FF=FF=FF...........
[13299.427008]  Padding 0xffff88000008fc1b:  00 00 00 00 00 00 00 00
00 00 00 00 00 00 01 10 ................
[13299.427008]  Padding 0xffff88000008fc2b:  00 00 00 ad de 00 02 20
00 00 00 ad de 80 f9 08 ...=AD=DE......=AD=DE.=F9.
[13299.427008]  Padding 0xffff88000008fc3b:  00 00 88 ff ff 00 00 00
00 5a 5a 5a 5a b8 b6 28 ...=FF=FF....ZZZZ=B8=B6(
[13299.427008]  Padding 0xffff88000008fc4b:  00 00 00 00 00 00 00 00
00 01 00 00 00 02 00 00 ................
[13299.427008]  Padding 0xffff88000008fc5b:  00 00 00 00 00 a2 99 81
4c 00 00 00 00 13 41 21 .....=A2..L.....A!
[13299.427008]  Padding 0xffff88000008fc6b:  37 00 00 00 00 70 fc 08
00 00 88 ff ff 70 fc 08 7....p=FC....=FF=FFp=FC.
[13299.427008]  Padding 0xffff88000008fc7b:  00 00 88 ff ff 01 01 00
00 ad 4e ad de ff ff ff ...=FF=FF....=ADN=AD=DE=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fc8b:  ff 5a 5a 5a 5a ff ff ff
ff ff ff ff ff ff ff ff =FFZZZZ=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fc9b:  ff 00 00 00 00 00 00 00
00 00 00 00 00 00 00 5a =FF..............Z
[13299.427008]  Padding 0xffff88000008fcab:  5a 5a 5a 5a 5a 00 00 00
00 00 00 00 00 00 00 00 ZZZZZ...........
[13299.427008]  Padding 0xffff88000008fcbb:  00 1c 00 5a 5a 0e 0e 00
00 ad 4e ad de ff ff ff ...ZZ....=ADN=AD=DE=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fccb:  ff 5a 5a 5a 5a ff ff ff
ff ff ff ff ff d8 fc 08 =FFZZZZ=FF=FF=FF=FF=FF=FF=FF=FF=D8=FC.
[13299.427008]  Padding 0xffff88000008fcdb:  00 00 88 ff ff d8 fc 08
00 00 88 ff ff 00 00 00 ...=FF=FF=D8=FC....=FF=FF...
[13299.427008]  Padding 0xffff88000008fceb:  00 ad 4e ad de ff ff ff
ff 5a 5a 5a 5a ff ff ff .=ADN=AD=DE=FF=FF=FF=FFZZZZ=FF=FF=FF
[13299.427008]  Padding 0xffff88000008fcfb:  ff ff ff ff ff 00 00 00
00 00 00 00 00 bb 59 03 =FF=FF=FF=FF=FF........=BBY.
[13299.427008]  Padding 0xffff88000008fd0b:  00 bb 59 03 00 cc cc cc
cc cc cc cc cc e8 f3 08 .=BBY..=CC=CC=CC=CC=CC=CC=CC=CC=E8=F3.
[13299.427008]  Padding 0xffff88000008fd1b:  00 00 88 ff ff 9f 60 14
81 ff ff ff ff 01 00 00 ...=FF=FF.`..=FF=FF=FF=FF...
[13299.427008]  Padding 0xffff88000008fd2b:  00 c0 28 00 00 a5 58 bb
00 01 00 00 00 b9 c1 14 .=C0(..=A5X=BB.....=B9=C1.
[13299.427008]  Padding 0xffff88000008fd3b:  81 ff ff ff ff 01 00 00
00 0f 1c 00 00 b0 7a ba .=FF=FF=FF=FF........=B0z=BA
[13299.427008]  Padding 0xffff88000008fd4b:  00 01 00 00 00 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a .....ZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fd5b:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fd6b:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fd7b:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fd8b:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fd9b:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fdab:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fdbb:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fdcb:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fddb:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fdeb:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[13299.427008]  Padding 0xffff88000008fdfb:  5a 5a 5a 5a 5a 00 5a 5a
5a 10 20 0f 3f 00 80 00 ZZZZZ.ZZZ...?...
[13299.427008]  Padding 0xffff88000008fe0b:  00 c7 60 ed 3f 3f 00 10
df ed 3f ff 07 10 c0 ed .=C7`=ED??..=DF=ED?=FF..=C0=ED
[13299.427008]  Padding 0xffff88000008fe1b:  3f fa 33 c9 33 d2 b8 3c
fe 08 00 0f 01 c8 b8 31 ?=FA3=C93=D2=B8<=FE....=C8=B81
[13299.427008]  Padding 0xffff88000008fe2b:  00 00 00 0f 01 c9 eb e9
                      .....=C9=EB=E9
[13299.427008] FIX ext4_inode_cache: Restoring
0xffff88000008fb8b-0xffff88000008fe32=3D0x5a
[13299.427008]
[13369.168442] general protection fault: 0000 [#1] SMP
[13369.168448] last sysfs file: /sys/devices/platform/applesmc.768/ligh=
t
[13369.168451] CPU 0
[13369.168453] Modules linked in: xfrm4_mode_transport xcbc rmd160
sha512_generic sco bnep xt_tcpudp ipt_LOG iptable_nat nf_nat xt_state
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables snd_hda_codec_idt ath9k
firewire_ohci firewire_core ath9k_common evdev ath9k_hw ohci1394
joydev button thermal battery sky2 ac ath snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801
video aes_x86_64 lzo lzo_compress tun kvm_intel ipcomp xfrm_ipcomp
crypto_null sha256_generic cbc des_generic cast5 blowfish serpent
camellia twofish_generic twofish_x86_64 twofish_common ctr ah4 esp4
authenc raw1394 ieee1394 uhci_hcd ehci_hcd hci_uart rfcomm btusb hidp
l2cap bluetooth coretemp acpi_cpufreq processor mperf appletouch
applesmc
[13369.168522]
[13369.168526] Pid: 21876, comm: objdump Tainted: G   M
2.6.36-rc3-00001-gb0425ef #2 Mac-F42187C8/MacBookPro2,2
[13369.168529] RIP: 0010:[<ffffffff811a19ad>]  [<ffffffff811a19ad>]
selinux_dentry_open+0x27/0x91
[13369.168540] RSP: 0018:ffff88000dcb7c98  EFLAGS: 00010292
[13369.168543] RAX: 5a5a5a5a5a5a5a5a RBX: ffff88000008f980 RCX: ffff880=
001800000
[13369.168545] RDX: ffff880001800000 RSI: ffff88000ddf6800 RDI: ffff880=
030d6f500
[13369.168548] RBP: ffff88000dcb7cb8 R08: 0000000000000000 R09: ffff880=
01aa70360
[13369.168551] R10: ffff880030f25c6c R11: ffff88000191c000 R12: ffff880=
030d6f500
[13369.168553] R13: ffff88001e6b79a0 R14: ffff88000ddf6800 R15: ffff880=
00008f980
[13369.168557] FS:  00002ab84b7ebb20(0000) GS:ffff880001800000(0000)
knlGS:0000000000000000
[13369.168560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13369.168562] CR2: 00002ab84b52b300 CR3: 00000000276ed000 CR4: 0000000=
0000006f0
[13369.168565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[13369.168568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[13369.168571] Process objdump (pid: 21876, threadinfo
ffff88000dcb6000, task ffff88001e799ec0)
[13369.168573] Stack:
[13369.168575]  ffff880030d6f500 ffff88003ecf08c0 ffff88001aa70360
0000000000000000
[13369.168579] <0> ffff88000dcb7cd8 ffffffff8119afc9 ffff880030d6f500
ffff880030d6f500
[13369.168584] <0> ffff88000dcb7d48 ffffffff810e8ebc ffff88000dcb7d18
ffffffff810f2f78
[13369.168589] Call Trace:
[13369.168595]  [<ffffffff8119afc9>] security_dentry_open+0x19/0x4c
[13369.168601]  [<ffffffff810e8ebc>] __dentry_open+0x159/0x2be
[13369.168607]  [<ffffffff810f2f78>] ? generic_permission+0x17/0xa4
[13369.168611]  [<ffffffff810e9e96>] nameidata_to_filp+0x3a/0x4b
[13369.168616]  [<ffffffff810f58cb>] do_last+0x504/0x691
[13369.168620]  [<ffffffff810f5c48>] do_filp_open+0x1f0/0x621
[13369.168625]  [<ffffffff810ff29f>] ? alloc_fd+0x102/0x114
[13369.168629]  [<ffffffff810e9f02>] do_sys_open+0x5b/0xf7
[13369.168633]  [<ffffffff810e9fb9>] sys_open+0x1b/0x1d
[13369.168639]  [<ffffffff81027602>] system_call_fastpath+0x16/0x1b
[13369.168642] Code: ff ff c9 c3 55 48 89 e5 41 56 49 89 f6 41 55 41
54 49 89 fc 53 48 8b 47 18 4c 8b af c0 00 00 00 48 8b 58 28 48 8b 83
78 02 00 00 <8b> 40 1c 41 89 45 08 e8 a1 af ff ff 41 89 45 0c 41 8b 44
24 54
[13369.168681] RIP  [<ffffffff811a19ad>] selinux_dentry_open+0x27/0x91
[13369.168685]  RSP <ffff88000dcb7c98>
[13369.168688] ---[ end trace a79a28a58d538d97 ]---

as for performance issues,would of never know about this if I hadnt
looked in dmesg.


--=20
Justin P. Mattock
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
