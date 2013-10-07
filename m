From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/31] debugfs: Handle 64bit block numbers
Date: Mon, 7 Oct 2013 11:49:43 -0700
Message-ID: <20131007184943.GD6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012824.28415.25821.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071742580.1975@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41936 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3JGSt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 14:49:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310071742580.1975@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 05:49:45PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
>=20
> > Date: Mon, 30 Sep 2013 18:28:24 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 16/31] debugfs: Handle 64bit block numbers
> >=20
> > debugfs should use strtoull (and equivalent wrappers) for reading b=
lock numbers
> > from the command line.  "unsigned long" isn't wide enough on 32bit =
platforms.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  debugfs/debugfs.c      |   19 ++++++++++---------
> >  debugfs/extent_inode.c |   24 +++++++++++++-----------
> >  debugfs/util.c         |    2 +-
> >  3 files changed, 24 insertions(+), 21 deletions(-)
>=20
> Look good, but some nitpicks bellow.
>=20
> >=20
> >=20
> > diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> > index da44ce4..60452c9 100644
> > --- a/debugfs/debugfs.c
> > +++ b/debugfs/debugfs.c
> > @@ -167,8 +167,9 @@ void do_open_filesys(int argc, char **argv)
> >  				return;
> >  			break;
> >  		case 's':
> > -			superblock =3D parse_ulong(optarg, argv[0],
> > -						 "superblock number", &err);
> > +			superblock =3D parse_ulonglong(optarg, argv[0],
> > +						     "superblock number",
>=20
> this is not really a superlock number, but rather block number.
>=20
> > +						     &err);
> >  			if (err)
> >  				return;
> >  			break;
> > @@ -269,8 +270,8 @@ void do_init_filesys(int argc, char **argv)
> >  		return;
> > =20
> >  	memset(&param, 0, sizeof(struct ext2_super_block));
> > -	ext2fs_blocks_count_set(&param, parse_ulong(argv[2], argv[0],
> > -						    "blocks count", &err));
> > +	ext2fs_blocks_count_set(&param, parse_ulonglong(argv[2], argv[0],
> > +							"blocks count", &err));
> >  	if (err)
> >  		return;
> >  	retval =3D ext2fs_initialize(argv[1], 0, &param,
> > @@ -2050,7 +2051,7 @@ void do_bmap(int argc, char *argv[])
> >  	ino =3D string_to_inode(argv[1]);
> >  	if (!ino)
> >  		return;
> > -	blk =3D parse_ulong(argv[2], argv[0], "logical_block", &err);
> > +	blk =3D parse_ulonglong(argv[2], argv[0], "logical_block", &err);
>=20
> Also I wonder whether we could use strtoblk() in cases like this ?
> This would fix the "logical_block" string as well since it should be
> either "logical block" or "block number".

Sounds reasonable for all of these cases.  I'll update the patch.

--D
>=20
> > =20
> >  	errcode =3D ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk)=
;
> >  	if (errcode) {
> > @@ -2195,9 +2196,9 @@ void do_punch(int argc, char *argv[])
> >  	ino =3D string_to_inode(argv[1]);
> >  	if (!ino)
> >  		return;
> > -	start =3D parse_ulong(argv[2], argv[0], "logical_block", &err);
> > +	start =3D parse_ulonglong(argv[2], argv[0], "logical_block", &err=
);
> >  	if (argc =3D=3D 4)
> > -		end =3D parse_ulong(argv[3], argv[0], "logical_block", &err);
> > +		end =3D parse_ulonglong(argv[3], argv[0], "logical_block", &err)=
;
> >  	else
> >  		end =3D ~0;
> > =20
> > @@ -2415,8 +2416,8 @@ int main(int argc, char **argv)
> >  						"block size", 0);
> >  			break;
> >  		case 's':
> > -			superblock =3D parse_ulong(optarg, argv[0],
> > -						 "superblock number", 0);
> > +			superblock =3D parse_ulonglong(optarg, argv[0],
> > +						     "superblock number", 0);
>=20
> same here
>=20
> Thanks!
> -Lukas
>=20
> >  			break;
> >  		case 'c':
> >  			catastrophic =3D 1;
> > diff --git a/debugfs/extent_inode.c b/debugfs/extent_inode.c
> > index 0bbc4c5..d5c4721 100644
> > --- a/debugfs/extent_inode.c
> > +++ b/debugfs/extent_inode.c
> > @@ -264,7 +264,8 @@ void do_replace_node(int argc, char *argv[])
> >  		return;
> >  	}
> > =20
> > -	extent.e_lblk =3D parse_ulong(argv[1], argv[0], "logical block", =
&err);
> > +	extent.e_lblk =3D parse_ulonglong(argv[1], argv[0], "logical bloc=
k",
> > +					&err);
> >  	if (err)
> >  		return;
> > =20
> > @@ -272,7 +273,8 @@ void do_replace_node(int argc, char *argv[])
> >  	if (err)
> >  		return;
> > =20
> > -	extent.e_pblk =3D parse_ulong(argv[3], argv[0], "logical block", =
&err);
> > +	extent.e_pblk =3D parse_ulonglong(argv[3], argv[0], "logical bloc=
k",
> > +					&err);
> >  	if (err)
> >  		return;
> > =20
> > @@ -338,8 +340,8 @@ void do_insert_node(int argc, char *argv[])
> >  		return;
> >  	}
> > =20
> > -	extent.e_lblk =3D parse_ulong(argv[1], cmd,
> > -				    "logical block", &err);
> > +	extent.e_lblk =3D parse_ulonglong(argv[1], cmd,
> > +					"logical block", &err);
> >  	if (err)
> >  		return;
> > =20
> > @@ -348,8 +350,8 @@ void do_insert_node(int argc, char *argv[])
> >  	if (err)
> >  		return;
> > =20
> > -	extent.e_pblk =3D parse_ulong(argv[3], cmd,
> > -				    "pysical block", &err);
> > +	extent.e_pblk =3D parse_ulonglong(argv[3], cmd,
> > +					"physical block", &err);
> >  	if (err)
> >  		return;
> > =20
> > @@ -366,8 +368,8 @@ void do_set_bmap(int argc, char **argv)
> >  	const char	*usage =3D "[--uninit] <lblk> <pblk>";
> >  	struct ext2fs_extent extent;
> >  	errcode_t	retval;
> > -	blk_t		logical;
> > -	blk_t		physical;
> > +	blk64_t		logical;
> > +	blk64_t		physical;
> >  	char		*cmd =3D argv[0];
> >  	int		flags =3D 0;
> >  	int		err;
> > @@ -387,18 +389,18 @@ void do_set_bmap(int argc, char **argv)
> >  		return;
> >  	}
> > =20
> > -	logical =3D parse_ulong(argv[1], cmd,
> > +	logical =3D parse_ulonglong(argv[1], cmd,
> >  				    "logical block", &err);
> >  	if (err)
> >  		return;
> > =20
> > -	physical =3D parse_ulong(argv[2], cmd,
> > +	physical =3D parse_ulonglong(argv[2], cmd,
> >  				    "physical block", &err);
> >  	if (err)
> >  		return;
> > =20
> >  	retval =3D ext2fs_extent_set_bmap(current_handle, logical,
> > -					(blk64_t) physical, flags);
> > +					physical, flags);
> >  	if (retval) {
> >  		com_err(cmd, retval, 0);
> >  		return;
> > diff --git a/debugfs/util.c b/debugfs/util.c
> > index cf3a6c6..245d556 100644
> > --- a/debugfs/util.c
> > +++ b/debugfs/util.c
> > @@ -377,7 +377,7 @@ int common_block_args_process(int argc, char *a=
rgv[],
> >  	}
> > =20
> >  	if (argc > 2) {
> > -		*count =3D parse_ulong(argv[2], argv[0], "count", &err);
> > +		*count =3D parse_ulonglong(argv[2], argv[0], "count", &err);
> >  		if (err)
> >  			return 1;
> >  	}
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
