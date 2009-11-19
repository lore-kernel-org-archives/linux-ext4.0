From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: journal all modifications in
 ext3_xattr_set_handle
Date: Thu, 19 Nov 2009 15:44:19 +0100
Message-ID: <20091119144419.GD24836@duck.suse.cz>
References: <4B01D1D2.1060409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59411 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZKSOoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 09:44:14 -0500
Content-Disposition: inline
In-Reply-To: <4B01D1D2.1060409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-11-09 16:27:30, Eric Sandeen wrote:
> ext3_xattr_set_handle() was zeroing out an inode outside
> of journaling constraints; this is one of the accesses that
> was causing the crc errors in journal replay as seen in
> kernel.org bugzilla #14354.
> 
> Although ext3 doesn't have the crc issue, modifications
> out of journal control are a Bad Thing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
  Thanks. Looks good. Queue up.

								Honza
> 
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index 545e37c..387d92d 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -960,6 +960,10 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
> 	if (error)
> 		goto cleanup;
> 
> +	error = ext3_journal_get_write_access(handle, is.iloc.bh);
> +	if (error)
> +		goto cleanup;
> +
> 	if (EXT3_I(inode)->i_state & EXT3_STATE_NEW) {
> 		struct ext3_inode *raw_inode = ext3_raw_inode(&is.iloc);
> 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
> @@ -985,9 +989,6 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
> 		if (flags & XATTR_CREATE)
> 			goto cleanup;
> 	}
> -	error = ext3_journal_get_write_access(handle, is.iloc.bh);
> -	if (error)
> -		goto cleanup;
> 	if (!value) {
> 		if (!is.s.not_found)
> 			error = ext3_xattr_ibody_set(handle, inode, &i, &is);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
