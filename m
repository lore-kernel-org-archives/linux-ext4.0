From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/27] BKL: Remove BKL from ext3_put_super() and
	ext3_remount()
Date: Thu, 5 Nov 2009 12:56:59 +0100
Message-ID: <20091105115659.GB12770@duck.suse.cz>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-8-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755343AbZKEL45@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1257156307-24175-8-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 02-11-09 11:04:47, Jan Blunck wrote:
> The BKL lock is protecting the remounting against a potential call to
> ext3_put_super(). This could not happen, since this is protected by the
> s_umount rw semaphore of struct super_block.
> 
> Therefore I think the BKL is protecting nothing here.
  Yes, I'm also not aware of anything BKL would really protect. So I'm fine
with removing it here.
  Acked-by: Jan Kara <jack@suse.cz>
I can merge this patch as well if you want.

									Honza
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/ext3/super.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 4b635b7..3ddce03 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -398,8 +398,6 @@ static void ext3_put_super (struct super_block * sb)
>  	struct ext3_super_block *es = sbi->s_es;
>  	int i, err;
>  
> -	lock_kernel();
> -
>  	ext3_xattr_put_super(sb);
>  	err = journal_destroy(sbi->s_journal);
>  	sbi->s_journal = NULL;
> @@ -448,8 +446,6 @@ static void ext3_put_super (struct super_block * sb)
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> -
> -	unlock_kernel();
>  }
>  
>  static struct kmem_cache *ext3_inode_cachep;
> @@ -2495,8 +2491,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  	int i;
>  #endif
>  
> -	lock_kernel();
> -
>  	/* Store the original options */
>  	lock_super(sb);
>  	old_sb_flags = sb->s_flags;
> @@ -2607,7 +2601,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  			kfree(old_opts.s_qf_names[i]);
>  #endif
>  	unlock_super(sb);
> -	unlock_kernel();
>  	return 0;
>  restore_opts:
>  	sb->s_flags = old_sb_flags;
> @@ -2625,7 +2618,6 @@ restore_opts:
>  	}
>  #endif
>  	unlock_super(sb);
> -	unlock_kernel();
>  	return err;
>  }
>  
> -- 
> 1.6.4.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
