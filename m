Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27D24766A8;
	Thu,  8 Oct 2026 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452300; cv=none; b=JrjP420bKrLre9pDSYNbkSLqt0j8IExxOTWu/c68eiuECdXC+GW6XoGGqzuI9Sib1NlDb83K/w+Z7yJ3Sy1JdSl/QTUtFesCsdEzFyAIBU7dFp35s0uFGXOCP/3KoBFRzxmVi8yxpLItUek7age1iUBvDksbIRTZKRplxfLluHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452300; c=relaxed/simple;
	bh=fRudjOI8Htjz/enhPGJfFip6/QXy/lz6y/WtoJei/aA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5Ih/Sj8eqG79UOKSjTQsjdy8sB9aXGLNkD2NldKDnQjlnVZeVGRI9xupw29iL/jyWDLSW+SBlEuqKCVz0dLzDPVa0NCMxSogLOLmohZDKvtbEtasiPq+qZlV1ei1Q1u2pjS5JBFuqKgZ3QKJdjEgoNzrDMNwByKQJKyMsdkzvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iaAu6mGA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iaAu6mGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Egd1kXe6JmtGoV9wn+IgV9WNtGyO0BthKBmXan79PuM=; b=iaAu6mGA8Ityj2EUlTgAj2fKT6
	PlVJ9NKmMvpAgQQr8alCMWAxWbPyoWbo3HYSkF8kVUeh8EaffkyBBU2+odcFdJOBdIQ1ICbbFSaQr
	76ihaGJ/LOBBIo/wVOa4A48UqCRbcX70i6HtidlHt395fE1wfBZPaFKX1ifJo5KD6vj2I+kMJ3SPk
	qNOc6TjYu4yL1AYRVT1JvmRxv6vZ3scaI/ALecqGUjFurRG+hYyuHsNmoATsJBNFJS2e54rCT48z1
	UH8AYqf6bvonfR4gPgcfHYicPAJW5fgCBwQRKtok1wL5jZH3NTraJgL0brh6/72IfKDtfNTzCa3eB
	Y490CAig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEkZr-0000000413z-3G9A;
	Thu, 08 Oct 2026 09:38:15 +0000
Date: Thu, 8 Oct 2026 02:38:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: daejun7.park@samsung.com
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: test reads after a failed zeroout of an unwritten
 extent
Message-ID: <asdkh5WVi02SHuE2@infradead.org>
References: <20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 08, 2026 at 04:39:33PM +0900, Daejun Park via B4 Relay wrote:
> 
> Make the zeroout fail with dm-error and check that those blocks still
> read back as zeroes. The test mounts with dioread_lock and nodelalloc:
> with the default dioread_nolock, the extent stays unwritten until the
> I/O completes and is converted then, without this zeroout. generic/250
> and generic/252 do not hit it either, as they write with direct I/O
> while dm-error is loaded, which also leaves the extent unwritten.

Nothing in this looks ext4-specific, any reason why this is not a
generic test?

