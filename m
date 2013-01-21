From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Mon, 21 Jan 2013 11:24:28 +0100
Message-ID: <20130121102428.GA5588@quack.suse.cz>
References: <50DD20B2.6040204@asianux.com>
 <50E646BC.2090201@asianux.com>
 <50E64A4E.7010408@asianux.com>
 <50E64BFD.6090000@asianux.com>
 <20130107192016.GD13659@quack.suse.cz>
 <50EFD427.8060100@asianux.com>
 <50FB9696.7090702@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, viro@zeniv.linux.org.uk,
	paul.gortmaker@windriver.com, ebiederm@xmission.com,
	adilger.kernel@dilger.ca, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50FB9696.7090702@asianux.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 20-01-13 15:02:46, Chen Gang wrote:
> Hello all:
>=20
> consult:
>   excuse me, I wonder who is the final applier of this patch ?
>     it seems too many relative members are in this mailing list.
>       (it is why I also included torvalds@linux-foundation.org as 'TH=
E REST')
>=20
>   thanks.
>=20
>   :-)
>=20
>=20
> by the way:
>   originally, I send this mail by checking MAINTAINERS file, mannualy=
=2E
>   and this time (now), I reply this mail by using scripts/get_maintai=
ners.pl.
>     (but still add torvalds@linux-foundation.org as 'THE REST')
  Al Viro (you have him on CC list) is the right guy to merge this patc=
h.
But he's not very responsive at times... You can also check whether he =
just
didn't silently merge your patch into his tree -
http://git.kernel.org/?p=3Dlinux/kernel/git/viro/vfs.git
I don't see the patch there right now, last update to the tree has
happened 3 weeks ago. Maybe he's on vacation...

								Honza
