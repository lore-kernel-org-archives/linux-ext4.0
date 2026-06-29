Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225253BAD92
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733136; cv=none; b=hR7lDLDmZVOWqTbpA7w/oq4l8kg+bs9i9nw3BDYY1fRh78e96KOz81LgkCKnOolqOYGZEOHRFAgMdFB+OediwHxe9r1Fnlp6AM6rpksensqa1fIt3M0038Q4y2fFiddvLIQAqG6a+pM1ZzZpNnqmrV9r3XVrez6RSZ7CwLpDMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733136; c=relaxed/simple;
	bh=lN1IifZsflkfhK5GPM/B3+aPEWeAoH5hSQ7gb7yBDDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpLcGA4NLN65sGINbldtbIZfq3OxOpIlzEUDiIQIm6jsIVVwzdyuECAPdq0qujG14BkIOMGD8yFcLQV8vDtPVEK716tkM+vs+cpfywBrbIhsrIXPy7ZW13YcZzBa1Qv/WZbcSY/g+LljCATTwnHvo56I/GbvNK0sjyWqD4z6QBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0PnS5nLr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=87yKCZKh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0PnS5nLr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=87yKCZKh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0PnS5nLr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="87yKCZKh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0PnS5nLr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="87yKCZKh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6004273065;
	Mon, 29 Jun 2026 11:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8l1qXnS89fJooLwtG/GOT6JItKflAKJzdlPsMvSwQQg=;
	b=0PnS5nLrMMwagZaxVXYRQYB8d2+nyejHl5niG7YmVKAyx9+IYcGcDG2ckq3V+MRhVIoS+y
	mQl1TB924JiYwahCGZUx/Tr9awobY7MHMYsV0oChpFIZ+uzKh1nwy3glRghYR2IgqCtT33
	u/YRv7XyEpGOY2rvXxvUYevt+uqfcOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8l1qXnS89fJooLwtG/GOT6JItKflAKJzdlPsMvSwQQg=;
	b=87yKCZKh1GbYP7l6PJ7srAA9YeW7IdQnybYlymzu36MWPN4RSegSMrNWvS+zJcOShv/Zi0
	zUVo1t0vBLFhO3AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0PnS5nLr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=87yKCZKh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782733132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8l1qXnS89fJooLwtG/GOT6JItKflAKJzdlPsMvSwQQg=;
	b=0PnS5nLrMMwagZaxVXYRQYB8d2+nyejHl5niG7YmVKAyx9+IYcGcDG2ckq3V+MRhVIoS+y
	mQl1TB924JiYwahCGZUx/Tr9awobY7MHMYsV0oChpFIZ+uzKh1nwy3glRghYR2IgqCtT33
	u/YRv7XyEpGOY2rvXxvUYevt+uqfcOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782733132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8l1qXnS89fJooLwtG/GOT6JItKflAKJzdlPsMvSwQQg=;
	b=87yKCZKh1GbYP7l6PJ7srAA9YeW7IdQnybYlymzu36MWPN4RSegSMrNWvS+zJcOShv/Zi0
	zUVo1t0vBLFhO3AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43BFE779A8;
	Mon, 29 Jun 2026 11:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U8uKEExZQmqwYwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 11:38:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB228A10B5; Mon, 29 Jun 2026 13:38:47 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:38:47 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 3/5] ext4: convert all EA inode iput() calls to
 ext4_put_ea_inode()
