From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12829] kernel complains on ENOSPC
Date: Mon, 9 Mar 2009 10:46:45 +0530
Message-ID: <20090309051645.GB26853@skywalker>
References: <bug-12829-13602@http.bugzilla.kernel.org/> <20090306230222.2732110800D@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56253 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZCIFQx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 01:16:53 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n295GlaU012358
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 10:46:47 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n295GsK34124686
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 10:46:54 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id n295Gkd9012441
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 16:16:46 +1100
Content-Disposition: inline
In-Reply-To: <20090306230222.2732110800D@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 06, 2009 at 03:02:21PM -0800, bugme-daemon@bugzilla.kernel.org wrote:
> 
> 
> ------- Comment #1 from tytso@mit.edu  2009-03-06 15:02 -------
> What are the precise reproduction details?   We're supposed to keep track of
> how many delayed allocation blocks are outstanding, so that we return ENOSPC
> *before* we get to this stage.

Yes. We should not get the ENOSPC during writeback. That would imply the
block reservation is going wrong.

> 
> I'm not sure we do the right thing if we mmap into an unallocated region of
> file; when do we actually track delayed allocation blocks?   The right answer
> would be at mmap() time, but OTOH that means if we mmap a 2GB region, do we
> immediately take a 2GB charge because the process might write into this region?
>  And does free space returned by 'df' immediately drop by 2GB?


For mmap block reservation is doing during page_mkwrite.

> 
> Do you know if there was any allocation by mmap going on in your reproduction
> case?   That seems the most likely cause to me, if I had to guess....
> 

-aneesh
