From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Tue, 12 Nov 2013 14:35:04 -0700
Message-ID: <6DE0AF86-98E6-4DE9-BB7F-40FB32E1BC26@dilger.ca>
References: <1383808590.23882.13.camel@chiang> <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang> <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang> <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca> <1383981551.8994.27.camel@chiang> <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com> <1384070214.8994.47.camel@chiang> <20131112003018.GA30281@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: multipart/signed; boundary="Apple-Mail=_60C7458F-837E-41F8-8B1E-98D66CD277B4"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: David Turner <novalis@novalis.org>, Mark Harris <mhlk@osj.us>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131112003018.GA30281@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_60C7458F-837E-41F8-8B1E-98D66CD277B4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Nov 11, 2013, at 5:30 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Nov 10, 2013 at 02:56:54AM -0500, David Turner wrote:
>> b. Use Andreas's encoding, which is incompatible with pre-1970 files
>> written on 64-bit systems.
>>=20
>> I don't care about currently-existing post-2038 files, because I =
believe
>> that nobody has a valid reason to have such files.  However, I do
>> believe that pre-1970 files are probably important to someone.
>>=20
>> Despite this, I prefer option (b), because I think the simplicity is
>> valuable, and because I hate to give up date ranges (even ones that I
>> think we'll "never" need). Option (b) is not actually lossy, because =
we
>> could correct pre-1970 files with e2fsck; under Andreas's encoding,
>> their dates would be in the far future (and thus cannot be =
legitimate).
>>=20
>> Would a patch that does (b) be accepted?  I would accompany it with a
>> patch to e2fsck (which I assume would also go to the ext4 developers
>> mailing list?).
>=20
> I agree, I think this is the best way to go.  I'm going to drop your
> earlier patch, and wait for an updated patch from you.  It may miss
> this merge window, but as Andreas has pointed out, we still have a few
> years to get this right.  :-)

Since this change would immediately break files encoded with pre-1970 =
dates
on ext4 filesystems, should there be a transition period where both =
pre-1970
dates (with extra epoch bits =3D=3D 0x3 in the current encoding) and =
post-2378
(with extra epoch bits =3D=3D 0x3 in the new encoding) are decoded as =
being
pre-1970?  That could be conditional until some release in the future =
(e.g.
>=3D Linux 4.20, at least 5 years away) to give folks a chance to run =
the new
e2fsck to fix up those files.

Are there really any ext4 filesystems that have files with valid dates =
so old?
I don=92t want to break anyone=92s data, but if this extra complexity is =
completely
pointless then I=92m also fine with this minor risk of breakage.

Cheers, Andreas






--Apple-Mail=_60C7458F-837E-41F8-8B1E-98D66CD277B4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFSgp8JpIg59Q01vtYRAv/CAKCLdogtXGO6X8HMSdwlbxcK2njIggCcCjsA
XOzvl5skYbfVDyE1MkrysD0=
=jGZQ
-----END PGP SIGNATURE-----

--Apple-Mail=_60C7458F-837E-41F8-8B1E-98D66CD277B4--
