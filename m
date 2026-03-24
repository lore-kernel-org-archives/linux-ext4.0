Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350853A3831;
	Tue, 24 Mar 2026 05:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331329; cv=none; b=ZWNVc9oBSEKfe6R4Ijcv9rzKx4I1dgCmyEqd4Bcw8SrZZu4wYNxz3Tt7JmEEDjsd22KUCHr3rQH0gmys1URvlf8QUwCFwx5Rx/axkfoPHgS6CI6o77XTS08MZ+gEvc/Q3DGT3OawdFx985SxLcasdpHgmsHtJ26Aq3FrdRGWfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331329; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQ14gio7iSX804iO+YNXTYP1c41fW4WN7yq6bWycwYjqiEVXfbRslcaNLE2DQo3JLwWEyqFSHnDQYRb6cZg8NwjRbUI1S5RHCrNxLzVsSebeUpnoKtdgnTfwvsK4yQqfdlcAcEiqBn2xArzPmTFqOs/jfCbPq2uD2eCk1xeLiYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgGstViS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgGstViS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LgGstViSzEAutneHviSV2EOKmH
	OIdT1z5rAGAjNp+2aMbFDun0oi/J2vEi5XeEZ+Z+3z5l1LsCacOcwtzKUhWl9k7WB2OZrKdbVAs9G
	4T+h3w+YmWBO2jusglJEvobEuBsKeTszsiqrq6pNLitj42DkQGjCjnw4uOZypujRrliSIiJ0fAgTi
	F743/2vWUBvYEkvDL717WL6Uj4a1yVqVjituRIz0JPqKaeE8P7VEqpnnZTYEvTsmLrLWHYXUdHOCd
	JlihRTyc6SMxXV5thw5arbSAqCVrY4MRo6eg277PdhMpHVvqIt4vjwrRi1kdNBqAfA4Fvnytw6t6+
	GMxwwtvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4udD-00000000cRx-1X61;
	Tue, 24 Mar 2026 05:48:47 +0000
Date: Mon, 23 Mar 2026 22:48:47 -0700
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
Subject: Re: [PATCH 30/41] fs: Switch inode_has_buffers() to take
 mapping_metadata_bhs
Message-ID: <acIlvx7GcZO8LdM5@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-71-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-71-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

