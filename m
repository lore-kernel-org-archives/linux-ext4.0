From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 10 Jul 2008 08:11:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
 <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
 <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
 <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:51207 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYGJILX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2008 04:11:23 -0400
In-Reply-To: <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 7 Jul 2008, Holger Kiehl wrote:

> On Thu, 19 Jun 2008, Theodore Tso wrote:
>
>> On Wed, Jun 18, 2008 at 05:58:00AM +0000, Holger Kiehl wrote:
>>> For afdbench: 5336.41 files per second 15.63 MiB/s
>>> 
>>> So it seems that for afdbench the ext4-patch-queue is a slowdown.
>> 
>> Can you remind me where afdbench can be downloaded?  And if I remember
>> correctly, it creates and deletes large numbers of small files,
>> correct?
>> 
>> It would be interesting to see which new feature introduced by the
>> ext4 patch queue --- probably dellayed allocation or mballoc --- is
>> responsible for the slowdown.  One or the other (or both) can be
>> disabled by mounting the filesystem (using a kernel with the ext4
>> patch queue) with the mount options -O nomballoc or -O nodelalloc.
>> 
>> If it turns out that nomballoc restores the speed for afdbench, for
>> example, then it will tell us where we need to look more closely.
>> Ideally we would not want to have one mount option needed to optimize
>> filesystem operations for large amoutns of modifications to small
>> files, and another mode of operation when mostly writing to large
>> files.  So if you could do a round of tests using the ext4 patch queue
>> kernel, with -O nomballoc and -O nodelalloc (and if both seem to
>> improve things, try "-O nomballoc,nodelalloc" and see if you get back
>> to the pre-ext4 patch queue speed), it would be very much appreciated.
>> 
> Here the results:
>                                     +---------+------------+
>                                     | afdbench|   bonnie++ |
>                                     +---------+--------+---+
>                                     |file rate| block w|%CP|
> -------------------------------------+---------+--------+---+
> ext3                                 | 5536.79 | 212350 | 92|
> ext4-patch-queue                     | 5054.86 | 244384 | 50|
> ext4-patch-queue-nodelalloc          | 4943.78 | 225819 | 92|
> ext4-patch-queue-nomballoc           | 3123.49 | 244535 | 52|
> ext4-patch-queue-nomballoc-nodelalloc| 4931.09 | 231332 | 91|
> -------------------------------------+---------+--------+---+
>
> Test where done with 2.6.26-rc8 and
> ext4-patch-queue-52c8a02a8a7b7e5915b9301e9c171b4faf22b928.tar.gz,
> e2fsprogs is from git (27th April 2008). ext4 filesystem was created
> with 'mke2fs -m 0 -t ext4dev /dev/md7' and ext3 'mke2fs -m 0 -j /dev/md7'.
> Common mount options are: noatime,nodiratime,commit=15
>
> Looking at the afdbench results I also notice that when I just take
> the FTP results the results look as follows:
>
> ext3                                 : 3465.50
> ext4-patch-queue                     : 2785.58
> ext4-patch-queue-nodelalloc          : 2677.39
> ext4-patch-queue-nomballoc           :  219.12
> ext4-patch-queue-nomballoc-nodelalloc: 2566.24
>
> Now one can see the drop with ext4-patch-queue much clearer. The testing
> of afdbench is done in two parts, one where we just link lots of small
> files locally and the same test is then repeated using a network protocol
> in this case FTP. So the difference is that for the filesystem lots
> of new files get created. Further testing showed that when I increase
> the number FTP process performance decreases in all cases but much more
> for ext4-patch-queue (nearly 50% drop against ext3) as the following results
> show:
>
> ext3                                 : 2352.89
> ext4-patch-queue                     : 1226.55
> ext4-patch-queue-nodelalloc          : 1340.80
> ext4-patch-queue-nomballoc-nodelalloc: 1181.12
>
> I did not do the ext4-patch-queue-nomballoc test since there is obviously
> something wrong here when you look at the numbers above (219.12 fps).
> During that test I notice that when you try to open an existing file
> with vi it can take several minutes before it opens this file. The strange
> thing is that vi was not in D-state but it could not be killed, even root
> could not kill it with -9.
>
> There is also some corruption in filesystem during the test with
> ext4-patch-queue and ext4-patch-queue-nomballoc. It happens when after
> the test I umount the test filesystem and then mount it again the
> following message appears:
>
> root@athena:~# umount /home
> root@athena:~# mount /home
> mount: wrong fs type, bad option, bad superblock on /dev/md7,
>       missing codepage or helper program, or other error
>       In some cases useful info is found in syslog - try
>       dmesg | tail  or so
>
> EXT4-fs: ext4_check_descriptors: Inode bitmap for group 256 not in group 
> (block 117835012)!<3>EXT4-fs: group descriptors corrupted!
>
> Using fsck this problem could be corrected. Now that one does not think I
> did those test on a corrupted file system. The filesystem was newly created
> for each of the above five test runs.
>
Any ideas what I can do to help find why performance under load is nearly
halved and the group descriptor corruption?

