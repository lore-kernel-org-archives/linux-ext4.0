From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 01/10] string: introduce memweight
Date: Tue, 5 Jun 2012 18:03:14 +0900
Message-ID: <CAC5umyiLojOEuE6wyMk-Duf8C2skMhF2G4zw+3_qO_s2-F_nKg@mail.gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
	<20120604101237.GD7670@quack.suse.cz>
	<CAC5umyjP0Pov1a3b7N3VzNVHc1uhan2tLmy2_bOzWeY0u7h2FA@mail.gmail.com>
	<20120604133509.GA11010@quack.suse.cz>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120604133509.GA11010@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/6/4 Jan Kara <jack@suse.cz>:
> On Mon 04-06-12 20:46:14, Akinobu Mita wrote:
>> 2012/6/4 Jan Kara <jack@suse.cz>:
>> > On Sat 02-06-12 22:40:07, Akinobu Mita wrote:
>> >> memweight() is the function that counts the total number of bits =
set
>> >> in memory area. =E1Unlike bitmap_weight(), memweight() takes poin=
ter
>> >> and size in bytes to specify a memory area which does not need to=
 be
>> >> aligned to long-word boundary.
>> >>
>> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> >> Cc: Anders Larsen <al@alarsen.net>
>> >> Cc: Alasdair Kergon <agk@redhat.com>
>> >> Cc: dm-devel@redhat.com
>> >> Cc: linux-fsdevel@vger.kernel.org
>> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> >> Cc: linux-media@vger.kernel.org
>> >> Cc: Mark Fasheh <mfasheh@suse.com>
>> >> Cc: Joel Becker <jlbec@evilplan.org>
>> >> Cc: ocfs2-devel@oss.oracle.com
>> >> Cc: Jan Kara <jack@suse.cz>
>> >> Cc: linux-ext4@vger.kernel.org
>> >> Cc: Andrew Morton <akpm@linux-foundation.org>
>> >> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> >> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> >> Cc: Matthew Wilcox <matthew@wil.cx>
>> >> ---
>> >>
>> >> v2: simplify memweight(), adviced by Jan Kara
>> >>
>> >> =E1include/linux/string.h | =E1 =E13 +++
>> >> =E1lib/string.c =E1 =E1 =E1 =E1 =E1 | =E1 32 ++++++++++++++++++++=
++++++++++++
>> >> =E12 files changed, 35 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/include/linux/string.h b/include/linux/string.h
>> >> index e033564..ffe0442 100644
>> >> --- a/include/linux/string.h
>> >> +++ b/include/linux/string.h
>> >> @@ -145,4 +145,7 @@ static inline bool strstarts(const char *str,=
 const char *prefix)
>> >> =E1 =E1 =E1 return strncmp(str, prefix, strlen(prefix)) =3D=3D 0;
>> >> =E1}
>> >> =E1#endif
>> >> +
>> >> +extern size_t memweight(const void *ptr, size_t bytes);
>> >> +
>> >> =E1#endif /* _LINUX_STRING_H_ */
>> >> diff --git a/lib/string.c b/lib/string.c
>> >> index e5878de..bf4d5a8 100644
>> >> --- a/lib/string.c
>> >> +++ b/lib/string.c
>> >> @@ -26,6 +26,7 @@
>> >> =E1#include <linux/export.h>
>> >> =E1#include <linux/bug.h>
>> >> =E1#include <linux/errno.h>
>> >> +#include <linux/bitmap.h>
>> >>
>> >> =E1#ifndef __HAVE_ARCH_STRNICMP
>> >> =E1/**
>> >> @@ -824,3 +825,34 @@ void *memchr_inv(const void *start, int c, s=
ize_t bytes)
>> >> =E1 =E1 =E1 return check_bytes8(start, value, bytes % 8);
>> >> =E1}
>> >> =E1EXPORT_SYMBOL(memchr_inv);
>> >> +
>> >> +/**
>> >> + * memweight - count the total number of bits set in memory area
>> >> + * @ptr: pointer to the start of the area
>> >> + * @bytes: the size of the area
>> >> + */
>> >> +size_t memweight(const void *ptr, size_t bytes)
>> >> +{
>> >> + =E1 =E1 size_t w =3D 0;
>> >> + =E1 =E1 size_t longs;
>> >> + =E1 =E1 const unsigned char *bitmap =3D ptr;
>> >> +
>> >> + =E1 =E1 for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(lo=
ng);
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 bytes--, bitmap++)
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 w +=3D hweight8(*bitmap);
>> >> +
>> >> + =E1 =E1 longs =3D bytes / sizeof(long);
>> >> + =E1 =E1 if (longs) {
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 BUG_ON(longs >=3D INT_MAX / BITS_PER_LO=
NG);
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 w +=3D bitmap_weight((unsigned long *)b=
itmap,
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 =E1 longs *=
 BITS_PER_LONG);
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 bytes -=3D longs * sizeof(long);
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 bitmap +=3D longs * sizeof(long);
>> >> + =E1 =E1 }
>> >> +
>> >> + =E1 =E1 for (; bytes > 0; bytes--, bitmap++)
>> >> + =E1 =E1 =E1 =E1 =E1 =E1 w +=3D hweight8(*bitmap);
>> > =E1Looking at bitmap_weight() it seems this last loop is not neede=
d. Just
>> > pass to bitmap_weight() bytes*BITS_PER_BYTE. Also generally this f=
unction
>> > doesn't seem necessary at all at least for ext2 & ext3 (sorry for =
not
>> > noticing this earlier...).
>>
>> This last loop is necessary for big-endian architecture.
>> if bytes % sizeof(long) !=3D 0, bitmap_weight() counts one-bits in w=
rong
>> byte-field
>> of the last long word.
> =A0Ah, right. OK. Add this to the comment before the loop please. You=
 save
> yourself some explanations :)

OK.  Thanks for your advice again.
