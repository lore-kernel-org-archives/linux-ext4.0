Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857672;
	b=MwMOGw1GNhvtoX87UO0Liz6Jk2UaBTuUCb15Vvmdead8wbziNvjp59KWSp78eYBrMpc1
	 l1UJgHFm2/CLLrGqV3pKZvZBzQEv0SfrxyVdXFKSkBLpnncF7JXzyDm+t7eu61hKsQ8uZ
	 5+EexH/OE6OF1gwVL8jJZGR4+rvm7r/b+covz1sZ7si3sR68rzkzykz8QnHOejPyewZ0s
	 33zYlKdAIJ8PNsrRF7YEtxeWtapeFeXtuamNCaItJV5OYbSCoO1eg9fwdT2kdDYkAzs2K
	 M2ziwQ/5UAB5J9Fj73i5IRFBYCzQG4d5cAhzwkv8jcm2+Czp6h3bdpWLjcnC+6b0ITA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857672;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 Organization:References:Date:Message-ID:MIME-Version:Content-Type:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=gwzVKNiYhur3OtQ1cT38HuukpoZ1WwbTtI7Mh5sVJEc=;
	b=JfcZTn56v1GJTsZAiMrF//F1Qi+BQB/3pYJqDiHj04TYIAcyh5wris+Dg/y/rsyNblw/
	 w1fRFOj6MtVUfr+g4p90o5lnQookNn6sesRpuh8heqUKQzzNDKwUwbLwQwZx5cD5fDuNF
	 4aF1B9XvjSHo8kYEHKZBT3h0bRtgb2/oSb+LRuFhe5OWd4HBmvVuXPxU01KXMVO1/wDfs
	 Jc39IcrCu8e6gwE8odoHHHxWoJsKOJUh6XtLuT5msX6JD+efj1wbqm5nYU8oe99+UqXxM
	 5NKYy8o3fcX1NMVcxXCwmDkvL7iwApt2MrmqV3k2idEdWvmjnNKj2ieMe/PzFcOB7rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=F3mVwYNp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dEZzuhAR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GkVLx9nR;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tST6izaI;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D7606A322;
	Mon, 16 Nov 2026 19:34:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 217D7606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=F3mVwYNp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dEZzuhAR;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GkVLx9nR;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tST6izaI
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB20B22339;
	Mon, 16 Nov 2026 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794857670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwzVKNiYhur3OtQ1cT38HuukpoZ1WwbTtI7Mh5sVJEc=;
	b=F3mVwYNpWzXXM9z/hCwP6mceWTbT49DYsBgr1120q2Z42dT1ys2XAy0sme9hPOSR1ruSol
	NU53czHN38W9Z/rjR3SoHBCh2jwyxoLWPnlj4oWOUGx9LkKVqE2AYAxVFFXpaa4ub6DT3K
	0htpKcJlTNEPHRAwQxtCG1H9/XrnEdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794857670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwzVKNiYhur3OtQ1cT38HuukpoZ1WwbTtI7Mh5sVJEc=;
	b=dEZzuhARGX6BkDLawIUuqoLUdLqR5ZjBEOvrL0hidcrLSFi5Rw0O6r/u6ir0BjXdHu33m0
	PKqGLfUCSQ8GGZAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GkVLx9nR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tST6izaI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794857669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwzVKNiYhur3OtQ1cT38HuukpoZ1WwbTtI7Mh5sVJEc=;
	b=GkVLx9nR3jH9P+Qg3wX9ibsnf6uVnOs+mBJOMOh1LM//eeJbls3jtBjJQqeFtHbOTwpH9n
	P511zUlSLEHPQP6DtHN44ah6Lj+A+nWrw97we4oaPNYZoMZA26Os/B6HY6veGNq1drEalG
	6J00G0W78iuKOfg2NCdW/6Rqef9w4Xk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794857669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwzVKNiYhur3OtQ1cT38HuukpoZ1WwbTtI7Mh5sVJEc=;
	b=tST6izaIko6mYSQGCLylgtqxO9WLIKz4YZQ0+EAFCoaFvgrR6AQoik/JNBbxpLgXoOglAW
	DE7ncGrFSJUwJQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CA4613408;
	Mon, 16 Nov 2026 19:34:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id neMiCsRa+2pFMQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Nov 2026 19:34:28 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Sarthak Kukreti <sarthakkukreti@google.com>, Theodore Ts'o
 <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>, Eric Biggers
 <ebiggers@google.com>, Dmitry Torokhov <dtor@google.com>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 Sarthak Kukreti <sarthakkukreti@google.com>
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
In-Reply-To: <20261113065332.929085-2-sarthakkukreti@google.com>
Organization: SUSE
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-2-sarthakkukreti@google.com>
Date: Mon, 16 Nov 2026 14:34:26 -0500
Message-ID: <878q2swoxp.fsf@cartola>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: EB20B22339

Sarthak Kukreti <sarthakkukreti@google.com> writes:

> Unicode normalization and casefolding (utf8_casefold()) strips code
> points with the Default_Ignorable_Code_Point property, such as U+202E
> (RIGHT-TO-LEFT OVERRIDE) or U+200B (ZERO WIDTH SPACE). As a result:
>
> 1. A filename consisting of "." or ".." followed by ignorable characters
>    (e.g. ".\xe2\x80\xae" or "..\xe2\x80\xae") bypasses VFS special-entry
>    handling during path walk, but casefolds to "." or "..".
> 2. A filename consisting solely of ignorable characters (e.g.
>    "\xe2\x80\xae") casefolds to the empty string "" (length 0), causing
>    any two distinct ignorable-only filenames to compare and hash as
>    equal.

Hi Sarthak,

