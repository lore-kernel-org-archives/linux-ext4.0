From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Sat, 14 Feb 2009 15:11:01 +0530
Message-ID: <20090214094101.GD22585@skywalker>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090213220606.AE8FC11D109@picon.linux-foundation.org> <20090214015018.GB26628@mini-me.lan> <20090214084004.GC22585@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50041 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZBNJlb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2009 04:41:31 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1E9fBbv031460
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 20:41:11 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1E9fPTW389134
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 20:41:29 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1E9fOqQ027382
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 20:41:24 +1100
Content-Disposition: inline
In-Reply-To: <20090214084004.GC22585@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 14, 2009 at 02:10:04PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Feb 13, 2009 at 08:50:18PM -0500, Theodore Tso wrote:
> > > Patch from Aneesh, un-whitespace-mangled.
> > > 
> > > Ted, can you push this out?  Works great.  :) We might want to ask
> > > the other reporter of something similar (next-20090206: deadlock on
> > > ext4) to test it too.  I'll ping him.
> > 
> > Do we completely understand the root cause, in terms of which commit
> > broken the mm/page-writeback.c code we were depending on?  And if so,
> > what of the code in mm/page-writeback.c?  Does anyone else use it?
> > Can anyone sanely use it?
> 
> AFAIU we need the changes even for older kernels. The
> reasoning is, with delayed allocation we cannot allow to retry with lower
> page index in write_cache_pages. We do retry even in older version of
> kernel. What made it so easy to reproduce it on later kernels is that
> we were doing a retry even if nr_to_write was zero. This got fixed on
> mainline by 3a4c6800f31ea8395628af5e7e490270ee5d0585. So with that
> change we are logically back to 2.6.28 state, But still the possibility
> of deadlock remain.
> 

I found commit 31a12666d8f0c22235297e1c1575f82061480029 to be the root
cause. The commit is correct in what it does. Ext4 was dependent on the
wrong behaviour. The relevant change is 

@@ -897,7 +903,6 @@ retry:
                                              min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
                unsigned i;
 
-               scanned = 1;
                for (i = 0; i < nr_pages; i++) {


I think that caused us the retry. That would imply we may not need the
patch I did for 2.6.28. But given that Ext4 was dependent on the wrong
behaviour of write_cache_pages i would suggest we still push the patch
to 2.6.28

-aneesh
