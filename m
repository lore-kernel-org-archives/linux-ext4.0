Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CF62F6920
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781721742; cv=none; b=vBhWT6J5B6ftAl4QpHDnpPOQ2QRt2+LjUcRRm74z7q3Mr4FOe5lkL+s/0W/+eOdBxrIuqUK2iaUHo+vKpkUybkvNHRAq50SM7JTatdg3ZuA4beacAREOrmB+UsTSuDqHG/ys7J8S5/Fgwudmo3CR7OO9pKMegax7Xb4U8H8akU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781721742; c=relaxed/simple;
	bh=BXMxyBcoLVy2vs3VfzP6eoaaqZZPKLakk9UwfgR8YSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wa+G9zk1cM+GfSvbH8awP+j7T53kXkSjO9wzi4ZOPYSIkW8SUOJmppxU23Lyo6RQFFef2dn0ecJvF5KUoCAl8hVCt5MxaC4ADlGEg0ytNq6zPUq/mByl32kme9DNSF0moThOfVd5AugzLY2oJXylvF7JIlClGRSOhI57Qq43wGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yg7ZQsmZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A6N3kmye; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yg7ZQsmZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A6N3kmye; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yg7ZQsmZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A6N3kmye";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yg7ZQsmZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A6N3kmye"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E9A56BFB9;
	Wed, 17 Jun 2026 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781721739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ei5+YRxaye/GQJVd6OEnNbhr9nBK6ENNGoXj7DqIA+8=;
	b=Yg7ZQsmZa90Eugzei+4dTmXt2vBZbn0d19HvVi7mOfbux/BGlnINPMs4Xn18HfB3nVYTcG
	zmKeZiK5UYF+LrMqvyLqPjpLS4sm+fHhz8nP7/mS3QVrT31dDkyXqHzSML8aOV2lV7cBpw
	iScjaao9HanhVepBNaZautDVYjmmx9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781721739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ei5+YRxaye/GQJVd6OEnNbhr9nBK6ENNGoXj7DqIA+8=;
	b=A6N3kmyePayco2tOeYo/4fo0IKc7rGGRO4c1bM0UKJsX+PIma5ZBOH8jqusCWGKoTDZfgi
	XYwwf/88w1dDzJDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yg7ZQsmZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6N3kmye
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781721739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ei5+YRxaye/GQJVd6OEnNbhr9nBK6ENNGoXj7DqIA+8=;
	b=Yg7ZQsmZa90Eugzei+4dTmXt2vBZbn0d19HvVi7mOfbux/BGlnINPMs4Xn18HfB3nVYTcG
	zmKeZiK5UYF+LrMqvyLqPjpLS4sm+fHhz8nP7/mS3QVrT31dDkyXqHzSML8aOV2lV7cBpw
	iScjaao9HanhVepBNaZautDVYjmmx9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781721739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ei5+YRxaye/GQJVd6OEnNbhr9nBK6ENNGoXj7DqIA+8=;
	b=A6N3kmyePayco2tOeYo/4fo0IKc7rGGRO4c1bM0UKJsX+PIma5ZBOH8jqusCWGKoTDZfgi
	XYwwf/88w1dDzJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17772779A8;
	Wed, 17 Jun 2026 18:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sqK1BYvqMmpvHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 18:42:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AF003A0EC0; Wed, 17 Jun 2026 20:42:14 +0200 (CEST)
