From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: 2.6.25-rc8-mm2
Date: Sun, 13 Apr 2008 00:13:17 +0530
Message-ID: <20080412184317.GB18122@skywalker>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411134036.GB3821@cs181133002.pp.htv.fi> <20080411212222.b3c1177e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-m68k@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:38950 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYDLSnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2008 14:43:33 -0400
Content-Disposition: inline
In-Reply-To: <20080411212222.b3c1177e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2008 at 09:22:22PM -0700, Andrew Morton wrote:
> On Fri, 11 Apr 2008 16:40:36 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.25-rc8-mm1:
> > >...
> > > +ext4-is-busted-on-m68k.patch
> > > 
> > >  ext4 doesn't build on m68k
> > >...
> > 
> > Is this due to the generic_find_next_le_bit compile error I reported as 
> > 2.6.25 regression (there seems to be some discussion recently how to 
> > fix it - hopefully for 2.6.25) or is there even more breakage in -mm?
> 
> Yes, it's the bitops screwup.
> 
> I saw some related linux-ext4 email float past yesterday, so something
> might be happening.
> 

It would really help if we can get some m68k people to look at patch
i posted.

http://article.gmane.org/gmane.comp.file-systems.ext4/5944


-aneesh
