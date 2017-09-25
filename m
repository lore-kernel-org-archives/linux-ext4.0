From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: have filemap_check_and_advance_wb_err clear
 AS_EIO/AS_ENOSPC
Date: Mon, 25 Sep 2017 10:17:48 +0200
Message-ID: <20170925081748.GA5741@quack2.suse.cz>
References: <20170918112312.GN8034@eguan.usersys.redhat.com>
 <20170922133331.28812-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170922133331.28812-1-jlayton@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 22-09-17 09:33:31, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> Eryu noticed that he could sometimes get a leftover error reported when
> it shouldn't be on fsync with ext2 and non-journalled ext4. The problem
> is that writeback_single_inode still uses filemap_fdatawait. That picks
> up a previously set AS_EIO flag, which would ordinarily have been
> cleared before.
> 
> Since we're mostly using this function as a replacement for
> filemap_check_errors, have filemap_check_and_advance_wb_err clear AS_EIO
> and AS_ENOSPC when reporting an error. That should allow the new
> function to better emulate the behavior of the old with respect to these
> flags.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 870971e20967..404722ea0fdd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -620,6 +620,14 @@ int file_check_and_advance_wb_err(struct file *file)
>  		trace_file_check_and_advance_wb_err(file, old);
>  		spin_unlock(&file->f_lock);
>  	}
> +
> +	/*
> +	 * We're mostly using this function as a drop in replacement for
> +	 * filemap_check_errors. Clear AS_EIO/AS_ENOSPC to emulate the effect
> +	 * that the legacy code would have had on these flags.
> +	 */
> +	clear_bit(AS_EIO, &mapping->flags);
> +	clear_bit(AS_ENOSPC, &mapping->flags);
>  	return err;
>  }
>  EXPORT_SYMBOL(file_check_and_advance_wb_err);
> -- 
> 2.13.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
