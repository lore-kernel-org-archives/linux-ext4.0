From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: super: Fix spectre gadget in ext4_quota_on
Date: Tue, 31 Jul 2018 00:39:41 -0600
Message-ID: <E3E7B6AF-3819-4998-9B12-DACB4EBC14F1@dilger.ca>
References: <20180727162357.30801-1-jcline@redhat.com>
 <20180727162357.30801-2-jcline@redhat.com>
 <20180727174654.bnooz26puuo7456w@treble>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_10DC5A89-BDD9-4578-B2E7-CA670E54AF27";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Jeremy Cline <jcline@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180727174654.bnooz26puuo7456w@treble>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_10DC5A89-BDD9-4578-B2E7-CA670E54AF27
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jul 27, 2018, at 11:46 AM, Josh Poimboeuf <jpoimboe@redhat.com> =
wrote:
>=20
> On Fri, Jul 27, 2018 at 04:23:55PM +0000, Jeremy Cline wrote:
>> 'type' is a user-controlled value used to index into 's_qf_names', =
which
>> can be used in a Spectre v1 attack. Clamp 'type' to the size of the
>> array to avoid a speculative out-of-bounds read.
>>=20
>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jeremy Cline <jcline@redhat.com>
>> ---
>> fs/ext4/super.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 6480e763080f..c04a09b51742 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -40,6 +40,7 @@
>> #include <linux/crc16.h>
>> #include <linux/dax.h>
>> #include <linux/cleancache.h>
>> +#include <linux/nospec.h>
>> #include <linux/uaccess.h>
>> #include <linux/iversion.h>
>>=20
>> @@ -5559,6 +5560,7 @@ static int ext4_quota_on(struct super_block =
*sb, int type, int format_id,
>> 	if (path->dentry->d_sb !=3D sb)
>> 		return -EXDEV;
>> 	/* Journaling quota? */
>> +	type =3D array_index_nospec(type, EXT4_MAXQUOTAS);

This check just papers over the issue, but AFAICS doesn't actually
solve any problems.  It ends up squashing an invalid value to be
the same as EXT4_MAXQUOTAS, rather than returning an error to the
caller as it should.

>> 	if (EXT4_SB(sb)->s_qf_names[type]) {
>> 		/* Quotafile not in fs root? */
>> 		if (path->dentry->d_parent !=3D sb->s_root)
>=20
> Generally we try to put the array_index_nospec() close to the bounds
> check for which it's trying to prevent speculation past.
>=20
> In this case, I'd expect the EXT4_MAXQUOTAS bounds check to be in
> do_quotactl(), but it seems to be missing:
>=20
> 	if (type >=3D (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
> 		return -EINVAL;

Agreed that this should be checked at the highest layer possible.
IMHO, this means one check in the VFS/quota layer, and a separate
check in the filesystem layer.

> Also it looks like XQM_MAXQUOTAS, MAXQUOTAS, and EXT4_MAXQUOTAS all =
have the same value (3).  Maybe they can be consolidated to just use
> MAXQUOTAS everywhere?

No, the filesystem-specific MAXQUOTAS values were separated from
the kernel MAXQUOTAS value for a good reason.  This allows some
filesystems to support new quota types (e.g. project quotas) that
not all other filesystems can handle.  This may potentially change
again in the future, so they shouldn't be tightly coupled.

>  Then the nospec would be simple:
>=20
> 	if (type >=3D MAXQUOTAS)
> 		return -EINVAL;
> 	type =3D array_index_nospec(type, MAXQUOTAS);
>=20
> Otherwise I think we may need to disperse the array_index_nospec calls
> deeper in the callchain.
>=20
> --
> Josh


Cheers, Andreas






--Apple-Mail=_10DC5A89-BDD9-4578-B2E7-CA670E54AF27
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAltgBC4ACgkQcqXauRfM
H+Cu6xAAs5ILnj4vwZJw2+rJDtGADMRHQJO0tvEuhc6ual0yh6SVi8DH92s8Z3gd
u3omxJCNQNlQamxys9VBUDaUOHbJOt1EvZzlvp6stmEHPHkJ6othYZB7i5octvAO
HboxA2dhE1bFHfizcs9eYM6BtyzJ+xtNixyG+MUMJQZf+v4KNWm8YaQYOkKtJ5YS
9XWA5sS8Gcds4Jn+ZEWWETaJrjdKf4I3olsO2DHdwrCUirvkN0NRB5l/of29bYWs
tPddwKz3pZWQOkIFOnF6tIMgE7ViFHPjsd8I/CPo6kM6L2ngbFb9jbIBp0ZWIm9i
BmDPua2UbxMmkgnKzswuO/M0libkTvOyDEJ3/q1g+wdfnD1etLD+5dmxwdS0ZddI
I8qMNypv4LJmD+1ty4UHuBg9gD8Nwu8cUmgCOZqFKJ3ZaVF/JOaz2I8d25UYar1c
c6Mu8xlBPd6itP4wom5KXG9a7kE6eINXwOXGsPcHhj485LMei4z6rkRrpPL+hzDM
/4fi9/3mFPd+ZS6oi8trE4Hf706CHZqtpD0vFsOYKyxIMPPf1p3fHAiddwpZBv7n
K+6OBII6tli1GS136uq2SEXnTrZkfdC/HktXpkvkukcX0hcRd8WH1sN9hxTh5RaO
UZ1hAyntV4cyyNtiHBfy7wTX75CkwJsor1NZKNUx0N+0JlwWod8=
=BMKy
-----END PGP SIGNATURE-----

--Apple-Mail=_10DC5A89-BDD9-4578-B2E7-CA670E54AF27--
