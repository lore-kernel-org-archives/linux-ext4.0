From: "Craske, Mark" <Mark_Craske@mentor.com>
Subject: RE: ext4: what are possible causes of "zero length extent" ?
Date: Mon, 23 May 2016 10:48:35 +0000
Message-ID: <FE37120F1498264DADC12DBE98488214965A2601@EU-MBX-01.mgc.mentorg.com>
References: <FE37120F1498264DADC12DBE984882149659843D@EU-MBX-01.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:35354 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcEWKsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2016 06:48:39 -0400
In-Reply-To: <FE37120F1498264DADC12DBE984882149659843D@EU-MBX-01.mgc.mentorg.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted and Andreas,

We are still getting instances of "zero length extent" ext4 file system=
 corruptions.
Are there any know causes, and are any of those fixes by upstream kerne=
l patches?

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
> Sent: 11 May 2016 11:22
> To: linux-ext4@vger.kernel.org; Theodore Ts'o; Andreas Dilger
> Subject: ext4: what are possible causes of "zero length extent" ?
>=20
> Hello ext4 maintainers,
>=20
> This is somewhat of a follow-on from the "ext4 filesystem bad extent =
error
> review"
> thread from 2014.
>=20
> Embedded system with main SoC Freescale i.MX6(ARM cortex A9), dual CP=
U,
> running kernel 3.8.13.28, storage device is eMMC.
> This still suffers from "zero length extent" ext4 file system corrupt=
ions.
>=20
> I looked for upstream patches, but did not find any that explicitly f=
ix "zero
> length extent"
> problems apart from "2f97486 ext4: check for zero length extent expli=
citly".
> That patch prevents the kernel panics but makes the affected file unr=
eadable
> and unremovable, which can be fixed by running fsck.
>=20
> What are possible causes of "zero length extent", and are there upstr=
eam
> patches that actually deal with some of those?
>=20
> Regards,
> Mark Craske
> Mentor Graphics (UK) Ltd.
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
