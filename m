From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] update ext4-nanosecond-patch comments
Date: Tue, 29 May 2007 17:57:43 +0530
Message-ID: <465C1C3F.6030303@linux.vnet.ibm.com>
References: <20070529054822.GA14186@skywalker.home.org> <1180420717.4339.8.camel@garfield> <465BE1CF.2040304@linux.vnet.ibm.com> <20070529115327.GY5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:53068 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXE2M2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 08:28:00 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4TCTQCM6086838
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 22:29:31 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4TCVI74056316
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 22:31:18 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4TCRkwo017388
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 22:27:46 +1000
In-Reply-To: <20070529115327.GY5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On May 29, 2007  13:48 +0530, Aneesh Kumar K.V wrote:
>>
> 
> When the nanosecond timestamp extension was first proposed, the requirement
> from Ted and Stephen were that s_min_extra_isize was a requirement.  Otherwise
> it would be possible to have a filesystem where the timestamps are going
> backward on some files due to MOST of the files supporting ns timestamps,
> but some with full EAs having to truncate the ns part away.
> 
> Now, this might not be critical for some users, but for others it can be.
> Since this functionality is all here there isn't any reason to move it to
> a separate patch.  The same fields will be important for the inode version
> also.
>

That is why i was thinking it should not be buried in the nanosecond 
patch. Since there are multiple features depending on this, a nice patch 
list would be

Add extra fields to superblock to take care of enabling feature after 
file system creation

Add nano second feature

Add inode version feature

etc.

If wanted, i can attempt to split the patch as above. Let me know. If we 
don't think the above is important I would say we should at least move 
some of the commit message found in expand_inode_extra_isize.patch that 
explains the usage to the patch that introduce these fields (nano second 
patch ).

-aneesh
