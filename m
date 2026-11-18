Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003507;
	b=h9iqb2uNO4Qf1BIyZPzOJT4syQxuqVPi0ssDzNcuER2LlPPQnlaPuoBwojOe8J4s0hRV
	 jnZhcRcGjjZucquxwtJQ5LNqRm3JugPduTGXoSxyc2piYnmRe5aiLJZUTH2UVQKtEgI0k
	 ZjhpZcETn0kEEeknhWbp4V4x7z18y/RhvOVtgbh/Eb9byN94Lr0JNo6YaCUy2RdBcEYIg
	 YST7XftU2E9UV+iVl4MVqBuz2xIZ3UzMasROXa80qfGM/GjXLdh/W69tuGEIwJhYRoTZQ
	 nlhxcPF72i516lvewJZXZxZ5KjhfJQDVt/NDHcqlxMVcZMdW7AkcgT7p8n4V1wDKdvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003507;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=bFIUq3+e1/w1vGrkXQTPm9Z9hnS231jDKYMfaEh99Jw=;
	b=QNhAD7Wq+Uu1jhe6S7zHbQ8l1dZn2b9sv3x0QLr0rqK6bDTf/194oEbGreRYmlJUX9XY
	 KdoH8nd+sLzJG/bDJI/XtrE9SOKNjXTXFrQExe5yXW20DWHm55Y4Ew1aaSwGb6IfQ29Ug
	 W58YB6GViy3U0Y4vmOqWeuJF4Rjy2+MxZSfO0yyzdIt/3E974eyqFnBlJfb9VLOaHIs7H
	 r0lXxNzFoKuX3irBiXTq2a4oaKqYS7s8P3Ae9pidbG+1skj8c0ciNW2mXAkkhV2ghebx8
	 gc1RcV+doIIBh6kJ1v6fTXkKBCKDn66J2D2ALcrf6/cdlfh9fTimKru3t/jg9dKh9QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mAvFNLHE;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AhTV5laT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mAvFNLHE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AhTV5laT;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFF7606A31C;
	Wed, 18 Nov 2026 12:05:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BFF7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mAvFNLHE;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AhTV5laT;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mAvFNLHE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AhTV5laT
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FF712224B;
	Wed, 18 Nov 2026 12:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFIUq3+e1/w1vGrkXQTPm9Z9hnS231jDKYMfaEh99Jw=;
	b=mAvFNLHETlFOlGZZ8+/8AyO2v0ETZG+/AvDq7rr35GdKo5o3hnxhcmKTLW066vhbVJGerd
	XBMrrWTkXKMsxbHgkLeHzUjUsoDcmzzh9gszKShJeS05POpE3gPhFc1D6gSqBqnN654vWI
	1YzxXOA8Z3bjrDHZJ/kN5huChuLzYOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003505;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFIUq3+e1/w1vGrkXQTPm9Z9hnS231jDKYMfaEh99Jw=;
	b=AhTV5laTAvmzMLHv5pfi1zW3ZjVANE0RsQg9ctRteGrhfcsgrePaVYTxGkUchXdtb9eHkf
	Sb4oxdB2VXCwCDCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFIUq3+e1/w1vGrkXQTPm9Z9hnS231jDKYMfaEh99Jw=;
	b=mAvFNLHETlFOlGZZ8+/8AyO2v0ETZG+/AvDq7rr35GdKo5o3hnxhcmKTLW066vhbVJGerd
	XBMrrWTkXKMsxbHgkLeHzUjUsoDcmzzh9gszKShJeS05POpE3gPhFc1D6gSqBqnN654vWI
	1YzxXOA8Z3bjrDHZJ/kN5huChuLzYOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003505;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFIUq3+e1/w1vGrkXQTPm9Z9hnS231jDKYMfaEh99Jw=;
	b=AhTV5laTAvmzMLHv5pfi1zW3ZjVANE0RsQg9ctRteGrhfcsgrePaVYTxGkUchXdtb9eHkf
	Sb4oxdB2VXCwCDCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36BDF134E9;
	Wed, 18 Nov 2026 12:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iVbOAnGU/WovJgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 12:05:05 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C45382502C; Wed, 18 Nov 2026 13:05:00 +0100 (CET)
Date: Wed, 18 Nov 2026 13:05:00 +0100
From: Jan Kara <jack@suse.cz>
To: William Chuang <founder@logarcheon.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 2/2] ext4: reserve an orphan credit for inline data writes
Message-ID: <ko53oxbh4jdnp5rqxhavjen2phwv2bliqeqfuvip5c6n7lfwjc@qnknqdhu7jor>
References: <20261117052750.2955-1-founder@logarcheon.com>
 <20261117052750.2955-3-founder@logarcheon.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117052750.2955-3-founder@logarcheon.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,vger.kernel.org,syzkaller.appspotmail.com,googlegroups.com];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[e8180f5590685cbc9037];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Score: -11.30

On Tue 17-11-26 05:28:11, William Chuang wrote:
> ext4_generic_write_inline_data() starts its handle with one credit.
> ext4_prepare_inline_data() uses it when it creates or grows the inline
> data xattr and dirties the inode table block.
> 
> If the copy from user space then comes up short, write_end calls
> ext4_write_inline_data_end(), which sees pos + len > i_size and calls
> ext4_orphan_add() under the same handle.  That dirties a second block,
> the orphan file block or the superblock, and the handle has no credit
> left for it:
> 
>   WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata
>   Call Trace:
>    __ext4_handle_dirty_metadata
>    ext4_orphan_file_add
>    ext4_orphan_add
>    ext4_write_inline_data_end
>    generic_perform_write
>    ext4_buffered_write_iter
>    ext4_file_write_iter
> 
> jbd2 returns -ENOSPC, the journal is aborted and write() fails with
> ENOSPC.  An unprivileged user who can write to a file on such a
> filesystem can trigger this.  The inode table block must not already
> be dirty in the running transaction, which is the case with lazytime,
> or when the write is the first change to that block since the last
> commit.  The block write path already reserves an extra credit for
> this case in ext4_write_begin().
> 
> Start the inline handle with two credits.
> 
> Tested on UML with filesystems made by "mke2fs -O inline_data", with
> and without orphan_file, mounted with lazytime: a write to a new file
> whose user buffer runs into an unmapped page after 10 of 21 bytes.
> Without this patch the WARN fires ("credits 2/0") and write() fails
> with ENOSPC, also when run as uid 65534; with it there is no warning,
> write() returns 10, and e2fsck -fn is clean.
> 
> Fixes: f19d5870cbf7 ("ext4: add normal write support for inline data")
> Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8180f5590685cbc9037
> Signed-off-by: William Chuang <founder@logarcheon.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66..a1ae23888 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -709,7 +709,12 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  		return ret;
>  
>  retry_journal:
> -	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> +	/*
> +	 * One credit for the inode table block, plus one for the orphan
> +	 * file block or superblock that ext4_write_inline_data_end() may
> +	 * dirty via ext4_orphan_add() after a short copy.
> +	 */
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  		goto out_release_bh;
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
