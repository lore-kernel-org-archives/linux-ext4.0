Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A733A033;
	Tue, 24 Mar 2026 05:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330960; cv=none; b=p8JsZqqFK57kSsqI9cy+OwSM6eyBJ91DGZNb2sQQGYlpB6EWvfjHFgOztdMIQFmIGwFPnwuX9Mt6U6F1O7m097BSjc0NAe210qPeeDektHoap/KWfC+Zfv+8QT3194xEo9Qgv/xWAtLKCQCREohbAbhNfF+gGcHFeiQHQgv0zAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330960; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB4FOQfUZz40CCHFaH+0aOzLJ9Y3za/p0z5j0mNaIB7pjuhP616lRy1hQztxd0uhtE18nD1FN3r535sELiI7aiScbRtWaR8g4cA8ThaT2WLwXQBT3cbX7karaOuh8+N8DcUhhlcxLraU9PsUZkpn2SE421r4ovyXfEusHjjn0QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qQFeTJlz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQFeTJlz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qQFeTJlzyB8XD7CSyqWG4h7xpr
	fmMdmzbYgLOYphwXbV5fnnD7hUQYC2T6mP7De2t2Uc/hJxQPx3MecvEDn2YeYTkTUvPTFSeWVXqUE
	c26AfIUqiG8ugrvMUY/37vARh3kX/lMyW2BN5Pq9XqxPfdWElEwJCtEH58fplToi55p7eEfUnKVyr
	XhMY6ve4XOGBI1b0TgRPkHp20WvTZdR2IEENVsfUc8zm0P/x4E6WMvLsCeIaLiKXP+PBHQsseVkwf
	TYVtpSpTk5rCtgOpn3Spo1T4E8WYsiQ06wM0PTjurlQlKs5KzICqXUDIVHWSLZVLCyWU46FIS+AyU
	8EZU4hqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uXF-00000000bT1-3h7L;
	Tue, 24 Mar 2026 05:42:37 +0000
Date: Mon, 23 Mar 2026 22:42:37 -0700
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
Subject: Re: [PATCH 21/41] fs: Stop using i_private_data for metadata bh
 tracking
Message-ID: <acIkTafveTGFM3nm@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-62-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-62-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

