From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: don't call ext4_should_journal_data() on the
 journal inode
Date: Mon, 4 Jul 2016 10:08:38 +0200
Message-ID: <20160704080838.GB5200@quack2.suse.cz>
References: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 02-07-16 23:42:42, Vegard Nossum wrote:
> Certain combinations of mount options in the superblock will cause
> set_journal_csum_feature_set() in ext4_fill_super() to fail after the
> journal has been created. When iput() is called on the journal inode,
> we will hit the BUG() in ext4_should_journal_data(). We can prevent
> this by only calling ext4_should_journal_data() if we already know
> that it's not the journal inode.
> 
> Fixes: 2d859db3e4 ("ext4: fix data corruption in inodes with journalled data")
> Fixes: 2b405bfa84 ("ext4: fix data=journal fast mount/umount hang")
> Cc: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 91b66db..2591236 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -207,9 +207,9 @@ void ext4_evict_inode(struct inode *inode)
>  		 * Note that directories do not have this problem because they
>  		 * don't use page cache.
>  		 */
> -		if (ext4_should_journal_data(inode) &&
> -		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
> -		    inode->i_ino != EXT4_JOURNAL_INO) {
> +		if (inode->i_ino != EXT4_JOURNAL_INO &&
> +		    ext4_should_journal_data(inode) &&
> +		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
>  			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
>  			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
>  
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
