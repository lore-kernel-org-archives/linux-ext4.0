From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 2/2] jbd2: return ENOSPC in journal_dirty_metadata if a
 handle runs out of space
Date: Tue, 3 Dec 2013 07:34:42 +0000
Message-ID: <20131203073442.GA7047@ZenIV.linux.org.uk>
References: <1385995502-8344-1-git-send-email-tytso@mit.edu>
 <1385995502-8344-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52182 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3LCHeo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 02:34:44 -0500
Content-Disposition: inline
In-Reply-To: <1385995502-8344-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 09:45:02AM -0500, Theodore Ts'o wrote:
> If a handle runs out of space, we currently stop the kernel with a
> BUG.  This makes it hard to figure out what might be going on.  So
> return an error of ENOSPC, so we can let the file system layer figure
> out what is going on, to make it more likely we can get useful
> debugging information).  This should make it easier to debug problems
> such as the one which was reported by:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=44731
> 
> The only two callers of this function are ext4_handle_dirty_metadata()
> and ocfs2_journal_dirty().  The ocfs2 function will trigger a
> BUG_ON(), which means there will be no change in behavior.  The ext4
> function will call ext4_error_inode() which will print the useful
> debugging information and then handle the situation using ext4's error
> handling mechanisms (i.e., which might mean halting the kernel or
> remounting the file system read-only).
> 
> Also, since both file systems already call WARN_ON(), drop the WARN_ON
> from jbd2_journal_dirty_metadata() to avoid two stack traces from
> being displayed.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/jbd2/transaction.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 7aa9a32..b0b74e5 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1290,7 +1290,10 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  		 * once a transaction -bzzz
>  		 */
>  		jh->b_modified = 1;
> -		J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> +		if (handle->h_buffer_credits <= 0) {
> +			ret = -ENOSPC;
> +			goto out_unlock_bh;
> +		}
>  		handle->h_buffer_credits--;
>  	}
>  
> @@ -1373,7 +1376,6 @@ out_unlock_bh:
>  	jbd2_journal_put_journal_head(jh);
>  out:
>  	JBUFFER_TRACE(jh, "exit");
> -	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
>  	return ret;
>  }
>  
> -- 
> 1.8.5.rc3.362.gdf10213
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
