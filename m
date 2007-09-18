From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (September 17, 2007)
Date: Tue, 18 Sep 2007 10:10:49 -0700
Message-ID: <46F00699.5010400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36283 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251AbXIRRJx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 13:09:53 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8IH9qJe022725
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2007 13:09:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8IH9qee684696
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2007 13:09:52 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8IH9qKt001769
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2007 13:09:52 -0400
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l8IH9p1f001729
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2007 13:09:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: September 17, 2007 meeting minutes
Attendees: Mingming Cao, Andreas Dilger, Eric Sandeen, Dave Kleikamp, 
Ted Ts'o,
Avantika Mathur

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

PATCH QUEUE:
Reviewed patches in the patch queue, identifying those that are ready to 
be merged with 2.6.24-rc1

- Journal_Checksum: Not yet ready for mainline, Avantika and Girish are 
looking into kernel oops on fsstress.

- Uninitialized Block Groups:  Ready to be pushed upstream, Avantika 
will post this patch to lkml

- Large Block Support: Mingming tested these patches on various 
architectures.  There should be new testcases added to e2fsprogs to test 
large block sizes.  Andreas also described a possible error case with 
empty directories.  Otherwise the feature is ready to be pushed to lkml

- JBD Cleanups:  Ready to be pushed upstream

- Flex_BG Patches: should be pushed upstream asap.  The required flag in 
e2fsprogs is already reserved for this feature.

- Delalloc: Patch should be sent to lkml for detailed review, since not 
only ext4 code is being touched. Delalloc will be pushed with the other 
patches that are  being pushed upstream now.
    - Shaggy will look into whether the delalloc framework can be used 
for JFS
    - We will also try porting the patch to ext3, with a search/replace, 
and try testing on ext3.

- Mballoc: Not ready for 2.6.23. We will wait for the next release, as 
it hasn't been in the patch queue for very  long.  The main issue is to 
break the patch into smaller pieces making it easier to understand.  
This is tricky to break such a large patch into smaller patches.

- Mingming will re-order the patch queue, putting the patches that are 
ready to be pushed upstream at the top.

E2FSPROGS:
- Ted sent out his initial extents support patches to the mailing list; 
he is continuing on ToDo items which includes a lot of error checking, 
and waiting for feedback on the patches.   In his patches, any knowledge 
of the on-disk format of the filesystem is isolated to a small part of 
the library, making it easier to change format in the future.

- 64-bit support in e2fsprogs is background priority, while adding 
support for other ext4 features (e.g. unintialized block groups) is 
higher priority right now.  Some of Valerie's pre-work/cleanup patches 
are ready to be merged now.

- Avantika and Aneesh are working on automated testing of e2fsprogs.
