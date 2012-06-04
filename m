From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 01/10] string: introduce memweight
Date: Mon, 4 Jun 2012 20:46:14 +0900
Message-ID: <CAC5umyjP0Pov1a3b7N3VzNVHc1uhan2tLmy2_bOzWeY0u7h2FA@mail.gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
	<20120604101237.GD7670@quack.suse.cz>
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
	"Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56565 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759630Ab2FDLqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2012 07:46:15 -0400
In-Reply-To: <20120604101237.GD7670@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/6/4 Jan Kara <jack@suse.cz>:
> On Sat 02-06-12 22:40:07, Akinobu Mita wrote:
>> memweight() is the function that counts the total number of bits set
>> in memory area. =A0Unlike bitmap_weight(), memweight() takes pointer
>> and size in bytes to specify a memory area which does not need to be
>> aligned to long-word boundary.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Anders Larsen <al@alarsen.net>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: dm-devel@redhat.com
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: linux-media@vger.kernel.org
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Cc: ocfs2-devel@oss.oracle.com
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-ext4@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> ---
>>
>> v2: simplify memweight(), adviced by Jan Kara
>>
>> =A0include/linux/string.h | =A0 =A03 +++
>> =A0lib/string.c =A0 =A0 =A0 =A0 =A0 | =A0 32 +++++++++++++++++++++++=
+++++++++
>> =A02 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index e033564..ffe0442 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -145,4 +145,7 @@ static inline bool strstarts(const char *str, co=
nst char *prefix)
>> =A0 =A0 =A0 return strncmp(str, prefix, strlen(prefix)) =3D=3D 0;
>> =A0}
>> =A0#endif
>> +
>> +extern size_t memweight(const void *ptr, size_t bytes);
>> +
>> =A0#endif /* _LINUX_STRING_H_ */
>> diff --git a/lib/string.c b/lib/string.c
>> index e5878de..bf4d5a8 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -26,6 +26,7 @@
>> =A0#include <linux/export.h>
>> =A0#include <linux/bug.h>
>> =A0#include <linux/errno.h>
>> +#include <linux/bitmap.h>
>>
>> =A0#ifndef __HAVE_ARCH_STRNICMP
>> =A0/**
>> @@ -824,3 +825,34 @@ void *memchr_inv(const void *start, int c, size=
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
>> + =A0 =A0 const unsigned char *bitmap =3D ptr;
>> +
>> + =A0 =A0 for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes--, bitmap++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 w +=3D hweight8(*bitmap);
>> +
>> + =A0 =A0 longs =3D bytes / sizeof(long);
>> + =A0 =A0 if (longs) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(longs >=3D INT_MAX / BITS_PER_LONG)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 w +=3D bitmap_weight((unsigned long *)bitm=
ap,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 longs * BI=
TS_PER_LONG);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bytes -=3D longs * sizeof(long);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bitmap +=3D longs * sizeof(long);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 for (; bytes > 0; bytes--, bitmap++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 w +=3D hweight8(*bitmap);
> =A0Looking at bitmap_weight() it seems this last loop is not needed. =
Just
> pass to bitmap_weight() bytes*BITS_PER_BYTE. Also generally this func=
tion
> doesn't seem necessary at all at least for ext2 & ext3 (sorry for not
> noticing this earlier...).

This last loop is necessary for big-endian architecture.
if bytes % sizeof(long) !=3D 0, bitmap_weight() counts one-bits in wron=
g
byte-field
of the last long word.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
