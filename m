Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB9F31280D
	for <linux-ext4@vger.kernel.org>; Mon,  2 Mar 2026 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772476047; cv=none; b=HFGJbb4Dejveu0DmX+pLybAoXN/8ooqwc2c3YIHSrRX9bnKhN+HhJKGvhYAAQndAadw/IJzPVTlbbm2C5lUAEUflVzxZijtYJZGJhc48k8dmgdfvMP+b48F4IpQz8twTl0nF16U6s/u2DCZ1Nbr6LgVQXCBsr2ess8leuyEKTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772476047; c=relaxed/simple;
	bh=NBG53fJQtIEasj8rfe/5jylaKHRmSRoybtT1+mSx588=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT53QQf2e1neGYIMCftpZhVAad8IGIbtfle8FAHzuHLoL4tZ2Jm8SXs3RcsFgrAeKZiVdEQTAeumZsPYQQ/tkPiKZMh1l2/lIY0WvvlD5o8L8lbOa0d1VXEz0Gga08YW1n4vgOC1aw39Y3RecR2GKDJD+B0kE8X72YLylELeVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mm+n9zBk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kXZS+Mh3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mm+n9zBk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kXZS+Mh3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mm+n9zBk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kXZS+Mh3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mm+n9zBk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kXZS+Mh3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4BA43F824;
	Mon,  2 Mar 2026 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772476037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07I1tRE3iZWpjnfI1hc8HBBBxYQJiHuNoozkp+j7tEU=;
	b=Mm+n9zBkB5ebOuyC2CzBzY7LOQCA7dysSalitI8VXetkNhia2hMu3tCq1JA5Ufz4VLRjpz
	w0VTH3aME8yTKkGtaJABAKpYbqSxY2xVwFhDybbJ6y0YjiQi6Z1MbG8+TfbBcPa/uTaj5T
	gK5D5Z7TNlXuCVMv/WwaA5O2HNHCm20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772476037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07I1tRE3iZWpjnfI1hc8HBBBxYQJiHuNoozkp+j7tEU=;
	b=kXZS+Mh3mgBdjfgM5DkkZc1E2+b3YferEPbclOciRO+FQj7xMA+WDilDGHwVF+OQBAtJFs
	/XLLUzzcmDImSSDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772476037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07I1tRE3iZWpjnfI1hc8HBBBxYQJiHuNoozkp+j7tEU=;
	b=Mm+n9zBkB5ebOuyC2CzBzY7LOQCA7dysSalitI8VXetkNhia2hMu3tCq1JA5Ufz4VLRjpz
	w0VTH3aME8yTKkGtaJABAKpYbqSxY2xVwFhDybbJ6y0YjiQi6Z1MbG8+TfbBcPa/uTaj5T
	gK5D5Z7TNlXuCVMv/WwaA5O2HNHCm20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772476037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07I1tRE3iZWpjnfI1hc8HBBBxYQJiHuNoozkp+j7tEU=;
	b=kXZS+Mh3mgBdjfgM5DkkZc1E2+b3YferEPbclOciRO+FQj7xMA+WDilDGHwVF+OQBAtJFs
	/XLLUzzcmDImSSDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AABF3EA69;
	Mon,  2 Mar 2026 18:27:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EDC5JYXWpWkAMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Mar 2026 18:27:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54B2CA0A4E; Mon,  2 Mar 2026 19:27:13 +0100 (CET)
Date: Mon, 2 Mar 2026 19:27:13 +0100
From: Jan Kara <jack@suse.cz>
To: Li Chen <me@linux.beauty>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	Mark Fasheh <mark@fasheh.com>, linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] jbd2: store jinode dirty range in PAGE_SIZE units
Message-ID: <6oexp6kpanvquzjn3nnqqg6wyyhh6og7jjb7fitlj7vzlj5vzp@cobcxovcgzg5>
References: <20260224092434.202122-1-me@linux.beauty>
 <20260224092434.202122-5-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224092434.202122-5-me@linux.beauty>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Tue 24-02-26 17:24:33, Li Chen wrote:
> jbd2_inode fields are updated under journal->j_list_lock, but some paths
> read them without holding the lock (e.g. fast commit helpers and ordered
> truncate helpers).
> 
> READ_ONCE() alone is not sufficient for the dirty range fields when they
> are stored as loff_t because 32-bit platforms can observe torn loads.
> Store the dirty range in PAGE_SIZE units as pgoff_t instead.
> 
> Use READ_ONCE() on the read side and WRITE_ONCE() on the write side for the
> dirty range and i_flags to match the existing lockless access pattern.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Li Chen <me@linux.beauty>
...
> @@ -2654,15 +2655,20 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
>  	jbd2_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
>  			transaction->t_tid);
>  
> +	start_page = (pgoff_t)(start_byte >> PAGE_SHIFT);
> +	end_page = (pgoff_t)(end_byte >> PAGE_SHIFT);

MAX_LFS_SIZE on 32-bit is ULONG_MAX << PAGE_SHIFT and that's maximum file
size. So we could do here end_page = DIV_ROUND_UP(end_byte, PAGE_SIZE) and
just use end_page as exclusive end of a range to flush and get rid of
special JBD2_INODE_DIRTY_RANGE_NONE value.

The problem with the scheme you use is that files of MAX_LFS_SIZE would be
treated as having empty flush range...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
