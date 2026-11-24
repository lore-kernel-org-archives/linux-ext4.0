Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549746;
	b=Un+ef02oCCFdpEgiGUG9oKYSayFF+GqmKgZz0O4xCD9ukw8+tpK4hi/vYOiVhusO+uVk
	 fCWyLhAsVvnMR0X8HC59KI22lyybfDDTKLFNuqrJnsSbkKJ3lBNYBz+ctqtdaeNOJq2fs
	 1KduSZNBcp9LFh7C8zwxMkfy5RTuABTtjrizrev8VRz5EDekks/bzFwvnOOT8NdOYPBXR
	 oJ8/TnEmYMd4UiJ9eDAzh+i4BwPlLmhm2Aw14gj7LbAZTunrJFcuww1fmnd0Bd1I8QXGI
	 CMKOQNvsUdz/YmKRaw0O8P0Sjq2iN3hZdf2A5QYMaRjVV1lCceSaiCKRTUqCX4j4f0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549746;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 Organization:References:Date:Message-ID:MIME-Version:Content-Type:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Txnj8npZv8ues6Q9E3gBrI6hVjJw+5y4gtc7DZoJxPM=;
	b=f7ZQm67k7nN8uSu/6+hFTYg0+YLxyZbaNklPKNNrH6sWf49eJGf+rRPODGcBrxG+JPPW
	 pep2l/vgvkXCzs77frYtpWTqMloqgV/vgG0Pk7PTFuYiWjH1bX7i+77brJAqXVMhT9+RI
	 apKeu8cJsWMernCmYHuw337CB5UHqBvCSp2PFnR6yjaUfhMv9Zw7XVVb1Mf4sbFJ+1lyx
	 FKABQJaglTXNsZaNKC5DD2eUoSI6jshzKFIBX+1D7tsdH9Vla+mfyvybxXsxSF7MiNQxL
	 t6icf1ArNRhl/C/vkKNlnYfSbQ66jD4FCE/ozUGSy0CPHpg7XRNekdZ5SS0tVi7hbSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zYY69mhW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=S7x7P8K2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="gypI6d/V";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5PnAQBSm;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A8606A31E;
	Tue, 24 Nov 2026 19:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B32A8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zYY69mhW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=S7x7P8K2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gypI6d/V;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5PnAQBSm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB5D71F74B;
	Tue, 24 Nov 2026 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795549744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Txnj8npZv8ues6Q9E3gBrI6hVjJw+5y4gtc7DZoJxPM=;
	b=zYY69mhWGahHtc4rta8xtAR9I9Sms1hO1vd1yoRl9NcgG5w+DcMWzAkUd0kzoNszBW4MVL
	V/gS09B+oOCopBk2j+RqYwkaN77ALHpJUdfniVfq4Mv9k4KPNSFbz5ilwUTOoHhDNx5hOK
	JEmzuEnfTqO/Ww6My24evBrLkCkHCZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795549744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Txnj8npZv8ues6Q9E3gBrI6hVjJw+5y4gtc7DZoJxPM=;
	b=S7x7P8K2VQ3r1jrchadebt4oVo40oonPl15EmEEptM8mE8NGJNOlxgSM5y4NmJ8QD7PqYk
	CgigCZtB5B26NiCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795549742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Txnj8npZv8ues6Q9E3gBrI6hVjJw+5y4gtc7DZoJxPM=;
	b=gypI6d/VLiNgqpUDnAg2IdzGwqoG9GCLBUFb0SFT+/SyQpXuiX38yhAiWcrIn8JEhYSR9C
	aLvZCUDHIaIEkoi7L5J7xUuzjQHK9Hh0t131BCauRrUzTwgU1vvebEbgcYn5GR48Ags71z
	xpb0PKhKBX3tPhbcDhgV16XDXa9kdag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795549742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Txnj8npZv8ues6Q9E3gBrI6hVjJw+5y4gtc7DZoJxPM=;
	b=5PnAQBSmc70hsTm+07PWOG2TbOnH7SWN75B5bhpoC9uBO2ACT3jBWhezjW44cEd+aBudhi
	aoKDunw42VxtMTDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59C621339F;
	Tue, 24 Nov 2026 19:49:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sYTnNy3qBWsNdgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 24 Nov 2026 19:49:02 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Sarthak Kukreti via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Sarthak Kukreti <sarthakkukreti@google.com>,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Eric
 Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Dmitry Torokhov <dtor@google.com>
Subject: Re: [f2fs-dev] [PATCH v2 2/3] ext4: reject casefolded names that
 fold to ".", "..", or empty
