From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Ext4 Patch Queue using stgit.
Date: Fri, 18 May 2007 18:12:23 +0530
Message-ID: <464D9F2F.3030904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:54233 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXERMmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 08:42:31 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4ID2Zdx255122
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 23:02:35 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4ICjw1Q108316
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 22:45:58 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4ICgQbZ023115
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 22:42:26 +1000
Received: from [9.124.216.157] ([9.124.216.157])
	by d23av04.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4ICgOKh023048
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 22:42:25 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

I was looking at ext4 patch queue and was wondering why we are  putting 
.patch under git. If we are looking for a quilt like functionality, one 
can achieve the same using stgit. I was using stgit to maintain a set of
patches before. So if you look at

http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=summary

you will see the patches i was working on with linus tree as from-linus. 
Now to find out what changes were made to these patches during the 
development one can look at the tracking branch. In the above case the 
latest tracking branch was 2.6.20-rc1-ci-to-linus

http://git.openssi.org/~kvaneesh/gitweb.cgi?h=2.6.20-rc1-ci-to-linus;p=ci-to-linus.git;a=shortlog

Other tracking branches at different development stages can be found at
http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=heads


This make looking at the diff much easier. diff of .patch does seems to 
be useful.

Only problem i can think of is how multiple people will push to the same 
repo.

-aneesh
