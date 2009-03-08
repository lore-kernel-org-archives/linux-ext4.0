From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix incorrect .de translation file
Date: Sun, 8 Mar 2009 19:57:23 -0400
Message-ID: <20090308235723.GD5578@mit.edu>
References: <49B15B7F.4000200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Philipp Thomas <pth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44174 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZCIDPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:45 -0400
Content-Disposition: inline
In-Reply-To: <49B15B7F.4000200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 06, 2009 at 11:21:03AM -0600, Eric Sandeen wrote:
> The translation for this e2fsprogs output:
>=20
> This filesystem will be automatically checked every 34 mounts or
> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
>=20
> comes out as:
>=20
> Das Dateisystem wird automatisch alle 25 Mounts bzw. alle 180 Tage =FC=
berpr=FCft,
> je nachdem, was zuerst eintritt. Ver=E4nderbar mit tune2fs -c oder -t=
 .
>=20
> -t is not even a valid option for tune2fs...

Philipp Thomas is the upstream for the German translation.  Philipp,
=46YI.  Could you fix this and then run it through the Translation
Project publication process?   Thanks!

						- Ted

> Resolves-rh-bugzilla: 488960
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> Index: e2fsprogs/po/de.po
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.orig/po/de.po
> +++ e2fsprogs/po/de.po
> @@ -4895,7 +4895,7 @@ msgid ""
>  msgstr ""
>  "Das Dateisystem wird automatisch nach jeweils %d Einh=E4ng-Vorg=E4n=
gen bzw.\n"
>  "alle %g Tage =FCberpr=FCft, je nachdem, was zuerst eintritt. Ver=E4=
nderbar mit\n"
> -"tune2fs -c oder -t .\n"
> +"tune2fs -c oder -i .\n"
> =20
>  #: misc/uuidgen.c:31
>  #, c-format
>=20
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
