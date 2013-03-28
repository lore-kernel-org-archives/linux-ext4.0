From: CAI Qian <caiqian@redhat.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Thu, 28 Mar 2013 05:44:15 -0400 (EDT)
Message-ID: <1878403449.7692080.1364463855313.JavaMail.root@redhat.com>
References: <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60549 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab3C1JoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 05:44:17 -0400
In-Reply-To: <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "linux-s390" <linux-s390@vger.kernel.org>, "Steve Best" <sbest@re=
dhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
> linux-ext4@vger.kernel.org
> Sent: Thursday, March 28, 2013 2:40:33 PM
> Subject: s390x: kernel BUG at fs/ext4/inode.c:1591!
>=20
> System hung when running xfstests-dev 013 test case on an s390x
> guest. Never saw
> this on 3.9-rc3 before but need to double-check. Any idea?
Reproduced; bisect data so far,
# git bisect log
git bisect start
# good: [a937536b868b8369b98967929045f1df54234323] Linux 3.9-rc3
git bisect good a937536b868b8369b98967929045f1df54234323
# bad: [9064171268d838b8f283fe111ef086b9479d059a] Merge tag 'for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes
git bisect bad 9064171268d838b8f283fe111ef086b9479d059a
# bad: [38d78e587d4960d0db94add518d27ee74bad2301] mqueue: sys_mq_open: =
do not call mnt_drop_write() if read-only
git bisect bad 38d78e587d4960d0db94add518d27ee74bad2301
>=20
> CAI Qian
>=20
> =C3=9D 1113.795759=C2=A8 ------------=C3=9D cut here =C2=A8----------=
--
> =C3=9D 1113.795771=C2=A8 kernel BUG at fs/ext4/inode.c:1591!
> =C3=9D 1113.795845=C2=A8 illegal operation: 0001 =C3=9D#1=C2=A8 SMP
> =C3=9D 1113.795848=C2=A8 Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast
>  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
>  nf_defrag_ipv6 ipt
> able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT
> nf_conntrack_ipv4 nf_defra
> g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
> ip6table_filter ip6_tab
> les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c
> dasd_fba_mod dasd_eck
> d_mod dasd_mod lcs ctcm qeth fsm qdio ccwgroup dm_mirror
> dm_region_hash dm_log d
> m_mod
> =C3=9D 1113.795880=C2=A8 CPU: 1 Not tainted 3.9.0-rc4+ #2
> =C3=9D 1113.795882=C2=A8 Process flush-253:1 (pid: 12418, task:
> 0000000003f04890, ksp: 000
> 0000032eab3b8)
> =C3=9D 1113.795885=C2=A8 Krnl PSW : 0704e00180000000 000000000030bc62
> (mpage_da_submit_io+
> 0x38e/0x3c0)
> =C3=9D 1113.795895=C2=A8            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P=
:0 AS:3
> CC:2 PM:0 EA:
> 3
> Krnl GPRS: 0000000001000000 000000001b5823a8 0000000000000010
> 000000001b5823a8
> =C3=9D 1113.795900=C2=A8            0000000000000000 00000000000000af
> 0000000000001000 000
> 0000032eab9c8
> =C3=9D 1113.795902=C2=A8            000003d10053bb40 0000000032eaba30
> 00000000000000a1 000
> 0000032eaba98
> =C3=9D 1113.795905=C2=A8            00000000000100b0 00000000000000a1
> 000000000030b9a8 000
> 0000032eab8a0
> =C3=9D 1113.795921=C2=A8 Krnl Code: 000000000030bc54: f0dca7f4fecf   =
     srp
