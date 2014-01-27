From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How many files to create in one directory?
Date: Mon, 27 Jan 2014 12:02:39 -0600
Message-ID: <52E69F3F.2000104@redhat.com>
References: <52E607B1.2060206@jprs.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Masato Minda <minmin@jprs.co.jp>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaA0SCo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jan 2014 13:02:44 -0500
In-Reply-To: <52E607B1.2060206@jprs.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/27/14, 1:16 AM, Masato Minda wrote:
> Dear Ext4 Developer;
>=20
> I've copied the files from VxFS to EXT4, I saw the message =93Directo=
ry
> index full!=94. I've checked the search engine and found these mails.
>=20
>   http://www.spinics.net/lists/linux-ext4/msg25058.html
>   http://www.spinics.net/lists/linux-ext4/msg25069.html
>=20
> Our Ext4's block size was 1024. I've changed the block size from 1024=
 to
> 4096. Our problem was solved. But I have question.
>=20
> How many files to create in one directory in 4096 block size?
> I think that it is about 3 million files with perfect hashing.
>=20
>   16*(4096-16)/8*(4096-8)/8*3/4=3D 3M
>=20
> Is this correct?

It will depend on the length of the filenames.  But by my calculations,
for average 28-char filenames, it's closer to 30 million.

There are (4096-32)/8 indices per block, or 508.
There are 2 levels, so 508*508=3D258064 leaf blocks.
The length of each record for 28 char names would be 32 bytes.
So you can fit 4096/32 =3D 128 entries per leaf block.
258064 leaf blocks * 128 entries/bock is 33,032,192 entries.

I recently made a spreadsheet to calculate this.
I'm not sure if I am doing google docs sharing and protection
correctly, but this might work:

https://docs.google.com/spreadsheet/ccc?key=3D0AtdHTZsZ8XoYdE1IUXlDb1RX=
QkdPM3F4YWpfNGhMbFE&usp=3Dsharing#gid=3D0

-Eric

> Thanks in advance.
>=20
> --
> Masato minmin Minda <minmin@jprs.co.jp>
> Japan Registry Services Co., Ltd. (JPRS)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
