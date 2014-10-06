From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: fix compilation for no-MMU configurations
Date: Mon, 6 Oct 2014 11:25:29 +0200
Message-ID: <20141006092529.GB7526@quack.suse.cz>
References: <1412499516-12839-1-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	kernel@pengutronix.de, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1412499516-12839-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sun 05-10-14 10:58:36, Uwe Kleine-K=F6nig wrote:
> Commit ac4dd23b76ce introduced a new function pagecache_isize_extended.
> In <linux/mm.h> it was declared static inline and empty for no-MMU and
> defined unconditionally in mm/truncate.c which results a compiler
> error:
>=20
> 	  CC      mm/truncate.o
> 	mm/truncate.c:751:6: error: redefinition of 'pagecache_isize_extended'
> 	 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_=
t to)
> 	      ^
> 	In file included from mm/truncate.c:13:0:
> 	include/linux/mm.h:1161:91: note: previous definition of 'pagecache_is=
ize_extended' was here
> 	 static inline void pagecache_isize_extended(struct inode *inode, loff=
_t from,
> 												   ^
> 	scripts/Makefile.build:257: recipe for target 'mm/truncate.o' failed
>=20
> (tested with ARCH=3Darm efm32_defconfig).
>=20
> Fixes: ac4dd23b76ce ("vfs: fix data corruption when blocksize < pagesiz=
e for mmaped data")
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
  Yeah, sorry for the breakage. It should be already fixed in Ted's tree.
I've actually chosen to just remove the inline definition. It is true tha=
t
currently the function doesn't need to do anything for systems not
supporting mmap but that may change in future and the functions is
reasonably cheap anyway...

								Honza
> ---
> Hello,
>=20
> the bad commit sits in
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git#dev
>=20
> and is included in next.
>=20
> Best regards
> Uwe
>=20
>  mm/truncate.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 261eaf6e5a19..0d9c4ebd5ecc 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -729,6 +729,7 @@ void truncate_setsize(struct inode *inode, loff_t n=
ewsize)
>  }
>  EXPORT_SYMBOL(truncate_setsize);
> =20
> +#ifdef CONFIG_MMU
>  /**
>   * pagecache_isize_extended - update pagecache after extension of i_si=
ze
>   * @inode:	inode for which i_size was extended
> @@ -780,6 +781,7 @@ void pagecache_isize_extended(struct inode *inode, =
loff_t from, loff_t to)
>  	page_cache_release(page);
>  }
>  EXPORT_SYMBOL(pagecache_isize_extended);
> +#endif
> =20
>  /**
>   * truncate_pagecache_range - unmap and remove pagecache that is hole-=
punched
> --=20
> 2.1.0
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
