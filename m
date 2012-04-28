From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Intentionally corrupted fs: [this times really] "kernel BUG at
 fs/jbd2/transaction.c:161!"
Date: Fri, 27 Apr 2012 20:42:46 -0500
Message-ID: <4F9B4B16.4090903@redhat.com>
References: <20120428004522.GC20648@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab2D1Bms (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 21:42:48 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3S1gmNr005031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2012 21:42:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3S1gkbw017956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2012 21:42:47 -0400
In-Reply-To: <20120428004522.GC20648@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/27/12 7:45 PM, Sami Liedes wrote:
> [This is a distinct bug from the another similar-looking mail that I
> just sent on this list - confusingly by mistake with the subject this
> mail should have had...]
> 
> The 10 MiB ext4 image available at
> 
>    http://www.niksula.hut.fi/~sliedes/ext4/2000177.min.ext4.bz2
> 
> causes a crash on mainline 3.3.4 kernel at umount time when the
> following operations are run (not all of these are probably really
> necessary):
> 
> 1.  mount 2000177.min.ext4 /mnt -t ext4 -o errors=continue
> 2.  cd /mnt
> 3.  cp -r doc doc2 >&/dev/null
> 4.  find -xdev >&/dev/null
> 5.  find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
> 6.  mkdir tmp >&/dev/null
> 7.  echo whoah >tmp/filu 2>/dev/null
> 8.  rm -rf /mnt/* >&/dev/null
> 9.  cd /
> 10. umount /mnt
> 
> See the dmesg output below (the panic is due to panic_on_oops=1).
> 
> The image differs from a pristine, fully working ext4 filesystem
> available at
> 
>    http://www.niksula.hut.fi/~sliedes/ext4/pristine.ext4.bz2
> 
> by only one bit:
> 
> ------------------------------------------------------------
> $ wget http://www.niksula.hut.fi/~sliedes/ext4/pristine.ext4.bz2
> $ bunzip2 pristine.ext4.bz2
> $ diff -u <(hd pristine.ext4) <(hd 2000177.min.ext4)
> --- /dev/fd/63 2012-04-28 03:39:00.167101668 +0300
> +++ /dev/fd/62 2012-04-28 03:39:00.167101668 +0300
> @@ -32168,7 +32168,7 @@
>  00170050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>  *
>  00170400  07 01 00 00 0c 00 01 02  2e 00 00 00 a4 00 00 00  |................|
> -00170410  0c 00 02 02 2e 2e 00 00  08 01 00 00 e8 03 28 01  |..............(.|
> +00170410  0c 00 02 02 2e 2e 00 00  08 00 00 00 e8 03 28 01  |..............(.|
>  00170420  5c 78 32 66 64 65 76 69  63 65 73 5c 78 32 66 76  |\x2fdevices\x2fv|
>  00170430  69 72 74 75 61 6c 5c 78  32 66 62 6c 6f 63 6b 5c  |irtual\x2fblock\|
>  00170440  78 32 66 64 6d 2d 31 31  00 00 00 00 00 00 00 00  |x2fdm-11........|
> ------------------------------------------------------------

That's block 1473 (this is a 1k block fs)

debugfs:  stat <263>
Inode: 263   Type: directory    Mode:  0755   Flags: 0x80000
Generation: 1162591830    Version: 0x00000002
User:     0   Group:     0   Size: 1024
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 2
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x48bf269d -- Wed Sep  3 19:06:53 2008
atime: 0x484aa7c8 -- Sat Jun  7 10:22:48 2008
mtime: 0x4845aca6 -- Tue Jun  3 15:42:14 2008
EXTENTS:
(0):1473

which is a directory.

The changed byte is the inode nr in the dir entry; it should be 264 (0x108) but got changed to 8 (0x8) ... which is the journal inode.  That can't be good.  Testing a patch I'll send shortly if it works.

- -Eric

> 

> (This bug report serves also as a preview of the Berserker toolkit
> that automates finding such bugs and minimizing the differences to
> pristine filesystems. I plan on making the announcement and making the
> toolkit available within the next few hours.)

sounds a bit like fsfuzzer, how is it different?

> 	Sami
> 
> 
> ------------------------------------------------------------
> EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
> ------------[ cut here ]------------
> kernel BUG at fs/jbd2/transaction.c:161!

        BUG_ON(journal->j_flags & JBD2_UNMOUNT);


> invalid opcode: 0000 [#1]
> CPU 0
> Pid: 1528, comm: umount Not tainted 3.3.4 #1 Bochs Bochs
> RIP: 0010:[<ffffffff811c19b1>]  [<ffffffff811c19b1>] start_this_handle+0x591/0x6d0
> RSP: 0018:ffff880006c57b38  EFLAGS: 00010202
> RAX: 0000000000000039 RBX: ffff880006d06828 RCX: 0000000000021020
> RDX: 0000000000000039 RSI: ffffffff817b4ba0 RDI: ffff880006d06828
> RBP: ffff880006c57be8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000153 R12: 0000000000000062
> R13: ffff880006d06800 R14: ffff880006cee040 R15: ffff880006c57ba8
> FS:  0000000000000000(0000) GS:ffffffff8161d000(0063) knlGS:00000000f74e9750
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f75833e0 CR3: 000000000614c000 CR4: 00000000000006b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process umount (pid: 1528, threadinfo ffff880006c56000, task ffff880006cee040)
> Stack:
>  0000000000000000 ffff880006cee040 ffffffff810e748d 00000000fffedcd4
>  ffff880007252608 ffff880006cee040 ffff880006c0f200 ffff880006cee040
>  ffff880000000050 0000000000000296 ffff880006c57b98 ffffffff8107660d
> Call Trace:
>  [<ffffffff810e748d>] ? kmem_cache_alloc+0xad/0x150
>  [<ffffffff8107660d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff811c1c11>] jbd2__journal_start+0x121/0x1a0
>  [<ffffffff81186785>] ? ext4_evict_inode+0x135/0x490
>  [<ffffffff811c1c9e>] jbd2_journal_start+0xe/0x10
>  [<ffffffff811a07da>] ext4_journal_start_sb+0x7a/0x1d0
>  [<ffffffff8114437b>] ? __dquot_initialize+0x2b/0x180
>  [<ffffffff81186785>] ext4_evict_inode+0x135/0x490
>  [<ffffffff81105057>] evict+0xa7/0x1b0
>  [<ffffffff81105de5>] iput+0x105/0x210
>  [<ffffffff811cb847>] jbd2_journal_destroy+0x1b7/0x240
>  [<ffffffff81053200>] ? abort_exclusive_wait+0xb0/0xb0
>  [<ffffffff811a0cd3>] ext4_put_super+0x73/0x320
>  [<ffffffff810ee52d>] generic_shutdown_super+0x5d/0xf0
>  [<ffffffff810efa3b>] kill_block_super+0x2b/0x80
>  [<ffffffff810ee365>] deactivate_locked_super+0x45/0x80
>  [<ffffffff810ee3e8>] deactivate_super+0x48/0x60
>  [<ffffffff81108bd0>] mntput_no_expire+0xa0/0xf0
>  [<ffffffff81109e0c>] sys_umount+0x6c/0x360
>  [<ffffffff8110a10b>] sys_oldumount+0xb/0x10
>  [<ffffffff813f5331>] sysenter_dispatch+0x7/0x2a
>  [<ffffffff8122ee0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> Code: 47 fa e8 93 16 23 00 48 8b 85 60 ff ff ff 4d 39 be a8 00 00 00 73 07 4d 89 be a8 00 00 00 48 89 c7 e8 a4 17 23 00 e9 30 ff ff ff <0f> 0b 48 c7 c1 50 21 42 81 ba df 00 00 00 31 c0 48 c7 c6 38 8c
> RIP  [<ffffffff811c19b1>] start_this_handle+0x591/0x6d0
>  RSP <ffff880006c57b38>
> ---[ end trace a277562ac91d83ad ]---
> Kernel panic - not syncing: Fatal exception
> Rebooting in 1 seconds..
> ------------------------------------------------------------

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPm0sVAAoJECCuFpLhPd7gQnEQAJ2nivGha/vInCViGr0Q3Q8w
HVtjEcpH1fK16IrhyOKqon+P7O/Jwn3+4rnSv8jGDwEmnly9KWQ7bTpo3KPGrdTk
/IpqMW06NLJIrlVyRO3ro2q7iqQD9VapZYg1jLdf/XKRT+VIlr38Ve/gS2kPQWN0
vR22A0+od22lvMiERCVzWRJ0IO32pkwFM7Ff3GuEcau9r+aOFYZz7kLQDzlssWa7
SfeIsKTtuplSSIcBudvXHK8asLtW9goLmTz4JfuZWTakGze4Y/Q0nd7yYgeO38wr
3L0X+pwTQpGmEdu7sFl5ZmSsu38RNxJqxepoNGiKZnEW2XNrO8ro+ckg732YmVpg
6N/c5OP2dnsPPISuORM1ssoHtJyEs/IvBE6RV9r9IZ/EA1yFFSLZbdxzFmO3A21K
bDuNG3H7loPZ52JULAWTEmvTkFiiC7nkk5ZuowKk8a4p3kGa5kAsLT7UEsV/gyix
wmq1C1LeiVdYR78wLEj9eMd9cz0WasrPMzbwzyatoXIkRvw1vtVsfWkaXoVrcsAu
Ae2Xhi9ito+yZ4rymXvy9+i2KZOf7XVrdRbivDC9tumpImBVDpnOO3zS/NbKosiw
AdxrVkQYTZnMoW8jOowakmEXMPZgmFmHBNSk0YG/EawSh0GDKKe1n5Tn57dl0XV9
/e/CT822l7foYCC6zG+B
=+8Qg
-----END PGP SIGNATURE-----
