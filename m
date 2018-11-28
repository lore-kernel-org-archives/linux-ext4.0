Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:22316 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbeK1U4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 15:56:19 -0500
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, grendel@twistedcode.net,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
 <2157925.3ZPi3Rj3bs@siriux> <20181127212255.GA2987@roeck-us.net>
From: Rainer Fiebig <jrf@mailbox.org>
Message-ID: <ff046ad7-5a57-c53c-2803-55f6604732b0@mailbox.org>
Date: Wed, 28 Nov 2018 10:56:50 +0100
MIME-Version: 1.0
In-Reply-To: <20181127212255.GA2987@roeck-us.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mFeNj4Q8ttMRQBmq2sOG9ojwA7yHwpEWm"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mFeNj4Q8ttMRQBmq2sOG9ojwA7yHwpEWm
Content-Type: multipart/mixed; boundary="SbQYsgVsPm5IkRJPb5ZHjeHBV5vK3dpP1";
 protected-headers="v1"
From: Rainer Fiebig <jrf@mailbox.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, grendel@twistedcode.net,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-ext4@vger.kernel.org
Message-ID: <ff046ad7-5a57-c53c-2803-55f6604732b0@mailbox.org>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
 <2157925.3ZPi3Rj3bs@siriux> <20181127212255.GA2987@roeck-us.net>
In-Reply-To: <20181127212255.GA2987@roeck-us.net>

--SbQYsgVsPm5IkRJPb5ZHjeHBV5vK3dpP1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 27.11.18 um 22:22 schrieb Guenter Roeck:
> On Tue, Nov 27, 2018 at 07:55:01PM +0100, Rainer Fiebig wrote:
>> Am Dienstag, 27. November 2018, 15:48:19 schrieb Marek Habersack:
>>> On 27/11/2018 15:32, Guenter Roeck wrote:
>>> Hi,
>>>
>>> You might try to see if you have CONFIG_SCSI_MQ_DEFAULT=3Dyes in your=
 kernel
>>> config. Starting with 4.19.1 it somehow interferes with ext4 and caus=
es
>>> problems similar to the ones you list below. Ever since I disabled MQ=

>>> (either recompile your kernel or add `scsi_mod.use_blk_mq=3D0` to the=
 kernel
>>> command line) none of those errors came back.
>>>
>>> hope it helps,
>>>
>>> marek
>>
>> Unfortunately, this doesn't seem to work in every case:=20
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D201685#c54
>>
>> And I'm using a defconfig-4.19.3 (meaning: CONFIG_SCSI_MQ_DEFAULT=3Dye=
s) in a VM=20
>> and I'm not seeing those errors there. OK, it's a VM - but anyway.
>>
>=20
> Agreed. I disabled CONFIG_SCSI_MQ_DEFAULT, but the problem is still see=
n
> at least on one of my servers, so disabling it does not help, at least =
not
> in my case.
>=20
> If the problem is somehow related to CONFIG_SCSI_MQ_DEFAULT, you might
> have to explicitly use a scsi drive (virtio-scsi-pci or similar) to
> trigger its use in a VM.

It seems more likely to me now that it may have nothing to do with the
SCSI-settings. Perhaps with some other config-option that's not set in a
defconfig.

I had hoped the problem would show up in the VM, so I could have safely
bisected it there. But tough luck.

So long!

Rainer Fiebig


>=20
> Guenter
>=20
>> The definite cause of this can only be found by bisecting, IMO. And it=
 needs=20
>> to be pinned down because else some feeling of insecurity will remain.=

>>
>> So long!
>>
>> Rainer Fiebig
>>
>>>
>>>> [trying again, this time with correct kernel.org address]
>>>>
>>>> Hi,
>>>>
>>>> I have seen the following and similar problems several times,
>>>> with both v4.19.3 and v4.19.4:
>>>>
>>>> Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device s=
db1):
>>>> ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (in=
ode
>>>> size 256)
>>>> Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on dev=
ice
>>>> sdb1-8. Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1):=

>>>> Remounting filesystem read-only Nov 23 04:32:25 mars kernel:
>>>> [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode
>>>> #12602881: comm rm: bad extra_isize 33685 (inode size 256)
>>>> ...
>>>>
>>>> Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device =
sda1):
>>>> ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted in=
ode
>>>> referenced: 238160407
>>>> Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on de=
vice
>>>> sda1-8. Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1)=
:
>>>> Remounting filesystem read-only ...
>>>>
>>>> Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device=

>>>> sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode
>>>> referenced: 52043796
>>>> Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on d=
evice
>>>> sda1-8. Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda1=
):
>>>> Remounting filesystem read-only
>>>>
>>>>
>>>> The same systems running v4.18.6 never experienced a problem.
>>>>
>>>> Has anyone else seen similar problems ? Is there anything I can do
>>>> to help tracking down the problem ?
>>>>
>>>> Thanks,
>>>> Guenter
>>
>> --=20
>> The truth always turns out to be simpler than you thought.
>> Richard Feynman
>=20
>=20



--SbQYsgVsPm5IkRJPb5ZHjeHBV5vK3dpP1--

--mFeNj4Q8ttMRQBmq2sOG9ojwA7yHwpEWm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv+Zm8ACgkQ8OH3JiWK
+PUagQ//Vz3/FSlRLfrQhm/b0kAhVJPdT+zQ0CYratQQBYl/1ETHgUkmsWJY9u5H
5m0DlBkT2LTRWaaZT6eFpOkdnSK+xofn8cgPfBPvnpbeFf+AYAO6wupxRwsBZnJb
JIdhvWg25spx5EEgPircp5l2ZYk9eO74dPgNkskjhWOYfvplLRZ43rd6tRL9hi4U
hxVDMD4cC/cpFgY0vkMtz1c8HKUtAhKs329kS9zhFa6+4h/vwwy+XxkltCzWwsYj
s4vWKPUR6cMGmLTAy6uzPPZruFO9UiLlT97Qw6culB3wyovftAfubVjbrerPGZrV
kuZxYrxFyS4lBxfxGXYJ2W8v6detvO0imGHh/4wtConJCY4vWpxJA6KX3IrwYucF
k5H6ekz5IjMv+kZZPZ/IYYqDAdUIgZKAlAaI5ZV5zzVs6I3AhftdfxBOrKu1aosH
sOZ//stbZtP3DV/g0wx+6siZGbEoexTUBtwe5ZiauTNCN0/Q6y0JcZ7TJcnkgcC5
DD1rncm7gSy1gDe86VyyxbSf1kPS/WDycJ6tIEIqD9IbADyKq5tbBR4PeZsT+lBw
9sD+kQ/RUSaTKQBjrKPbX3/6eanSmuwqVSyFOZosYZJzQB/0ZnyRNLXnt8IlEA2H
lwHOfP9GE+XCXi/jNfR9omJxYf1eJeyme9USWBg09q+2hdyYM4o=
=bFdK
-----END PGP SIGNATURE-----

--mFeNj4Q8ttMRQBmq2sOG9ojwA7yHwpEWm--
