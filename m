From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
Date: Thu, 16 Aug 2012 18:39:04 +0200
Message-ID: <20120816163904.GA17526@quack.suse.cz>
References: <502CC4BA.3040702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <502CC4BA.3040702@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 16-08-12 12:00:26, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Replaced lock and unlock super with a new fs mutex s_lock.
  Hum, is the lock needed at all? Remount & unfreeze both run with s_umount
held for writing. Thus we already have exclusion between these two calls.
The same seems to hold for ext4 BTW.

								Honza
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> diff -Nurp linux-3.6-rc1-orig/fs/ext3/ext3.h linux-3.6-rc1/fs/ext3/ext3.h
> --- linux-3.6-rc1-orig/fs/ext3/ext3.h	2012-08-16 09:37:31.000000000 +0200
> +++ linux-3.6-rc1/fs/ext3/ext3.h	2012-08-16 09:46:39.000000000 +0200
> @@ -672,6 +672,7 @@ struct ext3_sb_info {
>  	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
>  	int s_jquota_fmt;			/* Format of quota to use */
>  #endif
> +	struct mutex s_lock;
>  };
>   static inline spinlock_t *
> diff -Nurp linux-3.6-rc1-orig/fs/ext3/super.c linux-3.6-rc1/fs/ext3/super.c
> --- linux-3.6-rc1-orig/fs/ext3/super.c	2012-08-16 09:37:31.000000000 +0200
> +++ linux-3.6-rc1/fs/ext3/super.c	2012-08-16 09:49:11.000000000 +0200
> @@ -1939,6 +1939,7 @@ static int ext3_fill_super (struct super
>  	sbi->s_gdb_count = db_count;
>  	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
>  	spin_lock_init(&sbi->s_next_gen_lock);
> +	mutex_init(&sbi->s_lock);
>   	/* per fileystem reservation list head & lock */
>  	spin_lock_init(&sbi->s_rsv_window_lock);
> @@ -2582,11 +2583,11 @@ out:
>  static int ext3_unfreeze(struct super_block *sb)
>  {
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		lock_super(sb);
> +		mutex_lock(&EXT3_SB(sb)->s_lock);
>  		/* Reser the needs_recovery flag before the fs is unlocked. */
>  		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
>  		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> -		unlock_super(sb);
> +		mutex_unlock(&EXT3_SB(sb)->s_lock);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
>  	}
>  	return 0;
> @@ -2606,7 +2607,7 @@ static int ext3_remount (struct super_bl
>  #endif
>   	/* Store the original options */
> -	lock_super(sb);
> +	mutex_lock(&EXT3_SB(sb)->s_lock);
>  	old_sb_flags = sb->s_flags;
>  	old_opts.s_mount_opt = sbi->s_mount_opt;
>  	old_opts.s_resuid = sbi->s_resuid;
> @@ -2712,7 +2713,7 @@ static int ext3_remount (struct super_bl
>  		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
>  			kfree(old_opts.s_qf_names[i]);
>  #endif
> -	unlock_super(sb);
> +	mutex_unlock(&EXT3_SB(sb)->s_lock);
>   	if (enable_quota)
>  		dquot_resume(sb, -1);
> @@ -2732,7 +2733,7 @@ restore_opts:
>  		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
>  	}
>  #endif
> -	unlock_super(sb);
> +	mutex_unlock(&EXT3_SB(sb)->s_lock);
>  	return err;
>  }
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
