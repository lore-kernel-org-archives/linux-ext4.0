From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4:an improvement in ext4 feature inline_data
Date: Sun, 26 May 2013 21:40:41 +0800
Message-ID: <51A210D9.3030703@tao.ma>
References: <CAAFszuV7QJc2-5xFerStUrjNhD4+MR3R7kBVAxsg+Otx18RvGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Robin Dong <sanbai@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: boxi liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:50783 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752692Ab3EZNkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 May 2013 09:40:51 -0400
In-Reply-To: <CAAFszuV7QJc2-5xFerStUrjNhD4+MR3R7kBVAxsg+Otx18RvGg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/26/2013 09:19 PM, boxi liu wrote:
> In ext4 feature inline_data,it use the xattr's space to store the
> inline data in inode.When we calculate the inline data as the xattr,we
> add the pad.But in get_max_inline_xattr_value_size() function we count
> the free space without pad.It cause some contents are moved to a block
> even if it can be
> stored in the inode.
> 
> Signed-off-by:liulei <lewis.liulei@huawei.com>
Reviewed-by: Tao Ma <boyu.mt@taobao.com>

Thanks,
Tao
> ---
>  fs/ext4/inline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index c0fd1a1..87758ca 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -71,7 +71,7 @@ static int get_max_inline_xattr_value_size(struct
> inode *inode,
>                 entry = (struct ext4_xattr_entry *)
>                         ((void *)raw_inode + EXT4_I(inode)->i_inline_off);
> 
> -               free += le32_to_cpu(entry->e_value_size);
> +               free += EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
>                 goto out;
>         }
> 
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

