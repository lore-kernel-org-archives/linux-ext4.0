From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse
 range
Date: Fri, 18 Apr 2014 14:31:35 +0900
Message-ID: <002101cf5ac7$76d97bf0$648c73d0$@samsung.com>
References: <002d01cf59d4$c9a07a30$5ce16e90$@samsung.com>
 <003101cf59d5$cf1798d0$6d46ca70$@samsung.com>
 <alpine.LFD.2.00.1404171004250.2143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57583 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRFbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Apr 2014 01:31:37 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4700LYLOON5MD0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 18 Apr 2014 14:31:35 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1404171004250.2143@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, 17 Apr 2014, Namjae Jeon wrote:
>=20
> > Date: Thu, 17 Apr 2014 09:41:45 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Luk=E1=B9 Czerner <lczerner@redhat.com>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>
> > Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice =
in collapse
> >      range
> >
> > >
> > > We're already calling truncate_pagecache_range() before we attemp=
t to
> > > do any actual job so there is not need to truncate pagecache once=
 more
> > > using truncate_setsize() after we're finished.
> > >
> > > Remove truncate_setsize() and replace it just with i_size_write()=
 note
> > > that we're holding appropriate locks.
> > >
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> >
> > Hi Lukas.
> >
> > I added this code by getting rewiew from Hugh.
> > Plz see the disscusion beween Hugh and Dave.
> >
> > Hugh: But your case is different: collapse is much closer to trunca=
tion,
> >  and if you do not unmap the private COW'ed pages, then pages left
> >  behind beyond the EOF will break the spec that requires SIGBUS whe=
n
> >  touching there, and pages within EOF will be confusingly derived
> >  from file data now belonging to another offset or none (move these
> >  pages within the user address space? no, I don't think anon_vmas
> >  would allow that, and there may be no right place to move them).
> >
> > Dave: See above - we never leave pages beyond the new EOF because s=
etting
> >  the new EOF is a truncate operation that calls
> >  truncate_setsize(inode, newsize).
> >
> > Hugh: Right, thanks, I now see the truncate_setsize() in the xfs ca=
se -
> >  though not in the ext4 case, which looks as if it's just doing an
> >  i_size_write() afterwards.
> >
> > Dave: So that's a bug in the ext4 code ;)
> >
> > truncate_setsize is not needed in case Hugh pointed out ?
> >
> > Thanks!
>=20
> That is true, we need to make sure that the page cache is coherent
> with what's on disk. But we've already done that before releasing
> the blocks. As I mention in the comment we're doing
> truncate_pagecache_range() before removing any space. That's exactly
> how it's supposed to be used. See comment in
> truncate_pagecache_range().
>=20
> However as I noticed we do not actually need to use
> truncate_pagecache_range(), but rather truncate_pagecache() so I can
> change that in my patch.
Hi Lukas.

Will you change that in your patch ?
Actually, I am waiting for this one..
Thanks.
>=20
> Does that make sense to everyone ?
>=20
> Thanks!
> -Lukas

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
