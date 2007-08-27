From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (August 27, 2007)
Date: Mon, 27 Aug 2007 16:46:20 -0700
Message-ID: <46D3624C.6060200@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51512 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXH0Xpd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Aug 2007 19:45:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l7RMcPgf027354
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2007 18:38:25 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7RNjXrr500954
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2007 17:45:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7RNjWBi028648
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2007 17:45:32 -0600
Received: from [9.47.16.64] (dyn9047016064.beaverton.ibm.com [9.47.16.64])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7RNjVIT028412
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2007 17:45:31 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: August 27, 2007 Meeting Minutes
Attendees: Mingming Cao, Takashi Sato, Dave Kleikamp, Ted T'so, Jose 
Santos, Andreas Dilger, Avantika Mathur

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

E2fsprogs
- Ted has started working on extents support in e2fsprogs; and will try 
to send these patches out before kernel summit.
- Valerie has a cleanup patch which will be posted the mailing list this 
week.

Kernel Patches
- Preallocation: This feature is in 2.6.23-rc1, but ia64 and s390 
architectures still need support for the system call.  Mingming will ask 
the architecture maintainers to add this support.

- Inode Version: The overwrite case still needs to be addressed.  Calls 
to ext4_mark_inode_dirty() still depend on changes to the timestamp.  
The plan is to update the i_version on every call to file_update_time(); 
and add a mountoption and flag to the superblock so the update is only 
made if i_version is enabled and filesystems not using the feature are 
not affected.

- Delayed / Multiple Block Allocation: Both patches are in the patch 
queue.  Mingming was wondering which feature should be pushed first.  
Both patches need to be posted for review.  The delayed allocation 
patches should not be pushed through the ext4 tree, but rather through 
the -mm tree.
 
- Uninitialized block groups: Avantika sent out an updated patch which 
is ready to be merged to the patch queue.

- Flexible Block Groups - Jose had sent an email with questions and 
details for plans for the feature.  He has decided not to use 
uninitialized inode tables, and will be sending out another email to the 
list with more details about the future plans for this feature..

Automated Testing
- Avantika has a set of automated tests that run whenever the 
ext4-patch-queue is updated.  She will change the scripts to kick off 
two suites; one only testing the stable patches in the queue, and one 
testing the entire patch queue
