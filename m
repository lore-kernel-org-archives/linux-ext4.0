From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: metadata operation reordering regards to crash
Date: Sat, 15 Sep 2018 12:04:51 -0600
Message-ID: <22C71398-EFD7-4638-AAE4-CE7E30E95B7E@dilger.ca>
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
 <20180914222336.GD16550@dastard>
 <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_024CC7D5-5AFC-4E92-92E1-51525F7D4B85";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Dave Chinner <david@fromorbit.com>, cmumford@cmumford.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?utf-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_024CC7D5-5AFC-4E92-92E1-51525F7D4B85
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Sep 15, 2018, at 12:58 AM, =E7=84=A6=E6=99=93=E5=86=AC =
<milestonejxd@gmail.com> wrote:
>=20
> On Sat, Sep 15, 2018 at 6:23 AM Dave Chinner <david@fromorbit.com> =
wrote:
>>=20
>> On Fri, Sep 14, 2018 at 05:06:44PM +0800, =E7=84=A6=E6=99=93=E5=86=AC =
wrote:
>>> Hi, all,
>>>=20
>>> A probably bit of complex question:
>>> Does nowadays practical filesystems, eg., extX, btfs, preserve =
metadata
>>> operation order through a crash/power failure?
>>=20
>> Yes.
>>=20
>> Behaviour is filesystem dependent, but we have tests in fstests that
>> specifically exercise order preservation across filesystem failures.
>>=20
>>> What I know is modern filesystems ensure metadata consistency
>>> after crash/power failure. Journal filesystems like extX do that by
>>> write-ahead logging of metadata operations into transactions. Other
>>> filesystems do that in various ways as btfs do that by COW.
>>>=20
>>> What I'm not so far clear is whether these filesystems preserve
>>> metadata operation order after a crash.
>>>=20
>>> For example,
>>> op 1.  rename(A, B)
>>> op 2.  rename(C, D)
>>>=20
>>> As mentioned above,  metadata consistency is ensured after a crash.
>>> Thus, B is either the original B(or not exists) or has been replaced =
by A.
>>> The same to D.
>>>=20
>>> Is it possible that, after a crash, D has been replaced by C but B =
is still
>>> the original file(or not exists)?
>>=20
>> Not for XFS, ext4, btrfs or f2fs. Other filesystems might be
>> different.
>=20
> Thanks, Dave,
>=20
> I found this archive:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31937.html
>=20
> It seems btrfs people thinks reordering could happen.
>=20
> It is a relatively old reply. Has the implement changed? Or is there
> some new standard that requires reordering not happen?

There is nothing in POSIX that requires any particular ordering.  =
However,
the sequence "A, B, C, sync C" on ext3/ext4 has "always" resulted in A, =
B
also being sync'd to disk (including parent directory creation, etc).

For a while, ext4 with delayed allocation resulted in write A, rename =
A->B
causing "B" to potentially not have any data (commit =
v2.6.29-5120-g8750c6d).
While the applications are depending on non-POSIX behaviour, the =
operation
ordering behaviour has been around long that applications have grown to
depend on it, and consider the filesystem to have a bug when it doesn't
behave that way.

If you want to write a robust application, you should fsync() the files =
you
care about (possibly with AIO so you get a notification on completion =
rather
than waiting).

Cheers, Andreas






--Apple-Mail=_024CC7D5-5AFC-4E92-92E1-51525F7D4B85
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAludScsACgkQcqXauRfM
H+B51g//RtucN7xoWHw6x+k1YAOFJXpc5sYOBfCT4EktAn1NuTkNcSd8TIJ9Y1Ad
EJvzQAt9K8PwuLcMCsD3hef1cG2D66UwCyw+HMCxftlxOJ32dh1ZNc3Vg3L1KUf2
EkepyzDrApjsxnjTq7u4L1cykmhZs/hLPvN+XfJFqeyLSsBxUUU1raE+THfLH+sW
8cmCIurnCRH7RgSq1wq0/mZbWTPoH6TDi3bTco7I5zPMAb2a1PIb8pqtUXuoPuzS
jW2xQ4CqcCqLboaCbEplQBa75U/SMIUmNX+RoUxXpcIFnE5dOdUmGSq/Eq+708bo
Oil6MBhhnspiijQOzLsbhp2Wg2kpDFpBeUjdU/vTHx3VArACUUjYwjjE8qJya5NY
X2JTKjYLjra1As/09hU7ccbyWGb9JmPKd/+rUQRDFr8uhBi5+I0TRxjkTwqaVd/4
DKhb5VZJNVead4KzvalAItckvrJEOqKHzM0tpjSujNCJvn834GhipQiFC/jnZWsu
Lrupc0nmm+Gk35bvasGtnZXZ2ekovzpQEhGP2PIG2UiUIEelF48ex9D5f4vaOUVI
OcAxjRsspU2BIccEOEIAXfSzp6Ct/3X/jtvAyX8rt4FwnTpCMR+QkBbX2FVJWG5V
Bzsuw4Hj3FzXnd3/zyJu+k53Qxa1dSOwPu7J97KZWCAvzHbZCyM=
=/EmR
-----END PGP SIGNATURE-----

--Apple-Mail=_024CC7D5-5AFC-4E92-92E1-51525F7D4B85--
