From: Rishikesh K Rajak <risrajak@in.ibm.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 09:42:04 +0530
Message-ID: <OF45EB84A0.4D9527E0-ON652574A5.00168DD0-652574A5.0016C100@in.ibm.com>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu> <200808132307.07437.mail@eworm.de> <20080813220100.GE6142@mit.edu> <48A35E0B.5050907@redhat.com> <20080813224534.GG6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org,
	Christian Hesse <mail@eworm.de>,
	Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Iranna D Ankad <iranna.ankad@in.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:42721 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751784AbYHNEMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 00:12:52 -0400
In-Reply-To: <20080813224534.GG6142@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

linux-ext4-owner@vger.kernel.org wrote on 08/14/2008 04:15:34 AM:

> Theodore Tso <tytso@mit.edu>
> Sent by: linux-ext4-owner@vger.kernel.org
>
> 08/14/2008 04:15 AM
>
> To
>
> Eric Sandeen <sandeen@redhat.com>
>
> cc
>
> Christian Hesse <mail@eworm.de>, linux-ext4@vger.kernel.org
>
> Subject
>
> Re: Oops with ext4 from 2.6.27-rc3
>
> On Wed, Aug 13, 2008 at 05:19:55PM -0500, Eric Sandeen wrote:
> >
> > I don't :), but I tried a quick reproducer anyway and couldn't hit it
...
> >
> > mkfs.ext3, mount, create non-extents file
> > umount, tune2fs to ext4
> > mount as ext4, write to file, open file O_TRUNC
> >
> > ... didn't oops for me :(
> >
>
> In this particular case, we need to open the file for appending, write
> to it, and then unlink it in order to trigger it, I think.
>
>                                                  - Ted

Hi All,

Actually the same oops hit for me too with 2.6.27-rc1, i was suppose to
open a bug but found it active, but my scenario was same what Ted is
telling to do.

I have created and lvm partition with 30GB, and wrote 2.3GB file on it and
when i am trying to remove this file with "rm -rf "file_name" then i hit
the call trace, as below , but for me machine is in pingable state, rather
i can not execute any command inside the ext4 mounted directory and even i
can not umount the filesystem :(

Here is the call trace i am getting, it seems same as christian has
reported and also i have pasted the code where it is getting oops.

------------[ cut here ]------------
kernel BUG at fs/ext4/mballoc.c:3963!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: ipv6 autofs4 hidp rfcomm l2cap bluetooth sunrpc
dm_mirror dm_log dm_multipath dm_mod sbs sbshc battery ac parport_pc lp
parport sr_mod sg ide_cd_mod cdrom serio_raw button rtc_cmos rtc_core
rtc_lib tg3 libphy k8temp hwmon i2c_piix4 pcspkr i2c_core usb_storage
sata_svw libata mptspi mptscsih scsi_transport_spi mptbase sd_mod scsi_mod
ext3 jbd uhci_hcd ohci_hcd ehci_hcd

Pid: 8852, comm: rm Not tainted (2.6.27-rc1 #2)
EIP: 0060:[<c04c98f0>] EFLAGS: 00010297 CPU: 0
EIP is at ext4_mb_free_blocks+0x3b6/0x51a
EAX: e56a5fcc EBX: 0000033f ECX: 00000000 EDX: e56a5e40
ESI: 0000000c EDI: 00000000 EBP: f5fb7de8 ESP: f5fb7d74
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 8852, ti=f5fb7000 task=f43b3b80 task.ti=f5fb7000)
Stack: 0067ee0d 00000000 0067ee01 e56a5e40 df0cc490 0067ee01 00000000
cca06a48
       ebfe5df0 d14d2f80 ddbcffe0 00000000 e7ad0000 00000000 0067ee0d
c966c860
       f35c3c00 c966c860 f35c3800 e7d2b7b8 ebfe5df0 0000000a 0000033f
0000033f
Call Trace:
 [<c04b02df>] ? ext4_free_blocks+0x9b/0x100
 [<c04b4c84>] ? ext4_clear_blocks+0xcb/0xd6
 [<c04b4d54>] ? ext4_free_data+0xc5/0x117
 [<c04b5056>] ? ext4_truncate+0x129/0x3d5
 [<c046ef0d>] ? kmem_cache_alloc+0x75/0xad
 [<c04cf0ff>] ? jbd2_journal_start+0x53/0xb4
 [<c04cf0ff>] ? jbd2_journal_start+0x53/0xb4
 [<c04cf133>] ? jbd2_journal_start+0x87/0xb4
 [<c04bbff7>] ? ext4_journal_start_sb+0x40/0x42
 [<c04b7153>] ? ext4_delete_inode+0xab/0x10a
 [<c04b70a8>] ? ext4_delete_inode+0x0/0x10a
 [<c04828c5>] ? generic_delete_inode+0x98/0xff
 [<c048293e>] ? generic_drop_inode+0x12/0x126
 [<c0482221>] ? iput+0x4b/0x4e
 [<c047ad43>] ? do_unlinkat+0xa9/0x112
 [<c047c98c>] ? vfs_readdir+0x7e/0x8f
 [<c047c780>] ? filldir64+0x0/0xcd
 [<c044a123>] ? audit_syscall_entry+0x101/0x12b
 [<c047adbc>] ? sys_unlink+0x10/0x12
 [<c040383d>] ? sysenter_do_call+0x12/0x21
 =======================
Code: 19 c0 85 c0 75 f0 8b 45 98 8d 55 c8 8b 4d f0 ff 75 08 e8 80 c2 ff ff
8b 45 98 8b 55 98 5e 05 8c 01 00 00 39 82 8c 01 00 00 74 04 <0f> 0b eb fe
8b 4d ac 8b 5d e8 8b 81 a0 01 00 00 89 da 8b 48 58
EIP: [<c04c98f0>] ext4_mb_free_blocks+0x3b6/0x51a SS:ESP 0068:f5fb7d74
---[ end trace d6eba9fe5baf0f00 ]---


================ Code of fs/ext4/mballoc.c
=================================


3952 /*
3953  * finds all preallocated spaces and return blocks being freed to them
3954  * if preallocated space becomes full (no block is used from the
space)
3955  * then the function frees space in buddy
3956  * XXX: at the moment, truncate (which is the only way to free blocks)
3957  * discards all preallocations
3958  */
3959 static void ext4_mb_return_to_preallocation(struct inode *inode,
3960                                         struct ext4_buddy *e4b,
3961                                         sector_t block, int count)
3962 {
3963         BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
3964 }



-Rishi

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

