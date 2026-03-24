Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1322B36D9F1;
	Tue, 24 Mar 2026 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331072; cv=none; b=IqPVzVTMtoBsiUm6JW7cfVDt+yjrAq6zxSWajMFYHUZWg81nlJUWgMVWrADCiQVbgieB+TCnWc/qavfBrRgT3CkDdldAqgkzqvMPrvlH1cj7ZxY8SLmorebLDYuzR4DUGQ2GNA5Fpvgb2YkQxiA4+EcS8RnhUm5OSBkUbyC2G/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331072; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzB6GmyDU/J+H4G43HMgsFSKD5P0Wr5C1WTdQwq+pj4kzb7hN0b2MiQspm3Q7vMjgHGyI0uZNLeSlkhRQvttOycGA48pSzs8ma32TLQHCytME/uexw1pmd8zX03CqPu0RdKr7HZlpv81LkhJoYdC0rQIv0n3/UuoFtMU20etGuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RhFkMTZ6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RhFkMTZ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RhFkMTZ67F+sUOPh21pTSl/sGN
	vbAOmcVHo3QDjLZMm+8mwGdxGYs65tgfHx+kzkwVz3DQHpRt5zdDazU+dDGR0LZ4c5bUWkvigVG2G
	KfIbGwz4L58S6ivdox/SL+IoOIhOi+yM7Hu2OryhR3ydvdOWSYWQgAUByZZ+eMhP7QmOPzU0aEcT2
	PGidfeDi40O8AbS0yzmHcSmSP7b/K//vTmwxS62JcR/NM6toAW07hp3IqF652oo8qEkI/kTpApJaf
	T+rqOXvjOuLxOWmj78woNA1j81Xfp+SAjYImg+4fndeQSCBeCWQL6YUhQr5WRRdMR3diESbjsuOKU
	NA79Ff6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uZ4-00000000cGy-2feu;
	Tue, 24 Mar 2026 05:44:30 +0000
Date: Mon, 23 Mar 2026 22:44:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 26/41] fs: Drop osync_buffers_list()
Message-ID: <acIkvmMRxM09LEwf@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-67-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-67-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

