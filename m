From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: One question about ext4_fallocate
Date: Fri, 20 Jul 2012 14:39:23 +0800
Message-ID: <5008FD1B.9030203@gmail.com>
References: <50081EFC.5060601@gmail.com> <A9962DF5-1C88-4385-A8DA-20227E055910@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2GTGjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jul 2012 02:39:41 -0400
Received: by pbbrp8 with SMTP id rp8so5666914pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jul 2012 23:39:41 -0700 (PDT)
In-Reply-To: <A9962DF5-1C88-4385-A8DA-20227E055910@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B407=E6=9C=8819=E6=97=A5 23:42, Andreas Dilger wrote:
>=20
> On 2012-07-19, at 7:51 AM, Wang Sheng-Hui wrote:
>> I have one question about ext4_fallocate:
>> 	For its parameters, offset & len, it will preallocate
>> 	one space with length >=3D len, right?
>>
>> From the code:
>> 	map.m_lblk =3D offset >> blkbits;
>> 	/*
>> 	 * We can't just convert len to max_blocks because
>> 	 * If blocksize =3D 4096 offset =3D 3072 and len =3D 2048
>> 	 */
>> 	max_blocks =3D (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
>> 		- map.m_lblk;
>>
>> We can see that the target space is enlarged to the (floor, ceiling)=
 of=20
>> (offset, offset+len). Right?
>>
>> If I'm wrong, please correct me.
>=20
> A whole block has to be allocated for fallocate, but if KEEP_SIZE is =
not used, the i_size should be changed to match the actual requested si=
ze.
>=20

Got it.

=46rom the code:
	/* Return error if mode is not supported */
	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
		return -EOPNOTSUPP;

	if (mode & FALLOC_FL_PUNCH_HOLE)
		return ext4_punch_hole(file, offset, len);

ext4 only supports FALLOC_FL_KEEP_SIZE & FALLOC_FL_PUNCH_HOLE currently=
=2E
=46or FALLOC_FL_PUNCH_HOLE, it will turn to ext4_punch_hole, so the res=
t
path deals with only FALLOC_FL_KEEP_SIZE and thus it will use whole blo=
cks.

Thanks, Andreas.
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
