Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A74AB1DF;
	Wed, 23 Sep 2026 11:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163530; cv=none; b=pIbEFtvDyge2unUZ2LECzqLcdhm6qUQkUr+6EhoRn6BY8IuLkxAGiGFshsU052dpLtmkiDC3qkyW6MT+giL4Ti6klsK7taGWSWkk1l8J7PoJxRoSOMPLXAbpD259esMEDKBsH4QfAb2v4yxwSMm9HHX0PrKC/M/jejtgy0HpXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163530; c=relaxed/simple;
	bh=AiF9ZUYkyepkQuTjLsnzVBdKXkgTqa4rcsJnORH7g2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwTu9IuxG0b8LiUDzs4wnZ1yLwxnwYjaM1v5hncwjwq9TEmSorVBpCKtF0ocf0fildMB9VUYYa/5aTJ5+HlnUIbJzeeclvecHUFlb25oCYbxJNukUZamleAO+RjwWcxLlEQmMcmm9uyu4qwSK0j5y+pGXExVbul5r53wnc3qDVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zN3yQbKc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uGBGCMuR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MM+07n9u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BwNxzhwQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zN3yQbKc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uGBGCMuR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MM+07n9u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BwNxzhwQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F85A1FFA7;
	Wed, 23 Sep 2026 11:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790163518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fD67Dyf8Sc8C+cA2ukUNWrPZXFrZsVNhO0qmwQZIlM=;
	b=zN3yQbKcaUZ9nkrqeayGTZCRLvNsEtaRD/ZlPUufAVcRTsdtE5r7Ydq8tM4BpNp5sTxEdY
	8BErQJKfyFx29cKUCAN5qSHLnPVq0/GMqtfxqmqtknZPpJjz24eTGEP7UQWn9LHG2uIWld
	cDQ5NQpMcDmuZel6cX6NqKzRX21m1rM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790163518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fD67Dyf8Sc8C+cA2ukUNWrPZXFrZsVNhO0qmwQZIlM=;
	b=uGBGCMuRntSWIRZUpp2Hrwb57U3NTJ1oCoAnS1DnZJGnb4IBP/lfenMal/dxX6sgZzIlCh
	tqA+ENRKe6R02sDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790163514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fD67Dyf8Sc8C+cA2ukUNWrPZXFrZsVNhO0qmwQZIlM=;
	b=MM+07n9ulLeleHvrcLmz2utwhWL7n9+gJHcPvxaCEaRdXfGZU2SwMlSYGEz4QlkrWLEPjN
	/WPTNwAHvokOsvZSBrqsBXIfcKpEPaIP3L+NjcQ9U2+Kk7k7kGGAp8J2oPOti3MG0EZ6TV
	Q6vTfL4tO6WeBVXSXBA3Npu/NkFvAfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790163514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fD67Dyf8Sc8C+cA2ukUNWrPZXFrZsVNhO0qmwQZIlM=;
	b=BwNxzhwQudYk37RX+Gu8zfvdIqmkmSBxcwDm+CvBmewCAbO0eVmU5kYozbQcrTAPaN6Lix
	9UX1Zsyo5pD5Y+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46B1B13432;
	Wed, 23 Sep 2026 11:38:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id To4sCTq6s2rIKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 23 Sep 2026 11:38:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C829DA13D4; Wed, 23 Sep 2026 13:38:33 +0200 (CEST)
Date: Wed, 23 Sep 2026 13:38:33 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ye Bin <yebin10@huawei.com>, 
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
Message-ID: <amwf3l6egqlrzf62syxvibicguuzvnbymsptqws6frybcd3q6x@jrmjtda7ps3x>
References: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,gmail.com,huawei.com,linux.alibaba.com,suse.cz,intel.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Tue 22-09-26 19:28:08, Ojaswin Mujoo wrote:
> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
> 
> >> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
> 
> Fix this by declaring it as static.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a82607..9669b2197fca 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -48,7 +48,7 @@
>  #define EXT_DATA_LBLK 10
>  #define EXT_DATA_LEN 3
>  
> -struct kunit_ctx {
> +static struct kunit_ctx {
>  	/*
>  	 * Ext4 inode which has only 1 unwrit extent
>  	 */
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
