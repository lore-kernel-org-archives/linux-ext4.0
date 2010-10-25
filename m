From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Mon, 25 Oct 2010 22:08:01 +0200
Message-ID: <4CC5E3A1.5010906@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com> <4CC45BFB.4010403@ddn.com> <4CC46241.8070107@redhat.com> <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com> <4CC56DEE.8020306@redhat.com> <4CC57E0A.9070502@redhat.com> <5ED9AA37-357B-49E9-95E1-3E5A42B6245E@oracle.com> <4CC5DF41.1080402@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3F5226A94E93D0C7E4F212D4"
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
	Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:39866 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0JYUIN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 16:08:13 -0400
In-Reply-To: <4CC5DF41.1080402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enig3F5226A94E93D0C7E4F212D4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/25/2010 09:49 PM, Ric Wheeler wrote:
>   On 10/25/2010 10:57 AM, Andreas Dilger wrote:
>> On 2010-10-25, at 20:54, Ric Wheeler wrote:
>>> On 10/25/2010 07:45 AM, Ric Wheeler wrote:
>>>> On 10/25/2010 06:14 AM, Andreas Dilger wrote:
>>>>> I don't really agree with this.  The whole reason for having the er=
ror flag in the superblock and ALWAYS running e2fsck at mount time to rep=
lay the journal is that e2fsck should be done before mounting the filesys=
tem.
>>>>>
>>>>> I really dislike the reiserfs/XFS model where a filesystem is mount=
ed and fsck is not run in advance, and then if there is a serious error i=
n the filesystem this needs to be detected by the kernel, the filesystem =
unmounted, e2fsck started, and the filesystem remounted...  That's just b=
ackward.
>>>>>
>>>>> Bernd's issue (the part that I agree with) is that the error may on=
ly be recorded in the journal, not in the ext3 superblock, and there is n=
o easy way to detect this from userspace.  Allowing e2fsck to only replay=
 the journal is useful this problem.  Another similar issue is that if tu=
ne2fs is run on an unmounted filesystem that hasn't had a journal replay,=
 then it may modify the superblock, but journal replay will clobber this.=
  There are other similar issues.
>>> One more thought here is that effectively the xfs model of mount befo=
re fsck is basically just doing the journal replay - if you need to repai=
r the file system, it will fail to mount. If not, you are done.
>> This won't happen with ext3 today - if you mount the filesystem, it wi=
ll succeed regardless of whether the filesystem is in error.  I did like =
Bernd's suggestion that the "errors=3D" mount option should be used to de=
tect if a filesystem with errors tries to mount in a read-write state, bu=
t I think that is only a safety measure.
>>
>>> For HA fail over, what Bernd is proposing is effectively equivalent:
>>>
>>> (1) Replay the journal without doing a full fsck which is the same as=
 the mount for XFS
>> Does XFS fail the mount if there was an error from a previous mount on=
 it?
>>
>=20
> It does not have an "in error" state bit, but does have sanity checks a=
t mount time.
>>> (2) See if the journal replay failed (i.e., set the error flag) which=
 is the same as seeing if the mount succeeded
>> I assume you mean for XFS here, since ext3/4 will happily mount the fi=
lesystem today without returning an error.
>>
>=20
> On IRC with Eric, xfs will also mount happily after many types of error=
s.
>=20
>=20
>>> (3) If error, you need to do a full, time consuming fsck for either
>>>
>>> (4) If no error in (2), you need to mount the file system for ext4 (x=
fs is already done at this stage)
>>>
>>> Aside from putting the journal replay into a magic fsck flag, I reall=
y do not see that you are saving any complexity.  In fact, for this case,=
 you add step (4).
>> In comparison, the normal ext2/3/4 model is:
>>
>> 1) Run e2fsck against the filesystem before accessing it (without the =
-f flag that forces a full check).  e2fsck will replay the journal, and i=
f there is no error recorded it will only check the superblock validity b=
efore exiting.  If there is an error, it will run a full e2fsck.
>=20
> One thing that prevents this from being useful in a cluster fail-over c=
ontext is=20
> that it is really hard to script responses for the full fsck for ext*. =
 Feeding=20
> it a "-y" should work, but it is still a bit scary in practice.
>=20
>> 2) mount the filesystem
>>
>> This is the simplest model, and IMHO the most correct one.  Using "mou=
nt" as a proxy for "is my filesystem broken" seems unusual to me, and uns=
afe for most filesystems.
>>
>> For Bernd, I guess he needs split step #1 into:
>>
>> 1a) replay the journal so the superblock is up-to-date
>> 1b) check if the filesystem has an error and report it to the HA agent=
, so that it doesn't have a fit because the mount is taking so long
>> 1c) run the actual e2fsck (which may take a few hours on a 16TB filesy=
stem)
>>
>=20
> I suppose that makes some sense, but it would seem that you could do (1=
a) and=20
> (1b) today with the mount & unmount (and then check for file system err=
ors)?

Hmm yes, mount + umount to replay the journal should work. The
disadvantage is that the kernel might run into a NULL pointer or panic
if something totally was messed up, while e2fsck 'only' would segfault.

Cheers,
Bernd




--------------enig3F5226A94E93D0C7E4F212D4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzF46YACgkQqh74FqyuOzQM/gCeMARXm7c37QJok2geSdVhm8zd
CUcAoKxVz2a/ZdkMS50Jc1u6tE3A0UNa
=6tSa
-----END PGP SIGNATURE-----

--------------enig3F5226A94E93D0C7E4F212D4--
