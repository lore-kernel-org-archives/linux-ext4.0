From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: found a scenario for BUG at fs/ext4/super.c:804!
Date: Sat, 01 Jun 2013 15:48:26 +0200
Message-ID: <51A9FBAA.2050906@gmx.de>
References: <51A79353.7030604@gmx.de> <51A7951C.5020300@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65067 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3FANsa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Jun 2013 09:48:30 -0400
Received: from mailout-de.gmx.net ([10.1.76.19]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LcmCH-1U1yxP1v7P-00k9yA for
 <linux-ext4@vger.kernel.org>; Sat, 01 Jun 2013 15:48:28 +0200
In-Reply-To: <51A7951C.5020300@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/30/2013 08:06 PM, Toralf F=C3=B6rster wrote:
> On 05/30/2013 07:58 PM, Toralf F=C3=B6rster wrote:
>> 11. if that attempt fails stop the nfs service and run the umount co=
mmand again - it segfaults now
>=20
> forgot to mention that after that just sysrq+b thelps me to reboot th=
e
> machine, a "sync" does not come back nor can be interrupted with Ctrl=
-C,
> "reboot" don't work too - OTOH I'm able to write an email and save it=
 as
> a draft.
>=20

sysrq+w gave :

2013-06-01T15:30:25.825+02:00 n22 kernel: SysRq : Show Blocked State
2013-06-01T15:30:25.825+02:00 n22 kernel: task                PC stack =
  pid father
2013-06-01T15:30:25.825+02:00 n22 kernel: kworker/0:1     D f08f7db0   =
  0    29      2 0x00000000
2013-06-01T15:30:25.825+02:00 n22 kernel: Workqueue: events do_sync_wor=
k
2013-06-01T15:30:25.825+02:00 n22 kernel: f22b9e88 00000046 00000000 f0=
8f7db0 00000008 e7a9080b 00000a16 f22b9e34
2013-06-01T15:30:25.825+02:00 n22 kernel: c16b1400 c104ec08 c16b1400 f3=
7ba400 f21b8d50 ef1a39b0 00000296 b9b6e892
2013-06-01T15:30:25.825+02:00 n22 kernel: f22b9eb0 7fffffff f22b9eac f2=
2b9e78 c14803f3 f21b8d50 00000001 f21b8d50
2013-06-01T15:30:25.825+02:00 n22 kernel: Call Trace:
2013-06-01T15:30:25.825+02:00 n22 kernel: [<c104ec08>] ? try_to_grab_pe=
nding+0x98/0x130
2013-06-01T15:30:25.825+02:00 n22 kernel: [<c14803f3>] ? wait_for_compl=
etion+0x83/0xc0
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c1062410>] ? try_to_wake_up=
+0x220/0x220
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c1480453>] schedule+0x23/0x=
60
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c1480d15>] rwsem_down_read_=
failed+0x75/0xb2
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c12da18f>] call_rwsem_down_=
read_failed+0x7/0xc
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c147f24c>] ? down_read+0x1c=
/0x1f
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c11208d2>] iterate_supers+0=
x62/0xc0
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c1144fa0>] ? fdatawrite_one=
_bdev+0x20/0x20
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c1144f22>] do_sync_work+0x2=
2/0x80
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c104e62e>] process_one_work=
+0x10e/0x390
2013-06-01T15:30:25.826+02:00 n22 kernel: [<c104f602>] worker_thread+0x=
102/0x320
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c104f500>] ? manage_workers=
=2Eisra.24+0x290/0x290
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1054b74>] kthread+0x94/0xa=
0
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1481a37>] ret_from_kernel_=
thread+0x1b/0x28
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1054ae0>] ? flush_kthread_=
worker+0x90/0x90
2013-06-01T15:30:25.827+02:00 n22 kernel: sync            D f08f7db0   =
  0 27190  27033 0x00000000
