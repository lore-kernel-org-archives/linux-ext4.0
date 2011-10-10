From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs: use ALL_CFLAGS to build gen_crc32ctable
Date: Mon, 10 Oct 2011 12:39:10 -0500
Message-ID: <4E932DBE.7080203@redhat.com>
References: <4E89DF57.90806@redhat.com> <20111004030232.GA28372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1JJRjO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 13:39:14 -0400
In-Reply-To: <20111004030232.GA28372@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/3/11 10:02 PM, Ted Ts'o wrote:
> On Mon, Oct 03, 2011 at 06:14:15AM -0000, Eric Sandeen wrote:
>> With just BUILD_CFLAGS this we don't get the right include
>> paths (i.e. within the tree) to build the gen_crc32ctable binary.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>=20
> We can't use ALL_CFLAGS because in the cross compilation case, it
> might contain some compiler directives that make sense for the target
> platform, but not for the host platform.  BUILD_CFLAGS is specificall=
y
> designed for this case.  For programs like gen_crc32ctable that need
> to compiled and run on the host OS, you have to do the following so
> the right thing happens when you are cross-compiling e2fsprogs (yes,
> there are people who do this!):
>=20
> gen_crc32ctable: $(srcdir)/gen_crc32ctable.c
> 	$(E) "	CC $@"
> 	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32ctable \
> 		$(srcdir)/gen_crc32ctable.c
>=20
> Note the use of $(BUILD_CC) instead of $(CC).
>=20
> The better fix is to note that gen_crc32ctable doesn't actually need
> anything from ext2fs.h, and move that #include to crc32c.c.
>=20
> 	      		    	      - Ted
>=20
> commit 8232f2ddaece256afd323eb5a289a5ec1b7fbd1a
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Oct 3 22:49:45 2011 -0400
>=20
>     libext2fs: move #include "ext2fs.h" from crc32c_defs.h to crc32c.=
c
>    =20
>     The byte swap functions which are defined in ext2fs.h are only ne=
eded
>     by crc32.c, and not by gen_crc32ctable.c.  The gen_crc32ctable pr=
ogram
>     needs to be compiled on the host OS, where ext2fs.h may not be
>     present.  So move the use of the header function to crc32c.c, to =
avoid
>     compilation problems.
>    =20
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>=20
> diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
> index 65bca5c..6be4336 100644
> --- a/lib/ext2fs/crc32c.c
> +++ b/lib/ext2fs/crc32c.c
> @@ -40,6 +40,23 @@
>  #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
>  #include "crc32c_defs.h"
> =20
> +#include "ext2fs.h"
> +#ifdef WORDS_BIGENDIAN

well, this has the exact same problem as originally reported, because
we still don't have the include paths to find ext2fs.h in the tree,
and it is still included via crc32c_defs.h

Perhaps I should have been more explicit about it last time.

I get:

making all in lib/ext2fs
make[2]: Entering directory `/src2/git/fedora/e2fsprogs/e2fsprogs-1.42/=
lib/ext2fs'
gcc -g -O2 -o gen_crc32ctable \
		./gen_crc32ctable.c
In file included from ./crc32c_defs.h:45,
                 from ./gen_crc32ctable.c:2:
=2E/ext2fs.h:73:31: error: ext2fs/ext2_types.h: No such file or directo=
ry
=2E/ext2fs.h:74:28: error: ext2fs/ext2_fs.h: No such file or directory
=2E/ext2fs.h:75:33: error: ext2fs/ext3_extents.h: No such file or direc=
tory
In file included from ./crc32c_defs.h:45,
                 from ./gen_crc32ctable.c:2:
=2E/ext2fs.h:78: error: expected =91=3D=92, =91,=92, =91;=92, =91asm=92=
 or =91__attribute__=92 before =91ext2_ino_t=92

=2E..

Looking into it, but if you have an obvious solution I'm all ears.

-Eric

> +#define __constant_cpu_to_le32(x) ___constant_swab32((x))
> +#define __constant_cpu_to_be32(x) (x)
> +#define __be32_to_cpu(x) (x)
> +#define __cpu_to_be32(x) (x)
> +#define __cpu_to_le32(x) (ext2fs_cpu_to_le32((x)))
> +#define __le32_to_cpu(x) (ext2fs_le32_to_cpu((x)))
> +#else
> +#define __constant_cpu_to_le32(x) (x)
> +#define __constant_cpu_to_be32(x) ___constant_swab32((x))
> +#define __be32_to_cpu(x) (ext2fs_be32_to_cpu((x)))
> +#define __cpu_to_be32(x) (ext2fs_cpu_to_be32((x)))
> +#define __cpu_to_le32(x) (x)
> +#define __le32_to_cpu(x) (x)
> +#endif
> +
>  #if CRC_LE_BITS > 8
>  # define tole(x) (__force uint32_t) __constant_cpu_to_le32(x)
>  #else
> diff --git a/lib/ext2fs/crc32c_defs.h b/lib/ext2fs/crc32c_defs.h
> index ced4f67..023f2c0 100644
> --- a/lib/ext2fs/crc32c_defs.h
> +++ b/lib/ext2fs/crc32c_defs.h
> @@ -42,23 +42,6 @@
>  		(((uint32_t)(x) & (uint32_t)0xff000000UL) >> 24)))
> =20
> =20
> -#include "ext2fs.h"
> -#ifdef WORDS_BIGENDIAN
> -#define __constant_cpu_to_le32(x) ___constant_swab32((x))
> -#define __constant_cpu_to_be32(x) (x)
> -#define __be32_to_cpu(x) (x)
> -#define __cpu_to_be32(x) (x)
> -#define __cpu_to_le32(x) (ext2fs_cpu_to_le32((x)))
> -#define __le32_to_cpu(x) (ext2fs_le32_to_cpu((x)))
> -#else
> -#define __constant_cpu_to_le32(x) (x)
> -#define __constant_cpu_to_be32(x) ___constant_swab32((x))
> -#define __be32_to_cpu(x) (ext2fs_be32_to_cpu((x)))
> -#define __cpu_to_be32(x) (ext2fs_cpu_to_be32((x)))
> -#define __cpu_to_le32(x) (x)
> -#define __le32_to_cpu(x) (x)
> -#endif
> -
>  #if (__GNUC__ >=3D 3)
>  #define likely(x)	__builtin_expect(!!(x), 1)
>  #define unlikely(x)	__builtin_expect(!!(x), 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
