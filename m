From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Patch collision: 64-bit quota changes and ext4 delalloc quota
	changs
Date: Wed, 05 Nov 2008 10:59:38 -0800
Message-ID: <1225911578.6333.7.camel@mingming-laptop>
References: <E1Kxkwt-0007Np-O4@closure.thunk.org>
	 <20081105084303.ed0c53d5.akpm@linux-foundation.org>
	 <20081105174026.GB29880@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:34389 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYKES7m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 13:59:42 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mA5IxAkn024638
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 11:59:10 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA5IxdSK123436
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 11:59:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA5Ix9DM015628
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 11:59:10 -0700
In-Reply-To: <20081105174026.GB29880@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-11-05 at 12:40 -0500, Theodore Tso wrote:
> On Wed, Nov 05, 2008 at 08:43:03AM -0800, Andrew Morton wrote:
> > 
> > It works for me.  I really need to get off my butt and get -mm into
> > linux-next.
> > 
> > I can merge ext4-quota-handling-for-delayed-allocation.patch if you
> > like, or you can merge it once te quota changes have gone in.
> > 
> 
> If you are willing to carry the
> ext4-quota-handling-for-delayed-allocation.patch, that would be great.
> 

I saw Andrew already picked up the ext4 quota changes. I will address
Andrew's comments soon. I assume I will working on incremental fixes to
address the comments? Or should I send new version of the series?

> Mingming, what I'll do is create a branch of the ext4 patch queue
> (since it's being maintained in git anyway), that basically reflects
> the patch queue as it currently exists today.  You can do your
> development in that branch so it won't impact you terribly, but I'll
> then set master branch of the ext4 patch queue to be a version that
> drops all of the quota related changes.  

Sure, that works for me. 


> But keeping this stuff all in -mm should work, although depending on
> how many more cleanup patches flow into ext4, this might cause some
> minor patch conflicts on that last quota dellaloc patch that actually
> touches ext4 core code.
> 

Since Andrew already picked up the ext4 quota changes, I will work
against mm tree then.


Mingming


