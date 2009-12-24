From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Fri, 25 Dec 2009 01:49:29 +0300
Message-ID: <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756260AbZLXWtc@vger.kernel.org>
In-Reply-To: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/12/25 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> Kernel is 2.6.33-rc1-00366-g2f99f5c
> Ext4 mounts ext3 filesystem
>
>
>
> kernel BUG at fs/ext4/inode.c:1063!
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\|/ ____ \|/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"@'/ .. \`@"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/_| \__/ |_\
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \__U_/
> flush-8:0(1137): Kernel bad sw trap 5 [#1]
> TSTATE: 0000000080001603 TPC: 0000000000544fb4 TNPC: 0000000000544fb8
> Y: 00000000 =C2=A0 =C2=A0Not tainted
> TPC: <ext4_get_blocks+0x3f4/0x400>
> g0: fffff800dc862fe0 g1: 0000000000000001 g2: 0000000000000001 g3:
> fffff800dc85f9c1
> g4: fffff800df305880 g5: 2e68006800002e68 g6: fffff800dc860000 g7:
> 0000000000833e08
> o0: 00000000007b0cb8 o1: 0000000000000427 o2: 0000000000000040 o3:
> 0000000000000040
> o4: fffff800dc8630a0 o5: 000000000000000d sp: fffff800dc8628d1 ret_pc=
:
> 0000000000544fac
> RPC: <ext4_get_blocks+0x3ec/0x400>
> l0: 0000000000000002 l1: fffff800c2674000 l2: fffff800c26740d0 l3:
> 0000000000000001
> l4: fffff800df39d2d0 l5: 00000000000003f9 l6: 0006000000000000 l7:
> 0000000000001ffe
> i0: 0000000000000040 i1: fffff800c2674130 i2: 000000000000064c i3:
> fffff800c26745a8
> i4: fffff800dc863308 i5: 0000000000000003 i6: fffff800dc8629a1 i7:
> 0000000000545380
> I7: <mpage_da_map_blocks+0x80/0x800>
> Disabling lock debugging due to kernel taint
> Caller[0000000000545380]: mpage_da_map_blocks+0x80/0x800
> Caller[00000000005461c0]: mpage_add_bh_to_extent+0x40/0x100
> Caller[000000000054642c]: __mpage_da_writepage+0x1ac/0x220
> Caller[00000000004a951c]: write_cache_pages+0x19c/0x380
> Caller[0000000000545d7c]: ext4_da_writepages+0x27c/0x680
> Caller[00000000004a978c]: do_writepages+0x2c/0x60
> Caller[00000000004f94cc]: writeback_single_inode+0xcc/0x3c0
> Caller[00000000004fa3d8]: writeback_inodes_wb+0x338/0x500
> Caller[00000000004fa6e8]: wb_writeback+0x148/0x220
> Caller[00000000004fab00]: wb_do_writeback+0x240/0x260
> Caller[00000000004fab8c]: bdi_writeback_task+0x6c/0xc0
> Caller[00000000004b6f50]: bdi_start_fn+0x70/0xe0
> Caller[000000000047030c]: kthread+0x6c/0x80
> Caller[000000000042bc9c]: kernel_thread+0x3c/0x60
> Caller[0000000000470408]: kthreadd+0xe8/0x160
> Instruction DUMP: 92102427 =C2=A07ffb95a5 =C2=A0901220b8 <91d02005> 0=
1000000
> 01000000 =C2=A09de3bf40 =C2=A011002096 =C2=A0a4100018
> note: flush-8:0[1137] exited with preempt_count 1
>

It seems I can easily reproduce it.
But I can't compile 2.6.33-rc2 :)

scripts/kconfig/conf -s arch/sparc/Kconfig
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  GZIP    kernel/config_data.gz
  CC      fs/configfs/inode.o
  IKCFG   kernel/config_data.h
  LD [M]  fs/btrfs/btrfs.o
  CC      kernel/configs.o
fs/btrfs/sysfs.o: file not recognized: File truncated
make[2]: *** [fs/btrfs/btrfs.o] Error 1
make[1]: *** [fs/btrfs] Error 2
make[1]: *** Waiting for unfinished jobs....
