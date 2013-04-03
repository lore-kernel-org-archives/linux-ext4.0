From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Date: Wed, 3 Apr 2013 10:09:55 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304031005310.30499@localhost>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com>
 <874nfps133.fsf@openvz.org> <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-219185414-1364976601=:30499"
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>, stable@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791Ab3DCIKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 04:10:13 -0400
In-Reply-To: <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-219185414-1364976601=:30499
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 3 Apr 2013, CAI Qian wrote:

> Date: Wed, 3 Apr 2013 00:00:17 -0400 (EDT)
> From: CAI Qian <caiqian@redhat.com>
> To: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
>     linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
>     linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
>     stable@vger.kernel.org
> Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
> 
> 
> 
> ----- Original Message -----
> > From: "Dmitry Monakhov" <dmonakhov@openvz.org>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>, "LKML" <linux-kernel@vger.kernel.org>, "linux-s390"
> > <linux-s390@vger.kernel.org>, "Steve Best" <sbest@redhat.com>, linux-ext4@vger.kernel.org
> > Sent: Tuesday, April 2, 2013 6:01:36 PM
> > Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
> > 
> > On Tue, 2 Apr 2013 00:06:24 -0400 (EDT), CAI Qian <caiqian@redhat.com> wrote:
> > > Bisect indicated this is the culprit,
> > > 
> > > 0e401101db49959f5783f6ee9e676124b5a183ac
> > > ext4: fix memory leakage in mext_check_coverage
> > Strange...
> > It changes a bug in move_extent.c (e4defrag functionality)
> > ASAIU you just previously stopped your bisecting process here. Right?
> > Is this indeed a first bad commit?
> Hmm, bisect went wrong in the first place. Now double-confirmed this is
> the culprit,
> 
> 4f42f80a8f08d4c3f52c4267361241885d5dee3a
> ext4: use s_extent_max_zeroout_kb value as number of kb

With this commit we're zeroing parts of uninitialized extents when
converting uninitialized extents to initialized as we should. This is
unlikely to be real cause, though it probably uncover some another bug which
we could not notice before.

-Lukas

