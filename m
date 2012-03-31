From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] ext2: write superblock only once on unmount
Date: Sat, 31 Mar 2012 13:53:32 +0200
Message-ID: <20120331115332.GB4569@quack.suse.cz>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
 <1332346475-1441-4-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab2DATnB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Apr 2012 15:43:01 -0400
Content-Disposition: inline
In-Reply-To: <1332346475-1441-4-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-03-12 18:14:30, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Currently on unmount if we are mounted R/W, we first write the superblock to
> the media if it is dirty, and then write it again, which is not optimal. This
> patch makes ext2 write the superblock on unmount less times.
  Looks good. I've added the patch to my tree.

									Honza
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/ext2/super.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 0090595..d141758 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -130,9 +130,6 @@ static void ext2_put_super (struct super_block * sb)
>  
>  	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
>  
> -	if (sb->s_dirt)
> -		ext2_write_super(sb);
> -
>  	ext2_xattr_put_super(sb);
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		struct ext2_super_block *es = sbi->s_es;
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
