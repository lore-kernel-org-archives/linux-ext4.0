Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D37037F746;
	Fri, 27 Mar 2026 06:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592493; cv=none; b=uemxAVCMn5EFWFqRmpNMUbHTbfOG6GVmR9fikYF7nyaqoGQPHxlYs8mm1+IsD0WNAC6SXuBa+EWkAPQWg4RRLl15FbZhyEEpalI3A0karEcGMbl2RTWjZZY8nMNh5LL8zs/mQxT4uC4JCB7MsGJgdp2jg1Flnps3/9PLcOwhSCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592493; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2uLrMaThakl5x9tPH/LznS9Mj0GMnzaxiIvzxL8UlTSu/hUy3ZNCLKBdZ92SjC2E+/725koIUop0xkhd8koVputNgYg8pzthh+Ej1aTcmUl8wrV36nFXB8k3FMPLBIDDvLrHWCGL9/bjMkZTxkF5GxaaI1eFcKSBeQAnYRAfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rZMZxQZV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZMZxQZV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rZMZxQZVt2Gy5NHLy87XGHPb2O
	t8UOhJLwShM3bxa+9/Y0ys6+zNjUdl6L2L45KVBQWdQNh0Q/qcylHCVQ5j0hgaUJgGzV82YSOGMAt
	4WeERQEYkPNjgAB56G3fOu3V3aIeZENSWgNNRIPa9uFjyjCZJTDt53zSycK3nCq7VjWmv0TxgZ4sB
	maWSmnRmAgymI4B7pvFhxQw98Z+04BH3DVt6xBJhgHkvo+a3DMoL8mVlDDSGrvy0Hdw2YeUJniC6T
	pzU8UoSJyzHYQDCfQM0r4PI71sGTlzaCbp+Y72JH+Jh7k2+XjXGRfbmHQzios9gqPx88CJNPd13po
	/rNwIiOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60ZU-00000006mxw-2THp;
	Fri, 27 Mar 2026 06:21:28 +0000
Date: Thu, 26 Mar 2026 23:21:28 -0700
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
Subject: Re: [PATCH 13/42] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acYh6LSOPzia4N03@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-55-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-55-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
