From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Fw: Re: 2.6.21-rc3-mm1
Date: Tue, 13 Mar 2007 21:57:17 -0800
Message-ID: <1173851838.4361.29.camel@localhost.localdomain>
References: <20070312220426.2b1d7aaa.akpm@linux-foundation.org>
	 <45F6BDC9.8080205@redhat.com>
	 <1173799745.9662.4.camel@kleikamp.austin.ibm.com>
	 <20070313170748.3e0bb466.akpm@linux-foundation.org>
	 <1173839458.8125.5.camel@kleikamp.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, astralstorm@gmail.com,
	kalpak@clusterfs.com
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58285 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964953AbXCNF5V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2007 01:57:21 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2E5vKC9013521
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2007 01:57:20 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2E5vKKt056516
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 23:57:20 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2E5vJKg014252
	for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2007 23:57:20 -0600
In-Reply-To: <1173839458.8125.5.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-03-13 at 21:30 -0500, Dave Kleikamp wrote:
> On Tue, 2007-03-13 at 17:07 -0800, Andrew Morton wrote:
> > > On Tue, 13 Mar 2007 10:29:05 -0500 Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> > > On Tue, 2007-03-13 at 10:05 -0500, Eric Sandeen wrote:
> > .
> > > > There were later patches posted to the list after this version, I think, which
> > > > are not yet in Ted's tree... I'll find some time today to test the "take3" version
> > > > on x86_64, unless someone beats me to it.
> > > 
> > > I didn't quite beat you to it, but I did make a diff to bring
> > > 2.6.21-rc3-mm1 in tune with the "take3" patch.  It makes the code easier
> > > to understand, but I'm not sure if it contains anything to fix the bug.
> > > Code inspection hasn't gotten me any closer to figuring out what's
> > > wrong.
> > > 
> > > Shaggy
> > 
> > It's possible that I screwed up merging Ted's tree into mainline - it spat
> > some rejects, and needs updating to 2.6.21-rc3.
> 
> I think your merge of Ted's tree is okay, although his tree could use
> some cleanup.  The patch Eric sent on top of mine should clear up this
> problem.  I'll try to get Ted's tree up to date, or find someone with
> some more spare time to take over maintenance.

I would help maintain the tree, it does needs a fair amount of work and
time.  Ted has already started looking at using ABAT to automate the
process of testing the ext4 git tree on all arch. This seems worth
invest some time on this.  Currently it seems he has been extremely busy
with other duties so I am trying to help on this first.

Mingming
