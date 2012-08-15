From: Marti Raudsepp <marti@juffo.org>
Subject: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Wed, 15 Aug 2012 21:33:29 +0300
Message-ID: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi list,

I was moving and deleting some files between two of my ext4 partitions
when it suddenly crashed and dropped me into an kernel oops screen
(below). I'm using ext4 on kernel 3.5.1 (Arch Linux). Both likely
suspect file systems are stored on LVM2, mounted with
data=writeback,errors=remount-ro,noatime

EXT4-fs (sda3): mounted filesystem with writeback data mode. Opts: (null)
EXT4-fs (dm-1): mounted filesystem with writeback data mode. Opts:
errors=remount-ro
EXT4-fs (dm-0): mounted filesystem with writeback data mode. Opts:
errors=remount-ro

I can't be bothered to transcribe all those 64-bit pointer values, but
here's the human-readable parts (screen shot links below):

BUG: unable to handle kernel NULL pointer dereference at 000...00028
IP: [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]
PGD ... PUD ... PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 2
Modules linked in: [... bazillion modules ...]

Pid: 3687, comm: rm Tainted: G    C    3.5.1-1-ARCH #1 System
manufacturer System Product Name/M3A76-CM
RIP: 0010:[...] [...] ext4_ext_remove_space
[... CPU register dump ...]
Process rm (pid: 3687, threadinfo ..., task ...)
Call Trace:
 [...] ext4_ext_truncate+0x183/0x1c0 [ext]
 [...] ? ext4_mark_inode_dirty+0x7e/0x230 [ext4]
 [...] ext4_truncate+0x135/0x140 [ext4]
 [...] ext4_evict_inode+0x40f/0x4e0 [ext4]
 [...] evict+0xb8/0x1b0
 [...] iput+0x105/0x210
 [...] do_unlinkat+0x1b/0x50
 [...] ? flip_close+0x66/0xa0
 [...] sys_unlinkat+0x1b/0x50
 [...] system_call_fastpath+0x16/0x1b
Code: [...]
RIP [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]
CR2: 000...00028

Taint flag C is caused by the staging r8712u driver (Realtek USB Wi-Fi
adapter). But I wasn't even using it today, so I doubt that had
anything to do with it.

Some "screen shots" taken with a webcam (warning: CSI "zoom & enhance"
technology required)
http://ompldr.org/vZjQ3dw
http://ompldr.org/vZjQ3eg
http://ompldr.org/vZjQ4MA
http://ompldr.org/vZjQ3eQ
http://ompldr.org/vZjQ3eA

Regards,
Marti
