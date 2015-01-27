From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] mke2fs: Fix German translation of mke2fs
Date: Tue, 27 Jan 2015 13:31:34 +0100
Message-ID: <54C78526.9070502@fastmail.fm>
References: <1422350355-21997-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57644 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308AbbA0Mbg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 07:31:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 88F8D206B2
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2015 07:31:35 -0500 (EST)
In-Reply-To: <1422350355-21997-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 01/27/2015 10:19 AM, Jan Kara wrote:
> When a device mke2fs should work on already contains an ext? filesyst=
em,
> mke2fs prints a warning. In German translation the warning doesn't en=
d
> with a date string (which is terminated by a newline) and thus the
> output comes out mangled like:
>=20
> mke2fs 1.42.12 (29-Aug-2014)
> /dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
> =E2=80=9EWD20_SL12=E2=80=9C
>         zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
>  eingeh=C3=A4ngtTrotzdem fortfahren? (j,n)
> ^^^^^^^^^^^^^ here
>=20
> Fix the translation to end the printed string with a newline and avoi=
d
> superfluous space at the beginning of the line.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  po/de.po | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/po/de.po b/po/de.po
> index fd96bb17f712..cf34daf428f2 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -5778,9 +5778,11 @@ msgid "Proceed anyway? (y,n) "
>  msgstr "Trotzdem fortfahren? (j,n) "
> =20
>  #: misc/util.c:132
> +# The second %s refers to a date string ending with a newline. Make =
the
> +# translated string end with a newline as well to maintain output co=
mpatibility.
>  #, c-format
>  msgid "\tlast mounted on %s on %s"
> -msgstr "\tzuletzt auf %s auf %s eingeh=C3=A4ngt"
> +msgstr "\tzuletzt auf %s auf %seingeh=C3=A4ngt.\n"

I never checked translation before, but if you already change that,
could you please change it to "am %s eingeh=C3=A4ngt"? So

-msgstr "\tzuletzt auf %s auf %s eingeh=C3=A4ngt"
+msgstr "\tzuletzt auf %s am %seingeh=C3=A4ngt.\n"

Now does the date string always end with a white space, or should that
better be

+msgstr "\tzuletzt auf %s am %s eingeh=C3=A4ngt.\n"


Also, the date string is in English, shouldn't that be localized either=
?


Thanks,
Bernd


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
