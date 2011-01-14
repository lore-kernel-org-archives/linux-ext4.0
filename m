From: apple <wangshilong1991@gmail.com>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk fails
Date: Thu, 13 Jan 2011 18:57:09 -0800
Message-ID: <AF6C6182-E0CF-486E-B3A0-E857EF08CD3D@gmail.com>
References: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:37009 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3AMKzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 05:55:23 -0500
In-Reply-To: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Something wrong with my clock, so i send patch several times.=20
 I feel very sorry about it.I have sent V1 patch after i fix my compute=
r clock.
Sorry to bother every one=A1=AD..
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>=20
> It will be better to have ENOMEM return rather than EIO,because
> the only reason that sb_getblk fails is allocation fails.
>=20
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> fs/ext3/inode.c  | 6 +++---
> fs/ext3/resize.c | 6 +++---
> fs/ext3/xattr.c  | 2 +-
> 3 files changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index c91f8bf..d5315d5 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1084,7 +1084,7 @@ struct buffer_head *ext3_getblk(handle_t *handl=
e, struct inode *inode,
> 		struct buffer_head *bh;
> 		bh =3D sb_getblk(inode->i_sb, dummy.b_blocknr);
> 		if (unlikely(!bh)) {
> -			*errp =3D -EIO;
> +			*errp =3D -ENOMEM;
> 			goto err;
> 		}
> 		if (buffer_new(&dummy)) {
> @@ -2739,7 +2739,7 @@ static int __ext3_get_inode_loc(struct inode *i=
node,
> 				"unable to read inode block - "
> 				"inode=3D%lu, block=3D"E3FSBLK,
> 				 inode->i_ino, block);
> -		return -EIO;
> +		return -ENOMEM;
> 	}
> 	if (!buffer_uptodate(bh)) {
> 		lock_buffer(bh);
> @@ -2833,7 +2833,7 @@ make_io:
> 					"inode=3D%lu, block=3D"E3FSBLK,
> 					inode->i_ino, block);
> 			brelse(bh);
> -			return -EIO;
> +			return -ENOMEM;
> 		}
> 	}
> has_buffer:
> diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
> index 704e8ce..2710565 100644
> --- a/fs/ext3/resize.c
> +++ b/fs/ext3/resize.c
> @@ -117,7 +117,7 @@ static struct buffer_head *bclean(handle_t *handl=
e, struct super_block *sb,
>=20
> 	bh =3D sb_getblk(sb, blk);
> 	if (unlikely(!bh))
> -		return ERR_PTR(-EIO);
> +		return ERR_PTR(-ENOMEM);
> 	if ((err =3D ext3_journal_get_write_access(handle, bh))) {
> 		brelse(bh);
> 		bh =3D ERR_PTR(err);
> @@ -235,7 +235,7 @@ static int setup_new_group_blocks(struct super_bl=
ock *sb,
>=20
> 		gdb =3D sb_getblk(sb, block);
> 		if (unlikely(!gdb)) {
> -			err =3D -EIO;
> +			err =3D -ENOMEM;
> 			goto exit_bh;
> 		}
> 		if ((err =3D ext3_journal_get_write_access(handle, gdb))) {
> @@ -723,7 +723,7 @@ static void update_backups(struct super_block *sb=
,
>=20
> 		bh =3D sb_getblk(sb, group * bpg + blk_off);
> 		if (unlikely(!bh)) {
> -			err =3D -EIO;
> +			err =3D -ENOMEM;
> 			break;
> 		}
> 		ext3_debug("update metadata backup %#04lx\n",
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index 9f57470..b1fc963 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -816,7 +816,7 @@ inserted:
> 			if (unlikely(!new_bh)) {
> getblk_failed:
> 				ext3_free_blocks(handle, inode, block, 1);
> -				error =3D -EIO;
> +				error =3D -ENOMEM;
> 				goto cleanup;
> 			}
> 			lock_buffer(new_bh);
> --=20
> 1.7.11.7
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
