From: CAI Qian <caiqian@redhat.com>
Subject: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Date: Tue, 2 Apr 2013 00:06:24 -0400 (EDT)
Message-ID: <874841142.414482.1364875584266.JavaMail.root@redhat.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87fvzaspr8.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bisect indicated this is the culprit,

0e401101db49959f5783f6ee9e676124b5a183ac
ext4: fix memory leakage in mext_check_coverage

This following with Dmitry's debug patch applied,

CAI Qian

=C3=9D  101.408610=C2=A8 ES cache assertation failed for inode: 753 es_=
cached ex =C3=9D56/5/744
81/20=C2=A8 !=3D found ex =C3=9D56/5/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  209.858899=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D57/7/332
82/20=C2=A8 !=3D found ex =C3=9D57/7/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  209.860656=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D25/1/332
50/20=C2=A8 !=3D found ex =C3=9D25/1/0/0=C2=A8 retval 0 flags 0
=C3=9D  209.893587=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D22/1/332
47/20=C2=A8 !=3D found ex =C3=9D22/1/34838/1000=C2=A8 retval 1 flags 0
=C3=9D  209.913482=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D27/1/329
40/20=C2=A8 !=3D found ex =C3=9D27/1/0/0=C2=A8 retval 0 flags 0
=C3=9D  209.919950=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D59/5/338
48/20=C2=A8 !=3D found ex =C3=9D59/5/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  209.931856=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D7/1/3292
0/20=C2=A8 !=3D found ex =C3=9D7/1/35879/20=C2=A8 retval 1 flags 43
=C3=9D  209.969282=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D35/1/361
97/20=C2=A8 !=3D found ex =C3=9D35/1/36197/1000=C2=A8 retval 1 flags 0
=C3=9D  209.969290=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D48/1/362
10/20=C2=A8 !=3D found ex =C3=9D48/1/0/0=C2=A8 retval 0 flags 0
=C3=9D  209.980724=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D13/4/334
89/20=C2=A8 !=3D found ex =C3=9D13/4/2161372/0=C2=A8 retval 0 flags 5
=C3=9D  209.980744=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D61/3/335
37/20=C2=A8 !=3D found ex =C3=9D61/3/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  209.983848=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D44/2/335
20/20=C2=A8 !=3D found ex =C3=9D44/2/36216/20=C2=A8 retval 2 flags 43
=C3=9D  210.020041=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D61/3/341
91/20=C2=A8 !=3D found ex =C3=9D61/3/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  210.050100=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D22/11/34
565/20=C2=A8 !=3D found ex =C3=9D22/11/3396400/0=C2=A8 retval 0 flags 5
=C3=9D  210.053271=C2=A8 ES cache assertation failed for inode: 384 es_=
cached ex =C3=9D15/1/334
90/20=C2=A8 !=3D found ex =C3=9D15/1/33579/1000=C2=A8 retval 1 flags 1
=C3=9D  210.053275=C2=A8 mpage_da_submit_io failed block=3D33490 !=3D b=
_blocknr=3D33579
=C3=9D  210.053277=C2=A8 ino:384 lbkl:15, b_state=3D0x00001023, b_size=3D=
4096
=C3=9D  210.053320=C2=A8 ------------=C3=9D cut here =C2=A8------------
=C3=9D  210.053323=C2=A8 kernel BUG at fs/ext4/inode.c:1639!
=C3=9D  210.053402=C2=A8 illegal operation: 0001 =C3=9D#1=C2=A8 SMP
=C3=9D  210.053405=C2=A8 Modules linked in: nf_conntrack_netbios_ns nf_=
conntrack_broadcast
 ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag=
_ipv6 ipt
able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4=
 nf_defra
g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filte=
r ip6_tab
les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod=
 dasd_eck
d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash=
 dm_log d
m_mod
=C3=9D  210.053434=C2=A8 CPU: 0 Not tainted 3.8.0-rc3+ #16
=C3=9D  210.053436=C2=A8 Process fsx (pid: 20565, task: 000000002c35800=
0, ksp: 000000002c0
8f480)
=C3=9D  210.053439=C2=A8 Krnl PSW : 0704f00180000000 00000000003033e8 (=
mpage_da_submit_io
0x3d4/0x408)
=C3=9D  210.053450=C2=A8            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0=
 AS:3 CC:3 PM:0 EA:
