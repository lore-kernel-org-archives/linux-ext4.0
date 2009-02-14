From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Sat, 14 Feb 2009 14:10:04 +0530
Message-ID: <20090214084004.GC22585@skywalker>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090213220606.AE8FC11D109@picon.linux-foundation.org> <20090214015018.GB26628@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41885 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZBNIkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2009 03:40:20 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1E8eIv3029808
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 19:40:18 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1E8eIAj1110204
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 19:40:18 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1E8eH79019752
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 19:40:18 +1100
Content-Disposition: inline
In-Reply-To: <20090214015018.GB26628@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 13, 2009 at 08:50:18PM -0500, Theodore Tso wrote:
> > Patch from Aneesh, un-whitespace-mangled.
> > 
> > Ted, can you push this out?  Works great.  :) We might want to ask
> > the other reporter of something similar (next-20090206: deadlock on
> > ext4) to test it too.  I'll ping him.
> 
> Do we completely understand the root cause, in terms of which commit
> broken the mm/page-writeback.c code we were depending on?  And if so,
> what of the code in mm/page-writeback.c?  Does anyone else use it?
> Can anyone sanely use it?

AFAIU we need the changes even for older kernels. The
reasoning is, with delayed allocation we cannot allow to retry with lower
page index in write_cache_pages. We do retry even in older version of
kernel. What made it so easy to reproduce it on later kernels is that
we were doing a retry even if nr_to_write was zero. This got fixed on
mainline by 3a4c6800f31ea8395628af5e7e490270ee5d0585. So with that
change we are logically back to 2.6.28 state, But still the possibility
of deadlock remain.

> 
> And am I right in assuming that this only applies to 2.6.29-rcX
> kernels, and is not needed for 2.6.28 or earlier kernels?

I guess the hang can happen on 2.6.28 or earlier kernels.

> 
> I hadn't yet pushed it out because I needed time to understand all of
> these issues, hence these questions....

-aneesh
