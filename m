From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext4: shutdown should not prevent get_write_access
Date: Wed, 7 Mar 2018 10:42:01 +0100
Message-ID: <20180307094201.ihki3mh7lnib4ta4@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-4-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220023038.19883-4-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-02-18 21:30:34, Theodore Ts'o wrote:
> The ext4 forced shutdown flag needs to prevent new handles from being
> started, but it needs to allow existing handles to complete.  So the
> forced shutdown flag should not force ext4_journal_get_write_access to
> fail.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

OK, if you want the semantics of ext4 shutdown to be that running
handles should be allowed to complete, I see where you are going with this
patch. However there are more problems with this semantics than just
__ext4_journal_get_write_access(). Just for example
ext4_reserve_inode_write() will bail in case the fs got shutdown and thus
inode changes won't be properly added to the running handle. Also places
that rely on nested transactions being possible will not work because
ext4_journal_start_sb() will refuse to get refcount of a running handle
(ext4_journal_check_start() fails) in case fs got shutdown. And I may have
missed other cases.

The above problems are a reason why I though the semantics of ext4 shutdown
was terminate the fs *now* - effectively a software equivalent of power
off. That is much easier to implement since we just have to make sure no
running handle makes it to the journal... Since I've said Google is using
ext4 shutdown - is there any reason why you need the "running handles are
allowed to finish" semantics? After all it seems it's just a race whether
some handle makes it before the cut off or not...

								Honza

> ---
>  fs/ext4/ext4_jbd2.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 2d593201cf7a..7c70b08d104c 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -166,13 +166,6 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
>  	might_sleep();
>  
>  	if (ext4_handle_valid(handle)) {
> -		struct super_block *sb;
> -
> -		sb = handle->h_transaction->t_journal->j_private;
> -		if (unlikely(ext4_forced_shutdown(EXT4_SB(sb)))) {
> -			jbd2_journal_abort_handle(handle);
> -			return -EIO;
> -		}
>  		err = jbd2_journal_get_write_access(handle, bh);
>  		if (err)
>  			ext4_journal_abort_handle(where, line, __func__, bh,
> -- 
> 2.16.1.72.g5be1f00a9a
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
