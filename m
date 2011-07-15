From: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Subject: Ext4 flush blocked
Date: Thu, 14 Jul 2011 22:33:47 -0300
Message-ID: <4E1F98FB.8020800@taghos.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.236.22]:33035 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932217Ab1GOBeE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 21:34:04 -0400
Received: from gator1481.hostgator.com (gator1481.hostgator.com [184.173.199.228])
	by ham01.websitewelcome.com (Postfix) with ESMTP id 4FC7A4ECA57EA
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 20:33:58 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    Hi,

    I'm using a mmap-intensive file server on a Dell Machine with 2.6.35.13.

    The partition is a RAID-0 mounted with ext4 and noatime.

    After a while using (about an hour) I get a lot of:

INFO: task flush-8:16:6650 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:16    D 0000000000000000     0  6650      2 0x00000000
 ffff880400b0d980 0000000000000046 0000000000012500 ffff880400b0dfd8
 ffff880400b0dfd8 ffff880418b34830 0000000000012500 0000000000012500
 0000000000012500 ffff880418b34830 ffffffff81a11020 ffff880418b34ad8
Call Trace:
 [<ffffffff8151c837>] io_schedule+0x7b/0xc2
 [<ffffffff8108fceb>] sync_page+0x41/0x45
 [<ffffffff8151cb15>] __wait_on_bit_lock+0x45/0x8c
 [<ffffffff8108fcaa>] ? sync_page+0x0/0x45
 [<ffffffff8108fc96>] __lock_page+0x63/0x6a
 [<ffffffff8104ed1c>] ? wake_bit_function+0x0/0x2a
 [<ffffffff8108fd88>] ? unlock_page+0x22/0x27
 [<ffffffff81122f43>] ext4_da_writepages+0x516/0x8e1
 [<ffffffff8103233f>] ? find_busiest_group+0x2e9/0x900
 [<ffffffff81096720>] do_writepages+0x1c/0x25
 [<ffffffff810df4d6>] writeback_single_inode+0xe8/0x329
 [<ffffffff810dfaa9>] writeback_sb_inodes+0x14e/0x225
 [<ffffffff810e02e1>] writeback_inodes_wb+0x146/0x156
 [<ffffffff810e04a1>] wb_writeback+0x1b0/0x232
 [<ffffffff81035288>] ? get_parent_ip+0x11/0x41
 [<ffffffff810e065c>] wb_do_writeback+0x139/0x14f
 [<ffffffff810e06b0>] bdi_writeback_task+0x3e/0x112
 [<ffffffff8104ec02>] ? bit_waitqueue+0x12/0xa3
 [<ffffffff810a1800>] ? bdi_start_fn+0x0/0xd2
 [<ffffffff810a1871>] bdi_start_fn+0x71/0xd2
 [<ffffffff810a1800>] ? bdi_start_fn+0x0/0xd2
 [<ffffffff8104e892>] kthread+0x7d/0x85
 [<ffffffff810037d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8104e815>] ? kthread+0x0/0x85
 [<ffffffff810037d0>] ? kernel_thread_helper+0x0/0x10


    The hardware is:

02:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)

    The machine is RAID-0 with 2 450GB SAS 15K RPM hard drives.

sd 0:2:1:0: [sdb] 1755840512 512-byte logical blocks: (898 GB/837 GiB)
sd 0:2:1:0: [sdb] Write Protect is off
sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
scsi 0:0:32:0: Attached scsi generic sg0 type 13
sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
sd 0:2:0:0: Attached scsi generic sg1 type 0
sd 0:2:1:0: Attached scsi generic sg2 type 0

    Is there any other info I can provide you to help track this bug down?

    Cheers,


-- 
Felipe Wilhelms Damasio

TAGHOS - Tecnologia
Rua Prof. Alvaro Alvim, 211
Porto Alegre - RS - (51) 3239-3180
www.taghos.com.br <http://www.taghos.com.br/>
