From: Bas van Schaik <bas@tuxes.nl>
Subject: EXT3 filesystem corruptions on AoE, RAID and LVM?
Date: Fri, 15 Dec 2006 23:35:13 +0100
Message-ID: <45832321.4010305@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a-eskwadraat.nl ([131.211.39.72]:38780 "EHLO a-eskwadraat.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030353AbWLOXAX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Dec 2006 18:00:23 -0500
Received: from niels.localdomain ([10.14.0.4] ident=sjeik)
	by a-eskwadraat.nl with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1GvLe5-0003Qb-Us
	for linux-ext4@vger.kernel.org; Fri, 15 Dec 2006 23:35:14 +0100
To: Linux extfs development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I'm maintaining two clusters, with machines running a mix between Debian
Stable with Etch-kernels to have AoE (ATA over Ethernet support).
Machines in these clusters "export" their harddisks using AoE, and one
machine in the cluster imports those using the kernel "aoe"-module. On
top of those imported devices, multiple RAID5-arrays are created, and
LVM is running on top of RAID, ext3 on the LVM LV.

After a few days, I get EXT3-errors. like this:
>> EXT3-fs: mounted filesystem with ordered data mode.
>> EXT3-fs error (device loop0): ext3_free_blocks_sb: bit already
cleared for block 412186
>> Aborting journal on device loop0.
>> EXT3-fs error (device loop0) in ext3_free_blocks_sb: Journal has aborted
>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
aborted
>> EXT3-fs error (device loop0) in ext3_truncate: Journal has aborted
>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
aborted
>> EXT3-fs error (device loop0) in ext3_orphan_del: Journal has aborted
>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
aborted
>> EXT3-fs error (device loop0) in ext3_delete_inode: Journal has aborted
>> __journal_remove_journal_head: freeing b_committed_data
>> __journal_remove_journal_head: freeing b_committed_data

(...)

>> __journal_remove_journal_head: freeing b_committed_data
>> ext3_abort called.
>> EXT3-fs error (device loop0): ext3_journal_start_sb: Detected aborted
journal
>> Remounting filesystem read-only
>> __journal_remove_journal_head: freeing b_committed_data


FSCK'ing the filesystem fixes those errors, but after a few days (or
weeks, depending on the fs load) the corruptions appear again. I might
be worth telling you that there are no other suspicious messages in my logs.

I saw some other discussions on the mailinglist, but I don't think their
related to my problems. I don't know if I need to file a bug on this,
neither do I know which details you need to help me solve this problem.
So for now I just want to here your thoughts. FYI:

Kernel information for cluster 1:
>> root@infinity:~# uname -a
>> Linux infinity 2.6.17-2-686 #1 SMP Wed Sep 13 16:34:10 UTC 2006 i686
GNU/Linux


And cluster 2:
>> dust:~# uname -a
>> Linux dust 2.6.18-3-686 #1 SMP Thu Nov 23 20:49:23 UTC 2006 i686
GNU/Linux

Note that these are not vanilla kernels, but Debian kernels. However,
AFAIK there are no Debian-specific patches to AoE, ext3, LVM or RAID.

Thanks for your replies!

Best regards,

  -- Bas van Schaik