2013-06-01T15:30:25.827+02:00 n22 kernel: ef57ff38 00000082 00000000 f0=
8f7db0 00000008 c7f4f883 00000a15 ef57fee4
2013-06-01T15:30:25.827+02:00 n22 kernel: c16b1400 c104ec08 c16b1400 f3=
7c7400 eeed4fe0 ef1a39b0 00000296 2a2f912a
2013-06-01T15:30:25.827+02:00 n22 kernel: ef57ff60 7fffffff ef57ff5c ef=
57ff28 c14803f3 eeed4fe0 00000001 eeed4fe0
2013-06-01T15:30:25.827+02:00 n22 kernel: Call Trace:
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c104ec08>] ? try_to_grab_pe=
nding+0x98/0x130
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c14803f3>] ? wait_for_compl=
etion+0x83/0xc0
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1062410>] ? try_to_wake_up=
+0x220/0x220
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1480453>] schedule+0x23/0x=
60
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1480d15>] rwsem_down_read_=
failed+0x75/0xb2
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c12da18f>] call_rwsem_down_=
read_failed+0x7/0xc
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c147f24c>] ? down_read+0x1c=
/0x1f
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c11208d2>] iterate_supers+0=
x62/0xc0
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1144fa0>] ? fdatawrite_one=
_bdev+0x20/0x20
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c11450d1>] sys_sync+0x31/0x=
80
2013-06-01T15:30:25.827+02:00 n22 kernel: [<c1481ac1>] sysenter_do_call=
+0x12/0x22
2013-06-01T15:30:25.828+02:00 n22 kernel: kworker/0:0     D f08f7db0   =
  0 27191      2 0x00000000
2013-06-01T15:30:25.828+02:00 n22 kernel: Workqueue: events do_sync_wor=
k
2013-06-01T15:30:25.828+02:00 n22 kernel: ea5e9e88 00000046 00000000 f0=
8f7db0 00000008 42845398 00000a17 eeed0336
2013-06-01T15:30:25.828+02:00 n22 kernel: c16b1400 c104ec08 c16b1400 f3=
7ba400 eeed4290 eeed0000 00000296 c1535c4d
2013-06-01T15:30:25.828+02:00 n22 kernel: ea5e9eb0 7fffffff ea5e9eac ea=
5e9e78 c14803f3 eeed4290 00000001 eeed4290
2013-06-01T15:30:25.828+02:00 n22 kernel: Call Trace:
2013-06-01T15:30:25.828+02:00 n22 kernel: [<c104ec08>] ? try_to_grab_pe=
nding+0x98/0x130
2013-06-01T15:30:25.828+02:00 n22 kernel: [<c14803f3>] ? wait_for_compl=
etion+0x83/0xc0
2013-06-01T15:30:25.828+02:00 n22 kernel: [<c1062410>] ? try_to_wake_up=
+0x220/0x220
2013-06-01T15:30:25.828+02:00 n22 kernel: [<c1480453>] schedule+0x23/0x=
60
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1480d15>] rwsem_down_read_=
failed+0x75/0xb2
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c12da18f>] call_rwsem_down_=
read_failed+0x7/0xc
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c147f24c>] ? down_read+0x1c=
/0x1f
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c11208d2>] iterate_supers+0=
x62/0xc0
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1144fa0>] ? fdatawrite_one=
_bdev+0x20/0x20
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1144f22>] do_sync_work+0x2=
2/0x80
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c104e62e>] process_one_work=
+0x10e/0x390
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c104f602>] worker_thread+0x=
102/0x320
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c104f500>] ? manage_workers=
=2Eisra.24+0x290/0x290
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1054b74>] kthread+0x94/0xa=
0
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1481a37>] ret_from_kernel_=
thread+0x1b/0x28
2013-06-01T15:30:25.829+02:00 n22 kernel: [<c1054ae0>] ? flush_kthread_=
worker+0x90/0x90
2013-06-01T15:30:58.399+02:00 n22 kernel: SysRq : Emergency Sync


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