Ugh. I agree this is a problem, but I'm also trying to understand first
the real impact beyond filesystem complaints during lookup, if any:

  1. Looking up ".\u202e" folds to "." and matches the on-disk "." entry
     (de->inode == dir->i_ino) in generic_ci_match(), triggering
     EXT4_ERROR_INODE ("linked to parent dir") in ext4_lookup().
  2. Looking up "..\u202e" folds to ".." and matches the on-disk ".."
     entry, returning -ELOOP via d_splice_alias() (or triggering
     EXT4_ERROR_INODE on the root directory).

These two look like a "do stupid things, get stupid prizes" with no
further repercussions beyond the error message.  Sure, we can fix them
to throw EINVAL, but are there bigger repercussions I'm missing?

  3. Filenames consisting solely of ignorable characters fold to "" (0
     bytes), causing distinct ignorable-only filenames to hash and compare
     equal and creating entries that e2fsck flags as corruption.

This seems concerning. Do we actually writes multiple files to the disk?
shouldn't they all be folded into the same empty string and rejected or
at least written as a single file?  I'm not sure how it'd be writing
multiple files to the disk, that seems like a bigger problem.

Either way, this issue is another example of why treating ignorable code
points as 0-length strings was a bad idea.  I'd very much rather
utf8_casefold would treat all ignorable code points as foldable to
themselves, (i.e. commit 5c26d2f1d3f5 ("unicode: Don't special case
ignorable code points")), but that was tried and broke applications
that relied on variant selectors code-points being ignored.

> Update generic_ci_d_hash(), generic_ci_d_compare(), generic_ci_match(),
> and generic_ci_validate_strict_name() to reject case-insensitive
> hashing, matching, and creation of filenames that casefold to "", ".",
> or "..", while preserving exact byte-equality matches (such as NFS
> export lookups of literal ".."). Using a 3-byte stack buffer with
> utf8_casefold() detects all three cases in O(1) space without heap
> allocations.
>
> Fixes: c843843e714c ("fs: Add standard casefolding support")

This bug was just made generic by c843843e714c, but the issue was
introduced by b886ee3e778e in ext4 and the equivalent f2fs support.

> Co-developed-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> ---
>  fs/libfs.c         | 50 ++++++++++++++++++++++++++++++++++++++++++----
>  include/linux/fs.h | 31 ++++++++++++++++------------
>  2 files changed, 64 insertions(+), 17 deletions(-)
>
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 27d7dc16fcb0..54296dfb8444 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1801,8 +1801,11 @@ int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
>  {
>  	const struct dentry *parent;
>  	const struct inode *dir;
> +	const struct unicode_map *um;
>  	union shortname_store strbuf;
> +	unsigned char buf[3];
>  	struct qstr qstr;
> +	int cf_len;
>  
>  	/*
>  	 * Attempt a case-sensitive match first. It is cheaper and
> @@ -1821,6 +1824,19 @@ int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
>  	if (!dir || !IS_CASEFOLDED(dir))
>  		return 1;
>  
> +	if (name_is_dot_dotdot(str, len) ||
> +	    name_is_dot_dotdot(name->name, name->len))
> +		return 1;

This is checking for strictly encoded '.' and '..'.  But I'm not sure
that happens? Do we really reach the dcache for '.' and '..' instead of
the name of the parent or cwd?

> +
> +	/*
> +	 * utf8_strncasecmp() only matches if both names casefold to the same
> +	 * byte sequence, so checking @name covers @qstr as well.
> +	 */
> +	um = dentry->d_sb->s_encoding;
> +	cf_len = utf8_casefold(um, name, buf, sizeof(buf));
> +	if (cf_len == 0 || (cf_len > 0 && name_is_dot_dotdot(buf, cf_len)))
> +		return 1;

I think this is a bit too late in the lookup to detect these
code-points.  I'd much rather we fail the lookup outright instead of
attempting to treat them as different spellings of . and .. . But isn't
this dead code because we are rejecting those strings in d_hash through
your hunk below?  Is there a way we get here without the -EINVAL in
d_hash first?

If we must do it here, I suppose we'd be better off by doing the full
utf8_casefold and then using utf8_strncasecmp_folded for the comparison,
to avoid two trips to casefold the string.

But the way I'd suggest be handled is by rejecting the ignorable code
points lookup (all, but variant selectors for the reasons above), early
in the lookup path for case-insensitive directories so they never even
get to the filesystem.  Wdyt?


>  	qstr.len = len;
>  	qstr.name = str;
>  	/*
> @@ -1839,7 +1855,7 @@ int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
>  		barrier();
>  	}
>  
> -	return utf8_strncasecmp(dentry->d_sb->s_encoding, name, &qstr);
> +	return utf8_strncasecmp(um, name, &qstr);
>  }
>  EXPORT_SYMBOL(generic_ci_d_compare);
>  
> @@ -1855,13 +1871,21 @@ int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str)
>  	const struct inode *dir = READ_ONCE(dentry->d_inode);
>  	struct super_block *sb = dentry->d_sb;
>  	const struct unicode_map *um = sb->s_encoding;
> +	unsigned char buf[3];
>  	int ret;
>  
>  	if (!dir || !IS_CASEFOLDED(dir))
>  		return 0;
>  
>  	ret = utf8_casefold_hash(um, dentry, str);
> -	if (ret < 0 && sb_has_strict_encoding(sb))
> +	if (ret < 0) {
> +		if (sb_has_strict_encoding(sb))
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	ret = utf8_casefold(um, str, buf, sizeof(buf));
> +	if (ret == 0 || (ret > 0 && name_is_dot_dotdot(buf, ret)))
>  		return -EINVAL;
>  	return 0;

Thanks,

-- 
Gabriel Krisman Bertazi
