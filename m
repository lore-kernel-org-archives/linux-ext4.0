From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse
 range
Date: Fri, 18 Apr 2014 10:56:40 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404181056260.2128@localhost.localdomain>
References: <002d01cf59d4$c9a07a30$5ce16e90$@samsung.com> <003101cf59d5$cf1798d0$6d46ca70$@samsung.com> <alpine.LFD.2.00.1404171004250.2143@localhost.localdomain> <002101cf5ac7$76d97bf0$648c73d0$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1389744637-1397811403=:2128"
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaDRI4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 04:56:46 -0400
In-Reply-To: <002101cf5ac7$76d97bf0$648c73d0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1389744637-1397811403=:2128
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Fri, 18 Apr 2014, Namjae Jeon wrote:

> Date: Fri, 18 Apr 2014 14:31:35 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: 'Luká¹ Czerner' <lczerner@redhat.com>
> Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>
> Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse
>      range
> 
> > On Thu, 17 Apr 2014, Namjae Jeon wrote:
> > 
> > > Date: Thu, 17 Apr 2014 09:41:45 +0900
> > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > To: Luká¹ Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4 <linux-ext4@vger.kernel.org>
> > > Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse
> > >      range
> > >
> > > >
> > > > We're already calling truncate_pagecache_range() before we attempt to
> > > > do any actual job so there is not need to truncate pagecache once more
> > > > using truncate_setsize() after we're finished.
> > > >
> > > > Remove truncate_setsize() and replace it just with i_size_write() note
> > > > that we're holding appropriate locks.
> > > >
> > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > >
> > > Hi Lukas.
> > >
> > > I added this code by getting rewiew from Hugh.
> > > Plz see the disscusion beween Hugh and Dave.
> > >
> > > Hugh: But your case is different: collapse is much closer to truncation,
> > >  and if you do not unmap the private COW'ed pages, then pages left
> > >  behind beyond the EOF will break the spec that requires SIGBUS when
> > >  touching there, and pages within EOF will be confusingly derived
> > >  from file data now belonging to another offset or none (move these
> > >  pages within the user address space? no, I don't think anon_vmas
> > >  would allow that, and there may be no right place to move them).
> > >
> > > Dave: See above - we never leave pages beyond the new EOF because setting
> > >  the new EOF is a truncate operation that calls
> > >  truncate_setsize(inode, newsize).
> > >
> > > Hugh: Right, thanks, I now see the truncate_setsize() in the xfs case -
> > >  though not in the ext4 case, which looks as if it's just doing an
> > >  i_size_write() afterwards.
> > >
> > > Dave: So that's a bug in the ext4 code ;)
> > >
> > > truncate_setsize is not needed in case Hugh pointed out ?
> > >
> > > Thanks!
> > 
> > That is true, we need to make sure that the page cache is coherent
> > with what's on disk. But we've already done that before releasing
> > the blocks. As I mention in the comment we're doing
> > truncate_pagecache_range() before removing any space. That's exactly
> > how it's supposed to be used. See comment in
> > truncate_pagecache_range().
> > 
> > However as I noticed we do not actually need to use
> > truncate_pagecache_range(), but rather truncate_pagecache() so I can
> > change that in my patch.
> Hi Lukas.
> 
> Will you change that in your patch ?
> Actually, I am waiting for this one..
> Thanks.

Ah, sorry about that. I'll resend.

-Lukas

> > 
> > Does that make sense to everyone ?
> > 
> > Thanks!
> > -Lukas
> 
> 
--8323328-1389744637-1397811403=:2128--
