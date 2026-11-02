Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639359;
	b=bDMzXOqpapeZbd4HZRqsSPlEuOB0IBywtmZ1tPsEcU2VJbk4KybTgG21qWGlYD/1g51R
	 hmVAPZE1qLXVjILHzrnM9dk3WMw9EivUFNRdefGX0G84wL+jBgFlEzw5PJ7CQnfGjcLIS
	 feXFFhWcJ2Vyy8ebMGbadpS4Ssc/ecJm40Gsp52QcW7cMMlMRsAst4bnxTNQvF8FlgvpQ
	 RLCVkYwrxMNDSdtAVi8XhI7V9P9OKaJ6fUm4Ihn6vLJCSBwpty1bVYHy88bgPlD7StGUO
	 M400uiqwtaI/Y1Qo2fCOlp7xeSJAV8iYE7grpOrjhewSR+Q6PYMxSZm9M0Eu5F4YYZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639359;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=CG8PdGoXkS8gzBbqesSwymWTh5DOAjUj5BelwHkEN3Y=;
	b=uuRvFq8ssmU2cNY78ZJ0ZbgBuxDalXSeO3SocV4zQhyveS9qggZKUPD4j/Hg3180wMv4
	 vps1IhOphKBTMrr1aUNvP0piO9XG1RPMi5ITya0O5FUFktApWC85thcfHeq9G2SnbsEMi
	 b4/Vpgs4O261nh7biihWYaMM2LB7voMTi0AuBomFp/jQnX1TpmHSrECtQ9YGU56nMCqmL
	 fDpUH00XmBljdKcDX+amFxr1iXksZjbCiLWLG/OP08uPV7YPIqjuEqYIwbrcT0wMkDGK0
	 5RPIfKZPKEbwvT92fsHFvnnzqrvY7lW+YjqWq4ZjJfcswBqO0xcxtw24A4BhnS/uTsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=MSfYuodu;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDD5606AB84;
	Mon,  2 Nov 2026 17:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EDD5606AB84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=MSfYuodu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CG8PdGoXkS8gzBbqesSwymWTh5DOAjUj5BelwHkEN3Y=; b=MSfYuodukDpCMLaEEA6slLgCqy
	Kbd4GPSQdxvZnsv/lSAX4Z/Y5amPjgEzQaVNfYMWywopLOXDnF0sOc5LkFMgEXY7xa9JECDB3oMJ6
	cllkgc/gVtJzJUGE04Y2NMA+cnjn2SagfYAxEefkva/NQYwan3bBKZlTrO+CfBUTjXqJ7M4cz9Q25
	XEdAmNVcjFBJLAA3pmDwr5cKG07N9sxbx5WmcGAHJVKZ2RdiFS2pPa8QAKt8386MR4ldHEFmKz/5h
	K1rdThZyrJgOfn9ggh8MsLV5LiJWvijsVKSDV6ncBhCzkcV/XwKUwAE3G7aTC01lwMgvW0b3q7FC8
	7QmhmPQA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNvX1-00000004Aqj-3xDn;
	Mon, 02 Nov 2026 17:09:16 +0000
Date: Mon, 2 Nov 2026 17:09:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Naman Jain <namjain@linux.microsoft.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1] ext4: honor NULL returns from __filemap_get_folio()
Message-ID: <aujDuxgeH-TyEsXh@casper.infradead.org>
References: <20261102163341.2170232-1-namjain@linux.microsoft.com>
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
In-Reply-To: <20261102163341.2170232-1-namjain@linux.microsoft.com>

On Mon, Nov 02, 2026 at 04:33:41PM +0000, Naman Jain wrote:
> The bitmap and buddy folio conversions assume that
> __filemap_get_folio() returns error pointers. In Linux 6.1, however,
> it returns NULL both when a non-creating lookup misses and when folio
> creation fails.
> 
> A cache miss therefore passes the IS_ERR() check and reaches
> folio_test_uptodate(NULL) in ext4_mb_load_buddy_gfp(). Creating-lookup
> failures can also dereference NULL in its slow paths and in
> ext4_mb_get_buddy_page_lock().
> 
> Restore NULL checks at all six lookup sites and return -ENOMEM when a
> creating lookup fails. Preserve the folio locking and migration checks
> without changing the global filemap API.
> 
> Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
> Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
> Cc: stable@vger.kernel.org # 6.1.x
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>

Elliot beat you to it:

https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com/

Care to drop a R-b on his series?
