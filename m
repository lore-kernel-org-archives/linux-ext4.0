Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E138228D;
	Fri, 27 Mar 2026 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592462; cv=none; b=NPALmAXxTzbP+Af3COkctMbHZvQ/kimnEdbhO04JQxduEBH/C/XSZC5B5EB7Lp/bvYJC3HtJgvNXIH1ml6x6+RW2Uhg3P7LskOiBE/pIPA+6x1Ba8ackcXPpNYVJe1BgIICIFQ0OhIyZLIyTB0u8NORL/DXkEZFG+11bTx/is7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592462; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsbQwPEC5k9hD87xwJFwf5m2WQlrcjYITaVLtZpYm54M49MYI/17kDJb7QMOuHqRBlnMVvIQqWZqTn1aAarlSoVqScPMQ3mk4vrIw9PjJ3323nV23iccpqBBngH5XB5SquxunmPghRKVTT1c2AhejepTJ+BQMsCR0BQ+n5OF7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2vOZpQFU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2vOZpQFU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2vOZpQFUuSoArLjW4+mjRcL+Po
	chyLRQuQQhiS4vg1Of0vLCRkf9KCHmt/31RjLTHnykdPbw39omN5VvPdoxKcGFYUi7W0s5mvxDbet
	RtKHfIGvwiVaslG4XnyGA7zLTvXFEWpXnWbBTRSzqMu85iQk5CkVlNMMn0lijpA5Iku/0ews52zFF
	oLCFUpKqZfNfRav5w1AYpCD2+jXXnt8wC5UWox6msg0JnsIfQavFpouPFiqGQZQi3CkfP5snFkFII
	DPAUvzcWlyFpOV2w2St8Jy7goJ4cetH38EXYLPmLuKs1PEkhYK2m3Eu8gvpGbi4IMt3IAzHhn+EbS
	MsqMhQQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Yz-00000006mZV-3eGt;
	Fri, 27 Mar 2026 06:20:57 +0000
Date: Thu, 26 Mar 2026 23:20:57 -0700
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
Subject: Re: [PATCH 08/42] fs: Remove inode lock from __generic_file_fsync()
Message-ID: <acYhyT_2B5n1dqDn@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-50-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-50-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

