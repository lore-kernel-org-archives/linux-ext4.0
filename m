From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix mb_find_next_bit not to return larger than
	max
Date: Wed, 09 Jul 2008 17:27:23 -0700
Message-ID: <1215649643.6978.16.camel@mingming-laptop>
References: <1215535496-15125-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53363 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYGJA1Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 20:27:25 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6A0ROgU029825
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 20:27:24 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A0RNqO172628
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 18:27:23 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6A0RN1u009768
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2008 18:27:23 -0600
In-Reply-To: <1215535496-15125-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-08=E4=BA=8C=E7=9A=84 22:14 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> Some architectures implement ext4_find_next_bit and
> ext4_find_next_zero_bit in such a way that they return
> greater than max for some input values. Make sure
> mb_find_next_bit and mb_find_next_zero_bit return the
> right values.
>=20

I am not quite clear what bad things happen when  ext4_find_next_bit()
returns greater than max?   Not sure why we need to force it return
within the range..

Just looking at the code it seems all handles properly that if the
return > max,  only one is missing is checking in  t ext4_find_next_bit
(),  (as the lustr e patch does), no?

> On 2.6.25 we have include/asm-x86/bitops_32.h
> static inline unsigned find_first_bit(const unsigned long *addr, unsi=
gned size)
> {
> 	unsigned x =3D 0;
>=20
> 	while (x < size) {
> 		unsigned long val =3D *addr++;
> 		if (val)
> 			return __ffs(val) + x;
> 		x +=3D (sizeof(*addr)<<3);
> 	}
> 	return x;
> }
>=20
> This can return value greater than size.
>=20
> Reported and fixed here for lustre
>=20
> https://bugzilla.lustre.org/show_bug.cgi?id=3D15932
> https://bugzilla.lustre.org/attachment.cgi?id=3D17205
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a1e58fb..d2c61eb 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -381,22 +381,28 @@ static inline void mb_clear_bit_atomic(spinlock=
_t *lock, int bit, void *addr)
>=20
>  static inline int mb_find_next_zero_bit(void *addr, int max, int sta=
rt)
>  {
> -	int fix =3D 0;
> +	int fix =3D 0, ret, tmpmax;
>  	addr =3D mb_correct_addr_and_bit(&fix, addr);
> -	max +=3D fix;
> +	tmpmax =3D max + fix;
>  	start +=3D fix;
>=20
> -	return ext4_find_next_zero_bit(addr, max, start) - fix;
> +	ret =3D ext4_find_next_zero_bit(addr, tmpmax, start) - fix;
> +	if (ret > max)
> +		return max;
> +	return ret;
>  }
>=20

I missed something basic here,  why we need to check ret against the
tmpmax instead of the max after adjust? (Actually not quite sure why we
need to correct the address in the first place).=20


>  static inline int mb_find_next_bit(void *addr, int max, int start)
>  {
> -	int fix =3D 0;
> +	int fix =3D 0, ret, tmpmax;
>  	addr =3D mb_correct_addr_and_bit(&fix, addr);
> -	max +=3D fix;
> +	tmpmax =3D max + fix;
>  	start +=3D fix;
>=20
> -	return ext4_find_next_bit(addr, max, start) - fix;
> +	ret =3D ext4_find_next_bit(addr, tmpmax, start) - fix;
> +	if (ret > max)
> +		return max;
> +	return ret;
>  }
>=20
>  static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *m=
ax)
> @@ -3633,8 +3639,6 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b=
, struct buffer_head *bitmap_bh,
>  		if (bit >=3D end)
>  			break;
>  		next =3D mb_find_next_bit(bitmap_bh->b_data, end, bit);
> -		if (next > end)
> -			next =3D end;
>  		start =3D group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
>  				le32_to_cpu(sbi->s_es->s_first_data_block);
>  		mb_debug("    free preallocated %u/%u in group %u\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
