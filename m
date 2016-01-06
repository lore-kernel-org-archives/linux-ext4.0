From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Wed, 6 Jan 2016 12:17:45 -0700
Message-ID: <E3F0FC8F-DE43-41F4-9E7B-E732867130FC@dilger.ca>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com> <20151222150037.GB18178@quack.suse.cz> <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com> <20160105153050.GF14464@quack.suse.cz> <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CA8E947F-22C2-44FC-AF9D-91D6A93323E9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37981 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcAFTRv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2016 14:17:51 -0500
Received: by mail-ig0-f181.google.com with SMTP id mw1so39085557igb.1
        for <linux-ext4@vger.kernel.org>; Wed, 06 Jan 2016 11:17:51 -0800 (PST)
In-Reply-To: <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CA8E947F-22C2-44FC-AF9D-91D6A93323E9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jan 5, 2016, at 7:39 PM, HUANG Weller (CM/ESW12-CN) =
<Weller.Huang@cn.bosch.com> wrote:
>=20
>> So you are running in 'ws' mode of your tool, am I right? Just =
looking into the
>> sources you've sent me I've noticed that although you set O_SYNC in =
openflg
>> when mode =3D=3D MODE_WS, you do not use openflg at all. So file =
won't be synced
>> at all. That would well explain why you see that not all file =
contents is written. So
>> did you just send me a different version of the source or is your =
test program
>> really buggy?
>>=20
>=20
> Yes, it is a bug of the test code. So the test tool create files =
without O_SYNC flag actually.
> But , even in this case, is the out of order acceptable ? or is it =
normal ?

Without O_SYNC there is no ordering guarantee between non-overlapping =
writes.  They may be reordered by the filesystem or the elevator or the =
storage device.

Cheers, Andreas

