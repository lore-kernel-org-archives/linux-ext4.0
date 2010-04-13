From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext2: Move ext2_write_super() out of
 ext2_setup_super()
Date: Tue, 13 Apr 2010 19:53:18 +0200
Message-ID: <20100413175318.GA3250@quack.wifi.zluty.cz>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
 <1271104905-8804-5-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0DMRxR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Apr 2010 13:53:17 -0400
Content-Disposition: inline
In-Reply-To: <1271104905-8804-5-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-04-10 22:41:44, Jan Blunck wrote:
> Move ext2_write_super() out of ext2_setup_super() as a preparation for the
> next patch that adds a new lock for superblock fields.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/ext2/super.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 40fc8d5..b01c491 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -606,7 +606,6 @@ static int ext2_setup_super (struct super_block * sb,
>  	if (!le16_to_cpu(es->s_max_mnt_count))
>  		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
>  	le16_add_cpu(&es->s_mnt_count, 1);
> -	ext2_write_super(sb);
>  	if (test_opt (sb, DEBUG))
>  		ext2_msg(sb, KERN_INFO, "%s, %s, bs=%lu, fs=%lu, gc=%lu, "
>  			"bpg=%lu, ipg=%lu, mo=%04lx]",
> @@ -1079,7 +1078,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
>  		ext2_msg(sb, KERN_WARNING,
>  			"warning: mounting ext3 filesystem as ext2");
> -	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> +	if (ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY))
> +		sb->s_flags != MS_RDONLY;
                            ^^ Should be |=, shouldn't it?

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
