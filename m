Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818FC28A72F;
	Mon, 11 May 2026 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778506238; cv=none; b=R98N3zTdgFUZTZTNpmayKnCW81hw+HNj1XV6uZJrAS9A/VMUB6hzycVTKoD40bKfW2Qv6e4GjoT+9HmN0bRQZwd2XrstUmZpaKpA/imDIRUZhzRGmw6ROaWcggyTNIGKdqP/BhhJ9cdq+5vUJAqmuZTfYtbdvqYZQCDYnkUTxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778506238; c=relaxed/simple;
	bh=jbcVI1jrUyyXCbcXulItGm9FT6kPhvF1wROwKgAVnOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRtFPj81vLgNm6CHgkF+Im91vrgOS5ypaHQrtnxVxN/pPRxVBfGkpJRpUmZDSqxZz375LlvSk37NukrD3eV6gJ4SKg01/ibzbNP1GuMybNjZzj2yz3uqj6ZD3F9KmDo/Uq4GVthqLG1GNVkxAx4l7vfnNCz0+ZkvMIClGMAd1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHuR6Nce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHuR6Nce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54B4C2BCC9;
	Mon, 11 May 2026 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506238;
	bh=jbcVI1jrUyyXCbcXulItGm9FT6kPhvF1wROwKgAVnOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHuR6Nceb6LxsqK4kUrZCwzIQWgQHB/rIEllzq2o9+kYM1STACDZ/IWNvFTtRrrJ4
	 ZaUpIpa6VY6rifO9CH34d66vEzIoa+U6+kw3GW3h+UZJssd9FKGQNbk5rpI9Sq99Rv
	 YbrU6ps0usCRHdO/3tS3dc/JgAIU4Xnc3dBVAkvpuNuxm8i5Bh9+Ul8aT5E8aKpJiT
	 ti+wwhrX0HWhSgUDX+hn5rqPCSZeJUcwNIjJ4DFPTSZD2vddyV2eQLQO8d0ln0++zv
	 mETWNAoKIZtuv9bw6K4G5b/82b4nwDtahGd1JJEJR3ZGYv4MgSTS1SCg93ogLXNK4Z
	 U7iZgCrApEikw==
Date: Mon, 11 May 2026 15:30:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, aivazian.tigran@gmail.com, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 9/9] ext4: Use mmb infrastructure for inode buffer
 writeout
Message-ID: <20260511-paletten-kekse-7dc3bc394633@brauner>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-18-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260511121356.241821-18-jack@suse.cz>

On Mon, May 11, 2026 at 02:13:59PM +0200, Jan Kara wrote:
> Use mmb inode buffer writeout infrastructure to reliably write out
> inode's inode table block on fsync(2) in nojournal mode (from
> ext4_sync_parent() and ext4_fsync_nojournal()). This significantly
> simplifies the code as we don't have to explicitely handle inode buffer
> writeback in ext4_write_inode() and thus we can also remove
> sync_inode_metadata() calls from ext4_sync_parent() and
> ext4_write_inode() call from ext4_fsync_nojournal().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4_jbd2.c |  2 +-
>  fs/ext4/ext4_jbd2.h |  2 ++
>  fs/ext4/fsync.c     | 12 ------------
>  fs/ext4/inode.c     | 24 +++++-------------------
>  4 files changed, 8 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 74f05bd0cdde..6bbaf72108fd 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -350,7 +350,7 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
>  	return 0;
>  }
>  
> -static void ext4_inode_attach_mmb(struct inode *inode)
> +void ext4_inode_attach_mmb(struct inode *inode)
>  {
>  	struct mapping_metadata_bhs *mmb;
>  
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 63d17c5201b5..2a01b8279c88 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -122,6 +122,8 @@
>  #define EXT4_HT_EXT_CONVERT     11
>  #define EXT4_HT_MAX             12
>  
> +void ext4_inode_attach_mmb(struct inode *inode);
> +
>  int
>  ext4_mark_iloc_dirty(handle_t *handle,
>  		     struct inode *inode,
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index e25d365e1179..af84489e57c6 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -75,9 +75,6 @@ static int ext4_sync_parent(struct inode *inode)
>  			if (ret)
>  				break;
>  		}
> -		ret = sync_inode_metadata(inode, 1);
> -		if (ret)
> -			break;
>  	}
>  	dput(dentry);
>  	return ret;
> @@ -87,10 +84,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
>  				int datasync, bool *needs_barrier)
>  {
>  	struct inode *inode = file->f_inode;
> -	struct writeback_control wbc = {
> -		.sync_mode = WB_SYNC_ALL,
> -		.nr_to_write = 0,
> -	};
>  	int ret;
>  
>  	ret = mmb_fsync_noflush(file, EXT4_I(inode)->i_metadata_bhs,
> @@ -98,11 +91,6 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
>  	if (ret)
>  		return ret;
>  
> -	/* Force writeout of inode table buffer to disk */
> -	ret = ext4_write_inode(inode, &wbc);
> -	if (ret)
> -		return ret;
> -
>  	ret = ext4_sync_parent(inode);
>  
>  	if (test_opt(inode->i_sb, BARRIER))
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3e66e9510909..09506b4de1b2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5786,24 +5786,6 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  		err = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
>  						EXT4_I(inode)->i_sync_tid);
> -	} else {
> -		struct ext4_iloc iloc;
> -
> -		err = __ext4_get_inode_loc_noinmem(inode, &iloc);
> -		if (err)
> -			return err;
> -		/*
> -		 * sync(2) will flush the whole buffer cache. No need to do
> -		 * it here separately for each inode.
> -		 */
> -		if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
> -			sync_dirty_buffer(iloc.bh);
> -		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
> -			ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
> -					       "IO error syncing inode");
> -			err = -EIO;
> -		}
> -		brelse(iloc.bh);
>  	}
>  	return err;
>  }
> @@ -6348,7 +6330,11 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>  
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);
> -
> +	if (!ext4_handle_valid(handle)) {
> +		if (!EXT4_I(inode)->i_metadata_bhs)
> +			ext4_inode_attach_mmb(inode);
> +		EXT4_I(inode)->i_metadata_bhs->inode_blk = iloc->bh->b_blocknr;

The series is great overall. The only thing I think we should change is
that we should hide this

EXT4_I(inode)->i_metadata_bhs->inode_blk = iloc->bh->b_blocknr;

behind a dedicated static inline/regular function call instead of
open-coding it everywhere. Can then also be paired with some
VFS_WARN_ON_ONCE() to detect garbage bh->b_blocknr.
