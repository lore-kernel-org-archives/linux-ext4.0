Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A128823BCE3;
	Tue, 24 Mar 2026 05:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330695; cv=none; b=abFHBGDnUUsXhlsBDAlFdtwXWyZnpOzAqywhrM3i/4QGV2xgNjJtrCrnaAgufz0WOHICMtSBVLWWAdvo4fo1APFM/yskh0fBC7FKnPjG4oI5g0zaqXHrvKOSrwEyCMfY6jC5IsK6t1tH4U+iBwnawXMc6E036OB0+2InbKwlTo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330695; c=relaxed/simple;
	bh=SvW94Q3F7Uj2MFDIrHLxUUC1KVfjuY3Zsi+gmKl/Z1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmKFHnO4+RbyIQqf38vv+XbMpDq3e/rEkPkNwoMkQ/XD4cSjsBhA8IEzkDJKmBXSiOMc0xhTkmFDiuDDHFu4Y+o5mt2ITwwpJehkWnQf/w5SQrUthUMqLby6/+cDac9vK7cQmVec6tZGR8rexQrjxLfdBdBQsymcGzQ52mkVU9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lz9EGP21; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lz9EGP21"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVQa6cRqLks0P01rcxaIrLnv8Mgq3ZwrRJH1SzRJAHQ=; b=Lz9EGP21r3Ckl7whnnUBaDo15q
	FO0M82HZT+fhnwVrNphEXkrWPHkrfbfmds2myTY+EFBGuJksvmWya7ISOOA3mFNCzfhHTSVL21gYd
	kIZF0EXvxeOGjeIZIQWp+pbZmeMmz3oEe60N+FYSaVm06E8iQIsEDBtP34DnBKcomlUkzvvaVsQwp
	/xenBeGw+jpHtqoB/KDeeI3k6LmSMIr4HImpYLxVxnPRZafonpuRyIoXZ+qDCxZRsRX/AaX6FyJD2
	4jzU+9M133RjoBO//tiVMxD1U671rLErGmyPMLyCNiLvEh0Rqm/ejAO+Qb6eelJLhHcwbcS14iWMq
	b91AyDXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uSv-00000000bK8-0TYN;
	Tue, 24 Mar 2026 05:38:09 +0000
Date: Mon, 23 Mar 2026 22:38:09 -0700
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
Subject: Re: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Message-ID: <acIjQVRICiVBndVr@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-49-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:03PM +0100, Jan Kara wrote:
> UDF uses metadata bh list attached to inode. Switch it to
> generic_buffers_fsync() instead of generic_file_fsync().

Can you explain this a bit more?  Right now the only difference between
generic_file_fsync and generic_buffers_fsync is that the former takes
i_rwsem and the other does not.  I'd expect the commit log to explain
why dropping the lock is safe and desirable.

Same for the other similar patches.

