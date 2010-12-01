From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 13/15] mke2fs: fix potential memory leak in
 mke2fs_setup_tdb()
Date: Wed, 01 Dec 2010 21:32:52 +0900
Message-ID: <1291206772.1684.26.camel@leonhard>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
	 <1291020917-8671-14-git-send-email-namhyung@gmail.com>
	 <alpine.LFD.2.00.1011301350290.3004@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52939 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0LAMdB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 07:33:01 -0500
Received: by yxt3 with SMTP id 3so2832017yxt.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 04:33:00 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1011301350290.3004@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-30 (=ED=99=94), 14:02 +0100, Lukas Czerner:
> On Mon, 29 Nov 2010, Namhyung Kim wrote:
>=20
> > 'tmp_name' allocated by strdup() should also be freed if error.
> > Also check return value of set_undo_io_backup_file() for possible
> > memory failure. A whitespace fix is added too.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  misc/mke2fs.c |   11 +++++++----
> >  1 files changed, 7 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 6e2092d..644b287 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1882,15 +1882,17 @@ static int mke2fs_setup_tdb(const char *nam=
e, io_manager *io_ptr)
> > =20
> >  	tmp_name =3D strdup(name);
> >  	if (!tmp_name) {
> > -	alloc_fn_fail:
> > -		com_err(program_name, ENOMEM,=20
> > +alloc_fn_fail:
> > +		com_err(program_name, ENOMEM,
> >  			_("Couldn't allocate memory for tdb filename\n"));
> >  		return ENOMEM;
> >  	}
>=20
> What about putting the alloc_fn_fail at the end of the function ? aft=
er return
> retval?
>=20

No problem.


> >  	device_name =3D basename(tmp_name);
> >  	tdb_file =3D malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7=
 + 1);
> > -	if (!tdb_file)
> > +	if (!tdb_file) {
> > +		free(tmp_name);
>=20
> What about adding
>=20
> if (tmp_name)
> 	free(tmp_name);
>=20
> in alloc_fs_fail context ?

I guess just free(tmp_name) is enough.


> >  		goto alloc_fn_fail;
> > +	}
> >  	sprintf(tdb_file, "%s/mke2fs-%s.e2undo", tdb_dir, device_name);
> > =20
> >  	if (!access(tdb_file, F_OK)) {
> > @@ -1899,6 +1901,7 @@ static int mke2fs_setup_tdb(const char *name,=
 io_manager *io_ptr)
> >  			com_err(program_name, retval,
> >  				_("while trying to delete %s"),
> >  				tdb_file);
> > +			free(tmp_name);
> >  			free(tdb_file);
> >  			return retval;
> >  		}
> > @@ -1906,7 +1909,7 @@ static int mke2fs_setup_tdb(const char *name,=
 io_manager *io_ptr)
> > =20
> >  	set_undo_io_backing_manager(*io_ptr);
> >  	*io_ptr =3D undo_io_manager;
> > -	set_undo_io_backup_file(tdb_file);
> > +	retval =3D set_undo_io_backup_file(tdb_file);
>=20
> You should probably return ENOMEM when this fails, moreover when
> set_undo_io_backup() you'll try to free not allocated space.
>=20

Its only user doesn't check the actual return value and simply does
exit(1). And confusingly, tdb_file here is a local variable and
allocated successully so there will be no problem. Also AFAIK C permits
to pass NULL to free(), means no operation.

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
