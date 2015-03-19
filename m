From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: fs corruption recovery
Date: Wed, 18 Mar 2015 17:56:31 -0700
Message-ID: <550A1EBF.2030902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jane@us.ibm.com, marcel.dufour@ca.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48827 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbCSA4p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2015 20:56:45 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Mar 2015 18:56:45 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 6A31F3E4003F
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2015 18:56:33 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2J0uQdf21037124
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2015 17:56:26 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2J0uWak024748
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2015 18:56:33 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've had some internal folks contact me for help with some customers 
that are having file system corruption woes.  It's been so long since 
I've done any work on ext3/4 code it's hard for me to advise.  So I told 
them I would run the situation by the folks on these mailing lists to 
see if I can generate some more ideas for them.

They have a 17 TB ext3 file system on rhel 6.5.  Upon reboot, the system 
was not able to come up and reported errors with the super block.  Right 
now, getting the machine to boot is not a critical as just recovering 
customer data.  They are able to boot a rescue disk to run fsck and they 
report that it ran for a short while and showed a lot of inode errors, 
but eventually it seg faulted.  They can re-run the tool, and they were 
able to progress further on repeated runs, but they do not seem to be 
able to get further than about 75%.  They do not have the fsck core at 
this point in time, but I'm guessing the tool is likely running out of 
memory for a file system that large, and they say they are using an old 
fsck (from 2010).  They report having run fsck successfully on large 
file systems in the past, but normally the machine has 24GB, and this 
one has only 16GB due to a bad dim.  The plan at the moment is for them 
to fix the bad dim and try the latest fsck.

So the questions they had that I am hoping to get help for is are there 
any other options they can try for data recovery?  I am hoping that the 
extra memory and the updated fsck might be able to complete, but I'm not 
sure what has changed in the tool since then.  I can assist them to 
collect more information/cores.  Any help is appreciated!  Thx!

Allison Henderson

