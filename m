Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143A73A5E85;
	Mon, 11 May 2026 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778485637; cv=none; b=kUVFGcLGzkDy2l0be5U0dAt5RAvT9poB7+4jTYB6CA5dfKXs52zJ770jjrB5ezOwE69oluxYnXDNH8D/m2vZ20pI/NQJRS45FeTP61ESCsQTSv/roVACHq5Nopg4gNwUkIM5PL+tP6NS137MJzMfJSNk9ORivn9aZHrCOwBgECI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778485637; c=relaxed/simple;
	bh=N6ss+xCOP7O0pY0VtA4mCakD33P3COe97atJnaQIhEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRIKePii9x3ej7iNMV+3zHx+QT4vlmNiGK1jxPbBFTtuZJn7sq0+hJf5j5pMYw/MfswhtNCmwrEL1e0V1bs3nufgCqg4gdxnJlbjAI4dmCUp4ITvsIHINX6ETN10P7GHK+kd8YlGON5vUSwq0SMdXVnle3IXNCos5vROXsVpFGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=draICOjW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="draICOjW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N6ss+xCOP7O0pY0VtA4mCakD33P3COe97atJnaQIhEE=; b=draICOjWgzkAZ6zgek0JMuGXHw
	8dGMtAH7BOtNkW2sRYpJO7DX7AZ4w/Q+j0XOsk4qKawl8UI5eElFKUQrX06ZCYxSYIUOfIGD7HLfj
	5gB+o3YL/1F7OUgmW37e8wPYaOkzC7lSXILtZfRWwbyl/P2wNbf2P9r0VYMo+ogRa3NQo1+B2fwWA
	6842WaA361ni6tJRnJIKoooRKTEX50RZoEG9WyMCQHhZ2V9HTmp87na8qHpNX6tbAsPun/LLd5HrD
	GaVIym5d9MkMVSXyyD+wYkgS1nLGLek7+K9F6bc1MfurdDXMXwvT5Bz+Dm4RCyCQZ4b7DT2KcGoNf
	li/MIUbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMLLu-0000000CeLe-2VVi;
	Mon, 11 May 2026 07:46:58 +0000
Date: Mon, 11 May 2026 00:46:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org,
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com,
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 11/23] iomap: correct the range of a partial dirty
 clear
Message-ID: <agGJcqFNl23qNLvx@infradead.org>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-12-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-12-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Plase send the iomap patches out separate, including to all the
relevant lists from the iomap MAINTAINERS entry.