>=20
>>=20
>>>>> [root@SiRFatlas6 ~]# debugfs /dev/nandblk0p3 debugfs 1.42.9
>>>>> (28-Dec-2013)
>>>>> debugfs:  imap test/hp0000017aMhWY3i0vMv Inode 390 is part of
>>>>> block group 0
>>>>>        located at block 141, offset 0x0280
>>>>>=20
>>>>> 00000280  80 81 00 00 10 00 04 00  c8 09 00 00 66 0a 00 00
>>>>> |............f...|
>>>>> 00000290  66 0a 00 00 00 00 00 00  00 00 01 00 04 02 00 00
>>>>> |f...............|
>>>>> 000002a0  00 00 08 00 01 00 00 00  0a f3 02 00 04 00 00 00
>>>>> |................|
>>>>> 000002b0  00 00 00 00 00 00 00 00  80 00 00 00 00 2c 01 00
>>>>> |.............,..|  =3D=3D> the file contents is at 0x00012c00
>>>>> 000002c0  80 00 00 00 01 00 00 00  8e 26 01 00 00 00 00 00
>>>>> |.........&......|
>>>>>=20
>>>>>=20
>>>>> Search the block number from the journal blocks:
>>>>>=20
>>>>> [root@SiRFatlas6 ~]# hexdump j.bin  -C |  grep "00 2c 01 00"
>>>>> 00039ab0  00 00 00 00 00 00 00 00  80 00 00 00 00 2c 01 00
>>>>> |.............,..|
>>>>>=20
>>>>> Search file name which the file checksum is error in journal =
blocks:
>>>>>=20
>>>>> [root@SiRFatlas6 ~]# hexdump j.bin  -C |  grep "3i0vMv" -B1
>>>>> 00030c60  86 01 00 00 1c 00 14 01  68 70 30 30 30 30 30 31
>>>>> |........hp000001|
>>>>> 00030c70  37 61 4d 68 57 59 33 69  30 76 4d 76 88 01 00 00
>>>>> |7aMhWY3i0vMv....|
>>>>>=20
>>>>>=20
>>>>> List all journal block record to check which journal block records =
it:
>>>>>=20
>>>>> [root@SiRFatlas6 ~]# hexdump j.bin -C | grep "c0 3b 39 98"
>>>>> 00000000  c0 3b 39 98 00 00 00 04  00 00 00 00 00 00 08 00
>>>>> |.;9.............|
>>>>> 00000800  c0 3b 39 98 00 00 00 05  00 00 00 6f 00 00 00 24
>>>>> |.;9........o...$|
>>>>> 00001000  c0 3b 39 98 00 00 00 01  00 00 00 6f 00 00 00 75
>>>>> |.;9........o...u|
>>>>> 0000c800  c0 3b 39 98 00 00 00 02  00 00 00 6f 00 00 00 00
>>>>> |.;9........o....|
>>>>> 0000d000  c0 3b 39 98 00 00 00 01  00 00 00 70 00 00 00 65
>>>>> |.;9........p...e|
>>>>> 00016000  c0 3b 39 98 00 00 00 02  00 00 00 70 00 00 00 00
>>>>> |.;9........p....|
>>>>> 00016800  c0 3b 39 98 00 00 00 01  00 00 00 71 00 00 00 7c
>>>>> |.;9........q...||
>>>>> 00021000  c0 3b 39 98 00 00 00 02  00 00 00 71 00 00 00 00
>>>>> |.;9........q....|
>>>>> 00021800  c0 3b 39 98 00 00 00 01  00 00 00 72 00 00 00 82
>>>>> |.;9........r....|
>>>>> 0002d000  c0 3b 39 98 00 00 00 02  00 00 00 72 00 00 00 00
>>>>> |.;9........r....|
>>>>> 0002d800  c0 3b 39 98 00 00 00 01  00 00 00 73 00 00 00 88
>>>>> |.;9........s....|
>>>> =3D=3D>00039ab0 is in last block, the file name and the start block
>>>> number are all recorded in the journals.
>>>>> 0003a000  c0 3b 39 98 00 00 00 02  00 00 00 73 00 00 00 00
>>>>> |.;9........s....|
>>>>>=20
>>>>>=20
>>>>> Back to see the kernel log which it print all the block numbers:
>>>>>=20
>>>>> ...
>>>>> ...
>>>>> [   46.222671] 244109  75277
>>>>> [   46.222693]
>>>>> [   46.272438] 244352  75520
>>>>> [   46.272460]
>>>>> [   46.348417] 238443  69611
>>>>> [   46.348438]
>>>>> [   46.349811] 244480  75648
>>>>> [   46.352287]
>>>>> [   46.404904] 244609  75777
>>>>> [   46.404926]
>>>>> [   46.454698] 244738  75906
>>>>> [   46.454719]
>>>>> [   46.505439] 244992  76160
>>>>> [   46.505459]
>>>>> [   46.557783] 245120  76288
>>>>> [   46.557804]
>>>>> [   46.610075] 245249  76417
>>>>> [   46.610096]
>>>>> [   46.660196] 245378  76546
>>>>> [   46.660219]
>>>>> [   46.709906] 201691  32859   =3D=3D> journal start is 32768, so =
the offset is 91,
>>>> block size=3D2048,  so, the offset address in the j.bin is 0x2d800
>>>>> [   46.709928] J [   46.711233]
>>>>> [   46.740635] drop to 9v
>>>>> [   46.749540] 201716  32884
>>>>> [   46.749560] J S
>>>>> [   46.751039]
>>>>> [   46.753151] 245632  76800  =3D=3D> 76800 in hex is 0x012c00, it =
is the same
>> start
>>>> block of the file which checksum is error.
>>>>> [   46.755284]
>>>>> nanddisk idle -> 1.
>>>>> [   46.800227] 6v irq-2
>>>>>=20
>>>>>=20
>>>>> The j.bin offset 0x2d800
>>>>>=20
>>>>> 0002d800  c0 3b 39 98 00 00 00 01  00 00 00 73 00 00 00 88
>>>>> |.;9........s....|  =3D=3D>00039ab0 is in last block
>>>>> 0003a000  c0 3b 39 98 00 00 00 02  00 00 00 73 00 00 00 00
>>>>> |.;9........s....|
>>>>>=20
>>>>>=20
>>>>> Normally, ext4 will first write the file contents, and then write
>>>>> the journal and journal commit. Then after some delay, it will
>>>>> write the meta data.  So The journal blocks contains the meta data
>>>>> of the file which the file contents already been written before.
>>>>> But from above analysis,  the journal sequence 0x73 already
>>>>> contain the file
>>>>> name(hp0000017aMhWY3i0vMv) and the start block number(76800). So
>>>>> from the kernel log,  the block
>>>>> number(76800) should be available before the journal blocks but
>>>>> NOT after it.  It seems that there is out of order happen.
>>>>>=20
>>>>> Could you please help to check this issue ? or give a explanation
>>>>> about it ?  Many thanks.
>>>>>=20
>>>>> Best regards
>>>>>=20
>>>>> Weller HUANG
>>>>>=20
>>>>>=20
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe =
linux-ext4"
>>>>> in the body of a message to majordomo@vger.kernel.org More
>>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> --
>>>> Jan Kara <jack@suse.com>
>>>> SUSE Labs, CR
>>=20
>>=20
>>=20
>> --
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_CA8E947F-22C2-44FC-AF9D-91D6A93323E9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVo1oWnKl2rkXzB/gAQheYRAAvYpA/qII16jVrgoFyl6uSIYJAHBdifpD
TaVCXFNsuxzvlElKTnANBWbt3pF5kwF7iJvR45p68AEsl9zHhT29OmZGFm6ZlR6J
Fy6hXBTmOW8DPyvl/EwcLiqbo61ed+d0uPxdP6mJROgGBZcL5TQQFugOy8+pElR9
L6nEzrfkC7pukL5Qtxw5+MVNqv2I5mlWRLjTzyQowAEgu9U0cF8GwO/QdSI2Gd+M
TxQoyaQ64cplHzA1Xp0QiEYH2ygCQAkw8eCIz29ZCbEax9L9znaTa+Rv9DW7OICY
pnJ9Nuvmb30Uh+kD092O5p1JWoATPwwZbUKXtQ0/eSnR3jEN7oQ0mvhXDzY6GvC0
7NamjU/4EkWbGLnphrVrjDVPY6ezbGgrDwk5cFahXbSQjNyv8LPoOhqJhc9OhIeX
zsCPDBVv3KXLaP782SOa3edX7EMvMnO13RWKT6F+Tsc5GIa6z8lEPMj72d1Jj5Kn
aEIE1jjTByeLc3v8WQDLhxnvJp3YJwpSRy6GAVP5Php+rEVcEkvrbLm7sSQjElFq
q2E18HaRh1Dsg4ECGDzw98OqlBu3qZNjdqUn1RQehzeJJMZODaCv0EHQnzkhkWTH
SxSFLxp+MMGJHRqR5LNBkO5Nfej/BIt1fgIzjRn+tQJziD0RoK2DyMN0MVqrgxFO
L3Angr/YrYM=
=F8jL
-----END PGP SIGNATURE-----

--Apple-Mail=_CA8E947F-22C2-44FC-AF9D-91D6A93323E9--
