From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] ext4 for v2.6.32
Date: Fri, 25 Sep 2009 13:31:35 +0530
Message-ID: <20090925080135.GA15586@skywalker.linux.vnet.ibm.com>
References: <E1MohbG-0006qg-1y@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60676 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZIYIB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 04:01:56 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8P7xFx5028394
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 17:59:15 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8P81tB21065124
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 18:01:56 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8P81tSU016681
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 18:01:55 +1000
Content-Disposition: inline
In-Reply-To: <E1MohbG-0006qg-1y@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2009 at 01:50:26PM -0400, Theodore Ts'o wrote:
> Hi Linus, 
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab the following changes for v2.6.32.

.....
....

> 
> Frank Mayhar (1):
>       ext4: Make non-journal fsync work properly
> 

I had a review comment on this patch
http://article.gmane.org/gmane.comp.file-systems.ext4/15498

Frank agreed to send an updated patch
http://article.gmane.org/gmane.comp.file-systems.ext4/15499

But the comment is not critical. So should we do a new patch as a cleanup
or leave the change as it is now ?

-aneesh
