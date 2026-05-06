Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D669D30AD0C
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 09:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778060121; cv=none; b=jdcL7+ParI6TL8RmUb5w4Z0uejJqF1mz1YiPZBi1QIXQeTk9ASPQiq4CzYMHXydC7cOepqZmOwnfEvX7q9PL1WzR8IRXD55d0lyt/KHOr7jyi7myrzX/HV/Hxzge5tos/FB8RtQ7QUEZDudjuoF3McfgKY5e64GxN1WJpzbVzag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778060121; c=relaxed/simple;
	bh=85uy0TE6amGgzWnJ0dK6WKEm+tc8kMVjzywmV+z7Tg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RekyGW/u41QKuFzxnbZJn5LxvK8Q+WAWNrw26D6BebNX//sBb8aH68uqIK6YAGoG1wY4aZDlFB5djUjUZBkHauDdUrugXK/J/SkipYCIxWh2/02IoZ2cbibDxDICDvjNjnyHFEmNG+J+Wh/4vf+e5lJiCahJVKD7zZv2g/I8rLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hK6nSEF6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ALVxJFS1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hK6nSEF6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ALVxJFS1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hK6nSEF6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ALVxJFS1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hK6nSEF6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ALVxJFS1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F4436B259;
	Wed,  6 May 2026 09:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778060118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/3jNXVakWdXrmEzJZl0S7Fl91TMBaZIw/pAeShBSRfU=;
	b=hK6nSEF6V7SHpd7axWAWAUEtLZaAiu2pf36yQHh9TIzoQhEtXI12JdVvU6gC1bfxO11ewx
	aG0dQQw18sDhQdLCatmsmO3davEg1U/EwwCPTKcOyx6/o7dDksSCje7s8gZNd8zM8uHyvL
	HKOJEu0O3zx0Es9jv98KG73xFr3OazQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778060118;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/3jNXVakWdXrmEzJZl0S7Fl91TMBaZIw/pAeShBSRfU=;
	b=ALVxJFS1zyEeY2bbR9CsMyPbkCucpas4bT301+rnvmpDzjWuLPkI/6gVcW9okBubrCUS6O
	1h8oTzTAZXKszQDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778060118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/3jNXVakWdXrmEzJZl0S7Fl91TMBaZIw/pAeShBSRfU=;
	b=hK6nSEF6V7SHpd7axWAWAUEtLZaAiu2pf36yQHh9TIzoQhEtXI12JdVvU6gC1bfxO11ewx
	aG0dQQw18sDhQdLCatmsmO3davEg1U/EwwCPTKcOyx6/o7dDksSCje7s8gZNd8zM8uHyvL
	HKOJEu0O3zx0Es9jv98KG73xFr3OazQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778060118;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/3jNXVakWdXrmEzJZl0S7Fl91TMBaZIw/pAeShBSRfU=;
	b=ALVxJFS1zyEeY2bbR9CsMyPbkCucpas4bT301+rnvmpDzjWuLPkI/6gVcW9okBubrCUS6O
	1h8oTzTAZXKszQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03BB7593A3;
	Wed,  6 May 2026 09:35:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PLPXAFYL+2lpBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 06 May 2026 09:35:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 53BBBA0790; Wed, 06 May 2026 11:35:17 +0200 (CEST)
Date: Wed, 6 May 2026 11:35:17 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com
Subject: Re: [PATCH] ext4: enable mballoc kunit tests for blocksize >
 PAGE_SIZE
Message-ID: <xjduwrjb3nlvvfaproth226slnagxhimeln3duhkizbzlh2xpx@zuh56jw5xk3u>
References: <20260506075900.3649944-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506075900.3649944-1-libaokun@linux.alibaba.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,alibaba.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30

On Wed 06-05-26 15:59:00, Baokun Li wrote:
> With Large Block Size (LBS) support, ext4 can now use block sizes larger
> than PAGE_SIZE. The mballoc kunit tests previously skipped three test
> cases (test_mb_mark_used, test_mb_free_blocks, test_mb_mark_used_cost)
> under this configuration because the buddy cache inode's folio mapping
> order was never initialized in the test harness.
> 
> The real mount path configures s_min_folio_order and s_max_folio_order
> in ext4_fill_super(), which allows ext4_set_inode_mapping_order() to
> set up the correct folio order for the buddy cache inode. The kunit
> test bypasses ext4_fill_super(), so the mapping order stayed at zero
> and __filemap_get_folio() allocated order-0 folios too small for LBS.
> 
> Initialize s_min_folio_order and s_max_folio_order in mbt_init_sb_layout()
> to mirror ext4_fill_super() behavior, enabling properly sized folio
> allocations and removing the three blocksize > PAGE_SIZE skips.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks sensible. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc-test.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index 90ed505fa4b1..04bc9f773d63 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -206,6 +206,8 @@ static void mbt_init_sb_layout(struct super_block *sb,
>  	sbi->s_desc_per_block_bits =
>  		sb->s_blocksize_bits - (fls(layout->desc_size) - 1);
>  	sbi->s_desc_per_block = 1 << sbi->s_desc_per_block_bits;
> +	sbi->s_min_folio_order = get_order(sb->s_blocksize);
> +	sbi->s_max_folio_order = sbi->s_min_folio_order;
>  
>  	es->s_first_data_block = cpu_to_le32(0);
>  	es->s_blocks_count_lo = cpu_to_le32(layout->blocks_per_group *
> @@ -791,10 +793,6 @@ static void test_mb_mark_used(struct kunit *test)
>  	struct test_range ranges[TEST_RANGE_COUNT];
>  	int i;
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
>  	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
> @@ -858,10 +856,6 @@ static void test_mb_free_blocks(struct kunit *test)
>  	int i;
>  	struct test_range ranges[TEST_RANGE_COUNT];
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
>  	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
> @@ -905,10 +899,6 @@ static void test_mb_mark_used_cost(struct kunit *test)
>  	int i, j;
>  	unsigned long start, end, all = 0;
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
>  	KUNIT_ASSERT_EQ(test, ret, 0);
>  
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
