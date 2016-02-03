From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 3 Feb 2016 14:12:15 -0700
Message-ID: <41C709B0-476E-4DE8-B973-1F7237102708@dilger.ca>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com> <20160203181356.GA5842@birch.djwong.org> <1454524232.7291.105.camel@perches.com> <20160203193233.GB5842@birch.djwong.org> <1454528313.7291.115.camel@perches.com> <20160203200706.GG22352@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E26BF9C7-3221-4100-B156-548FDFDEB7DA"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Joe Perches <joe@perches.com>,
	Huaitong Han <huaitong.han@intel.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203200706.GG22352@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E26BF9C7-3221-4100-B156-548FDFDEB7DA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Feb 3, 2016, at 1:07 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, Feb 03, 2016 at 11:38:33AM -0800, Joe Perches wrote:
>> On Wed, 2016-02-03 at 11:32 -0800, Darrick J. Wong wrote:
>>> On Wed, Feb 03, 2016 at 10:30:32AM -0800, Joe Perches wrote:
>>>> On Wed, 2016-02-03 at 10:13 -0800, Darrick J. Wong wrote:
>>>>> On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
>>>>>> This patch adds a line break for proc mb_groups display.
>>>>=20
>>>> Using 2 lines for output might break any existing users.
>>>>=20
>>>> Are there any?
>>>=20
>>> It's a multiline file if you have more than one blockgroup; this =
just makes it
>>> so that you don't have to special-case BG 0.
>>=20
>> And existing scripts might do that now and might fail
>> to do properly after this change.
>=20
> Or they might have sed -e 's/]#0/]\n#0/g' in which case they won't be =
affected.

I suspect that any scripts which handled this in the past probably =
didn't
even notice and just missed the bg=3D0 line at the end of the header.  =
Users
looking at the output probably saw it line-wrapped by the terminal and
didn't notice either.

>>> IOW: mb_groups scripts already had to parse multiple lines, and most =
likely any
>>> script parsing it would inject a newline after the header.
>>=20
>> I've no dog in this fight really.  I just wanted to make
>> it clear that this could cause existing scripts to fail.
>>=20
>> proc output is supposed to be unchanging except maybe
>> adding new fields to existing lines.
>>=20
>> Your choice.
>=20
> Ted's, really.  I have no idea which scripts do with various per-fs =
/proc
> files.  Usually poking in mb_groups is only done as part of failure =
report data
> collection to see what's mucked up the fs this time.
>=20
> Anyway, I'll defer to the maintainer. :)

I think it makes sense to accept the patch, since I doubt any scripts =
will be broken, and it is the "right thing to do" rather than perpetuate =
a bug.

Cheers, Andreas






--Apple-Mail=_E26BF9C7-3221-4100-B156-548FDFDEB7DA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVrJtMXKl2rkXzB/gAQigag/+PhW2NQ9SdLhFJrUO8IzrICxJFkbYSOP1
u1/LaAud+VScTFrr9N+Ewl/qiCjok162mXmNIla98dQAnljF4jF9LusTZcbMpCaZ
18e/b/CLwbYcm156jatKLGlf5BUsvaeA1gTn3C4A5TEUn9va8z3RJaI3u8m5DSaZ
yIZBrBZxZogICxHDyPISIW2rszLNpuPpeUHW7nC7TA0jUguxvzVgDGldEJ1P+egN
P6TDgv4hYGH7RhD6SLPtq5X54L2DCRYOvK4M9rdGG0k80IpBRS5ZqV3AecrURV7j
bM2EbMtrMJEVxK5wcp4YaXzZmPJlL5SdBlDC6I5tQ5NhDfGOBnQvWjMWkmSYonlr
/4X8xZVY+St76oef5HWaoZiwxycS2nIvAT90+MV1dkH0vCI7wD5wqNVx1d9tw9jW
mRXczSBBMa7QIFTyeoHsWilFvh5SJdnSPW5dl24V3LCNhwPPXb0g0AJwrWRFnGle
u7DTEQhvnTDouTBmprZww9fK/35Ph3funnEon4d6ZyVohKaLWbz7O6gxTAPjpnaT
0bNXEd6EkktRkFhNStDT1gFIwEKYJiCkRKaSo3mYtgYDFeotit2KXKauIDXuZkY0
Yfjq1NzZjmTpoWrdYh+NCA4b9EDuZpZbLntk0yxvhl14IvkauuzS3hecPJs3If4j
+71d0/tB/N0=
=PrJc
-----END PGP SIGNATURE-----

--Apple-Mail=_E26BF9C7-3221-4100-B156-548FDFDEB7DA--
