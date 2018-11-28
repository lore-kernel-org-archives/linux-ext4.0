Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:44028 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbeK2JL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 04:11:29 -0500
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: Andrey Melnikov <temnota.am@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
 <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
From: Rainer Fiebig <jrf@mailbox.org>
Message-ID: <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org>
Date: Wed, 28 Nov 2018 23:09:55 +0100
MIME-Version: 1.0
In-Reply-To: <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XLyZmzCNO8SaSKvjvHjlojTowaAa5gozF"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XLyZmzCNO8SaSKvjvHjlojTowaAa5gozF
Content-Type: multipart/mixed; boundary="W7OdREM4tN7WAkisvcy6yc7I3rbBHoD9Y";
 protected-headers="v1"
From: Rainer Fiebig <jrf@mailbox.org>
To: Andrey Melnikov <temnota.am@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
 <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
In-Reply-To: <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>

--W7OdREM4tN7WAkisvcy6yc7I3rbBHoD9Y
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.11.18 um 22:13 schrieb Andrey Melnikov:
> =D1=81=D1=80, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 18:55, R=
ainer Fiebig <jrf@mailbox.org>:
>>
>> Am Mittwoch, 28. November 2018, 13:02:56 schrieb Andrey Jr. Melnikov:
>>> In gmane.comp.file-systems.ext4 Theodore Y. Ts'o <tytso@mit.edu> wrot=
e:
>>>> On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote:=

>>>>> Corrupted inodes - always directory, not touched at least year or
>>>>> more for writing. Something wrong when updating atime?
>>>>
>>>> We're not sure.  The frustrating thing is that it's not reproducing
>>>> for me.  I run extensive regression tests, and I'm using 4.19 on my
>>>> development laptop without notcing any problems.  If I could reprodu=
ce
>>>> it, I could debug it, but since I can't, I need to rely on those who=

>>>> are seeing the problem to help pinpoint the problem.
>>>
>>> My workstation hit this bug every time after boot. If you have an ide=
a - I
>>> may test it.
>>>
>>>> I'm trying to figure out common factors from those people who are
>>>> reporting problems.
>>>>
>>>> (a) What distribution are you running (it appears that many people
>>>> reporting problems are running Ubuntu, but this may be a sampling
>>>> issue; lots of people run Ubuntu)?  (For the record, I'm using Debia=
n
>>>> Testing.)
>>>
>>> Debian sid but self-build kernel from ubuntu mainline-ppa.
>>
>> You could try a vanilla 4.19.5 from https://www.kernel.org/
>> and compile it with your current .config.
>=20
> mainline-ppa use vanilla kernel. Patches only adds debian specific
> build infrastructure.
>=20
>> If you still see the errors, at least the Ubuntu-kernel could be ruled=
 out.
>>
>> In addition, if you still see the errors:
>>
>> - backup your .config in a *different* folder (so that you can later r=
e-use
>> it)
>> - do a "make mrproper" (deletes the .config, see above)
>> - do a "make defconfig"
>> - and compile the kernel with that new .config
>=20
> defconfig is great - for abstract hardware in vacuum.
>=20
>> If you still have the problem after that, you may want to learn how to=
 bisect.
>> ;)
> I'm already know how-to bisect. From kernel 2.0 era. Without git ;)
>=20
> This problem simply non-bisectable, when same kernel corrupt FS on my
> workstation but normally working on other servers.
> And now - FS corrupted again with disabled CONFIG_EXT4_ENCRYPTION. Grea=
t.

OK, - and now we are looking forward to *your* ideas how to solve this.

>=20
>> So long!
>>
>> Rainer Fiebig
>>
>>
>>>
>>>> (b) What hardware are you using?  (SSD?  SATA-attached?
>>>> NVMe-attached?)
>>>
>>> SATA HDD WDC WD20EZRZ-00Z5HB0.
>>>
>>>> (c) Are you using LVM?  LUKS (e.g., disk encrypted)?
>>>
>>> No and no. Plain ext4.
>>> -- cut --
>>> debugfs:  features
>>> Filesystem features: has_journal ext_attr resize_inode dir_index file=
type
>>> needs_recovery extent 64bit flex_bg sparse_super large_file huge_file=

>>> dir_nlink extra_isize metadata_csum
>>> -- cut --
>>>
>>>> (d) are you using discard?  One theory is a recent discard change ma=
y
>>>> be in play.   How do you use discard?   (mount option, fstrim, etc.)=

>>>
>>> no
>>
>> --
>> The truth always turns out to be simpler than you thought.
>> Richard Feynman



--W7OdREM4tN7WAkisvcy6yc7I3rbBHoD9Y--

--XLyZmzCNO8SaSKvjvHjlojTowaAa5gozF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv/EjQACgkQ8OH3JiWK
+PUzihAAwRr1AHxmMnmHvQuOxL0IknivBzsiI3SobBTJpyZOeOAcC10Tm+0o9TU3
6q5r9OtA3HxmrX8Uyspo+eqlIS4JvjdKY0BZ3l5OW8+BWG/Xi3uuL2LywWNSao5q
x+6o81V+AwZEAzXFVIj4vvAkOlNdNooT9s8bcpzbA7Lwrg8GSM9hSZ9USbfEtWtK
OerSX6XORy5uORb0p/ZDXhsbZs2lQkCJUYKMhVoJxJvrqpCiIW6HgNvQ/GcopS8N
97ioi6UNTlcGWMd4Jws1qKf2m7c0sJ/B6YROqJHHGXEu1Bdt21T01VeA5I+9eAbN
MEB1hMqcjm+E64po5OICOgkKIp306u42EPiE23YgLYG4RFJ+grCQDaYqJ0FbOtXL
GBl9h+3VmwzZbgFqf7RNRA2/W0cH4H0LFfHaEWr8mPKx12BvKhukkJjEO0F1ljFr
m3De/ptfSQKAH5lmTSrTe2EXb2MadhJpupPNuGbV6vb8XdwS1PkTcJde/pfNNS9H
R/w+6/qNFKYXrjqBjTc0NIcaXe9aLb5TKwCfiJvdyoADuC40dC1uJt7ImihGVICr
8ofha2ur2EvKhOKcFVV2VERmAFmV5ohYgmg/qw9CAn760rZ1Zl8doVj3MXrozWCT
tprKSu99OkdBhTrMhLN6yAwydNVo9T8SDtxBDCM/wj8rUsfa6PM=
=272y
-----END PGP SIGNATURE-----

--XLyZmzCNO8SaSKvjvHjlojTowaAa5gozF--
