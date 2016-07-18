From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Mon, 18 Jul 2016 13:02:56 +1000
Message-ID: <20160718030256.GD1922@dastard>
References: <20160718022356.GC1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39873 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbcGRDDB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2016 23:03:01 -0400
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>)
	id 1bOypc-0003yK-G4
	for linux-ext4@vger.kernel.org; Mon, 18 Jul 2016 13:02:56 +1000
Content-Disposition: inline
In-Reply-To: <20160718022356.GC1922@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2016 at 12:23:56PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Another ext3 foobar on 4.7-rc6. The test VM hung when the rootfs ran
> out of space. mountinfo:
> 
> 16 0 8:1 / / rw,relatime shared:1 - ext3 /dev/root rw,errors=remount-ro,data=ordered
> 
> After reboot, df:
> 
> Filesystem     1K-blocks    Used Available Use% Mounted on
> /dev/root        9696448 9696420         0 100% /
> 
> 
> I then ran:
> 
> $ rm -rf /mnt/scratch
> 
> to cleanup some mess left by xfstests. This returned huge numbers of
> EPERM errors (expected, as files were created by root), but then the
> rm -rf process segfaulted. On the console:
> 
> [   26.275026] ------------[ cut here ]------------
> [   26.275672] kernel BUG at fs/ext4/xattr.c:1331!
> [   26.276231] invalid opcode: 0000 [#1] PREEMPT SMP
> [   26.276820] Modules linked in:
> [   26.277226] CPU: 0 PID: 3127 Comm: rm Not tainted 4.7.0-rc6-dgc+ #839
> [   26.278014] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [   26.279103] task: ffff880336dda3c0 ti: ffff880339740000 task.ti: ffff880339740000
> [   26.280033] RIP: 0010:[<ffffffff81310dfb>]  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/0x60
> [   26.281165] RSP: 0018:ffff880339743cf8  EFLAGS: 00010202
> [   26.281825] RAX: 000000000030000e RBX: ffff88013ab73740 RCX: ffff88013a295f9c
> [   26.282708] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff88013a295fa0
> [   26.283595] RBP: ffff880339743cf8 R08: ffffffffffffffd0 R09: 0000000000001000
> [   26.284466] R10: 000000000000000e R11: ffff88013a295fa0 R12: ffff8800bae366c0
> [   26.285335] R13: 0000000000000000 R14: 000000000000000a R15: ffff880139c895b0
> [   26.286201] FS:  00007f1805169700(0000) GS:ffff88013bc00000(0000) knlGS:0000000000000000
> [   26.287181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   26.287890] CR2: 00007fffedd68f94 CR3: 00000000ba973000 CR4: 00000000000006f0
> [   26.288757] Stack:
> [   26.289015]  ffff880339743de0 ffffffff8131326d 000000000000001c ffff880139c894d8
> [   26.289974]  ffff88013b6a54e0 0000000000000ebc ffff880000c02000 ffff880339743da0
> [   26.290934]  ffff88013a295f00 0000000000000000 000000000000005e ffff88013a295fa0
> [   26.291901] Call Trace:
> [   26.292216]  [<ffffffff8131326d>] ext4_expand_extra_isize_ea+0x3ad/0x810
> [   26.293033]  [<ffffffff812de361>] ? ext4_unlink+0x341/0x380
> [   26.293709]  [<ffffffff812d0e6c>] ext4_mark_inode_dirty+0x1cc/0x230
> [   26.294470]  [<ffffffff812de361>] ext4_unlink+0x341/0x380
> [   26.295126]  [<ffffffff81203211>] vfs_unlink+0xf1/0x180
> [   26.295783]  [<ffffffff81207839>] do_unlinkat+0x259/0x2d0
> [   26.296442]  [<ffffffff812082ab>] SyS_unlinkat+0x1b/0x30
> [   26.297096]  [<ffffffff81e3cc72>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [   26.297876] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 e8 4e 00 5d c3 <0f> 0b 0f 1f 00
> [   26.301236] RIP  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/0x60
> [   26.302068]  RSP <ffff880339743cf8>
> [   26.302562] ---[ end trace cc18c7e6935b8a49 ]---
> 
> Filesystem checked clean the during boot before it was ENOSPCed.
> Didn't check on reboot before this happened. After another reboot:
> 
> # e2fsck -f /dev/sda1
> e2fsck 1.43-WIP (18-May-2015)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sda1: 293892/624624 files (3.0% non-contiguous), 2496091/2496091 blocks
> #
> 
> Filesystem claims it is clean, but it's still at ENOSPC.

Filesystem clean, no longer at enospc (1.7GB free), still see this
problem. narrowed it down to this set of files:

# ls -l /mnt/scratch
total 64
-rw-r--r-- 1 root root 45056 Nov 10  2015 fsr_test_file.27768.14.10
-rw-r--r-- 1 root root 49152 Nov 10  2015 fsr_test_file.27768.14.11
-rw-r--r-- 1 root root 53248 Nov 10  2015 fsr_test_file.27768.14.12
-rw-r--r-- 1 root root 57344 Nov 10  2015 fsr_test_file.27768.14.13
-rw-r--r-- 1 root root 61440 Nov 10  2015 fsr_test_file.27768.14.14
-rw-r--r-- 1 root root 65536 Nov 10  2015 fsr_test_file.27768.14.15
-rw-r--r-- 1 root root 69632 Nov 10  2015 fsr_test_file.27768.14.16
-rw-r--r-- 1 root root 73728 Nov 10  2015 fsr_test_file.27768.14.17
-rw-r--r-- 1 root root 77824 Nov 10  2015 fsr_test_file.27768.14.18
-rw-r--r-- 1 root root 81920 Nov 10  2015 fsr_test_file.27768.14.19
-rw-r--r-- 1 root root 86016 Nov 10  2015 fsr_test_file.27768.14.20
-rw-r--r-- 1 root root 24576 Nov 10  2015 fsr_test_file.27768.14.5
-rw-r--r-- 1 root root 28672 Nov 10  2015 fsr_test_file.27768.14.6
-rw-r--r-- 1 root root 32768 Nov 10  2015 fsr_test_file.27768.14.7
-rw-r--r-- 1 root root 36864 Nov 10  2015 fsr_test_file.27768.14.8
-rw-r--r-- 1 root root 40960 Nov 10  2015 fsr_test_file.27768.14.9
# rm -rf /mnt/scratch/fsr_test_file.27768.14.5
[  399.018116] ------------[ cut here ]------------
[  399.018916] kernel BUG at fs/ext4/xattr.c:1331!
[  399.019567] invalid opcode: 0000 [#1] PREEMPT SMP
[  399.020259] Modules linked in:
[  399.020723] CPU: 12 PID: 5007 Comm: rm Not tainted 4.7.0-rc6-dgc+ #839
[  399.021660] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[  399.022901] task: ffff88033aa28000 ti: ffff88033a90c000 task.ti: ffff88033a90c000
[  399.023967] RIP: 0010:[<ffffffff81310dfb>]  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/0x60
[  399.025248] RSP: 0018:ffff88033a90fcf8  EFLAGS: 00010202
[  399.025937] RAX: 000000000030000e RBX: ffff88013aa13500 RCX: ffff88033764319c
[  399.026878] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff8803376431a0
[  399.027807] RBP: ffff88033a90fcf8 R08: ffffffffffffffd0 R09: 0000000000001000
[  399.028750] R10: 000000000000000e R11: ffff8803376431a0 R12: ffff88023b7a25a0
[  399.029693] R13: 0000000000000000 R14: 000000000000000a R15: ffff88013b54ce10
[  399.030617] FS:  00007f741d174700(0000) GS:ffff88013bd80000(0000) knlGS:0000000000000000
[  399.031713] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  399.032485] CR2: 00000000006111c8 CR3: 000000013ab14000 CR4: 00000000000006e0
[  399.033431] Stack:
[  399.033700]  ffff88033a90fde0 ffffffff8131326d 000000000000001c ffff88013b54cd38
[  399.034750]  ffff8800b99541a0 0000000000000f04 ffff8800bb6e2000 ffff88033a90fda0
[  399.035791]  ffff880337643100 0000000000000000 000000000000005e ffff8803376431a0
[  399.036853] Call Trace:
[  399.037197]  [<ffffffff8131326d>] ext4_expand_extra_isize_ea+0x3ad/0x810
[  399.038091]  [<ffffffff812de361>] ? ext4_unlink+0x341/0x380
[  399.038836]  [<ffffffff812d0e6c>] ext4_mark_inode_dirty+0x1cc/0x230
[  399.039674]  [<ffffffff812de361>] ext4_unlink+0x341/0x380
[  399.040477]  [<ffffffff81203211>] vfs_unlink+0xf1/0x180
[  399.041263]  [<ffffffff81207839>] do_unlinkat+0x259/0x2d0
[  399.042079]  [<ffffffff812082ab>] SyS_unlinkat+0x1b/0x30
[  399.042837]  [<ffffffff81e3cc72>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  399.043698] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 e8 4e 00 5d c3 <0f> 0b 0f 1f 00
[  399.047385] RIP  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/0x60
[  399.048272]  RSP <ffff88033a90fcf8>
[  399.048772] ---[ end trace 1b8726b74fc862c0 ]---
Segmentation fault
#

So, what are those files? They are created by an xfs_fsr
defragmentation test that exercises different data and attribute
extent fork sizes - xfs/227 to be precise. An XFS change I was
testing caused the scratch filesystem to fail to mount (due to an
oops on unmount on a prior test), so it created the files on the
filesystem underlying the scratch mount point(*).

The "14.N" in the file name tells us that there are 14 "2 byte
attributes" created on the file, and N is the number of data extents
on the file. It would appear that creating 14x2 byte attributes and
5 or more data extents causes a corner case problem with ext3 that
isn't realised until the we attempt to unlink the files. I can't
remove any of the above files without triggering the BUG.

# getfattr -d -e hex /mnt/scratch/fsr_test_file.27768.14.6
getfattr: Removing leading '/' from absolute path names
# file: mnt/scratch/fsr_test_file.27768.14.6
user.0=0xbabe
user.1=0xbabe
user.10=0xbabe
user.11=0xbabe
user.12=0xbabe
user.13=0xbabe
user.14=0xbabe
user.2=0xbabe
user.3=0xbabe
user.4=0xbabe
user.5=0xbabe
user.6=0xbabe
user.7=0xbabe
user.8=0xbabe
user.9=0xbabe

#
# setfattr -x user.0 /mnt/scratch/fsr_test_file.27768.14.6
# getfattr -d -e hex /mnt/scratch/fsr_test_file.27768.14.6
getfattr: Removing leading '/' from absolute path names
# file: mnt/scratch/fsr_test_file.27768.14.6
user.1=0xbabe
user.10=0xbabe
user.11=0xbabe
user.12=0xbabe
user.13=0xbabe
user.14=0xbabe
user.2=0xbabe
user.3=0xbabe
user.4=0xbabe
user.5=0xbabe
user.6=0xbabe
user.7=0xbabe
user.8=0xbabe
user.9=0xbabe

# rm !$
rm /mnt/scratch/fsr_test_file.27768.14.6
#

And, by removing an attribute, I can successfully remove the file.
So this definitely looks like a corner case xattr handling issue in
ext3/4.

Cheers,

Dave.

(*) This is a prime example of why xfstests should not stop running tests when
it fails to mount a scratch filesystem. I'd have never hit this
problem if we prevented xfs/227 from running because something else
had already gone wrong....

-- 
Dave Chinner
david@fromorbit.com
