From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21-git4 Scheduler, NOHZ, VFS bugs
Date: Fri, 04 May 2007 19:01:27 +0200
Message-ID: <463B66E7.4090102@googlemail.com>
References: <463B5D63.2030109@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	viro@ftp.linux.org.uk, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:24566 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031416AbXEDRBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 13:01:31 -0400
Received: by ug-out-1314.google.com with SMTP id 44so683842uga
        for <linux-ext4@vger.kernel.org>; Fri, 04 May 2007 10:01:29 -0700 (PDT)
In-Reply-To: <463B5D63.2030109@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Michal Piotrowski napisa=B3(a):
> Hi,
>=20
> I ran this script tree times,
>=20
> #! /bin/sh
>=20
> for i in `find /sys/ -type f`
> do
>     echo "wy=B6wietlam $i"
>     sudo cat $i > /dev/null
> done
>=20
> First run - scheduler bug
> Second run - NOHZ bug
> Third - VFS bug
>=20
> Hmmmm...
>=20

Something weird is happening here. I'll try to bisect it tomorrow.

[ 3083.712806] Slab corruption: size-4096 start=3Dedf32000, len=3D4096
[ 3083.720857] d50: 6b 6b 6b 6b 6b 6b 6b 6b 06 00 00 00 06 00 00 00
[ 3083.732297] d60: a4 3e f3 ed 00 00 00 00 20 6b 6b 6b 6b 6b 6b 6b
[ 3083.738865] d70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 00 c0 bd 32 c0
[ 3083.746526] d80: 00 00 00 00 6b 6b 34 36 6b 6b 6b 6b 6b 6b 6b 6b
[ 3083.753127] dc0: 6b 6b 6b 6b 6b 6b 6b 6b 68 2e f3 ed b2 2e f3 ed
[ 3083.760302] dd0: 64 2e f3 ed 24 2e f3 ed 73 d3 1e c0 40 00 00 00
[ 3084.254683] Slab corruption: size-4096 start=3Dedf32000, len=3D4096
[ 3084.261099] e60: 6b 6b 6b 6b 6b 6b 6b 6b a4 3e f3 ed a4 2e f3 ed
[ 3084.268084] e70: 20 00 00 00 a4 3e f3 ed 00 00 00 00 00 00 00 00
[ 3084.274977] e80: 5c 7b 40 c0 c0 7a 40 c0 ec f6 17 c6 30 3f f3 ed
[ 3084.281985] e90: a9 7b 25 c0 20 00 00 00 a4 2e f3 ed 00 10 00 00
[ 3084.288986] ea0: 00 c0 6b e8 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3088.529368] Slab corruption: names_cache start=3Dedfdc000, len=3D409=
6
[ 3088.537549] db0: d7 0f 00 00 cd ce fd ed 6b 6b 6b 00 6b 6b 6b 6b
[ 3088.544586] dc0: a4 de fd ed fe ff ff ff ff ff ff ff 00 00 00 00
[ 3088.552081] dd0: c9 0e 3c c0 19 00 00 00 2c ce fd ed 30 ce fd ed
[ 3088.560390] de0: fc cd fd ed 27 a8 1e c0 20 ce fd ed 20 ce fd ed
[ 3088.567164] df0: 30 ce fd ed 2c ce fd ed a0 7a 7c c0 40 ce fd ed
[ 3088.574541] e00: c0 92 26 c0 a8 de fd ed 1f 00 00 00 30 ce fd ed
[ 3090.468508] Slab corruption: names_cache start=3Dedfdc000, len=3D409=
6
[ 3090.476153] d00: 01 00 00 00 01 00 00 00 a4 de fd ed 00 00 00 00
[ 3090.482860] d20: 6b 6b 6b 00 c0 bd 32 c0 00 00 00 00 6b 6b 30 44
[ 3090.490778] d30: 34 32 36 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3090.498469] d70: 28 ce fd ed 34 cf fd ed 24 ce fd ed cc cd fd ed
[ 3090.506019] d80: 73 d3 1e c0 00 00 00 00 00 00 00 00 10 00 00 00
[ 3090.513663] d90: 02 00 00 00 ff ff ff ff 01 00 00 00 ac 0f 00 00
[ 3091.872283] Slab corruption: size-4096 start=3De8914000, len=3D4096
[ 3091.878257] e80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 30 5f 91 e8
[ 3091.884735] e90: 79 7b 25 c0 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3091.892213] ea0: 00 80 71 e8 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3093.410639] Slab corruption: size-4096 start=3Dedf32000, len=3D4096
[ 3093.417755] d00: 02 00 00 00 02 00 00 00 a4 3e f3 ed 00 00 00 00
[ 3093.425337] d20: 6b 6b 6b 00 c0 bd 32 c0 00 00 00 00 6b 6b 30 32
[ 3093.433142] d30: 30 38 43 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3093.440570] d70: 28 2e f3 ed 44 2f f3 ed 24 2e f3 ed cc 2d f3 ed
[ 3093.447276] d80: 73 d3 1e c0 20 00 00 00 00 00 00 00 10 00 00 00
[ 3093.454788] d90: 02 00 00 00 ff ff ff ff 01 00 00 00 9c 0f 00 00
[ 3093.966252] Slab corruption: size-4096 start=3Dedf32000, len=3D4096
[ 3093.972206] cf0: 6b 6b 6b 6b 6b 6b 6b 6b 09 00 00 00 09 00 00 00
[ 3093.979615] d00: a4 3e f3 ed 00 00 00 00 30 6b 6b 6b 6b 6b 6b 6b
[ 3093.988470] d10: 6b 6b 6b 6b 01 00 00 00 01 00 00 00 80 bd 32 c0
[ 3093.994932] d20: 00 00 00 00 30 6b 30 30 32 6b 6b 6b 6b 6b 6b 6b
[ 3094.002161] d30: 6b 6b 6b 6b 6b 6b 6b 00 c0 bd 32 c0 00 00 00 00
[ 3094.011258] d40: 6b 6b 31 30 32 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[ 3098.788932] Slab corruption: names_cache start=3Dedfdc000, len=3D409=
6
[ 3098.796601] d50: 6b 6b 6b 6b 6b 6b 6b 6b 08 00 00 00 08 00 00 00
[ 3098.803087] d60: a4 de fd ed 00 00 00 00 20 6b 6b 6b 6b 6b 6b 6b
[ 3098.810549] d70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 00 c0 bd 32 c0
[ 3098.818635] d80: 00 00 00 00 6b 6b 38 35 32 6b 6b 6b 6b 6b 6b 6b
[ 3098.825218] dc0: 6b 6b 6b 6b 6b 6b 6b 6b 68 ce fd ed b4 ce fd ed
[ 3098.832428] dd0: 64 ce fd ed 24 ce fd ed 73 d3 1e c0 08 00 00 00
[ 3105.030209] BUG: at /mnt/md0/devel/linux-git/kernel/lockdep.c:2427 c=
heck_flags()
[ 3110.647987] BUG: NMI Watchdog detected LOCKUP on CPU1, eip c01ed813,=
 registers:
