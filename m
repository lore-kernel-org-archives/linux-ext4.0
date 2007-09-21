From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patch format in ext4 patch queue.
Date: Fri, 21 Sep 2007 16:03:26 +0530
Message-ID: <46F39DF6.30402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59185 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbXIUKfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 06:35:30 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8LAZ89r010449
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 20:35:08 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8LAbRhP178260
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 20:37:27 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8LAWN1Y032022
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 20:32:23 +1000
Received: from [9.124.216.249] ([9.124.216.249])
	by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l8LAWMeU031739
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2007 20:32:22 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I was looking at the patch queue and see patches with different formats. 
If we can standardize on what rest of the linux kernel follows it would
be nice.

First line should be
<subsystem_name>: A single line description of the patch.
This appear in the subject line of the mail that results from different
commit list. 

eg: ext4: Uninitialized block group support


From: <Author of the patch>
This should be a valid email id. For example stgit checks for the 
author to be a valid email id. 


<Description of the fix>

Signed-off-by:
Reviewed-by:

What is missing in the patch queue is the First line for most of the patch.

Below is the steps i follow to manage patch queue.

One linux kernel repository:


[master@linux-review-ext4]$ git checkout -b review v2.6.23-rc6
Switched to a new branch "review"
[review@linux-review-ext4]$ stg init 
[review@linux-review-ext4]$ stg import --series /home/opensource/patches/ext4-patch-queue/series 

Now we should verify patches and make sure they look the way we wanted them in Linus tree by git log 

After:
stg pop -> similar to quilt pop
stg push -> similar to quilt push

To edit the commit message
stg edit 

To add sign-off or ack

stg edit --sign 
stg edit --ack

To change the author name
stg edit --author


Now once we are sure all are fine

stg export -d /home/new-patch-queue-set/

This should get a patch set with quilt series


To find stgit:

http://procode.org/stgit/


-aneesh 