In-Reply-To: <20261119214944.1480596-3-sarthakkukreti@google.com>
Organization: SUSE
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
 <20261119214944.1480596-3-sarthakkukreti@google.com>
Date: Tue, 24 Nov 2026 14:48:56 -0500
Message-ID: <87mrqyc8nr.fsf@cartola>
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
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

Sarthak Kukreti via Linux-f2fs-devel
<linux-f2fs-devel@lists.sourceforge.net> writes:

> Filenames consisting solely of ignorable Unicode characters fold to
> empty strings (causing the first such file to be created on disk and
> subsequent distinct ignorable-only names to collide with it), while
> names with leading dots and ignorable characters fold to "." or "..",
> colliding with on-disk "." and ".." entries and triggering
> EXT4_ERROR_INODE in ext4_lookup().
>
> Skip casefolding when the lookup name is literally "." or "..", reject
> any non-dot names that fold to "", ".", or ".." in
> ext4_fname_setup_ci_filename(), and fall back to opaque byte hashing in
> ext4fs_dirhash() when utf8_casefold() yields "", ".", or "..".
>
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Co-developed-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> ---
>  fs/ext4/hash-test.c | 14 ++++++++++++++
>  fs/ext4/hash.c      |  2 +-
>  fs/ext4/namei.c     |  9 +++++++--
>  3 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/hash-test.c b/fs/ext4/hash-test.c
> index 49b0d874c833..a8b206a6d751 100644
> --- a/fs/ext4/hash-test.c
> +++ b/fs/ext4/hash-test.c
> @@ -541,6 +541,20 @@ static void test_ext4fs_dirhash_casefold_fallback(struct kunit *test)
>  	KUNIT_ASSERT_EQ(test, ret_plain, 0);
>  	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
>  	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
> +
> +	ret_cf = ext4fs_dirhash(&ei->vfs_inode, ".\xe2\x80\xae", 4, &folded_dir);
> +	ret_plain = ext4fs_dirhash(plain_dir, ".\xe2\x80\xae", 4, &plain);
> +	KUNIT_ASSERT_EQ(test, ret_cf, 0);
> +	KUNIT_ASSERT_EQ(test, ret_plain, 0);
> +	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
> +	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
> +
> +	ret_cf = ext4fs_dirhash(&ei->vfs_inode, "\xe2\x80\xae", 3, &folded_dir);
> +	ret_plain = ext4fs_dirhash(plain_dir, "\xe2\x80\xae", 3, &plain);
> +	KUNIT_ASSERT_EQ(test, ret_cf, 0);
> +	KUNIT_ASSERT_EQ(test, ret_plain, 0);
> +	KUNIT_EXPECT_EQ(test, folded_dir.hash, plain.hash);
> +	KUNIT_EXPECT_EQ(test, folded_dir.minor_hash, plain.minor_hash);
>  }
>  #endif
>  
> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> index 978bd92da0ad..65019de4af93 100644
> --- a/fs/ext4/hash.c
> +++ b/fs/ext4/hash.c
> @@ -327,7 +327,7 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
>  			return -ENOMEM;
>  
>  		dlen = utf8_casefold(um, &qstr, buff, PATH_MAX);
> -		if (dlen < 0) {
> +		if (dlen <= 0 || name_is_dot_dotdot(buff, dlen)) {
>  			kfree(buff);
>  			goto opaque_seq;
>  		}
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 354fc2d22df1..cd2c9b873cc6 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1368,7 +1368,8 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
>  	int len;
>  
>  	if (!IS_CASEFOLDED(dir) ||
> -	    (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir))) {
> +	    (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir)) ||
> +	    name_is_dot_dotdot(iname->name, iname->len)) {

if name_is_dot_dotdot(iname->name, iname->len) is true, isn't that a
byte-exact match to dot or dotdot?  Do we actually get here for
byte-exact matches?

The rest of the patch looks good to me!

>  		cf_name->name = NULL;
>  		return 0;
>  	}
> @@ -1378,9 +1379,13 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
>  		return -ENOMEM;
>  
>  	len = utf8_casefold(dir->i_sb->s_encoding, iname, buf, EXT4_NAME_LEN);
> -	if (len <= 0) {
> +	if (len < 0) {
>  		kfree(buf);
>  		buf = NULL;
> +	} else if (len == 0 || name_is_dot_dotdot(buf, len)) {
> +		kfree(buf);
> +		cf_name->name = NULL;
> +		return -EINVAL;
>  	}
>  	cf_name->name = buf;
>  	cf_name->len = (unsigned) len;
> -- 
> 2.56.1.750.gf70dc682cf-goog
>
>
>
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

-- 
Gabriel Krisman Bertazi
