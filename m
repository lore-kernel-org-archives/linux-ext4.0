From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Tue, 11 Feb 2014 00:07:33 -0700
Message-ID: <A8F66E63-68C0-4363-BCB5-8CBD1AC777DA@dilger.ca>
References: <1383808590.23882.13.camel@chiang> <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang> <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang> <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca> <1383981551.8994.27.camel@chiang> <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com> <1384070214.8994.47.camel@chiang> <20131112003018.GA30281@thunk.org> <20140122062255.GA8973@birch.djwong.org> <1392095546.10065.56.camel@chiang>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_237FAE24-524C-4761-90B7-9CFA72E4DA34"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, Mark Harris <mhlk@osj.us>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52744 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKHHk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Feb 2014 02:07:40 -0500
Received: by mail-pd0-f173.google.com with SMTP id y10so7127519pdj.4
        for <linux-ext4@vger.kernel.org>; Mon, 10 Feb 2014 23:07:40 -0800 (PST)
In-Reply-To: <1392095546.10065.56.camel@chiang>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_237FAE24-524C-4761-90B7-9CFA72E4DA34
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 10, 2014, at 10:12 PM, David Turner <novalis@novalis.org> wrote:
> On Tue, 2014-01-21 at 22:22 -0800, Darrick J. Wong wrote:
>> On Mon, Nov 11, 2013 at 07:30:18PM -0500, Theodore Ts'o wrote:
>>> On Sun, Nov 10, 2013 at 02:56:54AM -0500, David Turner wrote:
>>>> b. Use Andreas's encoding, which is incompatible with pre-1970 =
files
>>>> written on 64-bit systems.
>>>>=20
>>>> I don't care about currently-existing post-2038 files, because I =
believe
>>>> that nobody has a valid reason to have such files.  However, I do
>>>> believe that pre-1970 files are probably important to someone.
>>>>=20
>>>> Despite this, I prefer option (b), because I think the simplicity =
is
>>>> valuable, and because I hate to give up date ranges (even ones that =
I
>>>> think we'll "never" need). Option (b) is not actually lossy, =
because we could correct pre-1970 files with e2fsck; under Andreas's =
encoding,
>>>> their dates would be in the far future (and thus cannot be =
legitimate).
>>>>=20
>>>> Would a patch that does (b) be accepted?  I would accompany it with =
a
>>>> patch to e2fsck (which I assume would also go to the ext4 =
developers
>>>> mailing list?).
>>>=20
>>> I agree, I think this is the best way to go.  I'm going to drop your
>>> earlier patch, and wait for an updated patch from you.  It may miss
>>> this merge window, but as Andreas has pointed out, we still have a =
few
>>> years to get this right.  :-)
>>=20
>> Just out of curiosity, did this (updated patch) ever happen?
>=20
> I think I sent a usable patch that Ted merged part of into =
e2fscktools;
> the kernel portion was dropped for some reason.
>=20
> While I was waiting to hear back on the kernel portion, I started
> looking into the dtime stuff, but then I got distracted by a new job.
>=20
> Assuming that I won't have time to deal with dtime (since it seems to =
be
> much more complicated), is the right way forward for me to rebase the
> non-dtime portion of my patch against the latest kernel, and resend =
it?
> If so, will it get merged?  (Assume here that I do the same with the
> e2fsck stuff)

Yes, please submit an updated patch for the kernel.  Ted will hopefully
merge it this time.

I don't know that we really care about dtime so much, since it is mostly
just treated as "zero =3D=3D not deleted" and "non-zero =3D=3D deleted" =
by e2fsck,
and maybe useful for manual debugging.  We might consider that it uses a
sliding window in the future, since I'm sure we won't care about files
deleted more than 70 years ago, and if we did the fact that they appear
to be files deleted 70 years in the future won't matter so much.  In any
case, that can be looked at in a separate patch.

Cheers, Andreas






--Apple-Mail=_237FAE24-524C-4761-90B7-9CFA72E4DA34
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUvnMNXKl2rkXzB/gAQKmUw/+PjRfKgS4NBcIyqvU9jvG8kehtGWfohSk
1+WBa9XCqCgi1nlx9cceOvQKBa4VaViFY4WqG3rQaI4xGkHZne4Tbhf1ADwkTKrg
XvOw89hliAeNwcI6WoYobEwlLakbWG1n6uCzoKYztrw7TnE6RAsp9q2BBjU+Xilq
m4+8M0bs1Pf0MhGtBtNkDcmGA7S54uzz42VKs771VlG6EwWS3kX040cxXRpp7u+K
VrECTcBkZ26Tldfh9KJFPm3URU/RdfX1Q/X2ayCX2VFzq2L+ilthurwhnS5QGtkP
hRqG0IyWI/KnVU8BUQVsVo67h9ro05/O7LIKIs9hEXRuKALve5peKWJHxOm2UmoB
GmEqSbmQULQ6jOAPf6ydb4jQKjlMGqE2NZlXcaKnhP4Vx1blHNLlNHc3FKNbe3QN
nqN09huGuOrTNCIi9yUMW8C7B2CnFVJXjF7zEEFojs/2tiDT1i77+xSxQfMtMlEr
WTg8shVxKEHfvfPaXi0Gd7Aft9d/cc424Edos0jYTZN19XNOxUiXHdsLu2cvUWPr
6gL5vgJobHZzfuC7H/Id238iwwxidx7QL/F8L2BMQBBQIRq+wFAC+zWVrNbuKcza
mV4b1rQdQs6VvUEXMR+nreQBmbJMhfD/kDs3UkjsGJOoBzJZeDcx61eOXYCYxRUG
ntjtZmxr01k=
=hcXj
-----END PGP SIGNATURE-----

--Apple-Mail=_237FAE24-524C-4761-90B7-9CFA72E4DA34--
