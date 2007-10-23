From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (October 22, 2007)
Date: Tue, 23 Oct 2007 14:07:05 -0700
Message-ID: <471E6279.2000603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39068 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXJWVGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2007 17:06:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9NL5uD1000738
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 17:05:56 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9NL5uIO110126
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 17:05:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9NL5uM5002645
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 17:05:56 -0400
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9NL5tAg002602
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 17:05:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call
October 22, 2007: Meeting Minutes

Attendees: Mingming Cao, Andreas Dilger, Eric Sandeen, Dave Kleikamp, 
Jose Santos, Aneesh Veetil, Valerie Clement, Avantika Mathur

- There has been discussion on linux-ext4 about overflow in ext2 with 64 
KB block size.  Discussed adding an incompat flag to this feature and 
concluded that it is too late to do this; it will be treated as a bug fix.

Patch Status: patches that were not picked up to mainline in the recent 
pull:
- journal_checksum patches - the fsstress kernel oops is not yet 
resolved, Avantika will be working on this.
- i_version: Jean-Noel recently sent out an updated version which adds a 
lock every time i_version is updated.  Still waiting on more review
- mballoc - target for next kernel release. Remaining work:
    - Aneesh plans to run some performance test and include results in 
	the patch description.
    - Waiting for Alex to address the fixme's that aneesh has added to 
	the code, for more clarification.
- block groupdescriptor sync with e2fsprogs:
- Aneeesh recently posted patches which have been added to the patch queue.

E2fsprogs
- Ted has added new branches the the e2fsprogs git tree
    - master: current stable version
    - next: patches expected to go into the next stable version
    - pu: proposed update; patches that are in preliminary review and 
	test phase
- E2fsprogs patches should probably be submitted against the 'next' 
branch of the git tree.

- Aneesh was looking for patches to support mke2fs of large 
filesystems.  Valerie's old patches don't apply cleanly.

- Documentation in the kernel tree; ext4.txt is out of date and needs to 
be updated.

Performance:
- Andreas had asked Chris Mason to add ext4 to his BTRfs benchmarks. 
Chris Mason reported that ext4 is doing poorly on a test which performs 
kernel untar and compile on 20 kernels in a row.  The performance of 
ext4 on reads is poor compared to ext3.
- Eric will talk to Chris and get all of the details of the tests.
- Eric suggested enabling delalloc,mballoc mount options by default.  
The dellaloc option can then be disabled if the fs is not in writeback 
journaling mode.
