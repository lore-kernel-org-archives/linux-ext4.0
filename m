Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:29530 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbeLBWL0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 2 Dec 2018 17:11:26 -0500
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: Andrey Melnikov <temnota.am@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
 <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
 <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org>
 <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com>
From: Rainer Fiebig <jrf@mailbox.org>
Message-ID: <de67b507-ca54-e827-867e-76d57e531cb9@mailbox.org>
Date: Sun, 2 Dec 2018 23:13:07 +0100
MIME-Version: 1.0
In-Reply-To: <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qgzTML2YGGPcmKqoL9spvq0ggi9nMdKZJ"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qgzTML2YGGPcmKqoL9spvq0ggi9nMdKZJ
Content-Type: multipart/mixed; boundary="Rb1c4r416ZZi5uWMwxPuRNFku2girw7nt";
 protected-headers="v1"
From: Rainer Fiebig <jrf@mailbox.org>
To: Andrey Melnikov <temnota.am@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <de67b507-ca54-e827-867e-76d57e531cb9@mailbox.org>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
 <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
 <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org>
 <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com>
In-Reply-To: <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com>

--Rb1c4r416ZZi5uWMwxPuRNFku2girw7nt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 02.12.18 um 21:19 schrieb Andrey Melnikov:
> =D1=87=D1=82, 29 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 01:08, R=
ainer Fiebig <jrf@mailbox.org>:
>>
>> Am 28.11.18 um 22:13 schrieb Andrey Melnikov:
>>> =D1=81=D1=80, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 18:55,=
 Rainer Fiebig <jrf@mailbox.org>:
>>>>
>>>> Am Mittwoch, 28. November 2018, 13:02:56 schrieb Andrey Jr. Melnikov=
:
>>>>> In gmane.comp.file-systems.ext4 Theodore Y. Ts'o <tytso@mit.edu> wr=
ote:
>>>>>> On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrot=
e:
>>>>>>> Corrupted inodes - always directory, not touched at least year or=

>>>>>>> more for writing. Something wrong when updating atime?
>>>>>>
>>>>>> We're not sure.  The frustrating thing is that it's not reproducin=
g
>>>>>> for me.  I run extensive regression tests, and I'm using 4.19 on m=
y
>>>>>> development laptop without notcing any problems.  If I could repro=
duce
>>>>>> it, I could debug it, but since I can't, I need to rely on those w=
ho
>>>>>> are seeing the problem to help pinpoint the problem.
>>>>>
>>>>> My workstation hit this bug every time after boot. If you have an i=
dea - I
>>>>> may test it.
>>>>>
>>>>>> I'm trying to figure out common factors from those people who are
>>>>>> reporting problems.
>>>>>>
>>>>>> (a) What distribution are you running (it appears that many people=

>>>>>> reporting problems are running Ubuntu, but this may be a sampling
>>>>>> issue; lots of people run Ubuntu)?  (For the record, I'm using Deb=
ian
>>>>>> Testing.)
>>>>>
>>>>> Debian sid but self-build kernel from ubuntu mainline-ppa.
>>>>
>>>> You could try a vanilla 4.19.5 from https://www.kernel.org/
>>>> and compile it with your current .config.
>>>
>>> mainline-ppa use vanilla kernel. Patches only adds debian specific
>>> build infrastructure.
>>>
>>>> If you still see the errors, at least the Ubuntu-kernel could be rul=
ed out.
>>>>
>>>> In addition, if you still see the errors:
>>>>
>>>> - backup your .config in a *different* folder (so that you can later=
 re-use
>>>> it)
>>>> - do a "make mrproper" (deletes the .config, see above)
>>>> - do a "make defconfig"
>>>> - and compile the kernel with that new .config
>>>
>>> defconfig is great - for abstract hardware in vacuum.
>>>
>>>> If you still have the problem after that, you may want to learn how =
to bisect.
>>>> ;)
>>> I'm already know how-to bisect. From kernel 2.0 era. Without git ;)
>>>
>>> This problem simply non-bisectable, when same kernel corrupt FS on my=

>>> workstation but normally working on other servers.
>>> And now - FS corrupted again with disabled CONFIG_EXT4_ENCRYPTION. Gr=
eat.
>>
>> OK, - and now we are looking forward to *your* ideas how to solve this=
=2E
>=20
> After four days playing games around git bisect - real winner is
> debian gcc-8.2.0-9. Upgrade it to 8.2.0-10 or use 7.3.0-30 version for
> same kernel + config - does not exhibit ext4 corruption.
>=20
> I think I hit this https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D87859=

> with 8.2.0-9 version.
>=20
Good that it works for you. But others used gcc 5.4.0 or 6.3.0 and were
hit anyway: https://bugzilla.kernel.org/show_bug.cgi?id=3D201685#c165


--Rb1c4r416ZZi5uWMwxPuRNFku2girw7nt--

--qgzTML2YGGPcmKqoL9spvq0ggi9nMdKZJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlwEWQMACgkQ8OH3JiWK
+PWGPg//dE+rE1YHVI8GwR+ILzz8Rsu+jneIh5Jn1dNqo9nrdleA6zE/HmQiVhey
Sj/ufcsdi0atD3TYrACyv4XTH0wSdX6iPmWWzxzPrzbgju/ynuo18R1tqxqlyo0d
CoACp+WoJDyZpzY8I70td4A+/NWfEzbFyaNfDCzyT78KfoOvsi/bVrEAOI4y29kz
RPQikUmuj6eI+6ixm3r8ATcJo3wJdUQF7iSfqwAC3SB7OsM9WXtFrJ7Ez03Qozs3
5f7FnifKN0sdMyCtWsCwa67R5qYVwnUOvtqRQQfHbCvNz7ftB6wP5z2j7An/UQz9
k7KbC9v0pcumMDR7VkVZBC9V07+Fr3QOWsjBWUFjK31oN0EGyDSWh9lBhR445Sro
lEMc0iX/llqQ/zzep0pXXP8VO1tYnWvRWjvJFuOLYK083NsgEu/3NQD7Xdk+WrNR
hTR10vh0vfLBwQlp4t1DGsEkz0V9Ma0yXc1+apbnSO9LpINCiJwfwo/isyqccP0M
f5TOr3HDFGSxCdT+kof72ZjCXWgAzSX4/l1XYDQwVTBqebbOw22Xple2Breh6Hsg
at2sbJUJtraLmnqm7CrHZGZBeye3lYV291DkrE5Tpo5cUSNapurkA9C9YCXeNqzm
esnjW1bKlWVLGp8gD6LiCBs9/gKaM9e08IpPMSG/PuJeqta4US0=
=SI+N
-----END PGP SIGNATURE-----

--qgzTML2YGGPcmKqoL9spvq0ggi9nMdKZJ--
