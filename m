From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Wed, 30 Apr 2014 10:06:57 -0400
Message-ID: <20140430140657.GB9213@thunk.org>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
 <1398556834-31913-4-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41953 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768AbaD3OG7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:06:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 02:21:46PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	fd =3D open(device, fl, 0666);
> > +	if (fd < 0) {
> > +		fprintf(stderr, _("Could not open %s: %s\n"),
> >  			device, error_message(errno));
> >  		if (errno =3D=3D ENOENT)
> >  			fputs(_("\nThe device apparently does not exist; "
> >  				"did you specify it correctly?\n"), stderr);
> >  		exit(1);
> >  	}
> > +
> > +	if (ext2fs_fstat(fd, &s) < 0) {
> > +		perror("stat");
>=20
> Maybe we can leave the old error printing code for consistency ?
>=20
> 	fprintf(stderr, _("Could not stat %s --- %s\n"),
> 		device, error_message(errno));
>=20
> Otherwise it looks good.

Well, it's very rare that ext2fs_fstat() would fail in
practice.  Previously the most common situation where ext2fs_stat()
would fail would be due to the file not existing or if there was a
permission denied error.

So I had modified the "Could not stat..." message to "Could not open",
since it would now be the open that failed, and if the file doesn't
exist, we're going to try to create the file first.

Hmm, it occurs to me if the user typo's the file name in and the user
specifies the size explicitly (i.e., "mke2fs /dev/scd3 2T) , it could
result in the the root file system filling up.  I'm not sure that's
big of a deal, since the user can always control-C the mke2fs and then
delete the typo'ed file name.  Do we think this is a real problem?
I'm not too worried...

    	    				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
