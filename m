From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 11/15] mke2fs: fix determination of size_type
Date: Wed, 01 Dec 2010 21:37:37 +0900
Message-ID: <1291207057.1684.30.camel@leonhard>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
	 <1291020917-8671-12-git-send-email-namhyung@gmail.com>
	 <alpine.LFD.2.00.1011301328040.3004@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:32806 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0LAMhr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 07:37:47 -0500
Received: by gxk1 with SMTP id 1so396583gxk.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 04:37:46 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1011301328040.3004@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-30 (=ED=99=94), 13:33 +0100, Lukas Czerner:
> On Mon, 29 Nov 2010, Namhyung Kim wrote:
>=20
> > In original code, 'huge' type could not be selected because it
> > always be caught for 'big' type. Change the ordering.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  misc/mke2fs.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 90cc206..b88decf 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -947,10 +947,10 @@ static char **parse_fs_type(const char *fs_ty=
pe,
> >  		size_type =3D "floppy";
> >  	else if (fs_blocks_count < 512 * meg)
> >  		size_type =3D "small";
> > -	else if (fs_blocks_count >=3D 4 * 1024 * 1024 * meg)
> > -		size_type =3D "big";
> >  	else if (fs_blocks_count >=3D 16 * 1024 * 1024 * meg)
> >  		size_type =3D "huge";
> > +	else if (fs_blocks_count >=3D 4 * 1024 * 1024 * meg)
> > +		size_type =3D "big";
> >  	else
> >  		size_type =3D "default";
> > =20
> >=20
>=20
> Personally, I do not like it very much. Either sort this in ascending=
 order
> and use "<" or sort it in descending order and use ">=3D". But since =
it
> was originally sorted in ascending order I would do that this way.
>=20
> -Lukas

No problem. You mean "floppy, small, default, big and huge", right? I'l=
l
resend v2 if you prefer that, Ted.

Thanks.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
