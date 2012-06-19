From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 09:16:49 -0400
Message-ID: <20120619131649.GA6811@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2FSNRA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 09:17:00 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19 2012 at  2:32am -0400,
Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wrote:

> On Mon, 18 Jun 2012, Mike Snitzer wrote:
>=20
> > Date: Mon, 18 Jun 2012 23:12:42 -0400
> > From: Mike Snitzer <snitzer@redhat.com>
> > To: Dave Chinner <david@fromorbit.com>
> > Cc: Spelic <spelic@shiftmail.org>,
> >     device-mapper development <dm-devel@redhat.com>,
> >     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> > Subject: Re: Ext4 and xfs problems in dm-thin on allocation and dis=
card
> >=20
> > On Mon, Jun 18 2012 at  9:57pm -0400,
> > Dave Chinner <david@fromorbit.com> wrote:
> >=20
> > > On Mon, Jun 18, 2012 at 11:33:50PM +0200, Spelic wrote:
> > >
> > > > Please note that since I am above MD raid5 (I believe this is t=
he
> > > > reason), the passdown of discards does not work, as my dmesg sa=
ys:
> > > > [160508.497879] device-mapper: thin: Discard unsupported by dat=
a
> > > > device (dm-1): Disabling discard passdown.
> > > > but AFAIU, unless there is a thinp bug, this should not affect =
the
> > > > unmapping of thin blocks by fstrimming xfs... and in fact ext4 =
is
> > > > able to do that.
> > >=20
> > > Does ext4 report that same error?
> >=20
> > That message says the underlying device doesn't support discards
> > (because it is an MD device).  But the thinp device still has disca=
rds
> > enabled -- it just won't pass the discards down to the underlying d=
ata
> > device.
> >=20
> > So yes, it'll happen with ext4 -- it is generated when the thin-poo=
l
> > device is loaded (which happens independent of the filesystem that =
is
> > layered ontop).
> >=20
> > The discards still inform the thin-pool that the corresponding exte=
nts
> > are no longer allocated.
>=20
> So do I understand correctly that even though the discard came
> through and thinp took advantage of it it still returns EOPNOTSUPP ?

No, not correct.  Why are you assuming this?  I must be missing
something from this discussion that led you there.

> This seems rather suboptimal. IIRC there was a discussion to add an
> option to enable/disable sending discard in thinp target down
> to the device.
>=20
> So maybe it might be a bit smarter than that and actually
> enable/disable discard pass through depending on the underlying
> support, so we do not blindly send discard down to the device even
> though it does not support it.

Yes, that is what we did.

Discards are enabled my default (including discard passdown), but if th=
e
underlying data device doesn't support discards then the discards will
not be passed down.

And here are the feature controls that can be provided when loading the
thin-pool's DM table:

ignore_discard: disable discard
no_discard_passdown: don't pass discards down to the data device

-EOPNOTSUPP is only ever returned if 'ignore_discard' is provided.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
