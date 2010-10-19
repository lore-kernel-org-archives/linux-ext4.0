From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] ext3: Check return value of sb_getblk()
Date: Tue, 19 Oct 2010 16:57:29 +0900
Message-ID: <1287475049.1705.2.camel@leonhard>
References: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0JSH5g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 03:57:36 -0400
In-Reply-To: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-10-19 (=ED=99=94), 15:34 +0900, Namhyung Kim:
> Check return value of sb_getblk() is NULL. unlikely is addded here
> since it is called from a loop and we've been OK without the check
> until now.
>=20
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/inode.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ef1c23a..a7ac778 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle, s=
truct inode *inode,
>  		 * parent to disk.
>  		 */
>  		bh =3D sb_getblk(inode->i_sb, new_blocks[n-1]);
> +		if (unlikely(!bh)) {
> +			n--;
> +			err =3D -ENOMEM;
> +			goto failed;
> +		}
> +
>  		branch[n].bh =3D bh;
>  		lock_buffer(bh);
>  		BUFFER_TRACE(bh, "call get_create_access");

Maybe EIO would be more proper error code, I guess.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
