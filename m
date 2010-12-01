From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 12/15] mke2fs: add some error checks into PRS()
Date: Wed, 01 Dec 2010 21:03:23 +0900
Message-ID: <1291205003.1684.12.camel@leonhard>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
	 <1291020917-8671-13-git-send-email-namhyung@gmail.com>
	 <alpine.LFD.2.00.1011301340570.3004@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64188 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0LAMDb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 07:03:31 -0500
Received: by ywl5 with SMTP id 5so3326745ywl.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 04:03:30 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1011301340570.3004@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-30 (=ED=99=94), 13:46 +0100, Lukas Czerner:
> On Mon, 29 Nov 2010, Namhyung Kim wrote:
>=20
> > Check return value of some functions and exit if unhandled error oc=
curred.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  misc/mke2fs.c |   26 ++++++++++++++++++++++----
> >  1 files changed, 22 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index b88decf..6e2092d 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1108,6 +1108,10 @@ static void PRS(int argc, char *argv[])
> >  	if (oldpath)
> >  		pathlen +=3D strlen(oldpath);
> >  	newpath =3D malloc(pathlen);
> > +	if (!newpath) {
> > +		fprintf(stderr, _("Couldn't allocate memory for new PATH.\n"));
> > +		exit(1);
> > +	}
> >  	strcpy(newpath, PATH_SET);
> > =20
> >  	/* Update our PATH to include /sbin  */
> > @@ -1138,14 +1142,28 @@ static void PRS(int argc, char *argv[])
> >  	profile_set_syntax_err_cb(syntax_err_report);
> >  	retval =3D profile_init(config_fn, &profile);
> >  	if (retval =3D=3D ENOENT) {
> > -		profile_init(default_files, &profile);
> > -		profile_set_default(profile, mke2fs_default_profile);
> > +		retval =3D profile_init(default_files, &profile);
> > +		if (retval)
> > +			goto profile_error;
> > +		retval =3D profile_set_default(profile, mke2fs_default_profile);
> > +		if (retval)
> > +			goto profile_error;
> > +	} else {
>=20
> Maybe use "else if (retval)" since profile_init(config_fn, &profile);
> might exit successfully (return 0) ?
>=20

Right! Will resend v2, thanks.

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
