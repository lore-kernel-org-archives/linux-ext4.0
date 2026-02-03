Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458F366824;
	Tue,  3 Feb 2026 05:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770096181; cv=none; b=GdnMtv7yKqnkugDO9thPBd/xwg+sPzqsSdtc5+VAHtP1R4QLdRaoFwKYHp98NGoRnO/7UnxN/xkhotaqCeu/5JBM/wRfSu0/rRLS+xUCjDbWB6RwQbYNxaXXXRFop/D8dCVaU8jKrQrhcOyJcbtBh9lup/82dnEDLgjVpeswCYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770096181; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xwz8x09v/UC65lDcs3FyZUe+uzfq89mcGrQypEPm8fLHELrTQqbFfw2kF2PrYuPRjKCbN/2SIQHRKPO3Hr9TOq58nV2gMwI1302cpdRaLxLhEJooAP63Ie2SlEb6A6crkenJNg6SafH1BYqkUN4IZfGInW/mnueAYpnZAltCrPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DRHF29hj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRHF29hj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DRHF29hjfZBMidrTKjiHii1Su2
	3lXY/XzOZPCWpbVInaalQzmhuRh38B+/3/V0Hnga3+gfylZ0kGCmA6cNx5Xmmsd2vdSouApLRfp9I
	as555OmlVAcdG2fRdF3VKNoNUQ0sXJlocsfiu2tLZPYizvUBgsEDD/f+Kq2laz4Dh5jRAyqaDbo94
	EaQwVpKcdeGxGrdSF2+KoKIPFRc5oVHiZXlAi+vfT/DNbTzaFgCVPWBBKJ0Octwn2dyHvMvkrmYq9
	kdSOGpFDdwTrPliQ3qe/nw6eLWYFsQrfc4DlSi7ihumeXKamBoBcP8ROp21FAfZ9biBNzEwTp8k4M
	CDGmzA6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn8sN-0000000665J-2ZM8;
	Tue, 03 Feb 2026 05:22:59 +0000
Date: Mon, 2 Feb 2026 21:22:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/620: force xattr leaf format for this test
Message-ID: <aYGGM6sRrdNi_j1F@infradead.org>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
 <177005945316.2432878.12756542407523044780.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177005945316.2432878.12756542407523044780.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

