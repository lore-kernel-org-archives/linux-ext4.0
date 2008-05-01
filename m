From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: start seraching for the right extent from the
	goal group.
Date: Thu, 1 May 2008 21:07:47 +0530
Message-ID: <20080501153747.GA7005@skywalker>
References: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48186CFB.8050206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45059 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbYEAPiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2008 11:38:20 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m41Fbd15020737
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:37:39 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41FgFM3275386
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:42:15 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m41FcEah021102
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:38:15 +1000
Content-Disposition: inline
In-Reply-To: <48186CFB.8050206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2008 at 07:58:35AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > With mballoc we search for the best extent using different
> > criteria. We should always use the goal group when we are
> > starting with a new criteria.
> 
> Aneesh, is there any testcase etc that will demonstrate the resulting
> difference in layout?
> 
> It's not clear to me from this changelog (without looking at a lot more
> context) exactly what you're changing and why...

I don't have any specific test case.  With mballoc depending on the
request size we follow different criteria to allocate blocks. For
example if the size is stripe size multiple we use criteria 1 and start
searching for the right blocks from block group starting with goal
group. If we don't find right count of blocks, we use criteria 2 and start
searching from the group block 0. I guess with criteria 2 also, we should start
searching from the goal group so that when we find the right count of
blocks we find them close to the goal group.


-aneesh
