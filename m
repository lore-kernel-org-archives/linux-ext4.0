From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/21] fs: Mark function as static in
 ext3/xattr_security.c
Date: Tue, 11 Feb 2014 21:49:16 +0100
Message-ID: <20140211204916.GE22835@quack.suse.cz>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 09-02-14 18:39:11, Rashika Kheria wrote:
> Mark function as static in ext3/xattr_security.c because it is not us=
ed
> outside this file.
>=20
> This eliminates the following warning in ext3/xattr_security.c:
> fs/ext3/xattr_security.c:46:5: warning: no previous prototype for =E2=
=80=98ext3_initxattrs=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
  Thanks. I've merged the patch.

								Honza
> ---
>  fs/ext3/xattr_security.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
> index 3387664..722c2bf 100644
> --- a/fs/ext3/xattr_security.c
> +++ b/fs/ext3/xattr_security.c
> @@ -43,8 +43,9 @@ ext3_xattr_security_set(struct dentry *dentry, cons=
t char *name,
>  			      name, value, size, flags);
>  }
> =20
> -int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_a=
rray,
> -		    void *fs_info)
> +static int ext3_initxattrs(struct inode *inode,
> +			   const struct xattr *xattr_array,
> +			   void *fs_info)
>  {
>  	const struct xattr *xattr;
>  	handle_t *handle =3D fs_info;
> --=20
> 1.7.9.5
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
