Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA73BA23F
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782732901; cv=none; b=aS8/hrE5P2MZ2AuCk+nCBZLwuaJeFtOFUAQGHcMNkbiBTxdimyt+Fv/ZGKjLhEx8Rg0EY7SLrj/b44dLhxc0DsRoOH0D5UYJ+p+WM/Nbe77OMVs49L8ryIIv9f/HdKPjTTllwFgXhEShePxZgE6p67Dm75RcYBDLvWFwzySqSV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782732901; c=relaxed/simple;
	bh=kSohMuLCvKmL9Q0aUeihQojKZx1rHobL/x9Q/NWpncc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHBth0aTK8pANrfv4F9+b2AB38SUm5YwP3JnY/oExGQ35rQtR2sRW/bN5xMDSspR8TU0RjwmOobko9hQszeW8l5Q14JhdZV3488NADlT0dgJggjPJGilInsjZeKWe440mKDrU2+ePMHoQ2XIKj+2loH0YQi2xOsNkwDw9srppUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yt37d7qA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lWazTBRY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CNRlUU/o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wKD2llb/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yt37d7qA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lWazTBRY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CNRlUU/o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wKD2llb/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 33A1275DA4;
	Mon, 29 Jun 2026 11:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782732898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6+GvXEtFwRqzS8tI9muzgmvx6ciYJO5o6MM0f2X7yK0=;
	b=Yt37d7qAsbXAGwZUu8b8j3mxm1mE9w3J7+iVBV2gPR2LKiheDO6XM7zonalqt2Hnp/+8FD
	O8tTp//Rp6E6V06v0RQA9/DUxI7nZafjtQ4nHmRLcfC7kJw5VQWC8e6c+bxPe1DNnu8DMS
	vtCtO7oiAc4HHBm6AVY4HtGqRBS1hGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782732898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6+GvXEtFwRqzS8tI9muzgmvx6ciYJO5o6MM0f2X7yK0=;
	b=lWazTBRYIk7I3bQRnrBbJoMYyNH2W2e+eBpEDIhrv5gUo5pc1DL1XoqMTSsrNfS+9Ju6z8
	UGJ4qjo5Gk6Z+uCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="CNRlUU/o";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wKD2llb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782732897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6+GvXEtFwRqzS8tI9muzgmvx6ciYJO5o6MM0f2X7yK0=;
	b=CNRlUU/o6BCZs1cXZjpsSnoHxZ1zkHxmdeQSdCBaI4jynoQG8qnpu1HsgfvjQSYhPb+far
	x1bLr+bwWLTCJqHWBuXbcBhEbP1ntFO51cvDA9HF7bGLDWafveGeM5NbCbfSIVrHhWe2Yo
	lr3FpmbapZpiIirbg787e33JKp1uVoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782732897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6+GvXEtFwRqzS8tI9muzgmvx6ciYJO5o6MM0f2X7yK0=;
	b=wKD2llb/CNCRwbbIdcstJyiyvffzPAY2tJB+toLXnUuqf18FqAUB3vmpevl8EXTOKiGGF9
	H50+V/Se6iUyCHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 255F0779A8;
	Mon, 29 Jun 2026 11:34:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uSsYCWFYQmq/XwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 11:34:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4D5BA10B5; Mon, 29 Jun 2026 13:34:48 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:34:48 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 2/5] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <l5bxxxkvphsn6gwrjva6jpypxcqwjbg6pkn5t2qyji35tbhlf5@hiokqig54iqq>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629110848.3085662-3-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,windriver.com:email,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 33A1275DA4
X-Spam-Score: -2.51

On Mon 29-06-26 19:08:45, Yun Zhou wrote:
> Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
> can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
> creating a lock ordering issue during mount (!SB_ACTIVE).
> 
> Add ext4_put_ea_inode() which uses iput_if_not_last() as a fast path.
> If this is not the last reference, it is dropped immediately.  If this
> is the last reference, the inode is linked onto a per-sb lock-free llist
> via i_ea_iput_node (embedded in ext4_inode_info, sharing space with the
> unused xattr_sem of EA inodes via a union) and a delayed worker
> (1 jiffie) performs the final iput() in a clean context.  This avoids
> per-iput memory allocation.
> 
> Flush points are placed before quota shutdown (ext4_put_super and
> failed_mount9) and before freeing structures that eviction depends on
> (failed_mount_wq and failed_mount3a).  Initialization is placed before
> journal loading since fast commit replay may trigger evictions that call
> ext4_put_ea_inode().
> 
> Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
> handle slab object reuse after the union field has been overwritten.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
