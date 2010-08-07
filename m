From: Justin Mattock <justinmattock@gmail.com>
Subject: kernel BUG at fs/ext4/mballoc.c:2993!
Date: Fri, 6 Aug 2010 22:48:40 -0700
Message-ID: <AANLkTinPtkUsVz6GYBgYMfgGKTJ88cyRfvdLcjtE5m4x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: gcc@gcc.gnu.org, linux-ext4@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <gcc-return-163636-gcc=m.gmane.org@gcc.gnu.org>
List-Unsubscribe: <mailto:gcc-unsubscribe-gcc=m.gmane.org@gcc.gnu.org>
List-Archive: <http://gcc.gnu.org/ml/gcc/>
List-Post: <mailto:gcc@gcc.gnu.org>
List-Help: <http://gcc.gnu.org/ml/>
Sender: gcc-owner@gcc.gnu.org
List-Id: linux-ext4.vger.kernel.org

hello,
I just built a fresh clfs system using the tutorial.. right now Im
able to boot and am able to login, the system seems to be running as
it should except for when I try to install gmp and/or do a /sbin/lilo
I see a message appear on screen(below) then if I do any kind of
command(dmesg > dmesg) I get a stuck screen. has there been anything
similar to the below message?

keep in mind the kernel I'm using is 2.6.35-rc6 which on other
machines(same type of system) run just fine without such message.

only real thing different that I did with this build was build the
latest gcc with gmp/mpfr/mpc inside gcc source directory instead of
installing them on the system then using the switches to there
location.



<0>[   48.976957] ------------[ cut here ]------------
<2>[   48.977187] kernel BUG at fs/ext4/mballoc.c:2993!
<0>[   48.977415] invalid opcode: 0000 [#1] SMP

<0>[   48.977694] last sysfs file: /sys/devices/virtual/vc/vcsa12/uevent
<4>[   48.977873] CPU 0
<4>[   48.977873] Modules linked in: uvcvideo videodev v4l1_compat
firewire_ohci firewire_core ohci1394 i2c_nforce2 ohci_hcd forcedeth
evdev thermal button aes_x86_64 lzo lzo_decompress lzo_compress tun
kvm_intel ipcomp xfrm_ipcomp crypto_null sha256_generic cbc
des_generic cast5 blowfish serpent camellia twofish twofish_common ctr
ah4 esp4 authenc adm1021 raw1394 ieee1394 uhci_hcd ehci_hcd hci_uart
rfcomm btusb hidp l2cap bluetooth coretemp acpi_cpufreq processor
mperf appletouch applesmc
<4>[   48.977873]
<4>[   48.977873] Pid: 1482, comm: lilo Not tainted 2.6.35-rc6 #1
Mac-F2218FC8/iMac9,1
<4>[   48.977873] RIP: 0010:[<ffffffff81150b02>]  [<ffffffff81150b02>]
ext4_mb_normalize_request+0x2d3/0x342
<4>[   48.977873] RSP: 0018:ffff880137a6fa88  EFLAGS: 00010206
<4>[   48.977873] RAX: ffff88013eef0000 RBX: ffff880138ee5000 RCX:
0000000000000010
<4>[   48.977873] RDX: 0000000000000010 RSI: 0000000000000010 RDI:
ffff88013eee1568
<4>[   48.977873] RBP: ffff880137a6fad8 R08: 000000000001fff0 R09:
ffff880137a6fb08
<4>[   48.977873] R10: 0000000100006e10 R11: ffff880137a6fc30 R12:
0000000000000010
<4>[   48.977873] R13: ffff880137a6fc10 R14: 000000000001fff0 R15:
0000000000020000
<4>[   48.977873] FS:  00007f58b5b65700(0000)
GS:ffff880001a00000(0000) knlGS:0000000000000000
<4>[   48.977873] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[   48.977873] CR2: 0000000000669018 CR3: 0000000138463000 CR4:
00000000000406f0
<4>[   48.977873] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<4>[   48.977873] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[   48.977873] Process lilo (pid: 1482, threadinfo
ffff880137a6e000, task ffff880137310f60)
<0>[   48.977873] Stack:
<4>[   48.977873]  0000000000000000 0000000000008050 ffff880138faaca8
0002000081150729
<4>[   48.977873] <0> ffff880137a6fb08 ffff880137a6fc10
ffff880137a6fc64 ffff88013eee1568
<4>[   48.977873] <0> ffff880138ee5000 0000000000000000
ffff880137a6fb58 ffffffff81154ca0
<0>[   48.977873] Call Trace:
<4>[   48.977873]  [<ffffffff81154ca0>] ext4_mb_new_blocks+0x173/0x3d3
<4>[   48.977873]  [<ffffffff8114a36f>] ? ext4_ext_find_extent+0x45/0x2a6
<4>[   48.977873]  [<ffffffff8114d2f6>] ext4_ext_map_blocks+0x1732/0x1aeb
<4>[   48.977873]  [<ffffffff811cc9e4>] ?
radix_tree_gang_lookup_tag_slot+0x81/0xa2
<4>[   48.977873]  [<ffffffff810bb944>] ? pagevec_lookup_tag+0x20/0x29
<4>[   48.977873]  [<ffffffff8113477b>] ext4_map_blocks+0x115/0x1f4
<4>[   48.977873]  [<ffffffff8113672b>] mpage_da_map_blocks+0xeb/0x364
<4>[   48.977873]  [<ffffffff81144cf9>] ? ext4_journal_start_sb+0xc7/0x103
<4>[   48.977873]  [<ffffffff811370b5>] ext4_da_writepages+0x330/0x579
<4>[   48.977873]  [<ffffffff813e88a9>] ? mutex_unlock+0x9/0xb
<4>[   48.977873]  [<ffffffff810b555f>] ? generic_file_aio_write+0x84/0xa4
<4>[   48.977873]  [<ffffffff810bafa7>] do_writepages+0x1f/0x28
<4>[   48.977873]  [<ffffffff810b4f5c>] __filemap_fdatawrite_range+0x4e/0x50
<4>[   48.977873]  [<ffffffff810b4fee>] filemap_write_and_wait_range+0x28/0x51
<4>[   48.977873]  [<ffffffff811030ca>] vfs_fsync_range+0x36/0x79
<4>[   48.977873]  [<ffffffff8110316b>] vfs_fsync+0x17/0x19
<4>[   48.977873]  [<ffffffff81103196>] do_fsync+0x29/0x3e
<4>[   48.977873]  [<ffffffff81103433>] sys_fdatasync+0xe/0x12
<4>[   48.977873]  [<ffffffff810263c2>] system_call_fastpath+0x16/0x1b
<0>[   48.977873] Code: 44 8b 45 b8 8b 43 10 89 c2 49 39 d7 7f 07 41
39 c4 76 02 0f 0b 4d 85 f6 74 11 48 8b 7b 08 48 8b 87 28 03 00 00 4c
3b 70 10 76 02 <0f> 0b 44 89 63 20 44 89 43 2c 49 8b 75 28 48 85 f6 74
1f 41 8b
<1>[   48.977873] RIP  [<ffffffff81150b02>]
ext4_mb_normalize_request+0x2d3/0x342
<4>[   48.977873]  RSP <ffff880137a6fa88>
<4>[   48.994547] ---[ end trace 5f3a007a6b3c50ca ]---




-- 
Justin P. Mattock
