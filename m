Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E460A3A7597;
	Fri, 27 Mar 2026 06:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592615; cv=none; b=ExFpRjZBTGpF+c6rbWmFEtjiuql2gow3CQpAisUTq32EebplJKLNTme398vCLsRsxhlQFj+RczXkgvWycnNUH3qOEZywQZua2DC5zYgzNGcLIdDyWajbaDZJu1DMytTvU7L7HqFSdsjoHIEbTj07NFZcupUE8kfBhRlZQPLJhaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592615; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jmo9ou1HWOLbm1wxaFGrbX7zGlwYq85gaMefwHcHBLQ1WHH1appPhPHy4uV9ESccXQlqg6DiejSA1na1MS9G2jywPcXPsHdr08IZ4NU84nmR4nU18IurMPs3rboUBv7Hle+8RVA8/vA/Hom4+OEYzxQ58e2IQ8ZF52peY9ZWQI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P3sPArVw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P3sPArVw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P3sPArVwhQ8WCAYNEEG9YJ/BHS
	tukoQVz92DHL8dl26nQWozXziiF0y9T0hKiG+IaeR67Al2gNp8G72Ds+JZpr06YB/YfYzayz7AvF/
	iDNfMAnVWDVidH793xF8yWOYbrLo+9W32KV/6TILxtzqTBUWFnlSEVARs5MPS4IkduCDaHdUHM6yw
	uvNGH/nB2wfx+/5nDD90OO/Nc3ZBrzjDC23sZVcdHX6UpnR2yFrqpp8wOeLXn803mQGCbSTffl4jg
	2tjb26IySD6C+FDxjdZmDVCvh5kK/p1TZJn10nBpob3AWirZAiloUvqLgwBKlEo/TOJFAI22OP574
	HcMB/pRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60bS-00000006oN7-3iTK;
	Fri, 27 Mar 2026 06:23:30 +0000
Date: Thu, 26 Mar 2026 23:23:30 -0700
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
Subject: Re: [PATCH 33/42] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <acYiYqpnz6WRDAxF@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-75-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-75-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

