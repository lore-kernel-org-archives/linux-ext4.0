From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: uninit block group/mballoc and fsstress
Date: Wed, 10 Oct 2007 22:07:55 +0530
Message-ID: <470CFFE3.7080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34532 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbXJJQiY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 12:38:24 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9AGcNqO020549
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:38:23 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9AGcMW24722732
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:38:22 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9AGc6Se014893
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:38:06 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I am hitting this with  the below config

mke2fs -j -I 256 -O lazy_bg $dev


mount -t ext4dev $dev /mnt/tmp -o "extents,mballoc"

and running fsstress on /mnt/tmp/



jbd2_journal_bmap: journal block not found at offset 31780 on sda7

Aborting journal on device sda7.

ext4_abort called.

EXT4-fs error (device sda7): ext4_journal_start_sb: Detected aborted journal

Remounting filesystem read-only

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_ordered_commit_write: IO failure

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_ordered_writepage: IO failure

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_orphan_del: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted

EXT4-fs error (device sda7) in ext4_reserve_inode_write: Journal has aborted
