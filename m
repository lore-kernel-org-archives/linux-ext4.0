From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] Unify log messages in ext3
Date: Mon, 23 Nov 2009 11:36:58 +0100
Message-ID: <20091123103658.GA15679@duck.suse.cz>
References: <4B087DEC.5010402@redhat.com>
 <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZKWKgx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 05:36:53 -0500
Content-Disposition: inline
In-Reply-To: <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Thanks for the patch. I've merged it into my tree just with the following
typo fixes.

								Honza

> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 427496c..b1b6da8 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1200,9 +1214,9 @@ set_qf_format:
>  			clear_opt(sbi->s_mount_opt, NOBH);
>  			break;
>  		default:
> -			printk (KERN_ERR
> -				"EXT3-fs: Unrecognized mount option \"%s\" "
> -				"or missing value\n", p);
> +			ext3_msg(sb, KERN_ERR,
> +				"error: unrecognized mount option \"%s\" "
> +				"or missing valuen", p);
                                                ^^^ value
> @@ -1290,22 +1306,20 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
>  
>  	ext3_commit_super(sb, es, 1);
>  	if (test_opt(sb, DEBUG))
> -		printk(KERN_INFO "[EXT3 FS bs=%lu, gc=%lu, "
> -				"bpg=%lu, ipg=%lu, mo=%04lx]\n",
> +		ext3_msg(sb, KERN_INFO, "[bs=%lu, gc=%lu, "
> +				"bpg=%lu, ipg=%lu, mo=%04lx]",
>  			sb->s_blocksize,
>  			sbi->s_groups_count,
>  			EXT3_BLOCKS_PER_GROUP(sb),
>  			EXT3_INODES_PER_GROUP(sb),
>  			sbi->s_mount_opt);
>  
> -	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
>  	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
>  		char b[BDEVNAME_SIZE];
> -
> -		printk("external journal on %s\n",
> +		ext3_msg(sb, KERN_INFO, "using externa journal on %s",
                                                   ^^^ external

>  			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
>  	} else {
> -		printk("internal journal\n");
> +		ext3_msg(sb, KERN_INFO, "using internal journaln");
                                                        ^^^^^ journal

> @@ -1944,8 +1961,9 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  
>  	if (test_opt(sb, NOBH)) {
>  		if (!(test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)) {
> -			printk(KERN_WARNING "EXT3-fs: Ignoring nobh option - "
> -				"its supported only with writeback mode\n");
> +			ext3_msg(sb, KERN_WARNING,
> +				"warning: ignoring nobh option - "
> +				"its supported only with writeback mode");
                                 ^^^ it is

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
