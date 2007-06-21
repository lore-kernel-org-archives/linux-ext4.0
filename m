From: Daniel Drake <ddrake@brontes3d.com>
Subject: ext3/journalling deadlock on old kernel
Date: Thu, 21 Jun 2007 10:42:26 -0400
Message-ID: <1182436946.8035.6.camel@systems03.mmm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp136.iad.emailsrvr.com ([207.97.245.136]:47124 "EHLO
	smtp136.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbXFUPHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:07:15 -0400
Received: from [169.14.245.222] (host34.155.212.242.conversent.net [155.212.242.34])
	(Authenticated sender: ddrake@brontes3d.com)
	by relay3.r3.iad.emailsrvr.com (SMTP Server) with ESMTP id A2FB144C00F
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:42:26 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

To start with, this was seen on a 2.6.18 kernel which was tainted. I
know how it doesn't make sense to work on a report from such an old code
base, never mind a tainted kernel, so feel free to ignore this if it's
not interesting..

I left a system running overnight, running "stress --cpu 4 --io 1 --vm 1
--hdd 1" on a 4 way opteron system. While running stress
(http://weather.ou.edu/~apw/projects/stress/) it was also repeatedly
checking the md5sums of several large files. The system was under both
CPU and IO (DMA) load.

After a few hours, it hung, but caps lock, ping, and sysrq were still
responsive. sysrq shows me this trace:

EIP at .text.lock.spinlock+0x2/0x97
Trace:
journal_dirty_data+0x78
ext3_journal_dirty_data+0x1d
walk_page_buffers+0x68
ext3_journal_dirty_data+0x0
ext3_ordered_commit_write+0x73
generic_file_buffered_write
__generic_file_aio_write
do_get_write_access
generic_file_aio_write
ext3_file_write
do_sync_write

The lock it hung on, according to gdb:

	spin_lock(&journal->j_list_lock);

If a fix is known for this issue, I'd appreciate any pointers. I'll
continue attempting to reproduce this with a serial console hooked up.

Thanks.
-- 
Daniel Drake
Brontes Technologies, A 3M Company
