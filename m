From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Mon, 9 Jul 2007 10:34:32 +0200
Message-ID: <20070709083431.GA14761@lazybastard.org>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070709041122.GA5889@martell.zuzino.mipt.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 July 2007 08:11:22 +0400, Alexey Dobriyan wrote:
>=20
> If CONFIG_EXT2_FS_POSIX_ACL is not configured, ext2_clear_inode() wil=
l be empty
> function. However, there still will be call and immediate return whic=
h can be
> avoided.
> [...]
> +#ifdef CONFIG_EXT2_FS_POSIX_ACL
>  static void ext2_clear_inode(struct inode *inode)
>  {
> -#ifdef CONFIG_EXT2_FS_POSIX_ACL
>  	struct ext2_inode_info *ei =3D EXT2_I(inode);
> =20
>  	if (ei->i_acl && ei->i_acl !=3D EXT2_ACL_NOT_CACHED) {
> @@ -197,8 +197,10 @@ static void ext2_clear_inode(struct inode *inode=
)
>  		posix_acl_release(ei->i_default_acl);
>  		ei->i_default_acl =3D EXT2_ACL_NOT_CACHED;
>  	}
> -#endif
>  }
> +#else
> +#define ext2_clear_inode NULL
> +#endif

Are you sure your patch makes a difference?  Does the resulting binary
change at all?

J=C3=B6rn

--=20
=46ancy algorithms are slow when n is small, and n is usually small.
=46ancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
