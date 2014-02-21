From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: small .de translation fix
Date: Thu, 20 Feb 2014 22:19:37 -0600
Message-ID: <5306D3D9.4040303@redhat.com>
References: <52C704EC.8000501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>, pth@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaBUETk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 23:19:40 -0500
In-Reply-To: <52C704EC.8000501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/14, 12:43 PM, Eric Sandeen wrote:
> This was reported in RH bugzilla.  I think my German is good enough
> that the fix is correct, but I don't mind a double-check.  :)
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

ping on this one, while it seems that Ted is processing old patches :)

But maybe this one is for Philipp...

-Eric

> ---
>=20
> diff --git a/po/de.po b/po/de.po
> index d1ed005..d0b357a 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -1840,7 +1840,7 @@ msgid ""
>  "  has %r @m @b(s), shared with %N file(s):\n"
>  msgstr ""
>  "Datei %Q (@i #%i, =C4nderungszeit %IM) \n"
> -"  hat %r mehrfach belegte(n) Block/B=F6cke, gemeinsam genutzt mit %=
N Datei(en):\n"
> +"  hat %r mehrfach belegte(n) Block/Bl=F6cke, gemeinsam genutzt mit =
%N Datei(en):\n"
> =20
>  #. @-expanded: \t%Q (inode #%i, mod time %IM)\n
>  #: e2fsck/problem.c:1011
> @@ -5274,7 +5274,7 @@ msgstr "Das Intervall zwischen zwei Checks wird=
 auf %lu Sekunden gesetzt\n"
>  #: misc/tune2fs.c:2016
>  #, c-format
>  msgid "Setting reserved blocks percentage to %g%% (%llu blocks)\n"
> -msgstr "Der Prozentsatz reservierter B=F6cke wird auf %g%% (%llu Bl=F6=
cke) gesetzt\n"
> +msgstr "Der Prozentsatz reservierter Bl=F6cke wird auf %g%% (%llu Bl=
=F6cke) gesetzt\n"
> =20
>  #: misc/tune2fs.c:2022
>  #, c-format
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
