From: Jiri Slaby <jirislaby@gmail.com>
Subject: BUG at __dentry_open [Was: 2.6.25-rc8-mm2]
Date: Mon, 14 Apr 2008 10:07:16 +0200
Message-ID: <480310B4.4070704@gmail.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, sct@redhat.com,
	adilger@clusterfs.com, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/11/2008 05:33 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/

$ cat /var/lib/rpm/Conflictname
Killed

BUG: unable to handle kernel paging request at fffff0002004c1b0
IP: [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
PGD 0
Oops: 0000 [6] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 1
Modules linked in: ipv6 tun bitrev test arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 crc32 rtc_cmos usbhid sr_mod ohci1394 hid rtc_core 
cfg80211 rtc_lib ehci_hcd cdrom ieee1394 ff_memless floppy
Pid: 4388, comm: cat Tainted: G      D   2.6.25-rc8-mm2_64 #399
RIP: 0010:[<ffffffff80296df7>]  [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
RSP: 0018:ffff810028ebbd98  EFLAGS: 00010206
RAX: fffff0002004c1b0 RBX: ffff81001a62d6c0 RCX: 0000000000000000
RDX: ffff81001a62d6c0 RSI: ffff81001a62d6c0 RDI: ffff81001a62d728
RBP: ffff810028ebbdc8 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000e6 R11: 0000000000000246 R12: ffff81002004c0a0
R13: 0000000000000000 R14: ffffffff80296770 R15: ffff81001c6583e8
FS:  00007fb9b575b6f0(0000) GS:ffff81007d006580(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffff0002004c1b0 CR3: 00000000268ea000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process cat (pid: 4388, threadinfo ffff810028eba000, task ffff810024500000)
Stack:  ffff81007c5d4500 ffff81001a62d6c0 0000000000000000 0000000000000004
  ffff810028ebbe48 0000000000008000 ffff810028ebbde8 ffffffff802970c4
  0000000000000004 0000000000000000 ffff810028ebbf28 ffffffff802a56cb
Call Trace:
  [<ffffffff802970c4>] nameidata_to_filp+0x44/0x60
  [<ffffffff802a56cb>] do_filp_open+0x1eb/0x990
  [<ffffffff80296aec>] ? get_unused_fd_flags+0x8c/0x140
  [<ffffffff80296c16>] do_sys_open+0x76/0x110
  [<ffffffff80296cdb>] sys_open+0x1b/0x20
  [<ffffffff8020b88b>] system_call_after_swapgs+0x7b/0x80


Code: 4d 85 f6 0f 84 9b 01 00 00 48 89 de 4c 89 e7 41 ff d6 41 89 c5 85 c0 75 63 
81 63 2c 3f fc ff ff 48 8b 83 b0 00 00 00 48 8d 7b 68 <48> 8b 00 48 8b b0 08 01 
00 00 e8 ea de fd ff f6 43 2d 40 74 1f
RIP  [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
  RSP <ffff810028ebbd98>
CR2: fffff0002004c1b0
---[ end trace ae5dfe91803cf591 ]---



as the first (not tainted):
00]
BUG: unable to handle kernel paging request at fffff0002004c1b0
IP: [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
PGD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 0
Modules linked in: ipv6 tun bitrev test arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 crc32 rtc_cmos usbhid sr_mod ohci1394 hid rtc_core 
cfg80211 rtc_lib ehci_hcd cdrom ieee1394 ff_memless floppy
Pid: 4348, comm: rpm Not tainted 2.6.25-rc8-mm2_64 #399
RIP: 0010:[<ffffffff80296df7>]  [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
RSP: 0018:ffff81003e95fd98  EFLAGS: 00010206
RAX: fffff0002004c1b0 RBX: ffff81003ea68cc0 RCX: 0000000000000000
RDX: ffff81003ea68cc0 RSI: ffff81003ea68cc0 RDI: ffff81003ea68d28
RBP: ffff81003e95fdc8 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000ee R11: 0000000000000246 R12: ffff81002004c0a0
R13: 0000000000000000 R14: ffffffff80296770 R15: ffff81001c6583e8
FS:  00007f32306556f0(0000) GS:ffffffff80657000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffff0002004c1b0 CR3: 00000000269ab000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process rpm (pid: 4348, threadinfo ffff81003e95e000, task ffff8100245069e0)
Stack:  ffff81007c5d4500 ffff81003ea68cc0 0000000000000000 0000000000000004
  ffff81003e95fe48 0000000000008000 ffff81003e95fde8 ffffffff802970c4
  0000000000000004 0000000000000000 ffff81003e95ff28 ffffffff802a56cb
Call Trace:
  [<ffffffff802970c4>] nameidata_to_filp+0x44/0x60
  [<ffffffff802a56cb>] do_filp_open+0x1eb/0x990
  [<ffffffff802a246c>] ? path_put+0x2c/0x40
  [<ffffffff80296aec>] ? get_unused_fd_flags+0x8c/0x140
  [<ffffffff80296c16>] do_sys_open+0x76/0x110
  [<ffffffff80296cdb>] sys_open+0x1b/0x20
  [<ffffffff8020b88b>] system_call_after_swapgs+0x7b/0x80


Code: 4d 85 f6 0f 84 9b 01 00 00 48 89 de 4c 89 e7 41 ff d6 41 89 c5 85 c0 75 63 
81 63 2c 3f fc ff ff 48 8b 83 b0 00 00 00 48 8d 7b 68 <48> 8b 00 48 8b b0 08 01 
00 00 e8 ea de fd ff f6 43 2d 40 74 1f
RIP  [<ffffffff80296df7>] __dentry_open+0xe7/0x2d0
  RSP <ffff81003e95fd98>
CR2: fffff0002004c1b0





(gdb) l *0xffffffff80296df7
0xffffffff80296df7 is in __dentry_open (/home/l/latest/xxx/fs/open.c:834).
829                             goto cleanup_all;
830             }
831
832             f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
833
834             file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
835
836             /* NB: we're sure to have correct a_ops only after f_op->open */
837             if (f->f_flags & O_DIRECT) {
838                     if (!f->f_mapping->a_ops ||


         .loc 1 834 0
         movq    176(%rbx), %rax # <variable>.f_mapping, <variable>.f_mapping
         leaq    104(%rbx), %rdi #, tmp92
HERE    movq    (%rax), %rax    # <variable>.host, <variable>.host
         movq    264(%rax), %rsi # <variable>.i_mapping, <variable>.i_mapping
         call    file_ra_state_init      #

So it seems like broken (freed) f_mapping. Before that, dmesg is full of
ext3_orphan_cleanup: deleting unreferenced inode 228686
ext3_orphan_cleanup: deleting unreferenced inode 245058
ext3_orphan_cleanup: deleting unreferenced inode 245070
ext3_orphan_cleanup: deleting unreferenced inode 245069
ext3_orphan_cleanup: deleting unreferenced inode 245059
ext3_orphan_cleanup: deleting unreferenced inode 228499
ext3_orphan_cleanup: deleting unreferenced inode 244841
ext3_orphan_cleanup: deleting unreferenced inode 245057
ext3_orphan_cleanup: deleting unreferenced inode 229196
ext3_orphan_cleanup: deleting unreferenced inode 228773
ext3_orphan_cleanup: deleting unreferenced inode 587535
ext3_orphan_cleanup: deleting unreferenced inode 554911
EXT3-fs: md1: 376 orphan inodes deleted


Now I got:
EXT3 Inode ffff81002009cb00: orphan list check failed!
ffff81002009cb00: 000e66cf 000e66d0 00000000 00000000
ffff81002009cb10: 00000000 00000000 00000000 00000000
ffff81002009cb20: 00000000 00000000 00000000 00000000
ffff81002009cb30: 00000000 00000000 00000000 00000000
ffff81002009cb40: 00000000 00000000 0000ffff 00000000
ffff81002009cb50: 0000001c 00000000 00000000 00000000
ffff81002009cb60: 00000000 00000006 f009cb68 ffff8100
ffff81002009cb70: 2009cb68 ffff8100 00002000 00000000
ffff81002009cb80: 148b0000 0000003c 00000001 00000000
ffff81002009cb90: 2009cb90 ffff8100 2009cb90 ffff8100
ffff81002009cba0: 00000000 00000000 00000000 00000000
ffff81002009cbb0: 00100100 00000000 00200200 00000000
ffff81002009cbc0: 2009cbc0 ffff8100 2009cbc0 ffff8100
ffff81002009cbd0: 2009cbd0 ffff8100 2009cbd0 ffff8100
ffff81002009cbe0: 0006ea1b 00000000 00000000 00000001
ffff81002009cbf0: 000001f4 000001f4 00000000 00000000
ffff81002009cc00: 00000001 00000000 00002000 00000000
ffff81002009cc10: 477fcac7 00000000 00000000 00000000
ffff81002009cc20: 477f4c94 00000000 00000000 00000000
ffff81002009cc30: 477f4c94 00000000 00000000 00000000
ffff81002009cc40: 0000000c 00000000 00000010 00000000
ffff81002009cc50: 81b40000 00000000 00000001 00000000
ffff81002009cc60: 2009cc60 ffff8100 2009cc60 ffff8100
ffff81002009cc70: 00000000 00000000 2009cc78 ffff8100
ffff81002009cc80: 2009cc78 ffff8100 8051d920 ffffffff
ffff81002009cc90: 8051d840 ffffffff 7a552400 ffff8100
ffff81002009cca0: 00000000 00000000 2009ccb0 ffff8100
ffff81002009ccb0: 2009cba0 ffff8100 00000000 00000020
ffff81002009ccc0: 00000000 00000000 01000000 00000000
ffff81002009ccd0: 00000000 00000000 00010001 00000000
ffff81002009cce0: 2009cce0 ffff8100 2009cce0 ffff8100
ffff81002009ccf0: 00000000 00000000 00000000 00000000
ffff81002009cd00: 00000000 00000000 8051db40 ffffffff
ffff81002009cd10: 001200d2 00000000 7c504bd8 ffff8100
ffff81002009cd20: 00000000 00000000 2009cd28 ffff8100
ffff81002009cd30: 2009cd28 ffff8100 00000000 00000000
ffff81002009cd40: 2009cd40 ffff8100 2009cd40 ffff8100
ffff81002009cd50: 00000000 00000000 00000000 a68b3ece
ffff81002009cd60: 00000000 00000000 00000000 00000000
ffff81002009cd70: 2009cd70 ffff8100 2009cd70 ffff8100
ffff81002009cd80: 00000001 00000000 2009cd88 ffff8100
ffff81002009cd90: 2009cd88 ffff8100 00000040 00000000
ffff81002009cda0: 00000000 00000000 00000000 00000000
ffff81002009cdb0: 00000000 00000000
Pid: 5579, comm: rrdtool Tainted: G      D   2.6.25-rc8-mm2_64 #399

Call Trace:
  [<ffffffff802fb03c>] ext3_destroy_inode+0x7c/0x80
  [<ffffffff802af11e>] destroy_inode+0x2e/0x60
  [<ffffffff802af7e3>] dispose_list+0xa3/0x120
  [<ffffffff802afaad>] shrink_icache_memory+0x24d/0x2a0
  [<ffffffff80277415>] shrink_slab+0x145/0x1e0
  [<ffffffff80278ed8>] try_to_free_pages+0x248/0x3a0
  [<ffffffff804f60ed>] ? schedule_timeout+0x5d/0xd0
  [<ffffffff80277820>] ? isolate_pages_global+0x0/0x40
  [<ffffffff80272229>] __alloc_pages_internal+0x1e9/0x470
  [<ffffffff802724cb>] __alloc_pages+0xb/0x10
  [<ffffffff802724e8>] get_zeroed_page+0x18/0x60
  [<ffffffff8027c33c>] __pte_alloc+0x2c/0xf0
  [<ffffffff8027fc9d>] handle_mm_fault+0x61d/0x6c0
  [<ffffffff804fa024>] do_page_fault+0x364/0xa30
  [<ffffffff80328fa8>] ? __up_write+0x68/0x140
  [<ffffffff804f7c29>] error_exit+0x0/0x51


Going to fsck.

Few days ago I got this (tainted) version:

BUG: unable to handle kernel paging request at ffff81f02003f16c
IP: [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
PGD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 1
Modules linked in: ppdev parport tun bitrev ipv6 test arc4 ecb crypto_blkcipher 
cryptomgr crypto_algapi ath5k mac80211 crc32 rtc_cmos sr_mod ohci1394 rtc_core 
usbhid rtc_lib ieee1394 cdrom cfg80211 hid usblp ehci_hcd ff_memless floppy 
[last unloaded: vmnet]
Pid: 3710, comm: sensors-applet Tainted: P          2.6.25-rc8-mm2_64 #399
RIP: 0010:[<ffffffff802ad7d5>]  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
RSP: 0018:ffff810057973b98  EFLAGS: 00010246
RAX: 0000000000000017 RBX: ffff81002003f0e0 RCX: 0000000000000017
RDX: 0000000000000017 RSI: ffff81f02003f16c RDI: ffff8100036f7022
RBP: ffff810057973bf8 R08: ffff810057973ca8 R09: 0000000000000000
R10: 00000000000000d8 R11: 0000000000000246 R12: ffff81002003f0c8
R13: 00000000910b9880 R14: ffff810035a5ded8 R15: ffff810057973bc8
FS:  00007f6e2b7266f0(0000) GS:ffff81007d006580(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff81f02003f16c CR3: 000000005788a000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sensors-applet (pid: 3710, threadinfo ffff810057972000, task 
ffff810062ace9e0)
Stack:  ffff810057973ca8 0000000000000017 ffff81002003f0d0 000000176767e000
  ffff8100036f7022 ffffffff8047a695 ffff81002003f0e0 0000000000000001
  ffff810057973e48 ffff810057973e48 ffff810057973ca8 ffff810057973cb8
Call Trace:
  [<ffffffff8047a695>] ? skb_release_data+0x85/0xd0
  [<ffffffff802a2b95>] do_lookup+0x35/0x220
  [<ffffffff802a2fd2>] __link_path_walk+0x252/0x1010
  [<ffffffff8022b4d0>] ? default_wake_function+0x0/0x10
  [<ffffffff802a3dfe>] path_walk+0x6e/0xe0
  [<ffffffff802a40c2>] do_path_lookup+0xa2/0x240
  [<ffffffff802a45c7>] __path_lookup_intent_open+0x67/0xd0
  [<ffffffff802a463c>] path_lookup_open+0xc/0x10
  [<ffffffff802a558a>] do_filp_open+0xaa/0x990
  [<ffffffff80281778>] ? unmap_region+0x138/0x160
  [<ffffffff80296aec>] ? get_unused_fd_flags+0x8c/0x140
  [<ffffffff80296c16>] do_sys_open+0x76/0x110
  [<ffffffff80296cdb>] sys_open+0x1b/0x20
  [<ffffffff8020b88b>] system_call_after_swapgs+0x7b/0x80


Code: 89 e0 48 8b 55 b0 fe 02 eb ae 0f 1f 40 00 8b 45 bc 41 39 44 24 34 75 8d 48 
8b 55 a8 49 8b 74 24 38 48 39 d2 48 8b 7d c0 48 89 d1 <f3> a6 0f 85 72 ff ff ff 
eb bb 90 55 48 89 e5 41 55 49 89 fd 41
RIP  [<ffffffff802ad7d5>] __d_lookup+0x155/0x160
  RSP <ffff810057973b98>
CR2: ffff81f02003f16c
---[ end trace 9c63388ed58b7c09 ]---

Here the qstr->name used in memcmp seems to be freed or somewhat:
         .loc 1 1280 0
         movq    -88(%rbp), %rdx #,
         movq    56(%r12), %rsi  # <variable>.d_name.name, <variable>.d_name.name
         cmpq    %rdx, %rdx      #,
         movq    -64(%rbp), %rdi # str, str
         movq    %rdx, %rcx      #, len
.LVL394:
HERE    repz cmpsb

