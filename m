From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12829] kernel complains on ENOSPC
Date: Sun,  8 Mar 2009 22:17:01 -0700 (PDT)
Message-ID: <20090309051701.C6465108040@picon.linux-foundation.org>
References: <bug-12829-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbZCIFRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 01:17:33 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n295H2Yu024732
	for <linux-ext4@vger.kernel.org>; Sun, 8 Mar 2009 22:17:03 -0700
In-Reply-To: <bug-12829-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829





------- Comment #3 from aneesh.kumar@linux.vnet.ibm.com  2009-03-08 22:17 -------
On Fri, Mar 06, 2009 at 03:02:21PM -0800, bugme-daemon@bugzilla.kernel.org
wrote:
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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
