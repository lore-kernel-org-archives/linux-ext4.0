From: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: Re: ext3 warnings from LTP rename14
Date: Sun, 21 Oct 2007 14:21:50 +0100
Message-ID: <20071021132150.GA14381@palantir8>
References: <20071017002009.GA2966@palantir8> <4715637B.1090503@redhat.com> <471570CB.3030709@redhat.com> <20071018060850.GN8122@schatzie.adilger.int> <47177116.5070705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from earth.karoo.kcom.com ([212.50.160.55]:38401 "EHLO
	earth.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXJUNV4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 09:21:56 -0400
Received: from mhabets by palantir8.mph.eclipse.net with local (Exim 3.36 #1 (Debian))
	id 1IjakZ-0003l0-00
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 14:21:51 +0100
Content-Disposition: inline
In-Reply-To: <47177116.5070705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I had a chance to try this on 2.6.23 today. The output from
rename14 was:

rename14    1  PASS  :  Test Passed
rename14    0  WARN  :  tst_rmdir(): rmobj(/tmp/renD0iZU9) failed: lstat(/tmp/renD0iZU9/rename14) failed; errno=2: No such file or directory

with these messages on the console:

EXT3-fs warning (device sdb4): ext3_rename: Deleting old file (162881), 2, error=-2
EXT3-fs warning (device sdb4): ext3_rename: Deleting old file (162881), 2, error=-2
EXT3-fs warning (device sdb4): ext3_rename: Deleting old file (162881), 2, error=-2
EXT3-fs warning (device sdb4): ext3_rename: Deleting old file (162881), 2, error=-2
EXT3-fs warning (device sdb4): ext3_unlink: Deleting nonexistent file (162885), 0

After this, umount /tmp resulted in the output below.
The filesystem shows up in mount, but another umount says it's not
mounted. After a hard reboot the fsck gives the following:

/dev/sdb4: Truncating orphaned inode 162884 (uid=1001, gid=1001, mode=0100644, size=0)
/dev/sdb4: Truncating orphaned inode 162882 (uid=1001, gid=1001, mode=0100644, size=0)
/dev/sdb4: Truncating orphaned inode 162883 (uid=1001, gid=1001, mode=0100644, size=0)
/dev/sdb4: Superblock last write time is in the future.  FIXED.
/dev/sdb4: clean, 19/488640 files, 69643/976600 blocks

The filesystem is okay again after this.

I am not able to interpret the output below. Does it give any clues as
to the cause of the problem, given that it is probably an endian issue?

The other bit of info I have is that 2.6.21 works okay. Did not have a
chance yet to bisect this further.

Martin

---
palantir9:~# umount /tmp
EXT3 Inode f10f18f0: orphan list check failed!
f10f18f0: 00000000 00000000 00000000 00000000 
f10f1900: 00000000 00000000 00000000 00000000 
f10f1910: 00000000 00000000 00000000 00000000 
f10f1920: 00000000 00000000 00000000 00000000 
f10f1930: 00000000 00000000 00000000 00000028 
f10f1940: 00000000 00000000 00000000 f0e8df0c 
f10f1950: f10f179c 00000000 00000000 00000000 
f10f1960: 00000000 00000001 00000000 f10f196c 
f10f1970: f10f196c 00000000 00000000 00000000 
f10f1980: 00100100 00200200 f10f1988 f10f1988 
f10f1990: f10f1990 f10f1990 00027c43 00000000 
f10f19a0: ffffffff 000003e9 000003e9 00000000 
f10f19b0: 00000001 00000000 00000000 00000000 
f10f19c0: 00000000 471b498a 00000000 471b498a 
f10f19d0: 00000000 471b498b 00000000 0000000a 
f10f19e0: 00000000 000081a4 00000000 00000001 
f10f19f0: 00000000 f10f19f4 f10f19f4 00000000 
f10f1a00: 00000000 f10f1a04 f10f1a04 f01a0674 
f10f1a10: f01a06cc f0e97200 00000000 f10f1a20 
f10f1a20: f10f1978 00000000 00000020 00000000 
f10f1a30: 00000000 00000000 00000000 00010001 
f10f1a40: f10f1a40 f10f1a40 00000000 00000000 
f10f1a50: 00000000 00000000 f01a0800 001200d2 
f10f1a60: f0d8fc6c 00000000 f10f1a68 f10f1a68 
f10f1a70: 00000000 f10f1a74 f10f1a74 00000000 
f10f1a80: 00000000 7588799e 00000040 00000000 
f10f1a90: 00000000 00000000 00000000 00000000 
[f0096b78 : dispose_list+0xc8/0x110 ] [f0096cb8 : invalidate_inodes+0xf8/0x108 ] [f008302c : generic_shutd
own_super+0xa8/0x134 ] [f0083dcc : kill_block_super+0x10/0x24 ] [f0082e7c : deactivate_super+0x50/0x6c ] [
f0099f9c : sys_umount+0x40/0x238 ] [f001541c : syscall_is_too_hard+0x3c/0x40 ] [00012438 : 0x12440 ] 
EXT3 Inode f10f1740: orphan list check failed!
f10f1740: 00000000 00000000 00000000 00000000 
f10f1750: 00000000 00000000 00000000 00000000 
f10f1760: 00000000 00000000 00000000 00000000 
f10f1770: 00000000 00000000 00000000 00000000 
f10f1780: 00000000 00000000 00027c43 00000028 
f10f1790: 00000000 00000000 00000000 f10f194c 
f10f17a0: f10f15ec 00000000 00000000 00000000 
f10f17b0: 00000000 00000001 00000000 f10f17bc 
f10f17c0: f10f17bc 00000000 00000000 00000000 
f10f17d0: 00100100 00200200 f10f17d8 f10f17d8 
f10f17e0: f10f17e0 f10f17e0 00027c42 00000000 
f10f17f0: ffffffff 000003e9 000003e9 00000000 
f10f1800: 00000001 00000000 00000000 00000000 
f10f1810: 00000000 471b498b 00000000 471b498b 
f10f1820: 00000000 471b498b 00000000 0000000a 
f10f1830: 00000000 000081a4 00000000 00000001 
f10f1840: 00000000 f10f1844 f10f1844 00000000 
f10f1850: 00000000 f10f1854 f10f1854 f01a0674 
f10f1860: f01a06cc f0e97200 00000000 f10f1870 
f10f1870: f10f17c8 00000000 00000020 00000000 
f10f1880: 00000000 00000000 00000000 00010001 
f10f1890: f10f1890 f10f1890 00000000 00000000 
f10f18a0: 00000000 00000000 f01a0800 001200d2 
f10f18b0: f0d8fc6c 00000000 f10f18b8 f10f18b8 
f10f18c0: 00000000 f10f18c4 f10f18c4 00000000 
f10f18d0: 00000000 758879a0 00000040 00000000 
f10f18e0: 00000000 00000000 00000000 00000000 
[f0096b78 : dispose_list+0xc8/0x110 ] [f0096cb8 : invalidate_inodes+0xf8/0x108 ] [f008302c : generic_shutd
own_super+0xa8/0x134 ] [f0083dcc : kill_block_super+0x10/0x24 ] [f0082e7c : deactivate_super+0x50/0x6c ] [
f0099f9c : sys_umount+0x40/0x238 ] [f001541c : syscall_is_too_hard+0x3c/0x40 ] [00012438 : 0x12440 ] 
EXT3 Inode f10f1590: orphan list check failed!
f10f1590: 00000000 00000000 00000000 00000000 
f10f15a0: 00000000 00000000 00000000 00000000 
f10f15b0: 00000000 00000000 00000000 00000000 
f10f15c0: 00000000 00000000 00000000 00000000 
f10f15d0: 00000000 00000000 00027c42 00000028 
f10f15e0: 00000000 00000000 00000000 f10f179c 
f10f15f0: f0e8df0c 00000000 00000000 00000000 
f10f1600: 00000000 00000001 00000000 f10f160c 
f10f1610: f10f160c 00000000 00000000 00000000 
f10f1620: 00100100 00200200 f10f1628 f10f1628 
f10f1630: f10f1630 f10f1630 00027c44 00000000 
f10f1640: ffffffff 000003e9 000003e9 00000000 
f10f1650: 00000001 00000000 00000000 00000000 
f10f1660: 00000000 471b498b 00000000 471b498b 
f10f1670: 00000000 471b498b 00000000 0000000a 
f10f1680: 00000000 000081a4 00000000 00000001 
f10f1690: 00000000 f10f1694 f10f1694 00000000 
f10f16a0: 00000000 f10f16a4 f10f16a4 f01a0674 
f10f16b0: f01a06cc f0e97200 00000000 f10f16c0 
f10f16c0: f10f1618 00000000 00000020 00000000 
f10f16d0: 00000000 00000000 00000000 00010001 
f10f16e0: f10f16e0 f10f16e0 00000000 00000000 
f10f16f0: 00000000 00000000 f01a0800 001200d2 
f10f1700: f0d8fc6c 00000000 f10f1708 f10f1708 
f10f1710: 00000000 f10f1714 f10f1714 00000000 
f10f1720: 00000000 758879a4 00000040 00000000 
f10f1730: 00000000 00000000 00000000 00000000 
[f0096b78 : dispose_list+0xc8/0x110 ] [f0096cb8 : invalidate_inodes+0xf8/0x108 ] [f008302c : generic_shutd
own_super+0xa8/0x134 ] [f0083dcc : kill_block_super+0x10/0x24 ] [f0082e7c : deactivate_super+0x50/0x6c ] [
f0099f9c : sys_umount+0x40/0x238 ] [f001541c : syscall_is_too_hard+0x3c/0x40 ] [00012438 : 0x12440 ] 
sb orphan head is 162884
sb_info orphan list:
  inode sdb4:162884 at f10f1618: mode 100644, nlink -1, next 162882
  inode sdb4:162882 at f10f17c8: mode 100644, nlink -1, next 162883
  inode sdb4:162883 at f10f1978: mode 100644, nlink -1, next 0
Assertion failure in ext3_put_super() at fs/ext3/super.c:423: "list_empty(&sbi->s_orphan)"
kernel BUG at fs/ext3/super.c:423!
              \|/ ____ \|/
              "@'/ ,. \`@"
              /_| \__/ |_\
                 \__U_/
umount(769): Kernel bad trap [#1]
PSR: 1e4000c3 PC: f00d0b80 NPC: f00d0b84 Y: 00000000    Not tainted
PC: <ext3_put_super+0x138/0x224>
%G: 000001a7 1e4000e2  f01f5084 f01f5080  f00368f0 f010e97c  f0f7c000 00000100
%O: 00000026 f01cdf08  000001a7 000001a7  f01cdf18 ffffffff  f0f7dce8 f00d0b78
RPC: <ext3_put_super+0x130/0x224>
%L: f01cdc00 f0e8df0c  f0e97200 f01cdc00  0000000a f0235400  00000001 f01fb000
%I: f0e8dc00 1e4000e4  00000001 00000063  00000078 f0f7dcf0  f0f7dd58 f00830b4
Caller[f00830b4]: generic_shutdown_super+0x130/0x134
Caller[f0083dcc]: kill_block_super+0x10/0x24
Caller[f0082e7c]: deactivate_super+0x50/0x6c
Caller[f0099f9c]: sys_umount+0x40/0x238
Caller[f001541c]: syscall_is_too_hard+0x3c/0x40
Caller[00012438]: 0x12440
Instruction DUMP: 90142308  7ffd1642  921021a7 <91d02005> 7fff55da  d004a0a0  d0062318  80a22000  2280000d
 
WARNING: at kernel/exit.c:890 do_exit()
[f0016754 : do_hw_interrupt+0x50/0x8c ] [f00146a0 : bad_trap_handler+0x28/0x30 ] [f00d0b78 : ext3_put_supe
r+0x130/0x224 ] [f00830b4 : generic_shutdown_super+0x130/0x134 ] [f0083dcc : kill_block_super+0x10/0x24 ] 
[f0082e7c : deactivate_super+0x50/0x6c ] [f0099f9c : sys_umount+0x40/0x238 ] [f001541c : syscall_is_too_ha
rd+0x3c/0x40 ] [00012438 : 0x12440 ] 
Killed


On Thu, Oct 18, 2007 at 09:43:34AM -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> 
> > It is probably significant that the original machine is a sparc32 (big
> > endian).  
> 
> Oh, true.
> 
> > I'd suspect you can reproduce this on a PPC system also.  You
> > might also consider running sparse on it ext3/ext4 in case you missed an
> > le32_to_cpu() or something.
> 
> sparse checks out ok... and, -rc6 which did not have that change showed
> the same behavior....
> 
> -Eric
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
