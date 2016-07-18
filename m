From: Dave Chinner <david@fromorbit.com>
Subject: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Mon, 18 Jul 2016 12:23:56 +1000
Message-ID: <20160718022356.GC1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7270 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbcGRCYB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2016 22:24:01 -0400
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>)
	id 1bOyDs-0003uW-DC
	for linux-ext4@vger.kernel.org; Mon, 18 Jul 2016 12:23:56 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

Another ext3 foobar on 4.7-rc6. The test VM hung when the rootfs ran
out of space. mountinfo:

16 0 8:1 / / rw,relatime shared:1 - ext3 /dev/root rw,errors=3Dremount-=
ro,data=3Dordered

After reboot, df:

=46ilesystem     1K-blocks    Used Available Use% Mounted on
/dev/root        9696448 9696420         0 100% /


I then ran:

$ rm -rf /mnt/scratch

to cleanup some mess left by xfstests. This returned huge numbers of
EPERM errors (expected, as files were created by root), but then the
rm -rf process segfaulted. On the console:

[   26.275026] ------------[ cut here ]------------
[   26.275672] kernel BUG at fs/ext4/xattr.c:1331!
[   26.276231] invalid opcode: 0000 [#1] PREEMPT SMP
[   26.276820] Modules linked in:
[   26.277226] CPU: 0 PID: 3127 Comm: rm Not tainted 4.7.0-rc6-dgc+ #83=
9
[   26.278014] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS Debian-1.8.2-1 04/01/2014
[   26.279103] task: ffff880336dda3c0 ti: ffff880339740000 task.ti: fff=
f880339740000
[   26.280033] RIP: 0010:[<ffffffff81310dfb>]  [<ffffffff81310dfb>] ext=
4_xattr_shift_entries+0x5b/0x60
[   26.281165] RSP: 0018:ffff880339743cf8  EFLAGS: 00010202
[   26.281825] RAX: 000000000030000e RBX: ffff88013ab73740 RCX: ffff880=
13a295f9c
[   26.282708] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff880=
13a295fa0
[   26.283595] RBP: ffff880339743cf8 R08: ffffffffffffffd0 R09: 0000000=
000001000
[   26.284466] R10: 000000000000000e R11: ffff88013a295fa0 R12: ffff880=
0bae366c0
[   26.285335] R13: 0000000000000000 R14: 000000000000000a R15: ffff880=
139c895b0
[   26.286201] FS:  00007f1805169700(0000) GS:ffff88013bc00000(0000) kn=
lGS:0000000000000000
[   26.287181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.287890] CR2: 00007fffedd68f94 CR3: 00000000ba973000 CR4: 0000000=
0000006f0
[   26.288757] Stack:
[   26.289015]  ffff880339743de0 ffffffff8131326d 000000000000001c ffff=
880139c894d8
[   26.289974]  ffff88013b6a54e0 0000000000000ebc ffff880000c02000 ffff=
880339743da0
[   26.290934]  ffff88013a295f00 0000000000000000 000000000000005e ffff=
88013a295fa0
[   26.291901] Call Trace:
[   26.292216]  [<ffffffff8131326d>] ext4_expand_extra_isize_ea+0x3ad/0=
x810
[   26.293033]  [<ffffffff812de361>] ? ext4_unlink+0x341/0x380
[   26.293709]  [<ffffffff812d0e6c>] ext4_mark_inode_dirty+0x1cc/0x230
[   26.294470]  [<ffffffff812de361>] ext4_unlink+0x341/0x380
[   26.295126]  [<ffffffff81203211>] vfs_unlink+0xf1/0x180
[   26.295783]  [<ffffffff81207839>] do_unlinkat+0x259/0x2d0
[   26.296442]  [<ffffffff812082ab>] SyS_unlinkat+0x1b/0x30
[   26.297096]  [<ffffffff81e3cc72>] entry_SYSCALL_64_fastpath+0x1a/0xa=
4
[   26.297876] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0=
 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 e8 4e 0=
0 5d c3 <0f> 0b 0f 1f 00
[   26.301236] RIP  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/=
0x60
[   26.302068]  RSP <ffff880339743cf8>
[   26.302562] ---[ end trace cc18c7e6935b8a49 ]---

=46ilesystem checked clean the during boot before it was ENOSPCed.
Didn't check on reboot before this happened. After another reboot:

# e2fsck -f /dev/sda1
e2fsck 1.43-WIP (18-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sda1: 293892/624624 files (3.0% non-contiguous), 2496091/2496091 b=
locks
#

=46ilesystem claims it is clean, but it's still at ENOSPC.

remount as rw, as user run:

dave@test4:~$ rm -rf /mnt/scratch
rm: cannot remove =BF=BF/mnt/scratch/dir5/fname1=BF=BF: Permission deni=
ed
rm: cannot remove =BF=BF/mnt/scratch/dir5/sd2=BF=BF: Permission denied
rm: cannot remove =BF=BF/mnt/scratch/dir5/ed2=BF=BF: Permission denied
=2E....
[  182.524593] ------------[ cut here ]------------
[  182.525295] kernel BUG at fs/ext4/xattr.c:1331!
[  182.525906] invalid opcode: 0000 [#1] PREEMPT SMP
[  182.526655] Modules linked in:
[  182.527132] CPU: 0 PID: 4001 Comm: rm Not tainted 4.7.0-rc6-dgc+ #83=
9
[  182.528031] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS Debian-1.8.2-1 04/01/2014
[  182.529174] task: ffff88013a990000 ti: ffff880338f30000 task.ti: fff=
f880338f30000
[  182.530278] RIP: 0010:[<ffffffff81310dfb>]  [<ffffffff81310dfb>] ext=
4_xattr_shift_entries+0x5b/0x60
[  182.531615] RSP: 0018:ffff880338f33cf8  EFLAGS: 00010202
[  182.532313] RAX: 000000000030000e RBX: ffff8800baf43640 RCX: ffff880=
33060cb9c
[  182.533379] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff880=
33060cba0
[  182.534317] RBP: ffff880338f33cf8 R08: ffffffffffffffd0 R09: 0000000=
000001000
[  182.535377] R10: 000000000000000e R11: ffff88033060cba0 R12: ffff880=
13a804000
[  182.536297] R13: 0000000000000000 R14: 000000000000000a R15: ffff880=
327109ad0
[  182.537348] FS:  00007f7513549700(0000) GS:ffff88013bc00000(0000) kn=
lGS:0000000000000000
[  182.538397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  182.539286] CR2: 0000000000638088 CR3: 00000000bb216000 CR4: 0000000=
0000006f0
[  182.540208] Stack:
[  182.540617]  ffff880338f33de0 ffffffff8131326d 000000000000001c ffff=
8803271099f8
[  182.541943]  ffff8800bb6af9c0 0000000000000ebc ffff8800bb665000 ffff=
880338f33da0
[  182.543317]  ffff88033060cb00 0000000000000000 000000000000005e ffff=
88033060cba0
[  182.544611] Call Trace:
[  182.545008]  [<ffffffff8131326d>] ext4_expand_extra_isize_ea+0x3ad/0=
x810
[  182.546016]  [<ffffffff812de361>] ? ext4_unlink+0x341/0x380
[  182.546750]  [<ffffffff812d0e6c>] ext4_mark_inode_dirty+0x1cc/0x230
[  182.547699]  [<ffffffff812de361>] ext4_unlink+0x341/0x380
[  182.548426]  [<ffffffff81203211>] vfs_unlink+0xf1/0x180
[  182.549249]  [<ffffffff81207839>] do_unlinkat+0x259/0x2d0
[  182.549970]  [<ffffffff812082ab>] SyS_unlinkat+0x1b/0x30
[  182.550815]  [<ffffffff81e3cc72>] entry_SYSCALL_64_fastpath+0x1a/0xa=
4
[  182.551663] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0=
 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 e8 4e 0=
0 5d c3 <0f> 0b 0f 1f 00 =20
[  182.557820] RIP  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/=
0x60
[  182.558849]  RSP <ffff880338f33cf8>
[  182.559476] ---[ end trace 84ae2f59660ff3c6 ]---

Not sure why it is trying to expand EA space in the inode on unlink,
but that's what it's trying to do and it's bugging out on it.

So, by pure chance, the third file I manually tried to remove:

$ ls -l /mnt/scratch/aligned_vector_rw
-rw-------  1 root  root    104857600 Jul 18 11:08 aligned_vector_rw
$ sudo rm /mnt/scratch/aligned_vector_rw
[  192.407586] ------------[ cut here ]------------
[  192.408765] kernel BUG at fs/ext4/xattr.c:1331!
[  192.409949] invalid opcode: 0000 [#1] PREEMPT SMP
[  192.410976] Modules linked in:
[  192.411691] CPU: 0 PID: 4521 Comm: rm Not tainted 4.7.0-rc6-dgc+ #83=
9
[  192.413083] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS Debian-1.8.2-1 04/01/2014
[  192.415011] task: ffff88023aa04780 ti: ffff880238cd4000 task.ti: fff=
f880238cd4000
[  192.416624] RIP: 0010:[<ffffffff81310dfb>]  [<ffffffff81310dfb>] ext=
4_xattr_shift_entries+0x5b/0x60
[  192.418599] RSP: 0018:ffff880238cd7cf8  EFLAGS: 00010202
[  192.419676] RAX: 000000000030000e RBX: ffff88013aa27e40 RCX: ffff880=
2391dbf9c
[  192.421042] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff880=
2391dbfa0
[  192.422386] RBP: ffff880238cd7cf8 R08: ffffffffffffffd0 R09: 0000000=
000001000
[  192.423724] R10: 000000000000000e R11: ffff8802391dbfa0 R12: ffff880=
23b803b40
[  192.425058] R13: 0000000000000000 R14: 000000000000000a R15: ffff880=
239672a30
[  192.426407] FS:  00007fa04a4f5700(0000) GS:ffff88013bc00000(0000) kn=
lGS:0000000000000000
[  192.427915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  192.428933] CR2: 00000000006120a8 CR3: 00000000bb2a6000 CR4: 0000000=
0000006f0
[  192.430219] Stack:
[  192.430591]  ffff880238cd7de0 ffffffff8131326d 000000000000001c ffff=
880239672958
[  192.431975]  ffff88023b25f7b8 0000000000000ebc ffff8800bb5dd000 ffff=
880238cd7da0
[  192.433370]  ffff8802391dbf00 0000000000000000 000000000000005e ffff=
8802391dbfa0
[  192.434726] Call Trace:
[  192.435152]  [<ffffffff8131326d>] ext4_expand_extra_isize_ea+0x3ad/0=
x810
[  192.436246]  [<ffffffff812de361>] ? ext4_unlink+0x341/0x380
[  192.437120]  [<ffffffff812d0e6c>] ext4_mark_inode_dirty+0x1cc/0x230
[  192.438113]  [<ffffffff812de361>] ext4_unlink+0x341/0x380
[  192.438961]  [<ffffffff81203211>] vfs_unlink+0xf1/0x180
[  192.439783]  [<ffffffff81207839>] do_unlinkat+0x259/0x2d0
[  192.440632]  [<ffffffff812082ab>] SyS_unlinkat+0x1b/0x30
[  192.441469]  [<ffffffff81e3cc72>] entry_SYSCALL_64_fastpath+0x1a/0xa=
4
[  192.442489] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0=
 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 e8 4e 0=
0 5d c3 <0f> 0b 0f 1f 00
[  192.446750] RIP  [<ffffffff81310dfb>] ext4_xattr_shift_entries+0x5b/=
0x60
[  192.447760]  RSP <ffff880238cd7cf8>
[  192.448330] ---[ end trace 4c5fd2f472bea26f ]---

So I rebooted again, and immediately ran:

# rm /mnt/scratch/aligned_vector_rw

And it succeeded without oopsing. Yay? Then I tried again as root
to run 'rm /mnt/scratch/*' and it oopsed on some other file....

-Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
