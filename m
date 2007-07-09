From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Mon, 9 Jul 2007 22:01:48 +0400
Message-ID: <20070709180148.GA5747@martell.zuzino.mipt.ru>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru> <20070709083431.GA14761@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070709083431.GA14761@lazybastard.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2007 at 10:34:32AM +0200, J=F6rn Engel wrote:
> On Mon, 9 July 2007 08:11:22 +0400, Alexey Dobriyan wrote:
> >=20
> > If CONFIG_EXT2_FS_POSIX_ACL is not configured, ext2_clear_inode() w=
ill be empty
> > function. However, there still will be call and immediate return wh=
ich can be
> > avoided.
> > [...]
> > +#ifdef CONFIG_EXT2_FS_POSIX_ACL
> >  static void ext2_clear_inode(struct inode *inode)
> >  {
> > -#ifdef CONFIG_EXT2_FS_POSIX_ACL
> >  	struct ext2_inode_info *ei =3D EXT2_I(inode);
> > =20
> >  	if (ei->i_acl && ei->i_acl !=3D EXT2_ACL_NOT_CACHED) {
> > @@ -197,8 +197,10 @@ static void ext2_clear_inode(struct inode *ino=
de)
> >  		posix_acl_release(ei->i_default_acl);
> >  		ei->i_default_acl =3D EXT2_ACL_NOT_CACHED;
> >  	}
> > -#endif
> >  }
> > +#else
> > +#define ext2_clear_inode NULL
> > +#endif
>=20
> Are you sure your patch makes a difference?  Does the resulting binar=
y
> change at all?

Yes. Note that ext2_clear_inode() is referenced from ext2_sops, so even
empty, it leaves traces in resulting kernel.

-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
