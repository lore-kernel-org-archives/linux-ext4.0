From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/37] mke2fs: always warn if 128-byte inode and
 inline_data
Date: Mon, 5 May 2014 13:10:00 -0700
Message-ID: <20140505201000.GH8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231249.31890.43562.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021325170.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27018 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaEEUKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 16:10:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021325170.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 01:27:01PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:12:49 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 04/37] mke2fs: always warn if 128-byte inode and in=
line_data
> >=20
> > The combination of 128-byte inodes and inline_data is silly, since
> > there's no room in the inode table.  Unfortunately, if neither
> > mke2fs.conf nor the mkfs command line options specify an inode size=
,
> > the default inode size is set to 128 bytes (by libext2fs) and the
> > warning isn't printed.  Therefore, always do the check-and-warning.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  misc/mke2fs.c |   25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >=20
> >=20
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index aecd5d5..6507d0d 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -2282,21 +2282,22 @@ profile_error:
> >  				blocksize);
> >  			exit(1);
> >  		}
> > -		/*
> > -		 * If inode size is 128 and inline data is enabled, we need
> > -		 * to notify users that inline data will never be useful.
> > -		 */
> > -		if ((fs_param.s_feature_incompat &
> > -		     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> > -		    inode_size =3D=3D EXT2_GOOD_OLD_INODE_SIZE) {
> > -			com_err(program_name, 0,
> > -				_("inode size is %d, inline data is useless"),
> > -				inode_size);
> > -			exit(1);
> > -		}
> >  		fs_param.s_inode_size =3D inode_size;
> >  	}
> > =20
> > +	/*
> > +	 * If inode size is 128 and inline data is enabled, we need
> > +	 * to notify users that inline data will never be useful.
> > +	 */
> > +	if ((fs_param.s_feature_incompat &
> > +	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> > +	    fs_param.s_inode_size =3D=3D EXT2_GOOD_OLD_INODE_SIZE) {
> > +		com_err(program_name, 0,
> > +			_("inode size is %d, inline data is useless"),
> > +			inode_size);
>=20
> Oops :) copy-paste is tricky. You need to use fs_param.s_inode_size
> rather than inode_size here. Otherwise it looks good.

Will fix, thanks.

--D
>=20
> Thanks!
> -Lukas
>=20
>=20
> > +		exit(1);
> > +	}
> > +
> >  	/* Make sure number of inodes specified will fit in 32 bits */
> >  	if (num_inodes =3D=3D 0) {
> >  		unsigned long long n;
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