>     2036(14,
> %r10),3791(%r15),12
>=20
>                                                             MORE...
>                                                               ZVM-RHT=
S
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            000000000030bc5a: a7f40001           brc     15,30bc5c
>           #000000000030bc5e: a7f40001           brc     15,30bc60
>           >000000000030bc62: a7f40001           brc     15,30bc64
>            000000000030bc66: a7f40001           brc     15,30bc68
>            000000000030bc6a: 4120f0e8           la      %r2,232(%r15)
>            000000000030bc6e: a7180000           lhi     %r1,0
> =C3=9D 1113.796303=C2=A8 Call Trace:
> =C3=9D 1113.796306=C2=A8 (=C3=9D<000000000030b9a8>=C2=A8 mpage_da_sub=
mit_io+0xd4/0x3c0)
> =C3=9D 1113.796311=C2=A8  =C3=9D<000000000031204c>=C2=A8
> mpage_da_map_and_submit+0x150/0x41c
> =C3=9D 1113.796314=C2=A8  =C3=9D<0000000000312bac>=C2=A8 ext4_da_writ=
epages+0x364/0x628
> =C3=9D 1113.796317=C2=A8  =C3=9D<00000000002a08c8>=C2=A8
> __writeback_single_inode+0x54/0x27c
> =C3=9D 1113.796322=C2=A8  =C3=9D<00000000002a2c6c>=C2=A8 writeback_sb=
_inodes+0x284/0x4d8
> =C3=9D 1113.796325=C2=A8  =C3=9D<00000000002a30b6>=C2=A8 wb_writeback=
+0x10e/0x374
> =C3=9D 1113.796327=C2=A8  =C3=9D<00000000002a3d22>=C2=A8 wb_do_writeb=
ack+0x102/0x2e0
> =C3=9D 1113.796330=C2=A8  =C3=9D<00000000002a3fa2>=C2=A8 bdi_writebac=
k_thread+0xa2/0x270
> =C3=9D 1113.796333=C2=A8  =C3=9D<00000000001581b2>=C2=A8 kthread+0xda=
/0xe4
> =C3=9D 1113.796338=C2=A8  =C3=9D<0000000000629836>=C2=A8 kernel_threa=
d_starter+0x6/0xc
> =C3=9D 1113.796342=C2=A8  =C3=9D<0000000000629830>=C2=A8 kernel_threa=
d_starter+0x0/0xc
> =C3=9D 1113.796345=C2=A8 Last Breaking-Event-Address:
> =C3=9D 1113.796346=C2=A8  =C3=9D<000000000030bc5e>=C2=A8 mpage_da_sub=
mit_io+0x38a/0x3c0
> =C3=9D 1113.796349=C2=A8
> =C3=9D 1113.796351=C2=A8 ---=C3=9D end trace 45df5089b835470e =C2=A8-=
--
> =C3=9D 1113.796365=C2=A8 ------------=C3=9D cut here =C2=A8----------=
--
> =C3=9D 1113.796367=C2=A8 WARNING: at kernel/exit.c:715
> =C3=9D 1113.796369=C2=A8 Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast
>  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
>  nf_defrag_ipv6 ipt
> able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT
> nf_conntrack_ipv4 nf_defra
> g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
> ip6table_filter ip6_tab
> les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c
> dasd_fba_mod dasd_eck
> d_mod dasd_mod lcs ctcm qeth fsm qdio ccwgroup dm_mirror
> dm_region_hash dm_log d
> m_mod
> =C3=9D 1113.796393=C2=A8 CPU: 1 Tainted: G      D      3.9.0-rc4+ #2
> =C3=9D 1113.796396=C2=A8 Process flush-253:1 (pid: 12418, task:
> 0000000003f04890, ksp: 000
> 0000032eab3b8)
> =C3=9D 1113.796398=C2=A8 Krnl PSW : 0704e00180000000 0000000000133074
> (do_exit+0x54/0xab8)
>=20
> =C3=9D 1113.796404=C2=A8            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P=
:0 AS:3
> CC:2 PM:0 EA:
> 3
> Krnl GPRS: 0000000000000015 0000000032eabb60 0000000032eabb68
> 0000000000000000
> =C3=9D 1113.796408=C2=A8            0000000000133058 ffffffffffffffff
> 0000000000000001 00
>=20
>                                                             MORE...
>                                                               ZVM-RHT=
S
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 0000032eab9c8
> =C3=9D 1113.796411=C2=A8            0704e00180000000 000000000030bc62
> 0000000003f04890 000
> 0000000778d38
> =C3=9D 1113.796413=C2=A8            000000000000000b 0000000000634140
> 0000000000133058 000
> 0000032eab4a0
> =C3=9D 1113.796423=C2=A8 Krnl Code: 0000000000133066: e32010080020   =
     cg
