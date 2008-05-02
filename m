From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: start seraching for the right extent from the
	goal group.
Date: Fri, 02 May 2008 14:11:40 -0700
Message-ID: <1209762700.3609.9.camel@localhost.localdomain>
References: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <48186CFB.8050206@redhat.com>  <20080501153747.GA7005@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57567 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935073AbYEBVLy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2008 17:11:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m42LBowO018427
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:11:50 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m42LBoSP255408
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:11:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m42LBnqj017846
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:11:50 -0400
In-Reply-To: <20080501153747.GA7005@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-05-01 at 21:07 +0530, Aneesh Kumar K.V wrote:
> On Wed, Apr 30, 2008 at 07:58:35AM -0500, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > With mballoc we search for the best extent using different
> > > criteria. We should always use the goal group when we are
> > > starting with a new criteria.
> > 
> > Aneesh, is there any testcase etc that will demonstrate the resulting
> > difference in layout?
> > 
> > It's not clear to me from this changelog (without looking at a lot more
> > context) exactly what you're changing and why...
> 
> I don't have any specific test case.  With mballoc depending on the
> request size we follow different criteria to allocate blocks. For
> example if the size is stripe size multiple we use criteria 1 and start
> searching for the right blocks from block group starting with goal
> group. If we don't find right count of blocks, we use criteria 2 and start
> searching from the group block 0. I guess with criteria 2 also, we should start
> searching from the goal group so that when we find the right count of
> blocks we find them close to the goal group.
> 

Sounds reasoanble to me. I added this patch in the ext4 patch queue
> 
> -aneesh

