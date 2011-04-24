From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH] ext2: fix error msg when mounting fs with too-large blocksize
Date: Sun, 24 Apr 2011 15:17:51 +0800
Message-ID: <4DB3CE9F.1020201@gmail.com>
References: <1303626991-6704-1-git-send-email-hao.bigrat@gmail.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Robin Dong <sanbai@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60556 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753071Ab1DXGsA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 02:48:00 -0400
In-Reply-To: <1303626991-6704-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B404=E6=9C=8824=E6=97=A5 14:36, Robin Dong Wrote:
> From: Robin Dong <sanbai@taobao.com>
>=20
> When ext2 mounts a filesystem, it attempts to set the block device
> blocksize with a call to sb_set_blocksize, which can fail for
> several reasons.  The current failure message in ext2 prints:
>=20
>   EXT2-fs (loop1): error: blocksize is too small
>=20
> which is not correct in all cases.  This can be demonstrated
> by creating a filesystem with
>=20
>   # mkfs.ext2 -b 8192
>=20
> on a 4k page system, and attempting to mount it.
>=20
> Change the error message to a more generic:
>=20
>   EXT2-fs (loop1): bad blocksize 8192
>=20
> to match the error message in ext3.
>=20

Reviewed-by: Coly Li <bosong.ly@taobao.com>


> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext2/super.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 0a78dae..1dd62ed 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -898,7 +898,8 @@ static int ext2_fill_super(struct super_block *sb=
, void *data, int silent)
>  		brelse(bh);
> =20
>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
> +			ext2_msg(sb, KERN_ERR,
> +				"error: bad blocksize %d", blocksize);
>  			goto failed_sbi;
>  		}
> =20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
