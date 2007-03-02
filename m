From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 2.6.21-rc2-mm1: EIP is at ext2_discard_reservation+0x1c/0x52
Date: Fri, 2 Mar 2007 17:05:52 +0300
Message-ID: <20070302140552.GA5545@martell.zuzino.mipt.ru>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:62242 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992457AbXCBOFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 09:05:45 -0500
Received: by ug-out-1314.google.com with SMTP id 44so703971uga
        for <linux-ext4@vger.kernel.org>; Fri, 02 Mar 2007 06:05:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

BUG: unable to handle kernel paging request at virtual address 5a5a5a72
 printing eip:
c01b09fd
*pde = 00000000
Oops: 0000 [#1]
PREEMPT DEBUG_PAGEALLOC
last sysfs file: devices/pci0000:00/0000:00:1d.3/usb5/5-0:1.0/bInterfaceProtocol
CPU:    0
EIP:    0060:[<c01b09fd>]    Not tainted VLI
EFLAGS: 00010206   (2.6.21-rc2-mm1 #1)
EIP is at ext2_discard_reservation+0x1c/0x52
eax: dec2bdf8   ebx: 5a5a5a5a   ecx: d8f14000   edx: c01b4fe4
esi: d70c6ddc   edi: 5a5a5a6e   ebp: 00000000   esp: d8f15dc8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ccache (pid: 6406, ti=d8f14000 task=ccaef5b0 task.ti=d8f14000)
Stack: d70c6d0c 5a5a5a5a 00000044 00000000 c01b4ff4 d70c6ddc d70c6fdc c015b69d
       00000000 d70c6ddc deddabf8 c015b8c6 d70c6ddc 00000000 c015aede ffffffe4
       c01b27c8 c01f75c4 00000246 c03b5f80 c03b5f80 df90e758 c01599a0 c045cfe8
Call Trace:
 [<c01b4ff4>] ext2_clear_inode+0x10/0x27
 [<c015b69d>] clear_inode+0x8f/0xdd
 [<c015b8c6>] generic_drop_inode+0x115/0x125
 [<c015aede>] iput+0x60/0x62
 [<c01b27c8>] ext2_new_inode+0x8fd/0x941
 [<c01f75c4>] _atomic_dec_and_lock+0x10/0x44
 [<c01599a0>] __d_lookup+0x6a/0x10a
 [<c01599a0>] __d_lookup+0x6a/0x10a
 [<c030726b>] _spin_unlock+0x25/0x3b
 [<c0159a23>] __d_lookup+0xed/0x10a
 [<c01b45ec>] ext2_create+0xc/0x95
 [<c01b45e0>] ext2_create+0x0/0x95
 [<c0151f14>] vfs_create+0x5f/0x6c
 [<c0154282>] open_namei+0x177/0x555
 [<c014ac56>] do_filp_open+0x25/0x39
 [<c030726b>] _spin_unlock+0x25/0x3b
 [<c014aa62>] get_unused_fd+0xaa/0xb4
 [<c014aca4>] do_sys_open+0x3a/0x6b
 [<c014ad0e>] sys_open+0x1c/0x1e
 [<c0102586>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 00 00 c7 42 20 00 00 00 00 89 56 88 5b 5e c3 55 57 56 53 89 c6 8b 58 88 8b 80 24 01 00 00 8b 80 98 02 00 00 85 db 74 34 8d 7b 14 <83> 7f 04 00 74 2b 8d a8 c8 00 00 00 89 e8 e8 b6 63 15 00 83 7f
EIP: [<c01b09fd>] ext2_discard_reservation+0x1c/0x52 SS:ESP 0068:d8f15dc8
------------------------------------------------------------------

This happened after following build script which
a) blows old build dirs and old cloned kernel
b) clones kernel to ext2 partition from reiserfs partition
c) starts build with help of .ccache also on ext2 partition
   it is mostly filled:
   /dev/hda4   8649576   7438480    771720  91% /home/ad/.ccache
d) make hangs somewhere after CC init/main.o


/dev/sda1	/home/linux		ext2     defaults,noatime 0 0
/dev/hda4	/home/ad/.ccache	ext2     defaults,noatime 0 0
------------------------------------------------------------------
#!/bin/sh -x

cd /home/linux
rm -rf logs build linux-irq-flags-t
git clone -s ~/linux/linux-linus linux-irq-flags-t
cd linux-irq-flags-t
patch -p1 <../akmk.patch        || exit 1
find . -type f -name '*.orig' | xargs rm -f
git commit -a -m 'akmk.patch'   || exit 1

make tags &

mkdir ../logs ../build

TARGET=i386-allnoconfig
mkdir ../build/$TARGET
make O=../build/$TARGET allnoconfig >/dev/null
akmk $TARGET -k 2>&1 | tee ../logs/$TARGET-000.log