> =E4=BA=8E 2013=E5=B9=B401=E6=9C=8811=E6=97=A5 16:58, Chen Gang =E5=86=
=99=E9=81=93:
> >=20
> >   give comments (by Theodore Ts'o)
> >=20
> >     ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[=
2] ACL_OTHER
> >=20
> >     [1] Where * is the regexp sense of "0 or more times"
> >     [2] ...
> >=20
> >   give comments (by Jan Kara)
> >     posix_acl_valid() makes sure that if there are <=3D 4 ACL entri=
es, then
> >     all of them are short. Otherwise exactly 4 entries are short on=
es and
> >     other have full length. See comment before that function for ex=
act ACL
> >     format.
> >     also correct the '[2]' comments:
> >       [2] If ACL_USER or ACL_GROUP is present, then ACL_MASK must b=
e present.
> >=20
> >   use macro instead of hard code number (by Chen Gang)
> >=20
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  fs/ext2/acl.h             |   10 +++++-----
> >  fs/ext3/acl.h             |   10 +++++-----
> >  fs/ext4/acl.h             |   10 +++++-----
> >  fs/f2fs/acl.c             |   12 +++++++-----
> >  fs/jffs2/acl.c            |   15 +++++++++------
> >  fs/posix_acl.c            |    7 +++++++
> >  fs/reiserfs/acl.h         |   10 +++++-----
> >  include/linux/posix_acl.h |    8 ++++++++
> >  8 files changed, 51 insertions(+), 31 deletions(-)
> >=20
> > diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
> > index 503bfb0..9af79d0 100644
> > --- a/fs/ext2/acl.h
> > +++ b/fs/ext2/acl.h
> > @@ -25,13 +25,13 @@ typedef struct {
> > =20
> >  static inline size_t ext2_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(ext2_acl_header) +
> >  		       count * sizeof(ext2_acl_entry_short);
> >  	} else {
> >  		return sizeof(ext2_acl_header) +
> > -		       4 * sizeof(ext2_acl_entry_short) +
> > -		       (count - 4) * sizeof(ext2_acl_entry);
> > +		       ACL_MAX_SHORT_ENTRY * sizeof(ext2_acl_entry_short) +
> > +		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext2_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -39,7 +39,7 @@ static inline int ext2_acl_count(size_t size)
> >  {
> >  	ssize_t s;
> >  	size -=3D sizeof(ext2_acl_header);
> > -	s =3D size - 4 * sizeof(ext2_acl_entry_short);
> > +	s =3D size - ACL_MAX_SHORT_ENTRY * sizeof(ext2_acl_entry_short);
> >  	if (s < 0) {
> >  		if (size % sizeof(ext2_acl_entry_short))
> >  			return -1;
> > @@ -47,7 +47,7 @@ static inline int ext2_acl_count(size_t size)
> >  	} else {
> >  		if (s % sizeof(ext2_acl_entry))
> >  			return -1;
> > -		return s / sizeof(ext2_acl_entry) + 4;
> > +		return s / sizeof(ext2_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
> > index dbc921e..b1cf2c0 100644
> > --- a/fs/ext3/acl.h
> > +++ b/fs/ext3/acl.h
> > @@ -25,13 +25,13 @@ typedef struct {
> > =20
> >  static inline size_t ext3_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(ext3_acl_header) +
> >  		       count * sizeof(ext3_acl_entry_short);
> >  	} else {
> >  		return sizeof(ext3_acl_header) +
> > -		       4 * sizeof(ext3_acl_entry_short) +
> > -		       (count - 4) * sizeof(ext3_acl_entry);
> > +		       ACL_MAX_SHORT_ENTRY * sizeof(ext3_acl_entry_short) +
> > +		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext3_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -39,7 +39,7 @@ static inline int ext3_acl_count(size_t size)
> >  {
> >  	ssize_t s;
> >  	size -=3D sizeof(ext3_acl_header);
> > -	s =3D size - 4 * sizeof(ext3_acl_entry_short);
> > +	s =3D size - ACL_MAX_SHORT_ENTRY * sizeof(ext3_acl_entry_short);
> >  	if (s < 0) {
> >  		if (size % sizeof(ext3_acl_entry_short))
> >  			return -1;
> > @@ -47,7 +47,7 @@ static inline int ext3_acl_count(size_t size)
> >  	} else {
> >  		if (s % sizeof(ext3_acl_entry))
> >  			return -1;
> > -		return s / sizeof(ext3_acl_entry) + 4;
> > +		return s / sizeof(ext3_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
> > index 18cb39e..66d1fa3 100644
> > --- a/fs/ext4/acl.h
> > +++ b/fs/ext4/acl.h
> > @@ -25,13 +25,13 @@ typedef struct {
> > =20
> >  static inline size_t ext4_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(ext4_acl_header) +
> >  		       count * sizeof(ext4_acl_entry_short);
> >  	} else {
> >  		return sizeof(ext4_acl_header) +
> > -		       4 * sizeof(ext4_acl_entry_short) +
> > -		       (count - 4) * sizeof(ext4_acl_entry);
> > +		       ACL_MAX_SHORT_ENTRY * sizeof(ext4_acl_entry_short) +
> > +		       (count - ACL_MAX_SHORT_ENTRY) * sizeof(ext4_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -39,7 +39,7 @@ static inline int ext4_acl_count(size_t size)
> >  {
> >  	ssize_t s;
> >  	size -=3D sizeof(ext4_acl_header);
> > -	s =3D size - 4 * sizeof(ext4_acl_entry_short);
> > +	s =3D size - ACL_MAX_SHORT_ENTRY * sizeof(ext4_acl_entry_short);
> >  	if (s < 0) {
> >  		if (size % sizeof(ext4_acl_entry_short))
> >  			return -1;
> > @@ -47,7 +47,7 @@ static inline int ext4_acl_count(size_t size)
> >  	} else {
> >  		if (s % sizeof(ext4_acl_entry))
> >  			return -1;
> > -		return s / sizeof(ext4_acl_entry) + 4;
> > +		return s / sizeof(ext4_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> > index 137af42..3e5a717 100644
> > --- a/fs/f2fs/acl.c
> > +++ b/fs/f2fs/acl.c
> > @@ -22,13 +22,15 @@
> > =20
> >  static inline size_t f2fs_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(struct f2fs_acl_header) +
> >  			count * sizeof(struct f2fs_acl_entry_short);
> >  	} else {
> >  		return sizeof(struct f2fs_acl_header) +
> > -			4 * sizeof(struct f2fs_acl_entry_short) +
> > -			(count - 4) * sizeof(struct f2fs_acl_entry);
> > +			ACL_MAX_SHORT_ENTRY
> > +			 * sizeof(struct f2fs_acl_entry_short) +
> > +			(count - ACL_MAX_SHORT_ENTRY)
> > +			 * sizeof(struct f2fs_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -36,7 +38,7 @@ static inline int f2fs_acl_count(size_t size)
> >  {
> >  	ssize_t s;
> >  	size -=3D sizeof(struct f2fs_acl_header);
> > -	s =3D size - 4 * sizeof(struct f2fs_acl_entry_short);
> > +	s =3D size - ACL_MAX_SHORT_ENTRY * sizeof(struct f2fs_acl_entry_s=
hort);
> >  	if (s < 0) {
> >  		if (size % sizeof(struct f2fs_acl_entry_short))
> >  			return -1;
> > @@ -44,7 +46,7 @@ static inline int f2fs_acl_count(size_t size)
> >  	} else {
> >  		if (s % sizeof(struct f2fs_acl_entry))
> >  			return -1;
> > -		return s / sizeof(struct f2fs_acl_entry) + 4;
> > +		return s / sizeof(struct f2fs_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> > index 223283c..48ef4b8 100644
> > --- a/fs/jffs2/acl.c
> > +++ b/fs/jffs2/acl.c
> > @@ -25,13 +25,15 @@
> > =20
> >  static size_t jffs2_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(struct jffs2_acl_header)
> >  		       + count * sizeof(struct jffs2_acl_entry_short);
> >  	} else {
> >  		return sizeof(struct jffs2_acl_header)
> > -		       + 4 * sizeof(struct jffs2_acl_entry_short)
> > -		       + (count - 4) * sizeof(struct jffs2_acl_entry);
> > +		       + ACL_MAX_SHORT_ENTRY
> > +				 * sizeof(struct jffs2_acl_entry_short)
> > +		       + (count - ACL_MAX_SHORT_ENTRY)
> > +				 * sizeof(struct jffs2_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -40,15 +42,16 @@ static int jffs2_acl_count(size_t size)
> >  	size_t s;
> > =20
> >  	size -=3D sizeof(struct jffs2_acl_header);
> > -	if (size < 4 * sizeof(struct jffs2_acl_entry_short)) {
> > +	if (size < ACL_MAX_SHORT_ENTRY * sizeof(struct jffs2_acl_entry_sh=
ort)) {
> >  		if (size % sizeof(struct jffs2_acl_entry_short))
> >  			return -1;
> >  		return size / sizeof(struct jffs2_acl_entry_short);
> >  	} else {
> > -		s =3D size - 4 * sizeof(struct jffs2_acl_entry_short);
> > +		s =3D size - ACL_MAX_SHORT_ENTRY
> > +				 * sizeof(struct jffs2_acl_entry_short);
> >  		if (s % sizeof(struct jffs2_acl_entry))
> >  			return -1;
> > -		return s / sizeof(struct jffs2_acl_entry) + 4;
> > +		return s / sizeof(struct jffs2_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> > index 8bd2135..15b1b0c 100644
> > --- a/fs/posix_acl.c
> > +++ b/fs/posix_acl.c
> > @@ -72,6 +72,13 @@ posix_acl_clone(const struct posix_acl *acl, gfp=
_t flags)
> > =20
> >  /*
> >   * Check if an acl is valid. Returns 0 if it is, or -E... otherwis=
e.
> > + *
> > + * make sure ACL format is the following:
> > + *
> > + *   ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MAS=
K[2] ACL_OTHER
> > + *
> > + *   [1] Where * is the regexp sense of "0 or more times"
> > + *   [2] If ACL_USER or ACL_GROUP is present, then ACL_MASK must b=
e present.
> >   */
> >  int
> >  posix_acl_valid(const struct posix_acl *acl)
> > diff --git a/fs/reiserfs/acl.h b/fs/reiserfs/acl.h
> > index f096b80..cb967a3 100644
> > --- a/fs/reiserfs/acl.h
> > +++ b/fs/reiserfs/acl.h
> > @@ -20,13 +20,13 @@ typedef struct {
> > =20
> >  static inline size_t reiserfs_acl_size(int count)
> >  {
> > -	if (count <=3D 4) {
> > +	if (count <=3D ACL_MAX_SHORT_ENTRY) {
> >  		return sizeof(reiserfs_acl_header) +
> >  		    count * sizeof(reiserfs_acl_entry_short);
> >  	} else {
> >  		return sizeof(reiserfs_acl_header) +
> > -		    4 * sizeof(reiserfs_acl_entry_short) +
> > -		    (count - 4) * sizeof(reiserfs_acl_entry);
> > +		    ACL_MAX_SHORT_ENTRY * sizeof(reiserfs_acl_entry_short) +
> > +		    (count - ACL_MAX_SHORT_ENTRY) * sizeof(reiserfs_acl_entry);
> >  	}
> >  }
> > =20
> > @@ -34,7 +34,7 @@ static inline int reiserfs_acl_count(size_t size)
> >  {
> >  	ssize_t s;
> >  	size -=3D sizeof(reiserfs_acl_header);
> > -	s =3D size - 4 * sizeof(reiserfs_acl_entry_short);
> > +	s =3D size - ACL_MAX_SHORT_ENTRY * sizeof(reiserfs_acl_entry_shor=
t);
> >  	if (s < 0) {
> >  		if (size % sizeof(reiserfs_acl_entry_short))
> >  			return -1;
> > @@ -42,7 +42,7 @@ static inline int reiserfs_acl_count(size_t size)
> >  	} else {
> >  		if (s % sizeof(reiserfs_acl_entry))
> >  			return -1;
> > -		return s / sizeof(reiserfs_acl_entry) + 4;
> > +		return s / sizeof(reiserfs_acl_entry) + ACL_MAX_SHORT_ENTRY;
> >  	}
> >  }
> > =20
> > diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> > index 7931efe..2c5609c 100644
> > --- a/include/linux/posix_acl.h
> > +++ b/include/linux/posix_acl.h
> > @@ -26,6 +26,14 @@
> >  #define ACL_MASK		(0x10)
> >  #define ACL_OTHER		(0x20)
> > =20
> > +/*
> > + * posix_acl_valid() makes sure that if there are <=3D 4 ACL entri=
es, then
> > + * all of them are short. Otherwise exactly 4 entries are short on=
es and
> > + * other have full length. See comment before that function for ex=
act ACL
> > + * format.
> > + */
> > +#define ACL_MAX_SHORT_ENTRY	4
> > +
> >  /* permissions in the e_perm field */
> >  #define ACL_READ		(0x04)
> >  #define ACL_WRITE		(0x02)
> >=20
>=20
>=20
> --=20
> Chen Gang
>=20
> Asianux Corporation
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