> 
> > > 
> > > This following with Dmitry's debug patch applied,
> > > 
> > > CAI Qian
> > > 
> > > Ý  101.408610¨ ES cache assertation failed for inode: 753 es_cached ex
> > > Ý56/5/744
> > > 81/20¨ != found ex Ý56/5/3396400/0¨ retval 0 flags 5
> > > Ý  209.858899¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý57/7/332
> > > 82/20¨ != found ex Ý57/7/3396400/0¨ retval 0 flags 5
> > > Ý  209.860656¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý25/1/332
> > > 50/20¨ != found ex Ý25/1/0/0¨ retval 0 flags 0
> > > Ý  209.893587¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý22/1/332
> > > 47/20¨ != found ex Ý22/1/34838/1000¨ retval 1 flags 0
> > > Ý  209.913482¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý27/1/329
> > > 40/20¨ != found ex Ý27/1/0/0¨ retval 0 flags 0
> > > Ý  209.919950¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý59/5/338
> > > 48/20¨ != found ex Ý59/5/3396400/0¨ retval 0 flags 5
> > > Ý  209.931856¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý7/1/3292
> > > 0/20¨ != found ex Ý7/1/35879/20¨ retval 1 flags 43
> > > Ý  209.969282¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý35/1/361
> > > 97/20¨ != found ex Ý35/1/36197/1000¨ retval 1 flags 0
> > > Ý  209.969290¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý48/1/362
> > > 10/20¨ != found ex Ý48/1/0/0¨ retval 0 flags 0
> > > Ý  209.980724¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý13/4/334
> > > 89/20¨ != found ex Ý13/4/2161372/0¨ retval 0 flags 5
> > > Ý  209.980744¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý61/3/335
> > > 37/20¨ != found ex Ý61/3/3396400/0¨ retval 0 flags 5
> > > Ý  209.983848¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý44/2/335
> > > 20/20¨ != found ex Ý44/2/36216/20¨ retval 2 flags 43
> > > Ý  210.020041¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý61/3/341
> > > 91/20¨ != found ex Ý61/3/3396400/0¨ retval 0 flags 5
> > > Ý  210.050100¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý22/11/34
> > > 565/20¨ != found ex Ý22/11/3396400/0¨ retval 0 flags 5
> > > Ý  210.053271¨ ES cache assertation failed for inode: 384 es_cached ex
> > > Ý15/1/334
> > > 90/20¨ != found ex Ý15/1/33579/1000¨ retval 1 flags 1
> > It does not looks like bigendian issue, actually I cant find any logical
> > system in the log. The only thing I see is that es_cache is
> > horribly out of sync with extent_tree.
> > Please try this patch:
> I'll test that shortly.
> CAI Qian
> > 
> > 
> > [Text Documents:disable-es_lookup_extent.patch]
> > 
> > 
> > It just disable es_cache lookup feature should. This should helps to
> > determine whenever this is a es_cache issue or not.
> > > Ý  210.053275¨ mpage_da_submit_io failed block=33490 != b_blocknr=33579
> > > Ý  210.053277¨ ino:384 lbkl:15, b_state=0x00001023, b_size=4096
> > > Ý  210.053320¨ ------------Ý cut here ¨------------
> > > Ý  210.053323¨ kernel BUG at fs/ext4/inode.c:1639!
> > > Ý  210.053402¨ illegal operation: 0001 Ý#1¨ SMP
> > > Ý  210.053405¨ Modules linked in: nf_conntrack_netbios_ns
> > > nf_conntrack_broadcast
> > >  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
> > >  nf_defrag_ipv6 ipt
> > > able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4
> > > nf_defra
> > > g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter
> > > ip6_tab
> > > les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod
> > > dasd_eck
> > > d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash
> > > dm_log d
> > > m_mod
> > > Ý  210.053434¨ CPU: 0 Not tainted 3.8.0-rc3+ #16
> > > Ý  210.053436¨ Process fsx (pid: 20565, task: 000000002c358000, ksp:
> > > 000000002c0
> > > 8f480)
> > > Ý  210.053439¨ Krnl PSW : 0704f00180000000 00000000003033e8
> > > (mpage_da_submit_io
> > > 0x3d4/0x408)
> > > Ý  210.053450¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:3
> > > PM:0 EA:
> > > 3
> > > Krnl GPRS: 0000000000000015 0000000000000001 0000000000000030
> > > 00000000031b4508
> > > Ý  210.053455¨            00000000003033e4 0000000000000000
> > > 0000000000001000 000
> > > 7ffff00001000
> > > Ý  210.053457¨            000000002c08fa98 000003d100a8c6c0
> > > 000000002c08fb68 000
> > > 000000000000f
> > > Ý  210.053460¨            00000000000082d2 000000002204d068
> > > 00000000003033e4 000
> > > 000002c08f970
> > > Ý  210.053473¨ Krnl Code: 00000000003033d8: c02000215447        larl
> > > %r2,72dc
> > > 66
> > >            00000000003033de: c0e50016788f       brasl   %r14,5d24fc
> > >           #00000000003033e4: a7f40001           brc     15,3033e6
> > >           >00000000003033e8: a7f40001           brc     15,3033ea
> > >            00000000003033ec: a7f40001           brc     15,3033ee
> > >            00000000003033f0: 4120f0e8           la      %r2,232(%r15)
> > >            00000000003033f4: a7180000           lhi     %r1,0
> > >            00000000003033f8: 5010f0d8           st      %r1,216(%r15)
> > > Ý  210.053497¨ Call Trace:
> > > Ý  210.053498¨ (Ý<00000000003033e4>¨ mpage_da_submit_io+0x3d0/0x408)
> > > Ý  210.053501¨  Ý<0000000000309a48>¨ mpage_da_map_and_submit+0x150/0x41c
> > > Ý  210.053505¨  Ý<000000000030a212>¨ write_cache_pages_da+0x4fe/0x530
> > > Ý  210.053509¨  Ý<000000000030a584>¨ ext4_da_writepages+0x340/0x628
> > > Ý  210.053512¨  Ý<00000000002024d2>¨ __filemap_fdatawrite_range+0x6e/0x7c
> > > Ý  210.053518¨  Ý<00000000002025fc>¨ filemap_write_and_wait_range+0x54/0x8c
> > > Ý  210.053521¨  Ý<00000000002fe0f8>¨ ext4_sync_file+0x7c/0x3d8
> > > Ý  210.053524¨  Ý<000000000023c932>¨ SyS_msync+0x14e/0x1d8
> > > Ý  210.053528¨  Ý<00000000005de66e>¨ sysc_tracego+0x14/0x1a
> > > Ý  210.053533¨  Ý<000003fffd0e1240>¨ 0x3fffd0e1240
> > > Ý  210.053536¨ Last Breaking-Event-Address:
> > > Ý  210.053537¨  Ý<00000000003033e4>¨ mpage_da_submit_io+0x3d0/0x408
> > > Ý  210.053540¨
> > > Ý  210.053542¨ ---Ý end trace f387176e9fcb98d0 ¨---
> > > Ý  210.053546¨ ------------Ý cut here ¨------------
> > > Ý  210.053548¨ WARNING: at kernel/exit.c:713
> > > Ý  210.053550¨ Modules linked in: nf_conntrack_netbios_ns
> > > nf_conntrack_broadcast
> > >  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
> > >  nf_defrag_ipv6 ipt
> > > able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4
> > > nf_defra
> > > g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter
> > > ip6_tab
> > > les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod
> > > dasd_eck
> > > d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash
> > > dm_log d
> > > m_mod
> > > Ý  210.053571¨ CPU: 0 Tainted: G      D      3.8.0-rc3+ #16
> > 
> 
--8323328-219185414-1364976601=:30499--
