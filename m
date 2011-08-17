From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Don't set s_buddy_cache->i_ino to EXT4_BAD_INO
Date: Wed, 17 Aug 2011 09:31:46 -0600
Message-ID: <DD100641-4899-41D1-9A49-FD50AB6F89CD@dilger.ca>
References: <1313569222-5079-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:14872 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1HQPbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 11:31:11 -0400
In-Reply-To: <1313569222-5079-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-17, at 2:20 AM, Tao Ma <tm@tao.ma> wrote:
> In 85fe4025, Christoph removed get_next_ino() from new_inode() and
> do s_buddy_cache->i_ino = get_next_ino();
> And then 48e6061b gives EXT4_BAD_INO to this inode. But actually
> s_buddy_cache is used directly and we never get it from an inode number.
> So it should be safe for us to not set i_ino at all and I guess that
> is the case Christoph described in his commit log of 85fe4025
> "For a few more filesystems we can avoid assigning any inode number given
> that they aren't user visible".

I don't see that setting i_ino is harmful here (only done once per filesystem mount) and the comment clearly indicates that it is for precautionary reasons only. 

If this inode happens to appear in a crashdump for some reason, I'd prefer it has an inode number that can be identified easily rather than some random value left over from a previously allocated and freed inode, because inode_init_always() does not zero out i_ino. 

> Cc: Yu Jian <yujian@whamcloud.com>
> Cc: Andreas Dilger <adilger@whamcloud.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
> fs/ext4/mballoc.c |    5 -----
> 1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 17a5a57..982f783 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2342,11 +2342,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
>        ext4_msg(sb, KERN_ERR, "can't get new inode");
>        goto err_freesgi;
>    }
> -    /* To avoid potentially colliding with an valid on-disk inode number,
> -     * use EXT4_BAD_INO for the buddy cache inode number.  This inode is
> -     * not in the inode hash, so it should never be found by iget(), but
> -     * this will avoid confusion if it ever shows up during debugging. */
> -    sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
>    EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
>    for (i = 0; i < ngroups; i++) {
>        desc = ext4_get_group_desc(sb, i, NULL);
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
