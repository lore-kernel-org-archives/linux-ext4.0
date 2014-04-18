From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
 __es_remove_extent()
Date: Fri, 18 Apr 2014 13:24:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404181323100.2128@localhost.localdomain>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com> <20140417161944.GJ18591@thunk.org> <alpine.LFD.2.00.1404181058230.2128@localhost.localdomain> <20140418111826.GA26437@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-138516155-1397820246=:2128"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDRLYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 07:24:07 -0400
In-Reply-To: <20140418111826.GA26437@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-138516155-1397820246=:2128
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 18 Apr 2014, Theodore Ts'o wrote:

> Date: Fri, 18 Apr 2014 07:18:26 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
>     __es_remove_extent()
> 
> On Fri, Apr 18, 2014 at 11:22:12AM +0200, Lukáš Czerner wrote:
> > Aside from the fact that this is totally undocumented and there is
> > not even comment on what is that all about in couple of years we
> > might actually get file systems big enough that this would not be an
> > I/O error anymore (that might be a bit of a stretch).
> 
> Well, do you have some suggestions about what might be a good place to
> document something like this?  My assumption is that it's something
> that would be used by developers after a bug had been reported, so
> presumably it would be someplace in the source code.
> 
> And I used "0x7FDEADBEEF" deliberately so that it would be a extremely
> unlikely we would have file systems that big (we're approximately 512
> PB, and honestly, if we had fixed all of the scaling limits such that
> it was sane to think someone would want to be using ext4 with a file
> system that big --- well, that would be a very nice problem to have
> :-)

Indeed :)

> 
> > But mainly this value is only going to be used if it is delayed
> > extent or a hole which implies that it has not been mapped and
> > pblock does not contain anything valid. And if we really screwed it
> > up and tried to use pblock of extent which is a hole or delayed
> > extent, then it would not help us anyway since the only place that
> > we actually set this is when splitting extent on removal.
> > 
> > Now I can see that in ext4_da_map_blocks() we're actually using ~0
> > value for the pblock which is a bit better I think as long as we're
> > using this reliably. So I'll resend the patch which will make sure
> > that we're using ~0 reliably when storin delayed, or hole extents in
> > the extent status tree. Does that make sense ?
> 
> So the technique that we're using in mballoc.c is that we use
> different illegal flag values depending on where the bad value was
> introduced:
> 
> % grep "debug value" fs/ext4/mballoc.c
> 	ex.fe_logical = 0xDEADFA11; /* debug value */
> 		ex.fe_logical = 0xDEADC0DE; /* debug value */
> 				ex.fe_logical = 0xDEADF00D; /* debug value */
> 
> I think it might be useful to do the same for the physical blocks in
> the extent_status tree.
> 
> 	  				- Ted

I agree. I'll send a patch.

Thanks!
-Lukas
--8323328-138516155-1397820246=:2128--
