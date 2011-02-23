From: Hari Subramanian <hari@vmware.com>
Subject: e2fsprogs/ext4 version compatibility
Date: Wed, 23 Feb 2011 13:09:20 -0800
Message-ID: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:18801 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab1BWVJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 16:09:22 -0500
Received: from mailhost3.vmware.com (mailhost3.vmware.com [10.16.27.45])
	by smtp-outbound-1.vmware.com (Postfix) with ESMTP id 40C4B130E1
	for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 13:09:22 -0800 (PST)
Received: from pa-exht01.vmware.com (pa-exht01.vmware.com [10.113.81.167])
	by mailhost3.vmware.com (Postfix) with ESMTP id 38C76CD974
	for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 13:09:22 -0800 (PST)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm running a SLES11 SP1 GA based kernel (2.6.32.23) with ext4 filesystem. The e2fsprogs package that's installed on the box is version 1.41.9 (22-Aug-2009). I was wondering if there was a version in compatibility between the filesystem implementation and the tools package, esp. since there have been 5 revisions of the package since 1.41.9

The reason I'm asking the question is my machine recently rebooted after a crash but fsck failed with an error code of 4 and the following message:

"Inodes that were part of a corrupted orphan linked list found"
"UNEXPECTED INCONSISTENCY: RUN fsck MANUALLY"

There were no files being created or deleted at the time of the crash although IOs were probably inflight. So, the inodes being a part of orphaned link list doesn't make sense to me. I don't claim deep knowledge in filesystem internals either. Before I go suspecting a corrupted filesystem, I wanted to make sure I was running the right version of fsck.

Thanks in advance for your help!
~ Hari

P.S. I wasn't sure if this is the right forum to post this question but I couldn't find a e2fsprogs mailing list and linux-ext4 seemed like a good alternative. Sorry, if this is the wrong forum.
