From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
 __es_remove_extent()
Date: Fri, 18 Apr 2014 07:18:26 -0400
Message-ID: <20140418111826.GA26437@thunk.org>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
 <20140417161944.GJ18591@thunk.org>
 <alpine.LFD.2.00.1404181058230.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59632 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRLSa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 07:18:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404181058230.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 18, 2014 at 11:22:12AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Aside from the fact that this is totally undocumented and there is
> not even comment on what is that all about in couple of years we
> might actually get file systems big enough that this would not be an
> I/O error anymore (that might be a bit of a stretch).

Well, do you have some suggestions about what might be a good place to
document something like this?  My assumption is that it's something
that would be used by developers after a bug had been reported, so
presumably it would be someplace in the source code.

And I used "0x7FDEADBEEF" deliberately so that it would be a extremely
unlikely we would have file systems that big (we're approximately 512
PB, and honestly, if we had fixed all of the scaling limits such that
it was sane to think someone would want to be using ext4 with a file
system that big --- well, that would be a very nice problem to have
:-)

> But mainly this value is only going to be used if it is delayed
> extent or a hole which implies that it has not been mapped and
> pblock does not contain anything valid. And if we really screwed it
> up and tried to use pblock of extent which is a hole or delayed
> extent, then it would not help us anyway since the only place that
> we actually set this is when splitting extent on removal.
>=20
> Now I can see that in ext4_da_map_blocks() we're actually using ~0
> value for the pblock which is a bit better I think as long as we're
> using this reliably. So I'll resend the patch which will make sure
> that we're using ~0 reliably when storin delayed, or hole extents in
> the extent status tree. Does that make sense ?

So the technique that we're using in mballoc.c is that we use
different illegal flag values depending on where the bad value was
introduced:

% grep "debug value" fs/ext4/mballoc.c
	ex.fe_logical =3D 0xDEADFA11; /* debug value */
		ex.fe_logical =3D 0xDEADC0DE; /* debug value */
				ex.fe_logical =3D 0xDEADF00D; /* debug value */

I think it might be useful to do the same for the physical blocks in
the extent_status tree.

	  				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
