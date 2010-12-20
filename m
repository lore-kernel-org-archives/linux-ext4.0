From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [01/15, RESEND] libext2fs: fix potential build failure with
 OMIT_COM_ERR
Date: Mon, 20 Dec 2010 10:04:36 -0500
Message-ID: <20101220150436.GC24990@thunk.org>
References: <1291020917-8671-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60298 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740Ab0LTPEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 10:04:38 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-2-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 28, 2010 at 10:55:03PM -0000, Namhyung Kim wrote:
> This fixes following build failure when OMIT_COM_ERR is defined:
>=20
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_clear_generic_b=
itmap=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:437: error: invalid storage class for functi=
on =E2=80=98ext2fs_test_clear_generic_bitmap_range=E2=80=99
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_get_generic_bit=
map_end=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_get_generic_bit=
map_start=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_unmark_generic_=
bitmap=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_mark_generic_bi=
tmap=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
>  lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_test_generic_bi=
tmap=E2=80=99:
>  lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statemen=
t at end of input
> make[2]: *** [gen_bitmap.o] Error 1
> make[2]: Leaving directory e2fsprogs/lib/ext2fs'
> make[1]: *** [all-libs-recursive] Error 1
> make[1]: Leaving directory e2fsprogs'
> make: *** [all] Error 2
>=20
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
