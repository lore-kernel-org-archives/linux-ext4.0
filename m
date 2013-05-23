From: Tao Ma <tm@tao.ma>
Subject: Re: it may be a ext4 feature-inlinedata bug
Date: Thu, 23 May 2013 14:48:48 +0800
Message-ID: <519DBBD0.2070204@tao.ma>
References: <CAAFszuUGv=0cKFw_ku7A12uZK7wNb5huMOUPKtC4b2REMMuFjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: boxi liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:39504 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751514Ab3EWGsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 May 2013 02:48:53 -0400
In-Reply-To: <CAAFszuUGv=0cKFw_ku7A12uZK7wNb5huMOUPKtC4b2REMMuFjA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Boxi,

On 05/20/2013 10:50 PM, boxi liu wrote:
> In fs/ext4/xattr.c file, the function ex4_xattr_set_entry(), the size
> of xattr space we use the pad to count it .In line 675:
>    size_t size = EXT4_XATTR_SIZE(i->value_len);
> We use the EXT_XATTR_SIZE to count the value_len,then get the xattr's
> used space.
> But in fs/ext4/inline.c file,we just use the actual size to count the
> inlinedata free size,in function get_max_inline_xattr_value_size()
> ,line 75,such as:
>     free += le32_to_cpu(entry->e_value_size);
> This may bring in a bug about count the inlinedata free space.
> The bug reproduction way:
> 1. in the subarea with inline_data feature
>     touch test
> 2. use echo to add to write the test file 129 bytes
> 3. use the "stat" to get the test file's status
>     stat test
>     the result is:  .....size:129 block:0 .....
> 4.use echo to add one byte in the test file
>    echo -n "0">>test
> 5.use the "stat" to get the test file's status
>    stat test
>    the result is:  .....size:130 block:8 .....
> It is incorrect.In inline_data feature,only when the size is bigger
> then 132,it will use the block.
OK, so it seems to be an improvement, not a bug since there is no data
loss and only some contents are moved to a block even if it can be
stored in the inode. But yes, the patch looks good to me.

So could you please read the Documentation/SubmittingPatches and submit
a real patch for it?

Thanks,
Tao
> 
> The patch about this bug:
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 3e2bf87..bea5ced 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -72,7 +72,7 @@ static int get_max_inline_xattr_value_size(struct
> inode *inode,
>                 entry = (struct ext4_xattr_entry *)
>                         ((void *)raw_inode + EXT4_I(inode)->i_inline_off);
> 
> -               free += le32_to_cpu(entry->e_value_size);
> +              free += EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
>                 goto out;
>         }
> It might be fix this bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

