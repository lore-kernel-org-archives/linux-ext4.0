From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: only call ext4_jbd2_file_inode when an inode has
 been extended
Date: Tue, 6 Sep 2011 12:02:53 +0200
Message-ID: <20110906100253.GB23747@quack.suse.cz>
References: <1315291106-25551-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1IFKC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 06:02:57 -0400
Content-Disposition: inline
In-Reply-To: <1315291106-25551-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-09-11 02:38:26, Ted Tso wrote:
> In delayed allocation mode, it's important to only call
> ext4_jbd2_file_inode when the file has been extended.  This is
> necessary to avoid a race which first got introduced in commit
> 678aaf481, but which was made much more common with the introduction
> of the "punch hole" functionality.  (Especially when dioread_nolock
> was enabled; when I could reliably reproduce this problem with
> xfstests #74.)
> 
> The race is this: If while trying to writeback a delayed allocation
> inode, there is a need to map delalloc blocks, and we run out of space
> in the journal, *and* at the same time the inode is already on the
> committing transaction's t_inode_list (because for example while doing
> the punch hole operation, ext4_jbd2_file_inode() is called), then the
> commit operation will wait for the inode to finish all of its pending
> writebacks by calling filemap_fdatawait(), but since that inode has
> one or more pages with the PageWriteback flag set, the commit
> operation will wait forever, and the so the writeback of the inode can
> never take place, and the kjournald thread and the writeback thread
> end up waiting for each other --- forever.
  Umm, I don't quite understand the race. It seems to me we can block on
lack of journal space during writeback only in ext4_da_writepages() where
we do ext4_journal_start(). But at that point there shouldn't be any pages
with PageWriteback set which were not submitted for IO. So it's not clear
to me why PageWriteback bit does not get cleared when IO finishes and
kjournald would then continue. Is it because IO completion is somehow
blocked on journal?

That would seem possible as I'm looking e.g. into
ext4_convert_unwritten_extents(). But then any waiting for writeback from
kjournald is prone to deadlocks. In fact regardless of what kjournald does
there does not seem to be sane lock ordering since we have:

transaction start -> PageWriteback -> transaction start
                  ^                ^
                  |         end_io handling if I'm right
      enforced by write_cache_pages_da

  Which is really nasty. We cannot end page writeback until the page is
readable from disk which means until we have properly updated extent tree.
But for extent tree update we need a transaction. The only way out I can
see is to reserve space for extent tree update in a transaction in
writepages() and holding the transaction open until end_io time when we
change extent tree and close the transaction. But I'm afraid that's going
to suck under heavy load... 

								Honza

> It's important at this point to recall why an inode is placed on the
> t_inode_list; it is to provide the data=ordered guarantees that we
> don't end up exposing stale data.  In the case where we are truncating
> or punching a hole in the inode, there is no possibility that stale
> data could be exposed in the first place, so we don't need to put the
> inode on the t_inode_list!
> 
> The right long-term fix is to get rid of data=ordered mode altogether,
> and only update the extent tree or indirect blocks after the data has
> been written.  Until then, this change will also avoid some
> unnecessary waiting in the commit operation.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Allison Henderson <achender@linux.vnet.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c |   23 ++++++++---------------
>  1 files changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d1b1ef7..f86b149 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1471,13 +1471,13 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
>  
>  		for (i = 0; i < map.m_len; i++)
>  			unmap_underlying_metadata(bdev, map.m_pblk + i);
> -	}
>  
> -	if (ext4_should_order_data(mpd->inode)) {
> -		err = ext4_jbd2_file_inode(handle, mpd->inode);
> -		if (err)
> -			/* This only happens if the journal is aborted */
> -			return;
> +		if (ext4_should_order_data(mpd->inode)) {
> +			err = ext4_jbd2_file_inode(handle, mpd->inode);
> +			if (err)
> +				/* Only if the journal is aborted */
> +				return;
> +		}
>  	}
>  
>  	/*
> @@ -3173,12 +3173,8 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
>  		err = 0;
>  		if (ext4_should_journal_data(inode)) {
>  			err = ext4_handle_dirty_metadata(handle, inode, bh);
> -		} else {
> -			if (ext4_should_order_data(inode) &&
> -			   EXT4_I(inode)->jinode)
> -				err = ext4_jbd2_file_inode(handle, inode);
> +		} else
>  			mark_buffer_dirty(bh);
> -		}
>  
>  		BUFFER_TRACE(bh, "Partial buffer zeroed");
>  next:
> @@ -3301,11 +3297,8 @@ int ext4_block_zero_page_range(handle_t *handle,
>  	err = 0;
>  	if (ext4_should_journal_data(inode)) {
>  		err = ext4_handle_dirty_metadata(handle, inode, bh);
> -	} else {
> -		if (ext4_should_order_data(inode) && EXT4_I(inode)->jinode)
> -			err = ext4_jbd2_file_inode(handle, inode);
> +	} else
>  		mark_buffer_dirty(bh);
> -	}
>  
>  unlock:
>  	unlock_page(page);
> -- 
> 1.7.4.1.22.gec8e1.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
