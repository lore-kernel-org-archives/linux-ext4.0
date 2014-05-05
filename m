From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/37] libext2fs: create sockets when populating
 filesystem
Date: Mon, 5 May 2014 13:08:39 -0700
Message-ID: <20140505200839.GG8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231242.31890.24539.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021321250.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26304 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaEEUIq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 16:08:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021321250.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 01:22:16PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:12:42 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 03/37] libext2fs: create sockets when populating fi=
lesystem
> >=20
> > Since the code to copy-in a socket when creating a filesystem is
> > fairly simple, just do it here.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  misc/create_inode.c |    9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >=20
> >=20
> > diff --git a/misc/create_inode.c b/misc/create_inode.c
> > index 4bb5e5b..e7faab1 100644
> > --- a/misc/create_inode.c
> > +++ b/misc/create_inode.c
> > @@ -114,6 +114,9 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext=
2_ino_t cwd, const char *name,
> >  		mode =3D LINUX_S_IFIFO;
> >  		filetype =3D EXT2_FT_FIFO;
> >  		break;
> > +	case S_IFSOCK:
> > +		mode =3D LINUX_S_IFSOCK;
> > +		filetype =3D EXT2_FT_SOCK;
>=20
> You probably want to change the comment for the function as well.

I'll do that, thanks.  I'll also teach the function to return retval in=
stead of
-1, since we're returning errcode_t anyway... though those changes are =
probably
more for the cleanup patch.

--D
>=20
> -Lukas
>=20
> >  	default:
> >  		abort();
> >  		/* NOTREACHED */
> > @@ -516,6 +519,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  		case S_IFCHR:
> >  		case S_IFBLK:
> >  		case S_IFIFO:
> > +		case S_IFSOCK:
> >  			retval =3D do_mknod_internal(fs, parent_ino, name, &st);
> >  			if (retval) {
> >  				com_err(__func__, retval,
> > @@ -524,11 +528,6 @@ static errcode_t __populate_fs(ext2_filsys fs,=
 ext2_ino_t parent_ino,
> >  				goto out;
> >  			}
> >  			break;
> > -		case S_IFSOCK:
> > -			/* FIXME: there is no make socket function atm. */
> > -			com_err(__func__, 0,
> > -				_("ignoring socket file \"%s\""), name);
> > -			continue;
> >  		case S_IFLNK:
> >  			read_cnt =3D readlink(name, ln_target,
> >  					    sizeof(ln_target) - 1);
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
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
