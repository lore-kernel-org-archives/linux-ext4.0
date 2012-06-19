From: Mike Snitzer <msnitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 09:30:42 -0400
Message-ID: <20120619133041.GB6811@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab2FSNaw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 09:30:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19 2012 at  9:25am -0400,
Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wrote:

> On Tue, 19 Jun 2012, Mike Snitzer wrote:
>=20
> > Date: Tue, 19 Jun 2012 09:16:49 -0400
> > From: Mike Snitzer <snitzer@redhat.com>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.or=
g>,
> >     device-mapper development <dm-devel@redhat.com>,
> >     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> > Subject: Re: Ext4 and xfs problems in dm-thin on allocation and dis=
card
> >=20
> > On Tue, Jun 19 2012 at  2:32am -0400,
> > Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wrote:
> >
> > > So do I understand correctly that even though the discard came
> > > through and thinp took advantage of it it still returns EOPNOTSUP=
P ?
> >=20
> > No, not correct.  Why are you assuming this?  I must be missing
> > something from this discussion that led you there.
>=20
> Those two paragraphs led me to that conclusion:
>=20
>   That message says the underlying device doesn't support discards
>   (because it is an MD device).  But the thinp device still has disca=
rds
>   enabled -- it just won't pass the discards down to the underlying d=
ata
>   device.
>=20
>   The discards still inform the thin-pool that the corresponding exte=
nts
>   are no longer allocated.
>=20
> so I am a bit confused now. Why the dm-thin returned EOPNOTSUPP then
> ? Is that because it has been configured to ignore_discard, or it
> actually takes advantage of the discard but underlying device does
> not support it (and no_discard_passdown is not set) so it return
> EOPNOTSUPP ?
>=20
> >=20
> > > This seems rather suboptimal. IIRC there was a discussion to add =
an
> > > option to enable/disable sending discard in thinp target down
> > > to the device.
> > >=20
> > > So maybe it might be a bit smarter than that and actually
> > > enable/disable discard pass through depending on the underlying
> > > support, so we do not blindly send discard down to the device eve=
n
> > > though it does not support it.
> >=20
> > Yes, that is what we did.
> >=20
> > Discards are enabled my default (including discard passdown), but i=
f the
> > underlying data device doesn't support discards then the discards w=
ill
> > not be passed down.
> >=20
> > And here are the feature controls that can be provided when loading=
 the
> > thin-pool's DM table:
> >=20
> > ignore_discard: disable discard
> > no_discard_passdown: don't pass discards down to the data device
> >=20
> > -EOPNOTSUPP is only ever returned if 'ignore_discard' is provided.
>=20
> Ok, so in this case 'ignore_discard' has been configured ?

I don't recall Spelic saying anything about EOPNOTSUPP.  So what has
made you zero in on an -EOPNOTSUPP return (which should not be
happening)?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
