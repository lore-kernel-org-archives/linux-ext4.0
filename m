From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular file
Date: Mon, 5 May 2014 09:52:39 -0400
Message-ID: <20140505135239.GB22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49756 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbaEENwl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 09:52:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 03:41:01PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 5 May 2014, Theodore Ts'o wrote:
>=20
> > Date: Mon,  5 May 2014 09:04:02 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Subject: [PATCH 1/3] mke2fs: print a message when creating a regula=
r file
>=20
> Description is missing.

I didn't think more of a description was needed; can you suggest one?

> >  	/* Can't undo discard ... */
> > -	if (!noaction && discard && (io_ptr !=3D undo_io_manager)) {
> > +	if (!noaction && discard && dev_size && (io_ptr !=3D undo_io_mana=
ger)) {
>=20
> I wonder whether it's possible not to have dev_size set at this point=
 ?

I checked, and I don't believe so.  ext2fs_get_device_size2() never
returns EXT2_ET_UNIMPLEMENTED any more; and it hasn't for quite some
time, since it will use st_size for a regular file or do a binary
search trying to figure out the device size in the worst case.  So in
fact, there are some code paths we can eliminate in misc/mke2fs.c
which will simplify this analysis.

Even if there is some case in the future where dev_size could be left
unset, it will be initialized to zero, at which point we will fail
safe by skipping the mke2fs_discard_device() call.

>=20
> > +	if ((fd < 0) && (errno =3D=3D ENOENT) && (flags & CREATE_FILE)) {
> > +		fl |=3D O_CREAT;
> > +		fd =3D open(device, fl, 0666);
> > +		if (fd >=3D 0 && (flags & VERBOSE_CREATE))
>=20
> Do we have to use VERBOSE_CREATE ? quiet is global variable so we
> can as well just test that here, or am I missing something ?

The problem is that util.c gets used by both mke2fs.c and tune2fs.c,
and it's only a global variable for mke2fs.c.

My long-term plans is to rename libquota to libsupport, which would
never be built as a shared library, and move some of our various
internal shared utility functions (i.e., e2fsck/profile.c,
misc/util.c, etc.) into that internal e2fsprogs insternal support
library.  So in general I'd prefer to minimize the number of global
functions which misc/util.c relies upon.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
