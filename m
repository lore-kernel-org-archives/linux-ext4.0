Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5BF3921E6;
	Thu, 26 Feb 2026 22:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772143640; cv=none; b=KzXQrDG/6ZDkUSBOcQ3FTI5/0QhGbROvKb8o/EBmqEkmsXYm2YPGrnslDqyShFuxMzGZn3jWUFvzZBMXa5sfUlsm0giDCGozcoPXq1Z+ZUMYtP1YTkvjVmv28T/2K+p6/cji4h53KzdRiw7wQZ25M2i08pZ4Y61o20kIE/dKUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772143640; c=relaxed/simple;
	bh=Bgb0YK8o2pkzPSpfkgVBWrdj2AMPxC0nf48KXkcpp6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5pWth4zvtLmYDFVuks0SKQyufYm63x6wEe7t4ByrS11buot/6+C8D4TBaj4IqwpbMyIgpjVfq3tlA+0Vj7VqWMjmJio+AwZPXxQnaypT6i8xHu1AMvdZ4YyD/0BCOnPRLHmstoQj9c9VhXaq9KfWITCG2jk/RYhRGcsQytVcqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K7DL8n1Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K7DL8n1Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kg9gzOuUKPXfQ8TifAkHBiU5GSG5v54A0/HGpdATajE=; b=K7DL8n1QS3fDGk8/1/ItX9kSyq
	wGDsP3RH3tejeQ90Haptd0/T0PuP9s1ekbp6LW1y31cbyrt9nWxqXpDH5yWK910W0H7qDmAOp4mir
	vPyykjX5r2Y9hYE4nuPKuxchdUtNCMGnFo7DpEMxzLsXdtuACqOyH7o+aoj6LwBSld9JPHEVZZaeS
	qBKvr5fqBFTTGOOveTkKaGnpZpaKhIND3S5tdw74N7oTSKyYDDBmUZ77/NuHPY3rtWDa/wNtmot3+
	r6z1pWxyxWHCTDAUm65LDMvRpEaU6e357eJg8d2uGILLtuClnyLAlOgGs7cbZuIkAkYRoS4MeaaqN
	lclBFExg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvjVq-00000007HdC-1p3G;
	Thu, 26 Feb 2026 22:07:14 +0000
Date: Thu, 26 Feb 2026 14:07:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v2 2/2] block: enable RWF_DONTCACHE for block devices
Message-ID: <aaDEEjVKBKrLxsht@infradead.org>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> --- a/fs/bfs/file.c
> +++ b/fs/bfs/file.c
> @@ -177,7 +177,7 @@ static int bfs_write_begin(const struct kiocb *iocb,
>  {
>  	int ret;
>  
> -	ret = block_write_begin(mapping, pos, len, foliop, bfs_get_block);
> +	ret = block_write_begin(iocb, mapping, pos, len, foliop, bfs_get_block);

Please don't change the prototoype for block_write_begin and thus
cause churn for all these legacy file systems.  Add a new
block_write_begin_iocb, and use that in the block code and to implement
block_write_begin.

And avoid the overly long line there to keep the code readable.

Note that you also need to cover the !CONFIG_BUFFER_HEAD case.

