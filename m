Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B894D3BADB1
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733346; cv=none; b=QNQFecAMReaVeGjWX6c+TewLNwpwRnpcvTnmcXvtogahmt3HaErpu3Rh+fAXzOABW78IPSW0IyVfHyBOm9ZxroolinAtMj3U6IvbxDgGAeHmIww+qQYK0f41ilIb/NuLzMjIQ8wrvZp4YJcgtfoYxqZCm7LfBB+y/zxybHZZ3RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733346; c=relaxed/simple;
	bh=oD4Wdy5Np6ria+AEGkm+NyN7hZz0aGJkUgH5tqs1MtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3wPmvCtlDco8GATF6iLtAAccp9K21pg5QF/BUmHE0HCso7InRRifSwAZyhkupeJ+jm2EYrSy3H+0Ehc/HqdfWJ5dW6uqMCMygT3EKrDVAHlwHz9xHYdwphWSZzUN4ovZQ+l50CCgal2NHHTiun9deCL3QDNGEHho9pMM/KcllA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=USPCkXY6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=obFlLoGl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=USPCkXY6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=obFlLoGl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="USPCkXY6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="obFlLoGl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="USPCkXY6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="obFlLoGl"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 134CB75ABF;
	Mon, 29 Jun 2026 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDbTdZTtFmnpbwfn9bc85A3WfRDW/mMNv4c4W36mirU=;
	b=USPCkXY67A0qWWtZdNUlHGZ7ShtSIxFN69tlJwwpTSmzo6qww+s+H+Nq/BUyHXsy8wctqq
	TVug1qUpnuuEJyEsCEPQNOi/fJmkOJYMYbug+0Wpo7+NS6bkTG54uofCfgyGzWXNJEbLm+
	FI9958ReRyphL+pSzwY7KlIlrhvyKSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDbTdZTtFmnpbwfn9bc85A3WfRDW/mMNv4c4W36mirU=;
	b=obFlLoGlLUK2XnrNTwRPQi+HDv5gIi1u9FY0L5PtxWgHqtRRE1CGmYjpQCixp2Z7IZy19c
	rsJVK/EDQpHEVrDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDbTdZTtFmnpbwfn9bc85A3WfRDW/mMNv4c4W36mirU=;
	b=USPCkXY67A0qWWtZdNUlHGZ7ShtSIxFN69tlJwwpTSmzo6qww+s+H+Nq/BUyHXsy8wctqq
	TVug1qUpnuuEJyEsCEPQNOi/fJmkOJYMYbug+0Wpo7+NS6bkTG54uofCfgyGzWXNJEbLm+
	FI9958ReRyphL+pSzwY7KlIlrhvyKSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDbTdZTtFmnpbwfn9bc85A3WfRDW/mMNv4c4W36mirU=;
	b=obFlLoGlLUK2XnrNTwRPQi+HDv5gIi1u9FY0L5PtxWgHqtRRE1CGmYjpQCixp2Z7IZy19c
	rsJVK/EDQpHEVrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93C5F779A8;
	Mon, 29 Jun 2026 11:42:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x/QRJBxaQmrAZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 11:42:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3AD5CA10B5; Mon, 29 Jun 2026 13:42:20 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:42:20 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 4/5] ext4: remove ea_inode_array mechanism in favor
 of ext4_put_ea_inode()
Message-ID: <m5r4btltl5swpuifvrmobsmmjyrgxckgp4fpsenuf5fofnqlqj@poubnm4v42of>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-5-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629110848.3085662-5-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,windriver.com:email,suse.com:email,suse.cz:email]
X-Spam-Level: 

