From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] update ext4-nanosecond-patch comments
Date: Tue, 29 May 2007 13:48:23 +0530
Message-ID: <465BE1CF.2040304@linux.vnet.ibm.com>
References: <20070529054822.GA14186@skywalker.home.org> <1180420717.4339.8.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:35056 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXE2ISt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 04:18:49 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4T8KGNs5316706
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 18:20:17 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4T8M3jO094558
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 18:22:06 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4T8ITqg001043
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 18:18:30 +1000
In-Reply-To: <1180420717.4339.8.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Kalpak Shah wrote:
> On Tue, 2007-05-29 at 11:18 +0530, Aneesh Kumar K.V wrote:
>> Also can we have a description of why s_{min, want}_extra_isize
>> fields are added in the commit message ?
> 
> The i_extra_isize for each inode should ideally be s_want_extra_isize
> after inode expansion. If expansion by s_want_extra_isize is not
> possible, then i_extra_isize must be atleast s_min_extra_isize.
> 
>

My point was that the commit message of ext4-nanosecond-patch should 
explain the usage scenario for these variables. We may want to move the
commit message of ext4_expand_inode_extra_isize.patch reworded to this.


BTW i also think that adding s_{min, want}_extra_isize can be a separate 
patch altogether.


-aneesh
