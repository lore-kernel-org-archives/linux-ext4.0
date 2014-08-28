From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 2/3] ext4: allocate buffer-cache for superblock in,
 non-movable area
Date: Thu, 28 Aug 2014 12:06:45 +0200
Message-ID: <20140828100645.GC5961@quack.suse.cz>
References: <53FE9357.6000505@lge.com>
 <53FE94BD.3020408@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847AbaH1KGv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2014 06:06:51 -0400
Content-Disposition: inline
In-Reply-To: <53FE94BD.3020408@lge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-08-14 11:32:29, Gioh Kim wrote:
> 
> A buffer-cache for superblock is disturbing page migration,
> because the buffer-cache is not released until unmount.
> The buffer-cache must be allocated from non-movable area.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>  fs/ext4/super.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 32b43ad..e4b62b3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3435,7 +3435,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>                 logical_sb_block = sb_block;
>         }
> 
> -       if (!(bh = sb_bread(sb, logical_sb_block))) {
> +       if (!(bh = sb_bread_unmovable(sb, logical_sb_block))) {
>                 ext4_msg(sb, KERN_ERR, "unable to read superblock");
>                 goto out_fail;
>         }
> @@ -3645,7 +3645,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>                 brelse(bh);
>                 logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
>                 offset = do_div(logical_sb_block, blocksize);
> -               bh = sb_bread(sb, logical_sb_block);
> +               bh = sb_bread_unmovable(sb, logical_sb_block);
>                 if (!bh) {
>                         ext4_msg(sb, KERN_ERR,
>                                "Can't read superblock on 2nd try");
> @@ -3867,7 +3867,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> 
>         for (i = 0; i < db_count; i++) {
>                 block = descriptor_loc(sb, logical_sb_block, i);
> -               sbi->s_group_desc[i] = sb_bread(sb, block);
> +               sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
>                 if (!sbi->s_group_desc[i]) {
>                         ext4_msg(sb, KERN_ERR,
>                                "can't read group descriptor %d", i);
> --
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
