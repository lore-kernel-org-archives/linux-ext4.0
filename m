From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 5/5] libquota: remove NLS support
Date: Tue, 4 Oct 2011 09:24:25 -0700
Message-ID: <CAGr1F2Gfz4ZpMVMLDDuj9xh4vPr6Gzx0xtKpdF_5F3AU1dJ2tw@mail.gmail.com>
References: <1317744998-8238-1-git-send-email-tytso@mit.edu> <1317744998-8238-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:1169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab1JDQYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2011 12:24:50 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id p94GOmYD015500
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 09:24:49 -0700
Received: from pzk33 (pzk33.prod.google.com [10.243.19.161])
	by hpaq7.eem.corp.google.com with ESMTP id p94GOjHx031591
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 09:24:47 -0700
Received: by pzk33 with SMTP id 33so2607928pzk.8
        for <linux-ext4@vger.kernel.org>; Tue, 04 Oct 2011 09:24:45 -0700 (PDT)
In-Reply-To: <1317744998-8238-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thanks for the patches.
I do have patches that removes log_err() and log_fatal() and all
'exit()' calls (and bunch of other cleanups). I will send those
patches as soon as possible.

Thanks,

On Tue, Oct 4, 2011 at 9:16 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> In general libraries should never (a) call exit() or (b) print output
> directly to the stdout (they might be used by GUI programs. =C2=A0Fro=
m (b)
> follows (c), should never call internationalization functions
> directly.
>
> Also, since po/POTFILES.in wasn't edited, these strings weren't
> getting included in e2fsprogs.pot for translation, so the _()
> indirection didn't actually buy us anything.
>
> We eventually need to nuke all of the log_fatal() and log_err() from
> libquota, so best thing to do for now is remove NLS support
> completely; no point whipsawing the translators with strings to
> translate that will be disappearing soon anyway!
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =C2=A0lib/quota/common.h | =C2=A0 30 ++++--------------------------
> =C2=A01 files changed, 4 insertions(+), 26 deletions(-)
>
> diff --git a/lib/quota/common.h b/lib/quota/common.h
> index 48f191f..7b88003 100644
> --- a/lib/quota/common.h
> +++ b/lib/quota/common.h
> @@ -13,41 +13,19 @@
> =C2=A0# endif
> =C2=A0#endif
>
> -#ifdef ENABLE_NLS
> -#include <libintl.h>
> -#include <locale.h>
> -#define _(a) (gettext (a))
> -#ifdef gettext_noop
> -#define N_(a) gettext_noop (a)
> -#else
> -#define N_(a) (a)
> -#endif
> -#define P_(singular, plural, n) (ngettext (singular, plural, n))
> -#ifndef NLS_CAT_NAME
> -#define NLS_CAT_NAME "e2fsprogs"
> -#endif
> -#ifndef LOCALEDIR
> -#define LOCALEDIR "/usr/share/locale"
> -#endif
> -#else
> -#define _(a) (a)
> -#define N_(a) a
> -#define P_(singular, plural, n) ((n) =3D=3D 1 ? (singular) : (plural=
))
> -#endif
> -
> =C2=A0#define log_fatal(exit_code, format, ...) =C2=A0 =C2=A0 =C2=A0d=
o { \
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, _(=
"[FATAL] %s:%d:%s:: " format "\n"), \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "[=
=46ATAL] %s:%d:%s:: " format "\n", \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__FILE__, __LINE__, __func__, __VA_ARGS__); \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(exit_code=
); \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (0)
>
> =C2=A0#define log_err(format, ...) =C2=A0 fprintf(stderr, \
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _("[ERROR] %s:%d:%s:: " format "\n"=
), \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "[ERROR] %s:%d:%s:: " format "\n", =
\
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__FILE__, __LINE__, __func__,=
 __VA_ARGS__)
>
> =C2=A0#ifdef DEBUG_QUOTA
> =C2=A0# define log_debug(format, ...) =C2=A0 =C2=A0 =C2=A0 =C2=A0fpri=
ntf(stderr, \
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _("[DEBUG] %s:%d:%s:: " format "\n"=
), \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "[DEBUG] %s:%d:%s:: " format "\n", =
\
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__FILE__, __LINE__, __func__,=
 __VA_ARGS__)
> =C2=A0#else
> =C2=A0# define log_debug(format, ...)
> @@ -55,7 +33,7 @@
>
> =C2=A0#define BUG_ON(x) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0do { if ((x)) { \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=
printf(stderr, \
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 _("BUG_ON: %s:%d:: ##x"), \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 "BUG_ON: %s:%d:: ##x", \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0__FILE__, __LINE__); \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0e=
xit(2); \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} } while (0)
> --
> 1.7.4.1.22.gec8e1.dirty
>



--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
