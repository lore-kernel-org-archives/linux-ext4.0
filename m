From: "Craske, Mark" <Mark_Craske@mentor.com>
Subject: RE: ext4: what are possible causes of "zero length extent" ?
Date: Fri, 1 Jul 2016 14:08:09 +0000
Message-ID: <FE37120F1498264DADC12DBE98488214990390F4@EU-MBX-01.mgc.mentorg.com>
References: <FE37120F1498264DADC12DBE984882149659843D@EU-MBX-01.mgc.mentorg.com>
 <FE37120F1498264DADC12DBE98488214965A2601@EU-MBX-01.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:60815 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcGAOvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2016 10:51:08 -0400
In-Reply-To: <FE37120F1498264DADC12DBE98488214965A2601@EU-MBX-01.mgc.mentorg.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted and Andreas,

Is https://github.com/torvalds/linux/commit/d2dc317d564a46dfc683978a2e5=
a4f91434e9711
"ext4: fix data corruption caused by unwritten and delayed extents"
a fix for one of the causes of "zero length extent"?

Regards,
Mark Craske
Embedded Software Engineer
Linux Transportation Solutions=20

Mentor Graphics (UK) Ltd., Rivergate,=A0Newbury Business Park, London R=
oad, Newbury, RG14 2QB, UK
=A0
Tel: +44 (0)1635 81 1436
Mobile : +44 (0)7900 008 230
E-mail : Mark_Craske@mentor.com
Yahoo-IM: mcraske_uk=A0=A0 Skype: mcraske_uk


> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> owner@vger.kernel.org] On Behalf Of Craske, Mark
> Sent: 23 May 2016 11:49
> To: linux-ext4@vger.kernel.org; Theodore Ts'o; Andreas Dilger
> Subject: RE: ext4: what are possible causes of "zero length extent" ?
>=20
> Hello Ted and Andreas,
>=20
> We are still getting instances of "zero length extent" ext4 file syst=
em
> corruptions.
> Are there any know causes, and are any of those fixes by upstream ker=
nel
> patches?
>=20
> Regards,
> Mark Craske
> Embedded Software Engineer
> Linux Transportation Solutions
>=20
> Mentor Graphics (UK) Ltd., Rivergate,=A0Newbury Business Park, London=
 Road,
> Newbury, RG14 2QB, UK
>=20
> Tel: +44 (0)1635 81 1436
> Mobile : +44 (0)7900 008 230
> E-mail : Mark_Craske@mentor.com
> Yahoo-IM: mcraske_uk=A0=A0 Skype: mcraske_uk
>=20
> > -----Original Message-----
> > From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> > owner@vger.kernel.org] On Behalf Of Craske, Mark
> > Sent: 11 May 2016 11:22
> > To: linux-ext4@vger.kernel.org; Theodore Ts'o; Andreas Dilger
> > Subject: ext4: what are possible causes of "zero length extent" ?
> >
> > Hello ext4 maintainers,
> >
> > This is somewhat of a follow-on from the "ext4 filesystem bad exten=
t
> > error review"
> > thread from 2014.
> >
> > Embedded system with main SoC Freescale i.MX6(ARM cortex A9), dual
> > CPU, running kernel 3.8.13.28, storage device is eMMC.
> > This still suffers from "zero length extent" ext4 file system corru=
ptions.
> >
> > I looked for upstream patches, but did not find any that explicitly
> > fix "zero length extent"
> > problems apart from "2f97486 ext4: check for zero length extent exp=
licitly".
> > That patch prevents the kernel panics but makes the affected file
> > unreadable and unremovable, which can be fixed by running fsck.
> >
> > What are possible causes of "zero length extent", and are there
> > upstream patches that actually deal with some of those?
> >
> > Regards,
> > Mark Craske
> > Mentor Graphics (UK) Ltd.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
