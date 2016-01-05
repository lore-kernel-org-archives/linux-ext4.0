From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: use XATTR_*_PREFIX_LEN instead sizeof(...)
Date: Tue, 5 Jan 2016 18:14:12 +0100
Message-ID: <20160105171412.GD18604@quack.suse.cz>
References: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 03-01-16 20:56:37, Toralf F=F6rster wrote:
> use the definition in include/uapi/linux/xattr.h
>=20
> Signed-off-by: Toralf F=F6rster <toralf.foerster@gmx.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr_security.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
> index 36f4c1a..1a3d629 100644
> --- a/fs/ext4/xattr_security.c
> +++ b/fs/ext4/xattr_security.c
> @@ -16,7 +16,7 @@ ext4_xattr_security_list(const struct xattr_handler=
 *handler,
>  			 struct dentry *dentry, char *list, size_t list_size,
>  			 const char *name, size_t name_len)
>  {
> -	const size_t prefix_len =3D sizeof(XATTR_SECURITY_PREFIX)-1;
> +	const size_t prefix_len =3D XATTR_SECURITY_PREFIX_LEN;
>  	const size_t total_len =3D prefix_len + name_len + 1;
> =20
> =20
> --=20
> 2.4.10
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
