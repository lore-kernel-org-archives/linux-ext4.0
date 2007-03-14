From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 21:30:58 -0500
Message-ID: <1173839458.8125.5.camel@kleikamp.austin.ibm.com>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
	 <45F6BDC9.8080205@redhat.com>
	 <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
	 <20070313170748.3e0bb466.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	astralstorm@gmail.com, kalpak@clusterfs.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:37776 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811AbXCNCbC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2007 22:31:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2E2V1lM014580
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 22:31:01 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2E2V1kM062282
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 20:31:01 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2E2V00X030788
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 20:31:00 -0600
In-Reply-To: <20070313170748.3e0bb466.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-03-13 at 17:07 -0800, Andrew Morton wrote:
> > On Tue, 13 Mar 2007 10:29:05 -0500 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> > On Tue, 2007-03-13 at 10:05 -0500, Eric Sandeen wrote:
> .
> > > There were later patches posted to the list after this version, I think, which
> > > are not yet in Ted's tree... I'll find some time today to test the "take3" version
> > > on x86_64, unless someone beats me to it.
> > 
> > I didn't quite beat you to it, but I did make a diff to bring
> > 2.6.21-rc3-mm1 in tune with the "take3" patch.  It makes the code easier
> > to understand, but I'm not sure if it contains anything to fix the bug.
> > Code inspection hasn't gotten me any closer to figuring out what's
> > wrong.
> > 
> > Shaggy
> 
> It's possible that I screwed up merging Ted's tree into mainline - it spat
> some rejects, and needs updating to 2.6.21-rc3.

I think your merge of Ted's tree is okay, although his tree could use
some cleanup.  The patch Eric sent on top of mine should clear up this
problem.  I'll try to get Ted's tree up to date, or find someone with
some more spare time to take over maintenance.
-- 
David Kleikamp
IBM Linux Technology Center
