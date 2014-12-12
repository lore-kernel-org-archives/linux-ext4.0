From: alex chen <alex.chen@huawei.com>
Subject: A doubt on journal_async_commit option
Date: Fri, 12 Dec 2014 14:03:32 +0800
Message-ID: <548A8534.1050606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Joseph Qi <joseph.qi@huawei.com>
To: <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	<linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:5268 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaLLGDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2014 01:03:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit 0e3d2a6313(ext4: Fix async commit mode to be safe by using
a barrier) show that using journal_async_commit feature has a 50%
performance improvement. But I tested in SUSE Linux Enterprise Server
11 SP3(linux kernel 3.0.93) and Red Hat Enterprise linux 6.4(linux
kernel 2.6.32), the result show this feature has no performance
improvement.
My test command:
mount /dev/sdb /mnt/sdb
./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
umount

mount /dev/sdb /mnt/sdb -o journal_async_commit
./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
umount

My test result:
FSUse%        Count         Size    Files/sec     App Overhead
     6         1000        10240         42.1            10671
vs.
-o journal_async_commit
FSUse%        Count         Size    Files/sec     App Overhead
     6         1000        10240         63.9            10625

Superblock info(-o journal_async_commit):
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file
uninit_bg dir_nlink extra_isize
Block size:               4096
Journal backup:           inode blocks
Journal features:         journal_checksum journal_async_commit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x000017a6
Journal start:            1

Am I missing something?

                                            ---Alex

