From: eworm@lugor.de
Subject: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 20:28:18 +0200 (CEST)
Message-ID: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: mail@eworm.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:34547 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYHMS4i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 14:56:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

I decided to switch to ext4 today. My kernel is 2.6.27-rc3 with some
additional patches, but none to the ext4 code. Here is my system setup:

* /dev/sda3 is encrypted with LUKS/device-mapper
* lvm2 on the encrypted partition
* two logical volumes with ext4 inside the lvm2

The ext4 filesystems have been converted from ext3 using this command:

$ tune2fs -O extents -E test_fs /dev/mapper/<device>

After mounting the partitions and logging in it took half a minute to hang
the system (or at least freeze all applications that access the fs). The
log contains the following:

kernel BUG at fs/ext4/mballoc.c:3963!
invalid opcode: 0000 [#1] SMP
Modules linked in: iwl3945 snd_hda_intel vboxdrv [last unloaded: iwl3945]

Pid: 5487, comm: opera Not tainted (2.6.27-rc3 #1)
EIP: 0060:[<c0232a93>] EFLAGS: 00210202 CPU: 0
EIP is at ext4_mb_free_blocks+0x593/0x5a0
EAX: ede02038 EBX: 0000000c ECX: 00000173 EDX: ede0223c
ESI: 00000000 EDI: 00000000 EBP: ed8cdc78 ESP: ed8cdbfc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process opera (pid: 5487, ti=ed8cc000 task=ed8b6570 task.ti=ed8cc000)
Stack: 0000000c ed8cdc68 c07163c0 ed8cdc30 c015e36b ede020b8 ede043ec
f5e85880
       edd72a94 f5c14e00 ede0d76c f609f100 00000000 f5e85800 ede02038
ede0223c
       000405cc c15b1620 ed8b1000 c15cf060 ee783000 f5dc8cc0 f5c14e00
0000000c
Call Trace:
 [<c015e36b>] ? find_get_page+0x2b/0xc0
 [<c0215887>] ? ext4_free_blocks+0x87/0x160
 [<c021d0f3>] ? ext4_clear_blocks+0xd3/0x100
 [<c021d295>] ? ext4_free_data+0x175/0x1d0
 [<c021da6e>] ? ext4_truncate+0x56e/0x640
 [<c0167e41>] ? truncate_inode_pages_range+0x181/0x350
 [<c016e027>] ? unmap_mapping_range+0x87/0x250
 [<c016e3c5>] ? vmtruncate+0xc5/0x190
 [<c0196885>] ? inode_setattr+0x65/0x1a0
 [<c021980a>] ? ext4_setattr+0x23a/0x320
 [<c0196ab5>] ? notify_change+0xf5/0x350
 [<c0180648>] ? do_truncate+0x68/0x90
 [<c018b4ca>] ? path_walk+0x9a/0xb0
 [<c018a41e>] ? may_open+0x1be/0x250
 [<c018c43f>] ? do_filp_open+0xff/0x7e0
 [<c0101d03>] ? __switch_to+0x153/0x160
 [<c019788e>] ? alloc_fd+0x6e/0x100
 [<c017f789>] ? do_sys_open+0x59/0xf0
 [<c017f889>] ? sys_open+0x29/0x40
 [<c01032b1>] ? sysenter_do_call+0x12/0x25
 =======================
Code: 90 8d b4 26 00 00 00 00 85 c0 75 83 8b 5d a4 f0 ff 4b 30 8b 45 b4 8b
75 c4 89 45 08 e9 57 fb ff ff bf fb ff ff ff e9 89 fc ff ff <0f> 0b eb fe
89 f6 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec
EIP: [<c0232a93>] ext4_mb_free_blocks+0x593/0x5a0 SS:ESP 0068:ed8cdbfc

Any help is welcome. ;)

Regards,
Chris