Date: Wed, 17 Jun 2026 20:42:14 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <jxcbsd2ot63wy3dcoximemkuitwoqn2a7jgxcsfdwaf5q3ecdu@sahahqqopo6y>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <20260616151558.1728881-4-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616151558.1728881-4-yun.zhou@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2E9A56BFB9
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 16-06-26 23:15:57, Yun Zhou wrote:
> Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
> can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
> creating a lock ordering issue during mount (!SB_ACTIVE).
> 
> Add ext4_put_ea_inode() which safely releases EA inode references:
> when SB_ACTIVE, it calls iput() directly (write_inode_now cannot be
> triggered); during mount (!SB_ACTIVE), it queues the inode on a per-sb
> lock-free llist and schedules a worker to call iput() in a clean
> context without holding any ext4 locks.
> 
> Convert the iput in ext4_xattr_block_set()'s "Drop the previous xattr
> block" path to use ext4_xattr_inode_array_free_deferred(), which
> releases EA inodes via ext4_put_ea_inode().  This path previously called
> ext4_xattr_inode_array_free() (synchronous iput) while holding xattr_sem
> and a jbd2 handle.
> 
> The worker is flushed in ext4_put_super() before journal destruction to
> ensure all pending EA inode cleanup completes while the journal is still
> available.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Yes, this goes in the direction I intended. But I have couple of
suggestions:

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..690202303269 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1706,6 +1706,11 @@ struct ext4_sb_info {
>  	struct ext4_es_stats s_es_stats;
>  	struct mb_cache *s_ea_block_cache;
>  	struct mb_cache *s_ea_inode_cache;
> +
> +	/* Deferred iput for EA inodes to avoid lock ordering issues */
> +	struct llist_head s_ea_inode_to_free;
> +	struct work_struct s_ea_inode_work;
> +

I'd probably use delayed work and schedule it with a delay of one jiffie so
that some inodes can accumulate before we process them which should reduce
the amount of task switching to workqueues.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..b777bb0a81ea 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1308,6 +1308,9 @@ static void ext4_put_super(struct super_block *sb)
>  	destroy_workqueue(sbi->rsv_conversion_wq);
>  	ext4_release_orphan_info(sb);
>  
> +	/* Flush deferred EA inode iputs before destroying journal */
> +	flush_work(&sbi->s_ea_inode_work);
> +

This should happen earlier in ext4_put_super(). At this place quotas were
already turned off and so quota accounting would go wrong.

> @@ -3025,6 +3028,74 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
>  	kfree(ea_inode_array);
>  }
>  
> +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
> +				struct ext4_xattr_inode_array *array)
> +{
> +	int idx;
> +
> +	if (array == NULL)
> +		return;
> +
> +	for (idx = 0; idx < array->count; ++idx)
> +		ext4_put_ea_inode(sb, array->inodes[idx]);
> +	kfree(array);
> +}

The array of EA inodes used in xattr handling is just another mechanism
used for delaying iput() of EA inodes. It doesn't make sense to stack these
to one on top of another. Just completely replace the array mechanism with
always deferring iput of EA inode into the workqueue.

> +struct ext4_ea_iput_entry {
> +	struct llist_node node;
> +	struct inode *inode;
> +};
> +
> +/*
> + * Worker function for deferred EA inode iput.  Processes all inodes queued
> + * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
> + */
> +void ext4_ea_inode_work(struct work_struct *work)
> +{
> +	struct ext4_sb_info *sbi = container_of(work, struct ext4_sb_info,
> +						s_ea_inode_work);
> +	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
> +	struct llist_node *next;
> +
> +	while (node) {
> +		struct ext4_ea_iput_entry *entry = container_of(node,
> +				struct ext4_ea_iput_entry, node);
> +		next = node->next;
> +		iput(entry->inode);
> +		kfree(entry);
> +		node = next;
> +	}
> +}

Allocating ext4_ea_iput_entry for dropping each inode is somewhat wasteful.
I want to suggest another scheme (somewhat more involved but more efficient
scheme):

1) Create a VFS helper bool iput_if_not_last(struct inode *inode) which
drops inode reference if it is not the last one (and returns true in that
case). Basically:

bool iput_if_not_last(struct inode *inode)
{
	return atomic_add_unless(&inode->i_count, -1, 1);
}

This needs to be a separate patch as it should get vetting from VFS
maintainers.

2) Use iput_if_not_last() in ext4_put_ea_inode(). If it returns true, we
are done. Otherwise we know we were at least for a moment holders of the
last inode reference, so we link the inode to the list of inodes to drop
through llist_node embedded in ext4_inode_info. We cannot race with anybody
else trying to link the same inode into the list because we hold one inode
ref and so nobody else can hit this "I was holding the last ref" path.
I'd union this llist_node say with xattr_sem which is unused for EA inodes
to avoid growing ext4_inode_info.

This way we avoid offloading unless really necessary and we don't have to
do allocations just to drop EA inode ref.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
