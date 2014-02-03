From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: mke2fs options for large media archive filesystem
Date: Mon, 3 Feb 2014 14:09:13 -0700
Message-ID: <7A86A0B9-5C08-42C9-A136-010CAAE384A1@dilger.ca>
References: <52EE703B.3010703@gmail.com> <op.xanxpcwg0ncgu9@vitalif.vhome> <F3EDB2EF-E089-486A-B1FC-6395770B111E@dilger.ca> <op.xao2fube0ncgu9@vitalif.vhome>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C5955F28-F649-49F0-AF66-38053FE21963"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Bastien Traverse <bastien.traverse@gmail.com>
To: Vitaliy Filippov <vitalif@yourcmc.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52890 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaBCVJU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 16:09:20 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so7559655pbc.38
        for <linux-ext4@vger.kernel.org>; Mon, 03 Feb 2014 13:09:19 -0800 (PST)
In-Reply-To: <op.xao2fube0ncgu9@vitalif.vhome>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C5955F28-F649-49F0-AF66-38053FE21963
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 3, 2014, at 12:15 AM, Vitaliy Filippov <vitalif@yourcmc.ru> =
wrote:
>> I would say that bigalloc is probably not what you want for an =
archival system. It is relatively new and the space savings is minimal. =
It is mostly for filesystems that need to allocate and free large files =
rapidly.
>=20
> And does it introduce any memory usage benefit? Maybe not on a 1TB, =
but on a 32TB partition? :)
> I.e. does the kernel keep full block bitmap (or maybe a tree of =
blocks?) in memory, or does it read parts of it when they're needed?

The kernel dynamically loads bitmaps when needed.

Cheers, Andreas






--Apple-Mail=_C5955F28-F649-49F0-AF66-38053FE21963
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUvAFenKl2rkXzB/gAQJXRBAAraJMrR3X0uf4BHDOiZWawiKqGOkV5thD
dXLPiQvrQDtv3V1yIxSprZVzNaAzH3gAmvW8o7+WvvyMtIYkehRBex891fcLJk2k
Fl23x3fKw4kQYacq8vC8D5WIUnINkKjR/0na9fISZxvihkxPGJN4pAcIBTrRW339
aoU2NQGUt+064zYDY+eaaL5HCE6v5/+nDh9BpiubhjtR6OII9lZ3iD98wvcQjGZp
4d5oY8ZLirL683dAJmWZFpz3hYmxR6NHvMNCUcjCj7CL0xktVhj1D+1pGCzo+vZt
MlkWcd/bsSuKvW1VqgwAqQ6hVVojASKorxXNBBblFrX3HqQFiSqup4MoaHPX8ZT6
lt8RddXtcMxRDj22tPv+er609sy8TwiqMVmtMi+v73uqttzLmQzW4lrpihZfNboB
RBfVTO5V2uhFjTWo4/Go7lCS1/cZx2nM+mvwb+eePBo0F4835OS0scJtZuMCO8oc
8gAXlrHtMXKpmUh8g47+rgAKLC36kgDvWwCwBwQjsrTDWUZ6xrg94kwMGB2zcxsR
2zzGWgAS1j7IwXrFpzYqvy4R2UKdiuyc/0fatosOntCJRwsttEzG7gvMtyAwocrA
TsO+UMHZLYWzbA0OkgcP74Qxo1xLBx8LZ/0CeeOcscR+a5nLYGsx16eDlrCZPRBu
/CqmSnUiq7U=
=Npim
-----END PGP SIGNATURE-----

--Apple-Mail=_C5955F28-F649-49F0-AF66-38053FE21963--