3
Krnl GPRS: 0000000000000015 0000000000000001 0000000000000030 000000000=
31b4508
=C3=9D  210.053455=C2=A8            00000000003033e4 0000000000000000 0=
000000000001000 000
7ffff00001000
=C3=9D  210.053457=C2=A8            000000002c08fa98 000003d100a8c6c0 0=
00000002c08fb68 000
000000000000f
=C3=9D  210.053460=C2=A8            00000000000082d2 000000002204d068 0=
0000000003033e4 000
000002c08f970
=C3=9D  210.053473=C2=A8 Krnl Code: 00000000003033d8: c02000215447     =
   larl    %r2,72dc
66
           00000000003033de: c0e50016788f       brasl   %r14,5d24fc
          #00000000003033e4: a7f40001           brc     15,3033e6
          >00000000003033e8: a7f40001           brc     15,3033ea
           00000000003033ec: a7f40001           brc     15,3033ee
           00000000003033f0: 4120f0e8           la      %r2,232(%r15)
           00000000003033f4: a7180000           lhi     %r1,0
           00000000003033f8: 5010f0d8           st      %r1,216(%r15)
=C3=9D  210.053497=C2=A8 Call Trace:
=C3=9D  210.053498=C2=A8 (=C3=9D<00000000003033e4>=C2=A8 mpage_da_submi=
t_io+0x3d0/0x408)
=C3=9D  210.053501=C2=A8  =C3=9D<0000000000309a48>=C2=A8 mpage_da_map_a=
nd_submit+0x150/0x41c
=C3=9D  210.053505=C2=A8  =C3=9D<000000000030a212>=C2=A8 write_cache_pa=
ges_da+0x4fe/0x530
=C3=9D  210.053509=C2=A8  =C3=9D<000000000030a584>=C2=A8 ext4_da_writep=
ages+0x340/0x628
=C3=9D  210.053512=C2=A8  =C3=9D<00000000002024d2>=C2=A8 __filemap_fdat=
awrite_range+0x6e/0x7c
=C3=9D  210.053518=C2=A8  =C3=9D<00000000002025fc>=C2=A8 filemap_write_=
and_wait_range+0x54/0x8c
=C3=9D  210.053521=C2=A8  =C3=9D<00000000002fe0f8>=C2=A8 ext4_sync_file=
+0x7c/0x3d8
=C3=9D  210.053524=C2=A8  =C3=9D<000000000023c932>=C2=A8 SyS_msync+0x14=
e/0x1d8
=C3=9D  210.053528=C2=A8  =C3=9D<00000000005de66e>=C2=A8 sysc_tracego+0=
x14/0x1a
=C3=9D  210.053533=C2=A8  =C3=9D<000003fffd0e1240>=C2=A8 0x3fffd0e1240
=C3=9D  210.053536=C2=A8 Last Breaking-Event-Address:
=C3=9D  210.053537=C2=A8  =C3=9D<00000000003033e4>=C2=A8 mpage_da_submi=
t_io+0x3d0/0x408
=C3=9D  210.053540=C2=A8
=C3=9D  210.053542=C2=A8 ---=C3=9D end trace f387176e9fcb98d0 =C2=A8---
=C3=9D  210.053546=C2=A8 ------------=C3=9D cut here =C2=A8------------
=C3=9D  210.053548=C2=A8 WARNING: at kernel/exit.c:713
=C3=9D  210.053550=C2=A8 Modules linked in: nf_conntrack_netbios_ns nf_=
conntrack_broadcast
 ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag=
_ipv6 ipt
able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4=
 nf_defra
g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filte=
r ip6_tab
les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod=
 dasd_eck
d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash=
 dm_log d
m_mod
=C3=9D  210.053571=C2=A8 CPU: 0 Tainted: G      D      3.8.0-rc3+ #16
