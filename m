From: Alexey Skidanov <Alexey.Skidanov@sandisk.com>
Subject: fsync and journal_async_commit mount options
Date: Thu, 13 Aug 2015 13:47:12 +0000
Message-ID: <CF2184B79FF73642B463E092E85766BF054744BD@SACMBXIP02.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "alexey.skidanov@gmail.com" <alexey.skidanov@gmail.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:22553
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752261AbbHMPSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Aug 2015 11:18:23 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Some partition on my device is mounted with  journal_async_commit option. I paid attention that fsync() system call doesn't cause to flush request to be sent. Looking in the source code of ext4_sync_file I understand that only if the barrier option is on the flush request will be issued:

	if (journal->j_flags & JBD2_BARRIER &&
	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
		needs_barrier = true;
                ...
	if (needs_barrier) {
		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
                               ...
	}

The fsync mainly used to ensure the data is actually written on backing device. The man page says:

fsync() transfers ("flushes") all modified in-core data of (i.e., modified buffer cache pages for) the file referred to by the file descriptor fd to the disk device (or other permanent storage device) so that all changed information can be retrieved even after the system crashed or was rebooted. This includes writing through or flushing a disk cache if present.

The barrier is a mount option imposing some ordering on journaling transactions - journaling content and journaling commit. So why  the flush request is issued only if the journal ordering is imposed by barrier option?

Thanks
Alexey