>      %r2,8(%r
> 1)
>            000000000013306c: a78403fa           brc     8,133860
>           #0000000000133070: a7f40001           brc     15,133072
>           >0000000000133074: e31003180004       lg      %r1,792
>            000000000013307a: 5810101c           l       %r1,28(%r1)
>            000000000013307e: c01b01ffff00       nilf    %r1,33554176
>            0000000000133084: a7740481           brc     7,133986
>            0000000000133088: e310a2bc0012       lt      %r1,700(%r10)
> =C3=9D 1113.796447=C2=A8 Call Trace:
> =C3=9D 1113.796449=C2=A8 (=C3=9D<0000000000133058>=C2=A8 do_exit+0x38=
/0xab8)
> =C3=9D 1113.796451=C2=A8  =C3=9D<0000000000100ea4>=C2=A8 die+0x158/0x=
180
> =C3=9D 1113.796455=C2=A8  =C3=9D<00000000006291fa>=C2=A8 do_trap+0x1a=
2/0x1a4
> =C3=9D 1113.796459=C2=A8  =C3=9D<00000000006293ac>=C2=A8 illegal_op+0=
xfc/0x144
> =C3=9D 1113.796462=C2=A8  =C3=9D<0000000000629974>=C2=A8 pgm_check_ha=
ndler+0x138/0x13c
> =C3=9D 1113.796464=C2=A8  =C3=9D<000000000030bc62>=C2=A8 mpage_da_sub=
mit_io+0x38e/0x3c0
> =C3=9D 1113.796467=C2=A8 (=C3=9D<000000000030b9a8>=C2=A8 mpage_da_sub=
mit_io+0xd4/0x3c0)
> =C3=9D 1113.796470=C2=A8  =C3=9D<000000000031204c>=C2=A8
> mpage_da_map_and_submit+0x150/0x41c
> =C3=9D 1113.796472=C2=A8  =C3=9D<0000000000312bac>=C2=A8 ext4_da_writ=
epages+0x364/0x628
> =C3=9D 1113.829664=C2=A8  =C3=9D<00000000002a08c8>=C2=A8
> __writeback_single_inode+0x54/0x27c
> =C3=9D 1113.829674=C2=A8  =C3=9D<00000000002a2c6c>=C2=A8 writeback_sb=
_inodes+0x284/0x4d8
> =C3=9D 1113.829681=C2=A8  =C3=9D<00000000002a30b6>=C2=A8 wb_writeback=
+0x10e/0x374
> =C3=9D 1113.829691=C2=A8  =C3=9D<00000000002a3d22>=C2=A8 wb_do_writeb=
ack+0x102/0x2e0
> =C3=9D 1113.829706=C2=A8  =C3=9D<00000000002a3fa2>=C2=A8 bdi_writebac=
k_thread+0xa2/0x270
> =C3=9D 1113.829715=C2=A8  =C3=9D<00000000001581b2>=C2=A8 kthread+0xda=
/0xe4
> =C3=9D 1113.829725=C2=A8  =C3=9D<0000000000629836>=C2=A8 kernel_threa=
d_starter+0x6/0xc
> =C3=9D 1113.829736=C2=A8  =C3=9D<0000000000629830>=C2=A8 kernel_threa=
d_starter+0x0/0xc
> =C3=9D 1113.829753=C2=A8 Last Breaking-Event-Address:
> =C3=9D 1113.829759=C2=A8  =C3=9D<0000000000133070>=C2=A8 do_exit+0x50=
/0xab8
> =C3=9D 1113.829771=C2=A8 ---=C3=9D end trace 45df5089b835470f =C2=A8-=
--
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
