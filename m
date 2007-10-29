From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (October 29, 2007)
Date: Mon, 29 Oct 2007 12:43:07 -0700
Message-ID: <472637CB.5070100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50372 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbXJ2Tl4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2007 15:41:56 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9TJfuCN002217
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:41:56 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9TJfu75139038
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:41:56 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9TJft1e013126
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:41:55 -0400
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9TJftRg013095
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:41:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call
October 29, 2007: Meeting Minutes

Attendees: Mingming Cao, Aneesh Veetil, Coly Li, Takashi Sato, Jean 
Pierre Dion, Avantika Mathur

We had a short meeting today.

Fragmentation issues with Delayed Allocation
- without delalloc the reservation window is discarded at file close 
time. With delalloc enabled some pages are still dirty in cache so we 
can't discard the reservation right at file close.  Aneesh is looking 
into when to call ext4_discard_reservation() when delalloc is enabled.  
If the reservation is discarded too early, there could be file 
fragmentation, if it is discarded late the files could be spread across 
the filesystem.
- This discussion will be continued on the mailing list.

- Takashi is planning to merge his online defragmentation patches into 
ext4-git tree.  He recently ran into a new data corruption problem.  
Once he fixes this problem he will send out the patches.

- Large files: Aneesh is planning to do some more needed testing.

- Today Coly will be sendng his directory inode reservation patches 
which fix readdir performance issues.  These patches do not modify 
on-disk format; and have not yet been performance tested.

- Mingming will add Jean Noel's new i_version patches to the queue today
