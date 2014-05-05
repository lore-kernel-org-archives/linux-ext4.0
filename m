From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/37] misc: coverity fixes
Date: Mon, 5 May 2014 13:04:29 -0700
Message-ID: <20140505200429.GF8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231236.31890.46904.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021306530.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24036 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaEEUEh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 16:04:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021306530.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 01:17:49PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:12:36 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 02/37] misc: coverity fixes
> >=20
> > Fix various small resource leaks and error code handling issues tha=
t
> > Coverity pointed out.

<snip>

> > diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> > index 60cd2a3..c9250cd 100644
> > --- a/lib/ext2fs/punch.c
> > +++ b/lib/ext2fs/punch.c
> > @@ -403,7 +403,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsy=
s fs, ext2_ino_t ino,
> >  			retval =3D 0;
> > =20
> >  			/* Jump forward to the next extent. */
> > -			ext2fs_extent_goto(handle, next_lblk);
> > +			(void)ext2fs_extent_goto(handle, next_lblk);
>=20
> Why do we not want to check the return value of this ? There might
> be an error right ?

We can ignore errors that happen during the goto because the subsequent
ext2fs_extent_get() about ten lines down (to load another extent) will =
tell us
if there are no more extents or if some error happened.

(I suppose I can add a comment explaining this.)

> >  			op =3D EXT2_EXTENT_CURRENT;
> >  		}
> >  		if (retval)
> > diff --git a/misc/create_inode.c b/misc/create_inode.c
> > index 964c66a..4bb5e5b 100644
> > --- a/misc/create_inode.c
> > +++ b/misc/create_inode.c
> > @@ -465,7 +465,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  	char		ln_target[PATH_MAX];
> >  	unsigned int	save_inode;
> >  	ext2_ino_t	ino;
> > -	errcode_t	retval;
> > +	errcode_t	retval =3D 0;
> >  	int		read_cnt;
> >  	int		hdlink;
> > =20
> > @@ -486,7 +486,11 @@ static errcode_t __populate_fs(ext2_filsys fs,=
 ext2_ino_t parent_ino,
> >  		if ((!strcmp(dent->d_name, ".")) ||
> >  		    (!strcmp(dent->d_name, "..")))
> >  			continue;
> > -		lstat(dent->d_name, &st);
> > +		if (lstat(dent->d_name, &st)) {
> > +			com_err(__func__, errno, _("while lstat \"%s\""),
> > +				dent->d_name);
> > +			goto out;
> > +		}
> >  		name =3D dent->d_name;
> > =20
> >  		/* Check for hardlinks */
> > @@ -501,7 +505,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  				if (retval) {
> >  					com_err(__func__, retval,
> >  						"while linking %s", name);
> > -					return retval;
> > +					goto out;
> >  				}
> >  				continue;
> >  			} else
> > @@ -517,7 +521,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  				com_err(__func__, retval,
> >  					_("while creating special file "
> >  					  "\"%s\""), name);
> > -				return retval;
> > +				goto out;
> >  			}
> >  			break;
> >  		case S_IFSOCK:
> > @@ -527,7 +531,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  			continue;
> >  		case S_IFLNK:
> >  			read_cnt =3D readlink(name, ln_target,
> > -					    sizeof(ln_target));
> > +					    sizeof(ln_target) - 1);
> >  			if (read_cnt =3D=3D -1) {
> >  				com_err(__func__, errno,
> >  					_("while trying to readlink \"%s\""),
> > @@ -541,7 +545,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  				com_err(__func__, retval,
> >  					_("while writing symlink\"%s\""),
> >  					name);
> > -				return retval;
> > +				goto out;
> >  			}
> >  			break;
> >  		case S_IFREG:
> > @@ -550,7 +554,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  			if (retval) {
> >  				com_err(__func__, retval,
> >  					_("while writing file \"%s\""), name);
> > -				return retval;
> > +				goto out;
> >  			}
> >  			break;
> >  		case S_IFDIR:
> > @@ -559,25 +563,25 @@ static errcode_t __populate_fs(ext2_filsys fs=
, ext2_ino_t parent_ino,
> >  			if (retval) {
> >  				com_err(__func__, retval,
> >  					_("while making dir \"%s\""), name);
> > -				return retval;
> > +				goto out;
> >  			}
> >  			retval =3D ext2fs_namei(fs, root, parent_ino,
> >  					      name, &ino);
> >  			if (retval) {
> >  				com_err(name, retval, 0);
> > -					return retval;
> > +					goto out;
> >  			}
> >  			/* Populate the dir recursively*/
> >  			retval =3D __populate_fs(fs, ino, name, root, hdlinks);
> >  			if (retval) {
> >  				com_err(__func__, retval,
> >  					_("while adding dir \"%s\""), name);
> > -				return retval;
> > +				goto out;
> >  			}
> >  			if (chdir("..")) {
> >  				com_err(__func__, errno,
> >  					_("during cd .."));
> > -				return errno;
>=20
> you probably wan to store errno in retval because that's what we
> return from the function.

Oops, yes.

> > +				goto out;
> >  			}
> >  			break;
> >  		default:
> > @@ -588,14 +592,14 @@ static errcode_t __populate_fs(ext2_filsys fs=
, ext2_ino_t parent_ino,
> >  		retval =3D  ext2fs_namei(fs, root, parent_ino, name, &ino);
> >  		if (retval) {
> >  			com_err(name, retval, 0);
> > -			return retval;
> > +			goto out;
> >  		}
> > =20
> >  		retval =3D set_inode_extra(fs, parent_ino, ino, &st);
> >  		if (retval) {
> >  			com_err(__func__, retval,
> >  				_("while setting inode for \"%s\""), name);
> > -			return retval;
> > +			goto out;
> >  		}
> > =20
> >  		/* Save the hardlink ino */
> > @@ -612,7 +616,7 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  				if (p =3D=3D NULL) {
> >  					com_err(name, errno,
> >  						_("Not enough memory"));
> > -					return errno;
> > +					goto out;
>=20
> same here.

Yes.  Thank you for spotting these.

--D
>=20
> Thanks!
> -Lukas
>=20
> >  				}
> >  				hdlinks->hdl =3D p;
> >  				hdlinks->size +=3D HDLINK_CNT;
> > @@ -623,6 +627,8 @@ static errcode_t __populate_fs(ext2_filsys fs, =
ext2_ino_t parent_ino,
> >  			hdlinks->count++;
> >  		}
> >  	}
> > +
> > +out:
> >  	closedir(dh);
> >  	return retval;
> >  }
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
