From: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Subject: Re: [PATCH] ext4 : Remove redundant condition in ext4_free_blocks_sb()
Date: 01 Jun 2008 09:25:19 +0300
Message-ID: <5d4p8du0xc.fsf@Hurtta06k.keh.iki.fi>
References: <ea11fea30805311156vff13c10mdb2d5e399112d0bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Manish Katiyar" <mkatiyar@gmail.com> writes in
gmane.linux.file-systems:

> For two unsigned values the check "block+count < block"  is always
> false. Thus the below patch removes that condition.
> 
> =============================================================
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> 
> --- a/fs/ext4/balloc.c  2008-05-18 18:07:45.000000000 +0530
> +++ b/fs/ext4/balloc.c  2008-06-01 00:05:48.000000000 +0530
> @@ -619,7 +619,6 @@
>         sbi = EXT4_SB(sb);
>         es = sbi->s_es;
>         if (block < le32_to_cpu(es->s_first_data_block) ||
> -           block + count < block ||
>             block + count > ext4_blocks_count(es)) {
>                 ext4_error (sb, "ext4_free_blocks",
>                             "Freeing blocks not in datazone - "
> 
> 
> =============================================================

Hmm. Consider situation where   block + count > max unsigned value
     mathematically

     in that case 
           block + count < block
     expression may be true

 
> -- 
> Thanks & Regards,
> ********************************************
> Manish Katiyar ( http://mkatiyar.googlepages.com )
> 3rd Floor, Fair Winds Block
> EGL Software Park
> Off Intermediate Ring Road
> Bangalore 560071, India
> ***********************************************
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

/ Kari Hurtta