On Mon 29-06-26 19:08:47, Yun Zhou wrote:
> Now that ext4_put_ea_inode() handles deferred iput safely for all cases
> (using iput_if_not_last + embedded llist_node), the ea_inode_array
> mechanism for batching deferred iputs is redundant.
> 
> Remove:
> - ext4_expand_inode_array() and ext4_xattr_inode_array_free()
> - struct ext4_xattr_inode_array and EIA_INCR/EIA_MASK defines
> - ea_inode_array parameter from ext4_xattr_inode_dec_ref_all(),
>   ext4_xattr_release_block(), and ext4_xattr_delete_inode()
> - ea_inode_array variable from ext4_evict_inode()
> 
> Instead, ext4_xattr_inode_dec_ref_all() now calls ext4_put_ea_inode()
> directly after processing each EA inode.  This simplifies the code
> by eliminating multi-layer parameter threading and removes the need
> for callers to manage array lifetime.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Nice. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c |  6 +---
>  fs/ext4/xattr.c | 80 ++++---------------------------------------------
>  fs/ext4/xattr.h |  7 -----
>  3 files changed, 6 insertions(+), 87 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0d131371ad3d..6f1b84e46a2e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -176,7 +176,6 @@ void ext4_evict_inode(struct inode *inode)
>  	 * (xattr block freeing), bitmap, group descriptor (inode freeing)
>  	 */
>  	int extra_credits = 6;
> -	struct ext4_xattr_inode_array *ea_inode_array = NULL;
>  	bool freeze_protected = false;
>  
>  	trace_ext4_evict_inode(inode);
> @@ -282,8 +281,7 @@ void ext4_evict_inode(struct inode *inode)
>  	}
>  
>  	/* Remove xattr references. */
> -	err = ext4_xattr_delete_inode(handle, inode, &ea_inode_array,
> -				      extra_credits);
> +	err = ext4_xattr_delete_inode(handle, inode, extra_credits);
>  	if (err) {
>  		ext4_warning(inode->i_sb, "xattr delete (err %d)", err);
>  stop_handle:
> @@ -291,7 +289,6 @@ void ext4_evict_inode(struct inode *inode)
>  		ext4_orphan_del(NULL, inode);
>  		if (freeze_protected)
>  			sb_end_intwrite(inode->i_sb);
> -		ext4_xattr_inode_array_free(ea_inode_array);
>  		goto no_delete;
>  	}
>  
> @@ -321,7 +318,6 @@ void ext4_evict_inode(struct inode *inode)
>  	ext4_journal_stop(handle);
>  	if (freeze_protected)
>  		sb_end_intwrite(inode->i_sb);
> -	ext4_xattr_inode_array_free(ea_inode_array);
>  	return;
>  no_delete:
>  	/*
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index d6950b0b8f40..01b9aff0cd25 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -114,10 +114,6 @@ const struct xattr_handler * const ext4_xattr_handlers[] = {
>  #define EA_INODE_CACHE(inode)	(((struct ext4_sb_info *) \
>  				inode->i_sb->s_fs_info)->s_ea_inode_cache)
>  
> -static int
> -ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
> -			struct inode *inode);
> -
>  #ifdef CONFIG_LOCKDEP
>  void ext4_xattr_inode_set_class(struct inode *ea_inode)
>  {
> @@ -1160,7 +1156,6 @@ static void
>  ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  			     struct buffer_head *bh,
>  			     struct ext4_xattr_entry *first, bool block_csum,
> -			     struct ext4_xattr_inode_array **ea_inode_array,
>  			     int extra_credits, bool skip_quota)
>  {
>  	struct inode *ea_inode;
> @@ -1197,14 +1192,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (err)
>  			continue;
>  
> -		err = ext4_expand_inode_array(ea_inode_array, ea_inode);
> -		if (err) {
> -			ext4_warning_inode(ea_inode,
> -					   "Expand inode array err=%d", err);
> -			ext4_put_ea_inode(parent->i_sb, ea_inode);
> -			continue;
> -		}
> -
>  		err = ext4_journal_ensure_credits_fn(handle, credits, credits,
>  			ext4_free_metadata_revoke_credits(parent->i_sb, 1),
>  			ext4_xattr_restart_fn(handle, parent, bh, block_csum,
> @@ -1212,6 +1199,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (err < 0) {
>  			ext4_warning_inode(ea_inode, "Ensure credits err=%d",
>  					   err);
> +			ext4_put_ea_inode(parent->i_sb, ea_inode);
>  			continue;
>  		}
>  		if (err > 0) {
> @@ -1221,6 +1209,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  				ext4_warning_inode(ea_inode,
>  						"Re-get write access err=%d",
>  						err);
> +				ext4_put_ea_inode(parent->i_sb, ea_inode);
>  				continue;
>  			}
>  		}
> @@ -1229,6 +1218,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (err) {
>  			ext4_warning_inode(ea_inode, "ea_inode dec ref err=%d",
>  					   err);
> +			ext4_put_ea_inode(parent->i_sb, ea_inode);
>  			continue;
>  		}
>  
> @@ -1245,6 +1235,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		entry->e_value_inum = 0;
>  		entry->e_value_size = 0;
>  
> +		ext4_put_ea_inode(parent->i_sb, ea_inode);
>  		dirty = true;
>  	}
>  
> @@ -1271,7 +1262,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  static void
>  ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  			 struct buffer_head *bh,
> -			 struct ext4_xattr_inode_array **ea_inode_array,
>  			 int extra_credits)
>  {
>  	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
> @@ -1313,7 +1303,6 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  			ext4_xattr_inode_dec_ref_all(handle, inode, bh,
>  						     BFIRST(bh),
>  						     true /* block_csum */,
> -						     ea_inode_array,
>  						     extra_credits,
>  						     true /* skip_quota */);
>  		ext4_free_blocks(handle, inode, bh, 0, 1,
> @@ -2182,12 +2171,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  
>  	/* Drop the previous xattr block. */
>  	if (bs->bh && bs->bh != new_bh) {
> -		struct ext4_xattr_inode_array *ea_inode_array = NULL;
> -
>  		ext4_xattr_release_block(handle, inode, bs->bh,
> -					 &ea_inode_array,
>  					 0 /* extra_credits */);
> -		ext4_xattr_inode_array_free(ea_inode_array);
>  	}
>  	error = 0;
>  
> @@ -2863,46 +2848,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  	return error;
>  }
>  
> -#define EIA_INCR 16 /* must be 2^n */
> -#define EIA_MASK (EIA_INCR - 1)
> -
> -/* Add the large xattr @inode into @ea_inode_array for deferred iput().
> - * If @ea_inode_array is new or full it will be grown and the old
> - * contents copied over.
> - */
> -static int
> -ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
> -			struct inode *inode)
> -{
> -	if (*ea_inode_array == NULL) {
> -		/*
> -		 * Start with 15 inodes, so it fits into a power-of-two size.
> -		 */
> -		(*ea_inode_array) = kmalloc_flex(**ea_inode_array, inodes,
> -						 EIA_MASK, GFP_NOFS);
> -		if (*ea_inode_array == NULL)
> -			return -ENOMEM;
> -		(*ea_inode_array)->count = 0;
> -	} else if (((*ea_inode_array)->count & EIA_MASK) == EIA_MASK) {
> -		/* expand the array once all 15 + n * 16 slots are full */
> -		struct ext4_xattr_inode_array *new_array = NULL;
> -
> -		new_array = kmalloc_flex(**ea_inode_array, inodes,
> -					 (*ea_inode_array)->count + EIA_INCR,
> -					 GFP_NOFS);
> -		if (new_array == NULL)
> -			return -ENOMEM;
> -		memcpy(new_array, *ea_inode_array,
> -		       struct_size(*ea_inode_array, inodes,
> -				   (*ea_inode_array)->count));
> -		kfree(*ea_inode_array);
> -		*ea_inode_array = new_array;
> -	}
> -	(*ea_inode_array)->count++;
> -	(*ea_inode_array)->inodes[(*ea_inode_array)->count - 1] = inode;
> -	return 0;
> -}
> -
>  /*
>   * ext4_xattr_delete_inode()
>   *
> @@ -2913,7 +2858,6 @@ ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
>   * references on xattr block and xattr inodes.
>   */
>  int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
> -			    struct ext4_xattr_inode_array **ea_inode_array,
>  			    int extra_credits)
>  {
>  	struct buffer_head *bh = NULL;
> @@ -2952,7 +2896,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  			ext4_xattr_inode_dec_ref_all(handle, inode, iloc.bh,
>  						     IFIRST(header),
>  						     false /* block_csum */,
> -						     ea_inode_array,
>  						     extra_credits,
>  						     false /* skip_quota */);
>  	}
> @@ -2991,7 +2934,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  
>  		}
>  
> -		ext4_xattr_release_block(handle, inode, bh, ea_inode_array,
> +		ext4_xattr_release_block(handle, inode, bh,
>  					 extra_credits);
>  		/*
>  		 * Update i_file_acl value in the same transaction that releases
> @@ -3013,19 +2956,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  	return error;
>  }
>  
> -void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
> -{
> -	int idx;
> -
> -	if (ea_inode_array == NULL)
> -		return;
> -
> -	for (idx = 0; idx < ea_inode_array->count; ++idx)
> -		iput(ea_inode_array->inodes[idx]);
> -	kfree(ea_inode_array);
> -}
> -
> -
>  /*
>   * Worker function for deferred EA inode iput.  Processes all inodes queued
>   * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index ad98f7e7348d..518f0283e174 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -131,11 +131,6 @@ struct ext4_xattr_ibody_find {
>  	struct ext4_iloc iloc;
>  };
>  
> -struct ext4_xattr_inode_array {
> -	unsigned int count;
> -	struct inode *inodes[] __counted_by(count);
> -};
> -
>  extern const struct xattr_handler ext4_xattr_user_handler;
>  extern const struct xattr_handler ext4_xattr_trusted_handler;
>  extern const struct xattr_handler ext4_xattr_security_handler;
> @@ -187,9 +182,7 @@ extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
>  				bool is_create);
>  
>  extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
> -				   struct ext4_xattr_inode_array **array,
>  				   int extra_credits);
> -extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
>  extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
>  extern void ext4_put_ea_inode(struct super_block *sb, struct inode *inode);
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
