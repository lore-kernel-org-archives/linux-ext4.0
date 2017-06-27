From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/12] e2fsck: track ea_inode references
Date: Tue, 27 Jun 2017 12:43:42 -0600
Message-ID: <DD3F340E-4D88-497D-9DCC-3A4C93F03E5B@dilger.ca>
References: <20170626134348.1240-1-tahsin@google.com>
 <20170626134348.1240-7-tahsin@google.com>
 <2822BB00-1A19-4DE4-8532-63FC307E5D7B@dilger.ca>
 <CAAeU0aMBM0DASLL_WjpNS=hvx9n4ntEJEKs_X=a948oJiHV26w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D7C21205-EA4B-4511-9A36-3F4C8BF7F8AB";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35896 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbdF0Snx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 14:43:53 -0400
Received: by mail-io0-f195.google.com with SMTP id h134so3364320iof.3
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 11:43:52 -0700 (PDT)
In-Reply-To: <CAAeU0aMBM0DASLL_WjpNS=hvx9n4ntEJEKs_X=a948oJiHV26w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D7C21205-EA4B-4511-9A36-3F4C8BF7F8AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 26, 2017, at 7:25 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
>>> +#ifdef EXT2_NO_64_TYPE
>>> +             fprintf(f, "%*u", width, ctx->num2);
>>> +#else
>>> +             fprintf(f, "%*llu", width, (long long)ctx->num2);
>>> #endif
>>=20
>> Rather than a series of "#ifdef EXT2_NO_64_TYPE" checks, it would be =
cleaner
>> to have a single #define to set the printf type, like:
>>=20
>> #ifdef EXT2_NO_64_TYPE
>> #define EXT2_64U "%*u"
>> #define EXT2_64D "%*d"
>> #define EXT2_64X "%*x"
>> #else
>> #define EXT2_64U "%*llu"
>> #define EXT2_64D "%*lld"
>> #define EXT2_64X "%*llx"
>> #endif
>=20
> I am trying to figure out the purpose of #ifdef EXT2_NO_64_TYPE checks
> now. Who defines it and what problem does it solve?

Sorry, I can't answer that.  Git history shows that it has been around =
since
2000 but is not set by the configure script.  I just thought it made =
sense to
clean up the code, but it might be even better to get rid of it =
completely.

Cheers, Andreas






--Apple-Mail=_D7C21205-EA4B-4511-9A36-3F4C8BF7F8AB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUqdhpIg59Q01vtYRArDkAJ9HPeMW6RUhymQlLmNIS97ta5Wx2ACeJprj
rgQTw5ZBAVF2QfzvFckd14E=
=+obC
-----END PGP SIGNATURE-----

--Apple-Mail=_D7C21205-EA4B-4511-9A36-3F4C8BF7F8AB--
