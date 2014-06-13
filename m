From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] mke2fs: prevent creation of unmountable ext4 with large flex_bg count
Date: Fri, 13 Jun 2014 15:45:03 -0600
Message-ID: <4206D78A-FD6D-4F3E-8CD1-5D717784BCA8@dilger.ca>
References: <28989C0C9F1C0A428470D967B5FCED372A7EA3@BPXM22GP.gisp.nec.co.jp> <6A410081-0492-4378-BA66-07AFA7C0DEAF@dilger.ca> <20140612235019.GB9743@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8F824BFD-FABD-488A-B495-8D482A6D4121"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43076 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFMVpL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 17:45:11 -0400
Received: by mail-pa0-f54.google.com with SMTP id et14so2518218pad.41
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2014 14:45:11 -0700 (PDT)
In-Reply-To: <20140612235019.GB9743@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8F824BFD-FABD-488A-B495-8D482A6D4121
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 12, 2014, at 5:50 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> On Wed, Jun 11, 2014 at 01:01:29PM -0600, Andreas Dilger wrote:
>>=20
>> This also reminds me of my previous flex_bg patch:
>> [PATCH][RFC] mke2fs: handle flex_bg collision with backup descriptors
>> http://permalink.gmane.org/gmane.comp.file-systems.ext4/42298
>>=20
>> which fixes the "bmap-imap-itable-bmap-imap-itable" problem when a =
large
>> flex_bg size is used.  Sadly, there were no comments on that patch.
>=20
> I had wondered if you were planning to address the FIXMEs in the =
patch, but
> then forgot to ever follow up... :/

Well, I was thinking that the patch was good enough to land as-is.  It =
fixes 99% the problem for flex_bg size up to 65536, but only 95% of the =
groups for flex_bg of 131072.  I guess I'll send it out again without =
[RFC], and if people start using flex_bg >=3D 131072 (which is enough =
for all the metadata in a 16TB chunk) then we can work out the final =
details.  I suspect that the sparse_super2 feature would probably become =
more prevalent and avoid this problem entirely.

Cheers, Andreas






--Apple-Mail=_8F824BFD-FABD-488A-B495-8D482A6D4121
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU5tw33Kl2rkXzB/gAQL+ZxAAmKYvFR5hZt9AAW8Mws9Yig1secfpbqbx
p7NXyzZ2XtBwkBnjwxeeujBjr6diuaew183y4qvjOY6qiFX36ZMc7UgtK/XZ/DnG
GKE4JCDDIrINaQ1bCcZZoR8koBpIO/aT4yE27ojgTEc9GyXEzCDexXnkQlWFUODU
iEwcZUF2tm1ZQ0+iJg1/fIBGzCQ5dcSl2T7UCkqt2GEhtThRq/B8cje3JDQZlfOB
KYDrxYGLrmnF6Mudbtfy3LFtyZ0KjLlbzlvAxirnigD6ruCHHXJAIeWxDPsAHjke
KFOuF+7YaFGpWDIAlpeW7eaFg5DBUP9nyKsCki+yyEKUfFP1zoBAMPkj+BOqp9dk
gTIIv1QdZrMui69jlVrjo6EXsi3DxKn81XMjCquz2hTK16WS/yxK0XQkc8cvBNgk
FUszoRGMWoCZJc0LJqhFq0m1TLgw5XD3HBLvAA8x8A8mJfIgT4Y2v2BDY8IM1HIx
LsPG7RC7EiF0pjaKbglaESLSir328grfYylwYNw0AgHRtc4AWdOX3M4JmADwT0jK
ZYp7UgIIQJ0UdWa6BhtzOtDgN0kM70NH1JG2ew5S16QqfKrEbtvL1WpGgyqZZVVN
ljzdR30caqdKql06DpDKIsn0C9GQx8GywcLTBAsACDAEJYaM6Y6IYSnEk1TiFGxr
wW6vow4rz/c=
=k+y/
-----END PGP SIGNATURE-----

--Apple-Mail=_8F824BFD-FABD-488A-B495-8D482A6D4121--
