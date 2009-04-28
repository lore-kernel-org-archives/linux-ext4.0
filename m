From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
 during write_begin with delayed allocation
Date: Mon, 27 Apr 2009 22:03:32 -0500
Message-ID: <49F67204.5000108@redhat.com>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51863 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZD1DDj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 23:03:39 -0400
In-Reply-To: <1240873494.6775.8.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> =E5=9C=A8 2009-04-28=E4=BA=8C=E7=9A=84 00:35 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
>> We need to mark the  buffer_head mapping prealloc space
>> as new during write_begin. Otherwise we don't zero out the
>> page cache content properly for a partial write. This will
>> cause file corruption with preallocation.
>>
>=20
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>> ---
>>  fs/ext4/inode.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c6bd6ce..c7251ec 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -2323,6 +2323,8 @@ static int ext4_da_get_block_prep(struct inode=
 *inode, sector_t iblock,
>>  		set_buffer_delay(bh_result);
>>  	} else if (ret > 0) {
>>  		bh_result->b_size =3D (ret << inode->i_blkbits);
>> +		if (buffer_unwritten(bh_result))
>> +			set_buffer_new(bh_result);
>>  		ret =3D 0;
>>  	}
>>
>=20
> Thanks Aneesh.
>=20
> Just to share with list, I have seen garbage content show up on a
> preallocated but later partially written blocks. This only happens wi=
th
> delayed allocation. The test simply preallocate 2blocks to a new file=
,
> then write a few bytes to the beginning of file(less than a block), a=
nd
> od shows the first block the written content followed by garbage fill=
ed
> to the end of the first block.
>=20
> After examing the code, we did set the buffer as new for nondelalloc,=
 as
> the create flag passed to ext4_ext_get_blocks() is 1, while for delal=
loc
> case, ext4_get_blocks_prep() calling ext4_ext_get_block() with create
> =3D0, which leads to the code path that forget to set the bh as new i=
f the
> block is preallocated.
>=20
> This patch is mostly correct except forget to set the bh_result->bdev=
,
> which caused the fs blow out.

Yep, I saw the oops too.

> The updated patch fixed the problem for me.
>=20
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>=20
> Index: linux-2.6.28-rc6/fs/ext4/inode.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.28-rc6.orig/fs/ext4/inode.c	2009-03-12 10:21:05.0000000=
00 -0700
> +++ linux-2.6.28-rc6/fs/ext4/inode.c	2009-04-27 14:35:21.000000000 -0=
700
> @@ -2177,7 +2177,10 @@ static int ext4_da_get_block_prep(struct
>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		bh_result->b_size =3D (ret << inode->i_blkbits);
> +		bh_result->b_bdev =3D inode->i_sb->s_bdev;
>  		ret =3D 0;
>  	}

It may be just me, but I'd like to sort out why we now need to set
b_bdev here just because we set it as new, and it wasn't necessary
before...?  If it's obvious I'm not yet seeing it :)

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
