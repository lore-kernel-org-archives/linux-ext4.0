From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Sat, 14 Feb 2009 01:42:10 -0800 (PST)
Message-ID: <20090214094210.80B6611D10A@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbZBNJml (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Feb 2009 04:42:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E9gAPX007936
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 01:42:11 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #14 from aneesh.kumar@linux.vnet.ibm.com  2009-02-14 01:42 -------
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
                                              min(end - index,
(pgoff_t)PAGEVEC_SIZE-1) + 1))) {
                unsigned i;

-               scanned = 1;
                for (i = 0; i < nr_pages; i++) {


I think that caused us the retry. That would imply we may not need the
patch I did for 2.6.28. But given that Ext4 was dependent on the wrong
behaviour of write_cache_pages i would suggest we still push the patch
to 2.6.28

-aneesh


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