[ 3110.655294] Modules linked in: isofs nls_base zlib_inflate ipt_MASQU=
ERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_=
REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter=
 ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ip=
v6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_a=
c97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq=
 snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm snd_timer snd i=
ntel_agp agpgart soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc uni=
x
[ 3110.705684] CPU:    1
[ 3110.705685] EIP:    0060:[<c01ed813>]    Not tainted VLI
[ 3110.705687] EFLAGS: 00001446   (2.6.21-gdc87c398-dirty #170)
[ 3110.718887] EIP is at delay_tsc+0xe/0x17

 l *0xc01ed813
0xc01ed813 is in delay_tsc (/mnt/md0/devel/linux-git/arch/i386/lib/dela=
y.c:49).
44
45              rdtscl(bclock);
46              do {
47                      rep_nop();
48                      rdtscl(now);
49              } while ((now-bclock) < loops);
50      }
51
52      /*
53       * Since we calibrate only once at boot, this


[ 3110.722799] eax: e154b640   ebx: 00000001   ecx: e154b5c4   edx: 000=
007ef
[ 3110.729566] esi: 0248c90e   edi: 00000001   ebp: e8919c20   esp: e89=
19c1c
[ 3110.736334] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 3110.742153] Process bash (pid: 9542, ti=3De8919000 task=3Df0fcd4f0 t=
ask.ti=3De8919000)
[ 3110.749352] Stack: c6029a20 e8919c28 c01ed850 e8919c54 c01f9bb5 001e=
d0a4 f7d1c034 fffffff5=20
[ 3110.757850]        00000005 00000001 a6c75fa0 c6029a20 c6029a20 e891=
9cd0 e8919c6c c031ec1e=20
[ 3110.766328]        00000000 00000002 c011b749 c045ada0 e8919c84 c011=
b749 f7f454f0 f2556f40=20
[ 3110.774817] Call Trace:
[ 3110.777455]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[ 3110.782605]  [<c01050eb>] show_stack_log_lvl+0x9d/0xa5
[ 3110.787756]  [<c01052e0>] show_registers+0x1ed/0x32c
[ 3110.792727]  [<c01064bf>] die_nmi+0x8b/0xe3
[ 3110.796929]  [<c0115bd7>] nmi_watchdog_tick+0x139/0x25e
[ 3110.802167]  [<c0105b0e>] do_nmi+0xa0/0x25e
[ 3110.806368]  [<c031f4f7>] nmi_stack_correct+0x26/0x2b
[ 3110.811433]  [<c01ed850>] __delay+0x9/0xb
[ 3110.815453]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[ 3110.820258]  [<c031ec1e>] _spin_lock+0x3c/0x42
[ 3110.824711]  [<c011b749>] task_rq_lock+0x36/0x5d
[ 3110.829345]  [<c011c603>] try_to_wake_up+0x19/0x3a0
[ 3110.834236]  [<c011c995>] default_wake_function+0xb/0xd
[ 3110.839466]  [<c01334fa>] autoremove_wake_function+0x17/0x38
[ 3110.845138]  [<c011a200>] __wake_up_common+0x32/0x55
[ 3110.850116]  [<c011aedf>] __wake_up+0x31/0x42
[ 3110.854489]  [<c0121c43>] wake_up_klogd+0x36/0x38
[ 3110.859201]  [<c0121df8>] release_console_sem+0x1b3/0x1bb
[ 3110.864613]  [<c01223fc>] vprintk+0x27e/0x2f6
[ 3110.868986]  [<c012248f>] printk+0x1b/0x1d
[ 3110.873093]  [<c013b28a>] check_flags+0x90/0x143
[ 3110.877727]  [<c013e044>] lock_acquire+0x29/0x82
[ 3110.882360]  [<c031c86d>] __sched_text_start+0x875/0x906
[ 3110.887683]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 3110.891254] Code: 00 8d bc 27 00 00 00 00 eb 0e 8d b4 26 00 00 00 00=
 8d bc 27 00 00 00 00 48 79 fd 5d c3 55 89 e5 53 89 c3 0f 31 89 c1 f3 9=
0 0f 31 <29> c8 39 d8 72 f6 5b 5d c3 55 89 e5 c7 05 70 de 3f c0 05 d8 1=
e=20
[ 3115.637041] BUG: NMI Watchdog detected LOCKUP on CPU0, eip c01ed811,=
 registers:
[ 3115.644353] Modules linked in: isofs nls_base zlib_inflate ipt_MASQU=
ERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_=
REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter=
 ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ip=
v6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_a=
c97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq=
 snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm snd_timer snd i=
ntel_agp agpgart soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc uni=
x
[ 3115.694793] CPU:    0
[ 3115.694795] EIP:    0060:[<c01ed811>]    Not tainted VLI
[ 3115.694797] EFLAGS: 00200046   (2.6.21-gdc87c398-dirty #170)
[ 3115.707995] EIP is at delay_tsc+0xc/0x17
[ 3115.711909] eax: 239935b0   ebx: 00000001   ecx: 239935b0   edx: 000=
007f3
[ 3115.718677] esi: 04567d97   edi: 00000001   ebp: f7e32ce8   esp: f7e=
32ce4
[ 3115.725444] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 3115.731263] Process konsole (pid: 3209, ti=3Df7e32000 task=3Df262003=
0 task.ti=3Df7e32000)
[ 3115.738721] Stack: c6029a20 f7e32cf0 c01ed850 f7e32d1c c01f9bb5 0020=
0046 00000000 00000002=20
[ 3115.747235]        00000001 c011b749 a6c75fa0 c6029a20 c6029a20 f7e3=
2d98 f7e32d34 c031ec1e=20
[ 3115.755733]        00000000 00000002 c011b749 c045ada0 f7e32d4c c011=
b749 eff8aa90 e855a028=20
[ 3115.764239] Call Trace:
[ 3115.766875]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[ 3115.772028]  [<c01050eb>] show_stack_log_lvl+0x9d/0xa5
[ 3115.777179]  [<c01052e0>] show_registers+0x1ed/0x32c
[ 3115.782158]  [<c01064bf>] die_nmi+0x8b/0xe3
[ 3115.786359]  [<c0115bd7>] nmi_watchdog_tick+0x139/0x25e
[ 3115.791598]  [<c0105b0e>] do_nmi+0xa0/0x25e
[ 3115.795799]  [<c031f4f7>] nmi_stack_correct+0x26/0x2b
[ 3115.800863]  [<c01ed850>] __delay+0x9/0xb
[ 3115.804892]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[ 3115.809698]  [<c031ec1e>] _spin_lock+0x3c/0x42
[ 3115.814160]  [<c011b749>] task_rq_lock+0x36/0x5d
[ 3115.818793]  [<c011c603>] try_to_wake_up+0x19/0x3a0
[ 3115.823685]  [<c011c995>] default_wake_function+0xb/0xd
[ 3115.828922]  [<c011a200>] __wake_up_common+0x32/0x55
[ 3115.833902]  [<c011aedf>] __wake_up+0x31/0x42
[ 3115.838275]  [<c02ce8e8>] sock_def_readable+0x42/0x6e
[ 3115.843342]  [<f8859121>] unix_stream_sendmsg+0x22d/0x2e2 [unix]
[ 3115.849357]  [<c02ca95f>] sock_aio_write+0xfb/0x107
[ 3115.854249]  [<c0171de2>] do_sync_write+0xc2/0xff
[ 3115.858962]  [<c01725cf>] vfs_write+0xc3/0x138
[ 3115.863414]  [<c0172b85>] sys_write+0x3d/0x61
[ 3115.867786]  [<c0104060>] syscall_call+0x7/0xb
[ 3115.872238]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 3115.875809] Code: 74 26 00 8d bc 27 00 00 00 00 eb 0e 8d b4 26 00 00=
 00 00 8d bc 27 00 00 00 00 48 79 fd 5d c3 55 89 e5 53 89 c3 0f 31 89 c=
1 f3 90 <0f> 31 29 c8 39 d8 72 f6 5b 5d c3 55 89 e5 c7 05 70 de 3f c0 0=
5=20

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/se=
rial-console3.log

Regards,
Michal

--=20
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
