From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
 in ext2_xattr_get
Date: Tue, 13 Jul 2010 22:28:19 +0800
Message-ID: <4C3C7803.2020006@gmail.com>
References: <201007122229025316610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>, tytso@mit.edu,
	adilger@sun.com, akpm@linux-fou
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007122229025316610@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  =E4=BA=8E 2010-7-12 22:29, crosslonelyover =E5=86=99=E9=81=93:
> Hi,
>         I walked through ext2_xattr_get, and felt that we can
> do some optimization on it. For name_len check, it's done
> after down xattr_sem and sb_read, both of which are time
> consuming operation compared with strlen:
>           down_read(&EXT2_I(inode)->xattr_sem);
>   ...
>           bh =3D sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>   ...
>           /* find named attribute */
>           name_len =3D strlen(name);
>
>           error =3D -ERANGE;
>           if (name_len>  255)
>                   goto cleanup;
>
>         Most of the case, you'll get one valid block, but if the
> name len>  255, then the xattr_sem down and sb_bread operation
> can be seen as a waste of time. So I think we'd better do
> name len check as early as possible.
>         Following is my patch, and it's against 2.6.35-rc4.
> Please check it.
>
> Signed-off-by: Wang Sheng-Hui<crosslonelyover@gmail.com>
> ---
>   fs/ext2/xattr.c |   12 +++++++-----
>   1 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..0b94d61 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_ind=
ex, const char *name,
>
>   	if (name =3D=3D NULL)
>   		return -EINVAL;
> +
> +	/* find named attribute */
> +	name_len =3D strlen(name);
> +	error =3D -ERANGE;
> +	if (name_len>  255)
> +		goto cleanup;
> +
>   	down_read(&EXT2_I(inode)->xattr_sem);
>   	error =3D -ENODATA;
>   	if (!EXT2_I(inode)->i_file_acl)
> @@ -181,12 +188,7 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_g=
et",
>   		error =3D -EIO;
>   		goto cleanup;
>   	}
> -	/* find named attribute */
> -	name_len =3D strlen(name);
>
> -	error =3D -ERANGE;
> -	if (name_len>  255)
> -		goto cleanup;
>   	entry =3D FIRST_ENTRY(bh);
>   	while (!IS_LAST_ENTRY(entry)) {
>   		struct ext2_xattr_entry *next =3D
Hi, I noticed in ext2_xattr_set, name_len check is done
before
down_write(&EXT2_I(inode)->xattr_sem);
So I think ext2_xattr_get should do in the same way.

Please check this patch.

--=20
Thanks and Regards,
shenghui
