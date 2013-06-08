From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: xfstests failure generic/239
Date: Sat, 8 Jun 2013 11:13:35 +0800
Message-ID: <51B2A15F.1060704@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <hch@lst.de>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:32103 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3FHDN6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jun 2013 23:13:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I run xfstests #239 against mainline 3.10.0-rc3, unfortunately it failure in my QEMU. I run the
case a hundred times, it certainly hit the failure several times. The failure msg is as follow:

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64  3.10.0-rc3-mainline

generic/239 1s ... - output mismatch (see /home/zhj/xfstests/results/generic/239.out.bad)
    --- tests/generic/239.out   2013-06-07 22:04:09.000000000 -0400
    +++ /home/zff/xfstests/results/generic/239.out.bad  2013-06-07 22:04:09.000000000 -0400
    @@ -1,2 +1,515 @@
     QA output created by 239
    +hostname: Host name lookup failure
     Silence is golden
    +0: 0x0
    +1: 0x0
    +2: 0x0
    +3: 0x0
     ...

I found that from 2.6.39 the test case occur this failure and it is is introduced by this
commit: 198868f35de99e7197829314076e5465c37e4cc5
ext4: Use single thread to perform DIO unwritten convertion

When i revert this patch, the failure seems go away. But when i see 
http://oss.sgi.com/archives/xfs/2010-06/msg00269.html, it said that 
"This contains core direct I/O changes to allow the filesystem to delay AIO completion, 
as well as a patch to fix XFS.  ext4 also has the same issue, and from a quick look also 
doesn't properly complete unwritten extent conversions for synchronous direct I/O, but 
I'll leave that for someone more familar to figure out."

I also run the test against 3.4.24 rt-tree with revert the patch which i found before, but
the hundred times tests all failure.

So, things maybe not simple, i doubt the patch i found isn't the root cause.

Regards,
						 - Hongjiang

