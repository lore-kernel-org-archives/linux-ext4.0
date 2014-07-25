From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add support for FIDTRIM, a best-effort ioctl for deep discard trim
Date: Thu, 24 Jul 2014 21:46:38 -0600
Message-ID: <EFCA683A-25F1-4A58-9500-42E2FD044656@dilger.ca>
References: <1406159238-7557-1-git-send-email-jpa@google.com> <20140724120801.GA26465@dastard> <CAKP4w2TzDu6d=hK+21GnZU6Sd_gH8icJ=XA3q23Oa9Bd9fF6uA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3ACD3160-6D75-48A3-8179-F4A62325BDC3"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Geremy Condra <gcondra@google.com>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56264 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaGYDqn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 23:46:43 -0400
Received: by mail-pa0-f45.google.com with SMTP id eu11so5242700pac.32
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2014 20:46:42 -0700 (PDT)
In-Reply-To: <CAKP4w2TzDu6d=hK+21GnZU6Sd_gH8icJ=XA3q23Oa9Bd9fF6uA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3ACD3160-6D75-48A3-8179-F4A62325BDC3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 24, 2014, at 7:50 PM, JP Abgrall <jpa@google.com> wrote:
> On Thu, Jul 24, 2014 at 5:08 AM, Dave Chinner <david@fromorbit.com> =
wrote:
>>=20
>> On Wed, Jul 23, 2014 at 04:47:18PM -0700, JP Abgrall wrote:
>>> +#define FIDTRIM      _IOWR('X', 122, struct fstrim_range)    /* =
Deep discard trim */
>>=20
>> The 'X' ioctl namespace is actually XFS's ioctl namespace. FIDTRIM
>> should be in the 'f' namespace
>=20
> Ok.
> How should the next sequence number be handled?
> Go with ('f', 122,...) after FITRIM, or go with ('f', 12,...) after
> FS_IOC_FIEMAP ('f' namepsace)?

Please leave the low 'f' values for ext2/3/4 (where FS_IOC_[GS]ETFLAGS,
FS_IOC_[GS]ETFLAGS, and FS_IOC_FIEMAPand came from, and use high 'f'
numbers, maybe starting at 128 (?) for generic ioctl values.

Cheers, Andreas






--Apple-Mail=_3ACD3160-6D75-48A3-8179-F4A62325BDC3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9HTHnKl2rkXzB/gAQKzlg/+NkLJWqwiVgOqfZqwjblMoIaUJrzd9qg+
FEYF/hfP1yrtKF62frjRiXAGmVikOEnOGBL9yWU/XODooAgWTv0vze7afRYUdOZO
ehmh14JKd5iKDIp2Y3nRglsWwg18tpxUM4WJqk3qqvo2I/BgxsXn+EJ7TNe9MQ0u
W2NX/sPMJDI3I1xTTWPwazZBdUgL3nMeiBetMS2+2/hy+4CAZb/Tze5d0VX9FisI
cm/Vi0u9nTuZ+Hed0AkrjvbewSUARouzZsmSloLz7K4h/vVPx2aY9b6CTV4lIADd
9nArtaJ+3Y3wOH8gGIuX4uOOnBF1KKOlQ4JxBCN5IFjvNQf1QJZak3SHPLQFxVjg
FwGNiBabKqE8J6qw005skX8MMsa/IfOtFkNVhKRURGzIgjFrJuZk2FWMbN+RoZPP
GWOphfCa5OYBjvx/HFPxrofAtrYy1z00RKKJvWMHbyfsV4TwC/mDYLyAHuU7twls
8D9Y36IUHw4Zklp4D8dlTzEdDEvSavbO8B62XrpL8QtdzJ9BByhq5qCLYSGlWZ3S
uUCjR7BbaEKHzEyGmXHIk05++9BRy2XlxZYhQTGi3QX3pEsnI8pntAgLr43+MRVu
hLRMwR73KZ+jiW2sgCc4fORwHNSC+CvR0vbAad1xfQNnqz/c1S4Ir1fqVAnoehex
n4rQvfiz6zo=
=OBfc
-----END PGP SIGNATURE-----

--Apple-Mail=_3ACD3160-6D75-48A3-8179-F4A62325BDC3--
