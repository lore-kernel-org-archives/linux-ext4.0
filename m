Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AF036605E;
	Tue,  3 Feb 2026 05:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770096199; cv=none; b=AL8vkHEbWQSXMwAPi3qbWylnKRuLCPIyJp63eRCCt8FyjznzmDqjbwNPPF13V6hyLSrKdYmhRUOxKqCD84Slfe4im2jqI/fHGJMWvZXQD+PFAk3ZOoyxYBaPtnHnaanOAUNKpxprl6nOfFdAt0/+/wAX7scli+D/QVcQuoQqF7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770096199; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKsfkjomFk3GL7CXn3PZhChV0i43YEtR+K9P/aducQn3BV/NxRC+D1Jz/o7T9ARX+ylSZVUUlsQEnuCrvqPZc2puTSWvKnswzieJAtlzqyoYk6MEeuL5R91wIt5oZbQ/zxWp4deUA/JH7xpYYRed7X6klN/T4U4AnRrQAy2wHUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yCnhYUuA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yCnhYUuA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yCnhYUuAQi2hKuMxXMif1DpWZp
	jCVz9VTLWCyttzT5Owt/sfcqF9EBMjf8uSyIDb19taLjSMY1wOwpllu5PWE8QoTHG/8dD1rgveemf
	H5g4rgPM4FDwrQog8mckh8jsJehfLg97RPwVvw7IVzsXezyXwskrmdvwlzQwvOACLYANLEfjKecHt
	ZBmAFactMWiV50MCx2YKb11zsvTpTfYPu8B3JfZ8HoqmEiQFVIb/6Nk1fXM3a+yf4s+jmAhsnoFJ3
	DYm0UvojiSKr8iZYm2042HL1iw3OZyQjS4UIb584S1z6+JN4IY/Rp2hBkJ2zg/TqEpIq8oYjFtO7J
	j5RLzqww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn8sg-0000000667J-0rkQ;
	Tue, 03 Feb 2026 05:23:18 +0000
Date: Mon, 2 Feb 2026 21:23:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/749: don't write a ton of _mread output to
 seqres.full
Message-ID: <aYGGRljKbUf4XNc6@infradead.org>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
 <177005945334.2432878.12923613447146396794.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177005945334.2432878.12923613447146396794.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

