From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 01/10] string: introduce memweight
Date: Wed, 23 May 2012 21:12:18 +0900
Message-ID: <CAC5umyi=ridqRZGGh0+_xw0-GCN+69B33Qz82-9x4dVODGGx6w@mail.gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
	<20120523092113.GG10452@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43459 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2EWMMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2012 08:12:19 -0400
In-Reply-To: <20120523092113.GG10452@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/5/23 Jan Kara <jack@suse.cz>:
> On Sun 20-05-12 22:23:14, Akinobu Mita wrote:
>> memweight() is the function that counts the total number of bits set
>> in memory area. =A0The memory area doesn't need to be aligned to
>> long-word boundary unlike bitmap_weight().
> =A0Thanks for the patch. I have some comments below.

Thanks for the review.

>> @@ -824,3 +825,39 @@ void *memchr_inv(const void *start, int c, size=
_t bytes)
>> =A0 =A0 =A0 return check_bytes8(start, value, bytes % 8);
>> =A0}
>> =A0EXPORT_SYMBOL(memchr_inv);
>> +
>> +/**
>> + * memweight - count the total number of bits set in memory area
>> + * @ptr: pointer to the start of the area
>> + * @bytes: the size of the area
>> + */
>> +size_t memweight(const void *ptr, size_t bytes)
>> +{
>> + =A0 =A0 size_t w =3D 0;
>> + =A0 =A0 size_t longs;
>> + =A0 =A0 union {
>> + =A0 =A0 =A0 =A0 =A0 =A0 const void *ptr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *b;
>> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned long address;
>> + =A0 =A0 } bitmap;
> =A0Ugh, this is ugly and mostly unnecessary. Just use "const unsigned=
 char
> *bitmap".
>
>> +
>> + =A0 =A0 for (bitmap.ptr =3D ptr; bytes > 0 && bitmap.address % siz=
eof(long);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes--, bitmap.address++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 w +=3D hweight8(*bitmap.b);
> =A0This can be:
> =A0 =A0 =A0 =A0count =3D ((unsigned long)bitmap) % sizeof(long);

The count should be the size of unaligned area and it can be greater th=
an
bytes. So

        count =3D min(bytes,
                    sizeof(long) - ((unsigned long)bitmap) % sizeof(lon=
g));

> =A0 =A0 =A0 =A0while (count--) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0w +=3D hweight(*bitmap);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes--;
> =A0 =A0 =A0 =A0}
>> +
>> + =A0 =A0 for (longs =3D bytes / sizeof(long); longs > 0; ) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 size_t bits =3D min_t(size_t, INT_MAX & ~(=
BITS_PER_LONG - 1),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 longs * BITS_PER_LONG);
> =A0I find it highly unlikely that someone would have such a large bit=
map
> (256 MB or more on 32-bit). Also the condition as you wrote it can ju=
st
> overflow so it won't have the desired effect. Just do
> =A0 =A0 =A0 =A0BUG_ON(longs >=3D ULONG_MAX / BITS_PER_LONG);

The bits argument of bitmap_weight() is int type. So this should be

        BUG_ON(longs >=3D INT_MAX / BITS_PER_LONG);

> and remove the loop completely. If someone comes with such a huge bit=
map,
> the code can be modified easily (after really closely inspecting whet=
her
> such a huge bitmap is really well justified).

size_t memweight(const void *ptr, size_t bytes)
{
	size_t w =3D 0;
	size_t longs;
	const unsigned char *bitmap =3D ptr;

	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
			bytes--, bitmap++)
		w +=3D hweight8(*bitmap);

	longs =3D bytes / sizeof(long);
	BUG_ON(longs >=3D INT_MAX / BITS_PER_LONG);
	w +=3D bitmap_weight((unsigned long *)bitmap, longs * BITS_PER_LONG);
	bytes -=3D longs * sizeof(long);
	bitmap +=3D longs * sizeof(long);

	for (; bytes > 0; bytes--, bitmap++)
		w +=3D hweight8(*bitmap);

	return w;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
