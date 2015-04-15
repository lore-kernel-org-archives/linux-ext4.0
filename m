From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [patch] ext4 crypto: type bug with encrypted symlinks
Date: Wed, 15 Apr 2015 09:14:17 -0600
Message-ID: <1591C866-F48B-4F82-B2D1-7F7180E3EE2A@dilger.ca>
References: <20150415092133.GA9264@mwanda>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150415092133.GA9264@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nak.  ostr.len is the variable being swabbed, and it is a __u32.

Cheers, Andreas

> On Apr 15, 2015, at 03:21, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> sd->len is an __le16 and not an __le32.
> 
> Fixes: f1195c72c951 ('ext4 crypto: Add symlink encryption')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 69e12ee..5c82a3c 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3256,7 +3256,7 @@ static int ext4_symlink(struct inode *dir,
>        ext4_put_fname_crypto_ctx(&ctx);
>        if (err < 0)
>            goto err_drop_inode;
> -        sd->len = cpu_to_le32(ostr.len);
> +        sd->len = cpu_to_le16(ostr.len);
>        disk_link.name = (char *) sd;
>    }
> 
