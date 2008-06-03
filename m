From: "Srinivas Murthy" <codevana@gmail.com>
Subject: md_thread and kjournald race w/ raid1 on 2-way x86
Date: Mon, 2 Jun 2008 19:37:40 -0700
Message-ID: <df1bdeb10806021937x5907f33cyd87327a0d143253b@mail.gmail.com>
References: <df1bdeb10806021835v71897b2es83e29a8188ca97f1@mail.gmail.com>
	 <df1bdeb10806021836g7258adc5gfbbc03667798bdd6@mail.gmail.com>
	 <df1bdeb10806021915m7429d1e8gd80ce40d0ce9048b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:3044 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYFCChl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 22:37:41 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1349537rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 Jun 2008 19:37:40 -0700 (PDT)
In-Reply-To: <df1bdeb10806021915m7429d1e8gd80ce40d0ce9048b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have the following kernel (2.6.23) crash on a 2-cpu smp 32b x86 system.

The crash is intermittent and seems to happen w/ md raid 1 sync.

As you can see one of the cpu's is running the md_thread while the
other was in kjournald. Is there a known race condn between kjournald
and md_thread threads?

Any idea what the problem is?

Thanks.



<6>md: md0 stopped.
<6>md: bind<sda1>
<6>md: bind<sdb1>
<6>raid1: raid set md0 active with 2 out of 2 mirrors
<6>md: md1 stopped.
<6>md: bind<sda2>
<6>md: bind<sdb2>
<6>raid1: raid set md1 active with 2 out of 2 mirrors
<6>md: md2 stopped.
<6>md: bind<sda3>
<6>md: bind<sdb3>
<6>raid1: raid set md2 active with 2 out of 2 mirrors
<6>md: md3 stopped.
<6>md: bind<sda5>
<6>md: bind<sdb5>
<6>raid1: raid set md3 active with 2 out of 2 mirrors
<6>md: md4 stopped.
<6>md: bind<sda6>
<6>md: bind<sdb6>
<6>raid1: raid set md4 active with 2 out of 2 mirrors
<6>md: md5 stopped.
<6>md: bind<sda7>
<6>md: bind<sdb7>
<3>md: md5: raid array is not clean -- starting background reconstruction
<6>raid1: raid set md5 active with 2 out of 2 mirrors
<6>md: resync of RAID array md5
<6>md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
<6>md: using maximum available idle IO bandwidth (but not more than
20000 KB/sec) for resync.
<6>md: using 128k window, over a total of 7339904 blocks.
<6>md: md6 stopped.
<6>md: bind<sda8>
<6>md: bind<sdb8>
<6>raid1: raid set md6 active with 2 out of 2 mirrors
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on md2, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on md5, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>EXT3 FS on md0, internal journal
<6>Adding 4138872k swap on /dev/md3.  Priority:-1 extents:1 across:4138872k
<6>EXT3 FS on md0, internal journal
<6>bonding: bond0: setting mode to balance-rr (0).
<6>tg3: eth0: Link is up at 1000 Mbps, full duplex.
<6>tg3: eth0: Flow control is off for TX and off for RX.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on md4, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on md6, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<0>Assertion failure in journal_commit_transaction() at
fs/jbd/commit.c:693: "((&bh->b_count)->counter) == 0"
<0>------------[ cut here ]------------
<2>kernel BUG at fs/jbd/commit.c:693!
<0>invalid opcode: 0000 [#1]
<0>PREEMPT SMP
<0>CPU:    1
<0>EIP:    0060:[<c02c1149>]    Tainted: P        VLI
<0>EFLAGS: 00010296   (2.6.23.waas #4)
<0>EIP is at journal_commit_transaction+0x879/0xe00
<0>eax: 00000096   ebx: f76bcf00   ecx: ffffffff   edx: f7588ac0
<0>esi: f6c66f88   edi: c0651dcd   ebp: c6549f5c   esp: c6549ec4
<0>ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
<0>Process kjournald (pid: 1684, ti=c6548000 task=c39db580 task.ti=c6548000)
<0>Stack: c0651de8 c0651dcd c0651e44 000002b5 c0651fa0 00000000
00000000 f7f63414
<0>       f7f634dc 00000000 00000fcc f7435034 00000000 00000000
c6402000 00000000
<0>       f7f63400 f7386fc0 000005d7 f77fb580 c39db580 f70bdd74
00000202 c70f8000
<0>Call Trace:
<0> [<c0203a1a>] show_trace_log_lvl+0x1a/0x30
<0> [<c0203aea>] show_stack_log_lvl+0x9a/0xc0
<0> [<c0203d46>] show_registers+0x1d6/0x340
<0> [<c020403d>] die+0x10d/0x220
<0> [<c02041e1>] do_trap+0x91/0xd0
<0> [<c0204419>] do_invalid_op+0x89/0xa0
<0> [<c06317e2>] error_code+0x72/0x78
<0> [<c02c3845>] kjournald+0xb5/0x1f0
<0> [<c0232a5c>] kthread+0x5c/0xa0
<0> [<c020388b>] kernel_thread_helper+0x7/0x1c
<0> =======================
<0>Code: 65 c0 b8 a0 1f 65 c0 bf cd 1d 65 c0 89 44 24 10 b8 b5 02 00
00 89 44 24 0c b8 44 1e 65 c0 89 7c 24 04 89 44 24 08 e8 57 de f5 ff
<0f> 0b eb fe 8b 43 34 85 c0 75 4e 8b 53 38 85 d2 0f 84 9e 00 00
<0>EIP: [<c02c1149>] journal_commit_transaction+0x879/0xe00 SS:ESP 0068:c6549ec4
<6>SysRq : Changing Loglevel
<4>Loglevel set to 7

[0]kdb> btc
btc: cpu status: Currently on cpu 0
Available cpus: 0-1
Stack traceback for pid 1609
0xc69ce000     1609        2  1    0   R  0xc69ce1e0 *md5_resync
esp        eip        Function (args)
0xc69e5d4c 0xc028fef3 bio_alloc_bioset+0xb3 (0x11200, invalid, 0xc70e3060)
0xc69e5d78 0xc028ffbe bio_alloc+0xe
0xc69e5d80 0xc054f6d7 r1buf_pool_alloc+0x37 (0x11200, 0xc39ca0c0)
0xc69e5da4 0xc024aff6 mempool_alloc+0x26 (0xf7e7dcc0, invalid)
0xc69e5de0 0xc0552624 sync_request+0x1f4 (0xf7f40a00, 0xa2ce80, 0x0,
0xc69e5ea0, 0x0)
0xc69e5e40 0xc056667f md_do_sync+0x4ef (0xf7f40a00)
0xc69e5f78 0xc0564f55 md_thread+0x35 (0xf7e7dc80)
0xc69e5fd0 0xc0232a5c kthread+0x5c (invalid)
Stack traceback for pid 1684
0xc39db580     1684        2  1    1   R  0xc39db760  kjournald
esp        eip        Function (args)
kdb_bb: address 0xffffffff not recognised
Using old style backtrace, unreliable with no arguments
esp        eip        Function (args)
0xc6549eb8 0xc02c1149 journal_commit_transaction+0x879
0xc6549f28 0xc0227945 lock_timer_base+0x25
0xc6549f40 0xc0227b6a try_to_del_timer_sync+0x4a
0xc6549f60 0xc02c3845 kjournald+0xb5
0xc6549f88 0xc0233040 autoremove_wake_function
0xc6549f94 0xc062f8e1 __sched_text_start+0x1f1
0xc6549fa8 0xc0233040 autoremove_wake_function
[0]kdb>
