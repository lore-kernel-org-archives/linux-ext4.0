From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: create function to read journal inode
Date: Thu, 22 Sep 2016 17:03:53 +0200
Message-ID: <20160922150353.GA19971@quack2.suse.cz>
References: <20160922011450.GB27216@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42499 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933674AbcIVPD4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Sep 2016 11:03:56 -0400
Content-Disposition: inline
In-Reply-To: <20160922011450.GB27216@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-09-16 21:14:50, Eric Whitney wrote:
> Factor out the code used in ext4_get_journal() to read a valid journal
> inode from storage, enabling its reuse in other functions.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

BTW: I didn't see PATCH 2/2?

								Honza
> ---
>  fs/ext4/super.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 50912cc..4b0ca25 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -78,6 +78,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
>  static void ext4_destroy_lazyinit_thread(void);
>  static void ext4_unregister_li_request(struct super_block *sb);
>  static void ext4_clear_request_list(void);
> +static struct inode *ext4_get_journal_inode(struct super_block *sb,
> +					    unsigned int journal_inum);
>  
>  /*
>   * Lock ordering
> @@ -4237,18 +4239,16 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
>  	write_unlock(&journal->j_state_lock);
>  }
>  
> -static journal_t *ext4_get_journal(struct super_block *sb,
> -				   unsigned int journal_inum)
> +static struct inode *ext4_get_journal_inode(struct super_block *sb,
> +					     unsigned int journal_inum)
>  {
>  	struct inode *journal_inode;
> -	journal_t *journal;
> -
> -	BUG_ON(!ext4_has_feature_journal(sb));
> -
> -	/* First, test for the existence of a valid inode on disk.  Bad
> -	 * things happen if we iget() an unused inode, as the subsequent
> -	 * iput() will try to delete it. */
>  
> +	/*
> +	 * Test for the existence of a valid inode on disk.  Bad things
> +	 * happen if we iget() an unused inode, as the subsequent iput()
> +	 * will try to delete it.
> +	 */
>  	journal_inode = ext4_iget(sb, journal_inum);
>  	if (IS_ERR(journal_inode)) {
>  		ext4_msg(sb, KERN_ERR, "no journal found");
> @@ -4268,6 +4268,20 @@ static journal_t *ext4_get_journal(struct super_block *sb,
>  		iput(journal_inode);
>  		return NULL;
>  	}
> +	return journal_inode;
> +}
> +
> +static journal_t *ext4_get_journal(struct super_block *sb,
> +				   unsigned int journal_inum)
> +{
> +	struct inode *journal_inode;
> +	journal_t *journal;
> +
> +	BUG_ON(!ext4_has_feature_journal(sb));
> +
> +	journal_inode = ext4_get_journal_inode(sb, journal_inum);
> +	if (!journal_inode)
> +		return NULL;
>  
>  	journal = jbd2_journal_init_inode(journal_inode);
>  	if (!journal) {
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