I did try newer patch queue (ext4-patch-queue-a5d48915447f44c3af6ce8e1c91d45b452977fcf)
from today, but I immediatly hit an oops as soon as I untar a file, see below.

Thanks,
Holger


kjournald2 starting.  Commit interval 15 seconds
EXT4 FS on md7, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1817!
invalid opcode: 0000 [1] SMP 
CPU 0 
Modules linked in: w83627hf lm85 hwmon_vid bonding nf_conntrack_ftp ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables binfmt_misc floppy i2c_amd756 i2c_core k8temp ohci_hcd sg button usbcore
Pid: 2757, comm: tar Not tainted 2.6.26-rc9 #1
RIP: 0010:[<ffffffff802e2722>]  [<ffffffff802e2722>] ext4_ext_get_blocks+0x9eb/0xde1
RSP: 0018:ffff81007a0f99b8  EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff81002cfd69c0 RCX: ffff81002cfd69a8
RDX: ffff81007f48c6fc RSI: 00000000ffffffff RDI: ffff81002cfd69c0
RBP: ffff81007a0f9b88 R08: ffff81007f48c6fc R09: 0000000000000000
R10: 000000000000a855 R11: 0000000000000000 R12: ffff81007f48c7b0
R13: 0000000000000001 R14: ffff81007f48c7b0 R15: 0000000000000001
FS:  00007f66afd3b780(0000) GS:ffffffff80570000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000081d000 CR3: 00000001e9e86000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process tar (pid: 2757, threadinfo ffff81007a0f8000, task ffff81007d9110e0)
Stack:  ffff81007d36c300 000000007f46e030 ffff81007a0f9b88 0000000000000001
  000000012c815bc0 ffff81007f46e030 ffff81002cfd69c0 000000007d36c300
  ffff81007a0f9bb8 ffff81007f48c6f0 000000007a0f9bc8 ffff81007f46e030
Call Trace:
  [<ffffffff802d2aaa>] ? ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff80223c42>] ? __wake_up+0x38/0x4f
  [<ffffffff802d4e0b>] ? ext4_get_blocks_wrap+0x70/0x165
  [<ffffffff8031af55>] ? __up_read+0x13/0x8a
  [<ffffffff802d5280>] ? ext4_getblk+0x62/0x170
  [<ffffffff802d7801>] ? add_dirent_to_buf+0xcb/0x2ec
  [<ffffffff802d539b>] ? ext4_bread+0xd/0x5f
  [<ffffffff802d7206>] ? ext4_append+0x3a/0x88
  [<ffffffff802d8042>] ? ext4_add_entry+0x620/0x87f
  [<ffffffff802d12ce>] ? ext4_new_inode+0xc4e/0xc78
  [<ffffffff802f58f3>] ? start_this_handle+0x2c7/0x370
  [<ffffffff802d8916>] ? ext4_add_nondir+0x18/0x4e
  [<ffffffff802d8ff8>] ? ext4_create+0xc2/0x105
  [<ffffffff802d9288>] ? ext4_lookup+0x97/0xc1
  [<ffffffff802823d6>] ? vfs_create+0x75/0xba
  [<ffffffff80284e5d>] ? do_filp_open+0x1e4/0x7f6
  [<ffffffff80279e7e>] ? sys_chown+0x5c/0x6b
  [<ffffffff80279684>] ? do_sys_open+0x46/0xca
  [<ffffffff8020b16b>] ? system_call_after_swapgs+0x7b/0x80


Code: 39 44 24 24 72 2f 66 81 fa 00 80 0f b7 c2 76 05 2d 00 80 00 00 48 8b 7c 24 30 01 f0 89 44 24 24 e8 71 d3 ff ff 3b 44 24 24 75 04 <0f> 0b eb fe 2b 44 24 24 eb 11 0f 0b eb fe c7 44 24 24 00 00 00 
RIP  [<ffffffff802e2722>] ext4_ext_get_blocks+0x9eb/0xde1
  RSP <ffff81007a0f99b8>
---[ end trace e595ecd19e9f2f92 ]---

