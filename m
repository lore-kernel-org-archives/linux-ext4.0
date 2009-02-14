From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Sat, 14 Feb 2009 13:36:40 +0530
Message-ID: <20090214080640.GA22585@skywalker>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090213220606.AE8FC11D109@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:47349 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZBNIGt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2009 03:06:49 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id n1E86jDF011545
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 13:36:45 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1E84Bfj4300882
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 13:34:11 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n1E86iwA029434
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 13:36:44 +0530
Content-Disposition: inline
In-Reply-To: <20090213220606.AE8FC11D109@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 13, 2009 at 02:06:06PM -0800, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12579
> 
> 
> 
> 
> 
> ------- Comment #8 from sandeen@redhat.com  2009-02-13 14:06 -------
> Created an attachment (id=20238)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=20238&action=view)
> Tested patch
> 
> Patch from Aneesh, un-whitespace-mangled.
> 
> Ted, can you push this out?  Works great.  :)  We might want to ask the other
> reporter of something similar (next-20090206: deadlock on ext4) to test it too.
>  I'll ping him.
> 

I think this small changes is also needed.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f743524..c80e038 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2495,7 +2495,10 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->range_end  = LLONG_MAX;
 		wbc->range_cyclic = 0;
 		range_cyclic = 1;
-		cycled = 0;
+		if (index == 0)
+			cycled = 1;
+		else
+			cycled = 0;
 	} else
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
