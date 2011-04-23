From: Coly Li <i@coly.li>
Subject: Re: [PATCH] fix incorrect error-message of ext2
Date: Sat, 23 Apr 2011 22:23:21 +0800
Message-ID: <4DB2E0D9.7090009@coly.li>
References: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Robin Dong <sanbai@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36341 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754032Ab1DWNxg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 09:53:36 -0400
In-Reply-To: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B404=E6=9C=8823=E6=97=A5 21:36, Robin Dong Wrote:
> From: Robin Dong <sanbai@taobao.com>
>=20
> After "mkfs.ext2 -b 8192" on a new partition, I mount it with a error=
 dmesg:
> "error: blocksize is too small"
> That's not correct.
>=20

Agree, it should be too big, or invalid block size.

> Signed-off-by: Robin Dong <sanbai@taobao.com>
[snip]
> +	hblock =3D bdev_logical_block_size(sb->s_bdev);
>  	/* If the blocksize doesn't match, re-read the thing.. */
>  	if (sb->s_blocksize !=3D blocksize) {
> +		/*
> +		 * Make sure the blocksize for the filesystem is larger
> +		 * than the hardware sectorsize for the machine.
> +		 */
> +		if (blocksize < hblock) {
> +			ext2_msg(sb, KERN_ERR,
> +				"error: fsblocksize %d too small for "
> +				"hardware sectorsize %d", blocksize, hblock);

When a file system is mounted, the reported underlying dev logical bloc=
k size may be larger than a sector size.

> +			goto failed_mount;
> +		}
> +
>  		brelse(bh);
> =20

How about just keeping bellowed lines ? Reporting bad block size number=
 is the behavior how Ext3 and Ext4 do.

>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
> +			ext2_msg(sb, KERN_ERR,
> +				"error: bad blocksize %d", blocksize);
>  			goto failed_sbi;
>  		}


--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
