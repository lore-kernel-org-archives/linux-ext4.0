From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 filesystem corruption across partitions
Date: Tue, 6 May 2014 16:38:36 -0600
Message-ID: <151D812A-0304-470C-AC67-B7A198408459@dilger.ca>
References: <1397747123.6833.24.camel@luigi> <20140417161249.GH18591@thunk.org> <20140505220130.1a256f9d@luigi> <20140506194006.GC5012@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2490A602-69A7-4B56-BE95-DD622F3A7A08"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Devrin Talen <dct23@cornell.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40668 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEFWit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2014 18:38:49 -0400
Received: by mail-pd0-f169.google.com with SMTP id z10so139530pdj.0
        for <linux-ext4@vger.kernel.org>; Tue, 06 May 2014 15:38:49 -0700 (PDT)
In-Reply-To: <20140506194006.GC5012@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2490A602-69A7-4B56-BE95-DD622F3A7A08
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 6, 2014, at 1:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, May 05, 2014 at 10:01:30PM -0400, Devrin Talen wrote:
>> 2. Write data to partition 12 via ADB (using `adb push ... /cache/`)
>=20
> Instead of using ADB, I would suggest writing a test program which
> writes a series of 512 byte sectors to a single large file in /cache.
> At the beginning of each 512 byte sector include a 4 byte serial
> number (which is incremented by one for each sector), a 4 byte testID
> which is different for each run of your test program, a time stamp, a
> CRC of these fields, and then fill the rest of the sector with some
> text string to make it easy to recognize this pattern.  It can be
> anything from 0xDEADBEEF, to a string such as "DEBUGGING RANDOM HW
> BUGS REALLY SUCKS".  :-)

We wrote a tool "llverfs" to do this years ago, for debugging problems
with >16TB LUN sizes and other 64/32-bit address truncation problems:

=
http://git.hpdd.intel.com/?p=3Dfs/lustre-release.git;a=3Dblob;f=3Dlustre/u=
tils/llverfs.c

It either partially fills the filesystem (write all files then read all
files, with one write per MB) to do a fast test of the system or can
optionally completely fill the filesystem and writes to every 4kB block
and then reads it back and verifies the data.

Each block contains the inode number, block offset, and a timestamp
(to distinguish between separate runs) so that it can detect where
badly written data is coming from.

There is a companion tool for doing block-device testing

=
http://git.hpdd.intel.com/?p=3Dfs/lustre-release.git;a=3Dblob;f=3Dlustre/u=
tils/llverdev.c

Caveat - we only ever use the llverfs on disposable filesystems, and
while I don't _think_ it will clobber the other files that already
exist, I've never tested it in such a manner.  Obviously, llverdev is
overwriting the whole block device, so it will erase all data in the
device it is pointed at.

Cheers, Andreas

> Now try to reproduce the problem with this write load.  If you can
> reproduce the problem, check and see if the corrupted file system
> block in the shows evidence of the string that was supposed to be
> written into /cache, showing up in /data.  You can also check the
> large file being written in the /cache has the expended serial number
> and checksum.
>=20
> This will allow you to see if a the block writes are just going to the
> wrong place on the SSD, or something else more strange might be going
> on.  Depending on the pattern of what blocks are ending up where they
> shouldn't, it might point towards different possible causes (i.e., a
> flaky solder joint, a buggy flash translation layer in the eMMC chip,
> etc.)
>=20
> Cheers,
>=20
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2490A602-69A7-4B56-BE95-DD622F3A7A08
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU2lkbHKl2rkXzB/gAQLa9Q/9HNrhsWOUN+Zzb+4cORNorniJgaetnvV8
j58AL33Db0+2Zh5aMs5QYfz3t2IfJU2AEsjicz3/VLzUVreqlFS5VygLWEVBst9r
Ul3GQwFS3//IWN7MSswBclwp1r80Zf0FFe5wME8+XTLvumF9AFd+Q1IyzzfeGhsR
rBa4qvDgfyNORuT1YvlrxlU8W/uydgSANI9A9g+Q+Q2ayWZSwOu2BqovR++MJfr9
MuabyKRMos7Y18yAgN0c7InDQ6j9Aa9yCzfuD9bMcyfGk9cnKZNyunh/r8rsDcvN
org1uZoQaLfro7s/1wQZNi21z3xSK2axxphQ9tmQxXdE1lCoKsS+gZovOlQY93Af
hswjDzJhphfZB3oEVkzujnKVeWyICHZvII6clgxoHNRAK2LyLlR9CZd1g/Ekesrg
v/3WE/UslL9s+638jg9KkIDlmevqvytX8QOOqx/YJVM/6BZV9h1wXze9fyuHKwAr
e/axLJuQFmaDbRZCiJahoTkmner7Zhzy58bQ74t+hxVvxIn1WHf1UH0XI6x/HrNK
kAwkgnSeVvKZcHodqMXXgOa8l44UM7DOaJ4+LVX5MABL+UJfiTIXlP8T9PveqqBi
HJr7T/IVwunjyg4Fbl6GyQudJQheKuwhTp/6kx5jwlevKXCbkr7Umly3FVYgy/nU
b6xvZJUIOr8=
=w5UO
-----END PGP SIGNATURE-----

--Apple-Mail=_2490A602-69A7-4B56-BE95-DD622F3A7A08--
