From: Janakiram Sistla <janakiram.sistla@gmail.com>
Subject: Re: [PATCH] fs : ext4 : super.c fixed coding style violations
 fs/ext4/super.c:41: WARNING: Use #include <linux/uaccess.h> instead of
 <asm/uaccess.h> fs/ext4/super.c:546: ERROR: "foo * bar" should be "foo *bar"
 fs/ext4/super.c:546: WARNING: space proh
Date: Tue, 16 Nov 2010 16:40:50 -0800
Message-ID: <AANLkTi=5wOtNV85bmfON6drn2zA9rAeDaO-VxG=Ck66o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51481 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab0KQAkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Nov 2010 19:40:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 4:41 PM, Vamsi Krishna B
<vamsikrishna.brahmajosyula@gmail.com> wrote:
> Signed-off-by: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
> ---
> =A0fs/ext4/super.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 61182fe..11a46dc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -38,7 +38,7 @@
> =A0#include <linux/ctype.h>
> =A0#include <linux/log2.h>
> =A0#include <linux/crc16.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>
> =A0#include <linux/kthread.h>
> =A0#include <linux/freezer.h>
> @@ -543,7 +543,7 @@ void __ext4_abort(struct super_block *sb, const c=
har *function,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0panic("EXT4-fs panic from previous err=
or\n");
> =A0}
>
> -void ext4_msg (struct super_block * sb, const char *prefix,
> +void ext4_msg(struct super_block *sb, const char *prefix,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *fmt, ...)
> =A0{
> =A0 =A0 =A0 =A0va_list args;
> @@ -1138,7 +1138,7 @@ static int bdev_try_to_free_page(struct super_b=
lock *sb, struct page *page,
>
> =A0#ifdef CONFIG_QUOTA
> =A0#define QTYPE2NAME(t) ((t) =3D=3D USRQUOTA ? "user" : "group")
> -#define QTYPE2MOPT(on, t) ((t) =3D=3D USRQUOTA?((on)##USRJQUOTA):((o=
n)##GRPJQUOTA))
> +#define QTYPE2MOPT(on, t) ((t) =3D=3D USRQUOTA ? ((on)##USRJQUOTA) :=
 ((on)##GRPJQUOTA))
>
> =A0static int ext4_write_dquot(struct dquot *dquot);
> =A0static int ext4_acquire_dquot(struct dquot *dquot);
> -

Vamsi,

Can you make the patch subject small ,very difficult to understand.

Regards,
Ram
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