Message-ID: <hhbqclaymocb7wxfg2wryy6fo3pwj55qj7mug623lah5z75ub4@pjtbe2jtvffx>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-4-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629110848.3085662-4-yun.zhou@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6004273065
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email,windriver.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim,windriver.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 29-06-26 19:08:46, Yun Zhou wrote:
> Convert all iput() calls on EA inodes in xattr code paths to use
> ext4_put_ea_inode().  This establishes a uniform rule: every EA inode
> reference release in ext4 xattr code goes through ext4_put_ea_inode(),
> eliminating the need to analyze each call site individually for lock
> safety.
> 
> Converted sites:
> 
> - ext4_xattr_inode_get() read path
> - ext4_xattr_inode_inc_ref_all() main loop and cleanup path
> - ext4_xattr_inode_dec_ref_all() error paths
> - ext4_xattr_inode_create() error path
> - ext4_xattr_inode_cache_find() mismatch path
> - ext4_xattr_inode_lookup_create() out_err
> - ext4_xattr_set_entry() old_ea_inode
> - ext4_xattr_block_set() new block path, cleanup, and tmp_inode
> - ext4_xattr_ibody_set() error and success paths
> - ext4_xattr_delete_inode() quota loop
> 
> For most of these, iput_if_not_last() will succeed (the EA inode has
> other references) making the overhead a single atomic operation.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index ec66c62fbdaa..d6950b0b8f40 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -567,7 +567,7 @@ ext4_xattr_inode_get(struct inode *inode, struct ext4_xattr_entry *entry,
>  					ea_inode->i_ino, true /* reusable */);
>  	}
>  out:
> -	iput(ea_inode);
> +	ext4_put_ea_inode(inode->i_sb, ea_inode);
>  	return err;
>  }
>  
> @@ -1104,10 +1104,10 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
>  		err = ext4_xattr_inode_inc_ref(handle, ea_inode);
>  		if (err) {
>  			ext4_warning_inode(ea_inode, "inc ref error %d", err);
> -			iput(ea_inode);
> +			ext4_put_ea_inode(parent->i_sb, ea_inode);
>  			goto cleanup;
>  		}
> -		iput(ea_inode);
> +		ext4_put_ea_inode(parent->i_sb, ea_inode);
>  	}
>  	return 0;
>  
> @@ -1133,7 +1133,7 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
>  		if (err)
>  			ext4_warning_inode(ea_inode, "cleanup dec ref error %d",
>  					   err);
> -		iput(ea_inode);
> +		ext4_put_ea_inode(parent->i_sb, ea_inode);
>  	}
>  	return saved_err;
>  }
> @@ -1201,7 +1201,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  		if (err) {
>  			ext4_warning_inode(ea_inode,
>  					   "Expand inode array err=%d", err);
> -			iput(ea_inode);
> +			ext4_put_ea_inode(parent->i_sb, ea_inode);
>  			continue;
>  		}
>  
> @@ -1505,7 +1505,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
>  			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
>  				ext4_warning_inode(ea_inode,
>  					"cleanup dec ref error %d", err);
> -			iput(ea_inode);
> +			ext4_put_ea_inode(inode->i_sb, ea_inode);
>  			return ERR_PTR(err);
>  		}
>  
> @@ -1564,7 +1564,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>  			kvfree(ea_data);
>  			return ea_inode;
>  		}
> -		iput(ea_inode);
> +		ext4_put_ea_inode(inode->i_sb, ea_inode);
>  	next_entry:
>  		ce = mb_cache_entry_find_next(ea_inode_cache, ce);
>  	}
> @@ -1615,7 +1615,7 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
>  				      ea_inode->i_ino, true /* reusable */);
>  	return ea_inode;
>  out_err:
> -	iput(ea_inode);
> +	ext4_put_ea_inode(inode->i_sb, ea_inode);
>  	ext4_xattr_inode_free_quota(inode, NULL, value_len);
>  	return ERR_PTR(err);
>  }
> @@ -1848,7 +1848,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  
>  	ret = 0;
>  out:
> -	iput(old_ea_inode);
> +	ext4_put_ea_inode(inode->i_sb, old_ea_inode);
>  	return ret;
>  }
>  
> @@ -2010,7 +2010,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  				old_ea_inode_quota = le32_to_cpu(
>  						s->here->e_value_size);
>  			}
> -			iput(tmp_inode);
> +			ext4_put_ea_inode(inode->i_sb, tmp_inode);
>  
>  			s->here->e_value_inum = 0;
>  			s->here->e_value_size = 0;
> @@ -2150,7 +2150,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  					ext4_warning_inode(ea_inode,
>  							   "dec ref error=%d",
>  							   error);
> -				iput(ea_inode);
> +				ext4_put_ea_inode(inode->i_sb, ea_inode);
>  				ea_inode = NULL;
>  			}
>  
> @@ -2203,7 +2203,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			ext4_xattr_inode_free_quota(inode, ea_inode,
>  						    i_size_read(ea_inode));
>  		}
> -		iput(ea_inode);
> +		ext4_put_ea_inode(inode->i_sb, ea_inode);
>  	}
>  	if (ce)
>  		mb_cache_entry_put(ea_block_cache, ce);
> @@ -2285,7 +2285,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  
>  			ext4_xattr_inode_free_quota(inode, ea_inode,
>  						    i_size_read(ea_inode));
> -			iput(ea_inode);
> +			ext4_put_ea_inode(inode->i_sb, ea_inode);
>  		}
>  		return error;
>  	}
> @@ -2297,7 +2297,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  		header->h_magic = cpu_to_le32(0);
>  		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
>  	}
> -	iput(ea_inode);
> +	ext4_put_ea_inode(inode->i_sb, ea_inode);
>  	return 0;
>  }
>  
> @@ -2986,7 +2986,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  					continue;
>  				ext4_xattr_inode_free_quota(inode, ea_inode,
>  					      le32_to_cpu(entry->e_value_size));
> -				iput(ea_inode);
> +				ext4_put_ea_inode(inode->i_sb, ea_inode);
>  			}
>  
>  		}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
