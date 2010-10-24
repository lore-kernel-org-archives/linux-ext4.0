From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 18:16:59 +0200
Message-ID: <4CC45BFB.4010403@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig5D49BCC5FC93AF31898FD5DC"
Cc: Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:6494 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab0JXQRF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 12:17:05 -0400
In-Reply-To: <4CC45590.80608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enig5D49BCC5FC93AF31898FD5DC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/24/2010 05:49 PM, Ric Wheeler wrote:
>   On 10/24/2010 11:39 AM, Bernd Schubert wrote:
>> On 10/24/2010 05:20 PM, Ric Wheeler wrote:
>>> This still sounds more like a Lustre issue than an ext4 one, Andreas =
can fill in
>>> the technical details.
>> The underlying device handling is unrelated to Lustre. In that sense i=
t
>> is just a local filesystem.
>>
>>> What ever shared storage sits under ext4 is irrelevant to the fail ov=
er case.
>>>
>>> Unless Lustre does other magic, they still need to obey the basic clu=
ster rules
>>> - one mount per cluster.
>> Yes, one mount per cluster.
>>
>>> If Lustre is doing the same trick you would do with active/passive fa=
ilure over
>>> clusters that export ext4 via NFS, you would still need to clean up t=
he file
>>> system before being able to re-export it from a fail over node.
>> What exactly is your question here? We use pacemaker/stonith to do the=

>> fencing job.
>> What exactly do you want to clean up? The device is recovered by
>> journals, Lustre goes into recovery mode, clients reconnect, locks are=

>> updated and incomplete transactions resend.
>>
>>
>> Cheers,
>> Bernd
>>
>=20
> What I don't get (certainly might just be me) is why this is a unique i=
ssue when=20
> used by lustre. Normally, any similar type of fail over will clean up t=
he local=20
> file system normally before trying to re-export from the second node.

Of course that is not a Lustre specific issue, which is why I also did
not open a Lustre bugzilla, but opened the thread here.

>=20
> Why exactly can't you use the same type of recovery here? Is it the fen=
cing=20
> agent killing nodes on detection of the file system errors?

But I'm using the same type of recovery! I just rewrote pacemakers
default "Filesystem" agent to a lustre_server agent, to include more
Lustre specific checks. When I then added last week a check for the
dumpe2fs "Filesystem state", I noticed, that sometimes the error state
is only set *after* mounting the filesystem, so difficult to script it.
And as I also wrote, running e2fsck from that script and to do a
complete fs check is not appropriate, as that might simply time out.
Again not Lustre specific. So after some discussion, the proposed
solution is to add a "journal recovery only" option to e2fsck and to do
that before the mount. I will add that to the 'lustre_server' agent
(which is part of Lustre now), but leave it to someone else to that for
the 'Filesystem' agent script (I'm not using that script myself and IMHO
it is already too complex, as it tries to support all filesystems -
shell code is ideal anymore then).

Really, only Lustre specific here is the feature to have a proc file to
see if filesystem errors came up on a node. That is a missing feature in
extX and all other linux filesystems I have worked with. And Lustre
server nodes just means the usage of dozens to hundreds of
ext3/ext4/ldiskfs devices, so bugs are more likely exposed by that high
number.


Cheers,
Bernd


--------------enig5D49BCC5FC93AF31898FD5DC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzEW/sACgkQqh74FqyuOzQjpwCgtHzBtOnRBAZF7KZVEzIFuSEO
as4An0qLsbnzg1IS3XAW+aRf9kz5DkNj
=gQ9Z
-----END PGP SIGNATURE-----

--------------enig5D49BCC5FC93AF31898FD5DC--
