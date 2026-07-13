Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A871F417357
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948192; cv=none; b=D8euPA/XMJcX0nIVLC8WNLrtAd5UiJvtxPDFMtjpJKb12sv2suLTSNfvqfMdUf2uMxHaz5A23FlJTuX7D2s18a7Nfzumlhj9obKQntjgZSDl6Bncom0sKwM7majwqshugltULCPPx9gdZksfmhrWMcVCCbwp1V7Uownpyq/bNg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948192; c=relaxed/simple;
	bh=eCLGgV4HCtUZ+915iey1H9NMtEJmuJ83xDIaUAfZJZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmAxhh9RcaieodFlfOeV6nI9fNLhsVHZkYBjOkrELQ7zBozeAHnCbzXFlMEYLNBIHnyQTTFce1acHcyr3n75AT/omVtGDE4angwhodZz6mohVmSNvzYVUjjfeSJQx4sNnEtxZgmgPvs96JuShEive3Y8I7VS6JkLd40M3sqgbvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1ge613Gl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5Y8E4Egh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0UcYh23w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jPEjMzl9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1ge613Gl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5Y8E4Egh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0UcYh23w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jPEjMzl9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB661778B8;
	Mon, 13 Jul 2026 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783948189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B5bcDpqM5eKuQnyIND1xQt5zCdEio+/KkxYIjdf2PAs=;
	b=1ge613GlkcOPwRjOXT4FKu0MPQ5fSg2077Kiefu1lkyHbrBtXC07B6eOmOJPOV/JNEbcCf
	NxoQjuOFNFl+ZzwDb5QXrTQBLeSyS8ntfY8oicHpMBjH8ZKKjl4dPSt6+kSUxD/927Fyek
	g7UuG1hg0isS64Sx6Qk1tNxnSdx3QKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783948189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B5bcDpqM5eKuQnyIND1xQt5zCdEio+/KkxYIjdf2PAs=;
	b=5Y8E4EghWLcuV6jCxIGFiFQtorLadq1iBtYWGi8DafXUZDGMjI+zS/AHZsbbUkDbCLkMQA
	4IgmmQOUPjIQuKDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783948188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B5bcDpqM5eKuQnyIND1xQt5zCdEio+/KkxYIjdf2PAs=;
	b=0UcYh23weZ2D5uPyst6acFL1jSrC60Vc6x2/Fkq7lMwFkViNiWWt966U7BsyGQyofGyCkM
	XM7gjGR4XifRmNMfe0FuyyA3gRvqwWKq/i0+wQ+7ULXN3eapFEnR1PrvIBu6IOyf9nWUDx
	S3FVEZMK8xggygHUGZkVwvEqi6GqZfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783948188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B5bcDpqM5eKuQnyIND1xQt5zCdEio+/KkxYIjdf2PAs=;
	b=jPEjMzl9JErnqY36vQrOcEqCwHi7mDwU7Z0h7fRSfzox3V+cDIXt7B+uKG14AQuexpmdp/
	gVdX5qUTWu6QjfAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5B82779AE;
	Mon, 13 Jul 2026 13:09:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YWo/MJzjVGoHWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Jul 2026 13:09:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 71BDFA131A; Mon, 13 Jul 2026 15:09:48 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:09:48 +0200
From: Jan Kara <jack@suse.cz>
To: Xiang Mei <xmei5@asu.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Daniel Rosenberg <drosen@google.com>, Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH] ext4: check dir entry fits before reading the hash
 trailer in ext4_search_dir()
Message-ID: <kokbbtjua37msovatv4ahnauqqof53ndzqooayk4l7qyamys6w@srqaissjlt3f>
References: <20260709184101.441348-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709184101.441348-1-xmei5@asu.edu>
X-Spam-Flag: NO
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
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,google.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,asu.edu:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 09-07-26 11:41:01, Xiang Mei wrote:
> For casefolded encrypted directories ext4 stores an 8-byte hash trailer
> after the name (EXT4_DIRENT_HASHES()), at an offset derived from
> de->name_len.  On the sb_no_casefold_compat_fallback() path ext4_match()
> reads that trailer, but ext4_search_dir()'s by-hand pre-check only tests
> de->name + de->name_len <= dlimit, which proves the name fits, not the
> rounded trailer.  A crafted entry whose name ends at the block boundary
> passes the check while EXT4_DIRENT_HASHES(de) lands past the block end,
> so ext4_match() reads out of bounds on an ordinary lookup.  KASAN reports
> it as a use-after-free when the page after the directory block holds a
> freed object:
> 
>   BUG: KASAN: use-after-free in ext4_match (fs/ext4/namei.c:1435)
>   Read of size 4 at addr ffff888010458000 by task exploit
>   Call Trace:
>    ext4_match (fs/ext4/namei.c:1435)
>    ext4_search_dir (fs/ext4/namei.c:1470)
>    __ext4_find_entry (fs/ext4/namei.c:1268 fs/ext4/namei.c:1632)
>    ext4_lookup (fs/ext4/namei.c:1703 fs/ext4/namei.c:1769)
>    ...
>    filename_lookup (fs/namei.c:2842)
>    vfs_statx (fs/stat.c:353)
>    __do_sys_newfstatat (fs/stat.c:538)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> 
> Require, for hash-in-dirent directories, that the whole entry including
> the rounded trailer fits before calling ext4_match().  This is the same
> bound ext4_check_dir_entry() already enforces via ext4_dir_rec_len(), so
> no well-formed entry is rejected.  The other caller, ext4_find_dest_de(),
> runs ext4_check_dir_entry() first and is unaffected.
> 
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/ext4/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cc49ae04a6f6..3b9740c1c16d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1467,6 +1467,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
>  		/* this code is executed quadratically often */
>  		/* do minimal checking `by hand' */
>  		if (de->name + de->name_len <= dlimit &&
> +		    (!ext4_hash_in_dirent(dir) ||
> +		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
>  		    ext4_match(dir, fname, de)) {
>  			/* found a match - just to be sure, do
>  			 * a full check */
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
