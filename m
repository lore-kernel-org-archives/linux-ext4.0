From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: metadata operation reordering regards to crash
Date: Sun, 16 Sep 2018 09:18:08 +0800
Message-ID: <176cee59-e95f-5077-8120-33277291a115@gmx.com>
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
 <20180914222336.GD16550@dastard>
 <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8gxq5ugRV8N6UJcc3dJsbuOH5Is7bOr4L"
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
To: =?UTF-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>,
        david@fromorbit.com, cmumford@cmumford.com,
        linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8gxq5ugRV8N6UJcc3dJsbuOH5Is7bOr4L
Content-Type: multipart/mixed; boundary="UQIkkXGbRNgYOADTbrzJfpzmDt584N5gg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>, david@fromorbit.com,
 cmumford@cmumford.com, linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
Message-ID: <176cee59-e95f-5077-8120-33277291a115@gmx.com>
Subject: Re: metadata operation reordering regards to crash
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
 <20180914222336.GD16550@dastard>
 <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
In-Reply-To: <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>

--UQIkkXGbRNgYOADTbrzJfpzmDt584N5gg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/15 =E4=B8=8B=E5=8D=882:58, =E7=84=A6=E6=99=93=E5=86=AC wrote:
> On Sat, Sep 15, 2018 at 6:23 AM Dave Chinner <david@fromorbit.com> wrot=
e:
>>
>> On Fri, Sep 14, 2018 at 05:06:44PM +0800, =E7=84=A6=E6=99=93=E5=86=AC =
wrote:
>>> Hi, all,
>>>
>>> A probably bit of complex question:
>>> Does nowadays practical filesystems, eg., extX, btfs, preserve metada=
ta
>>> operation order through a crash/power failure?
>>
>> Yes.
>>
>> Behaviour is filesystem dependent, but we have tests in fstests that
>> specifically exercise order preservation across filesystem failures.
>>
>>> What I know is modern filesystems ensure metadata consistency
>>> after crash/power failure. Journal filesystems like extX do that by
>>> write-ahead logging of metadata operations into transactions. Other
>>> filesystems do that in various ways as btfs do that by COW.
>>>
>>> What I'm not so far clear is whether these filesystems preserve
>>> metadata operation order after a crash.
>>>
>>> For example,
>>> op 1.  rename(A, B)
>>> op 2.  rename(C, D)
>>>
>>> As mentioned above,  metadata consistency is ensured after a crash.
>>> Thus, B is either the original B(or not exists) or has been replaced =
by A.
>>> The same to D.
>>>
>>> Is it possible that, after a crash, D has been replaced by C but B is=
 still
>>> the original file(or not exists)?
>>
>> Not for XFS, ext4, btrfs or f2fs. Other filesystems might be
>> different.
>=20
> Thanks, Dave,
>=20
> I found this archive:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31937.html
>=20
> It seems btrfs people thinks reordering could happen.

It depends.

For default btrfs (using log tree), it depends on the log replay code
(which is somewhat like journal, but not completely the same).

Unfortunately I'm not a expert on that part, but tree log is more a
performance optimization other than a vital part to keep fs consistent.

But if using notreelog mount option, btrfs won't use log tree and falls
back to sync() for all fsync() due to its metadata organization.

And in that case, there is no reordering at all. It uses metadata CoW to
ensure everything is consistent.
In that case, power loss happens either before or after super block
write back.
For old superblock it always points to old trees, and vice verse for new
superblock.
So one will only see either the new fs or the old fs, thus making btrfs
atomic for its metadata update.

Thanks,
Qu

>=20
> It is a relatively old reply. Has the implement changed? Or is there
> some new standard that requires reordering not happen?
>=20
>> Cheers,
>>
>> Dave,
>> --
>> Dave Chinner
>> david@fromorbit.com


--UQIkkXGbRNgYOADTbrzJfpzmDt584N5gg--

--8gxq5ugRV8N6UJcc3dJsbuOH5Is7bOr4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAludr1AACgkQwj2R86El
/qiyYwf/cvZm56CfvDwC4Y5Gok0oPuJhNW1yHtnJWjMIpZS0WaOOk0O/NKCSg1TA
ga4L9oJCDm7XzymrtSPa9zdxbto9EmQyCL39dtnI0ZGxx1/IEvplFQlyZ6/hnbde
de4HeUrPnSj6j1IaFwvG/uTposaNb4B9nCzT7161Lk34okm/UCsmb6I6iZQ4wvds
NbcibD73dE+XHS49UPHZNNT5PNmXUnHWeyh/RN69aWIq7L+vgKW0YVllFgVC1aLy
G5IXZ+bFm2WSa6rEePF+xGQipxlf+gDQbLCAc4QzBfPXsc9mej5yVGy3BvYdHzG9
thKX4O3VXonggHT30lfyFW0eWXiLIw==
=GMDQ
-----END PGP SIGNATURE-----

--8gxq5ugRV8N6UJcc3dJsbuOH5Is7bOr4L--
