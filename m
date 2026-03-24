Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48143386559;
	Tue, 24 Mar 2026 05:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330981; cv=none; b=SFlH8pXFoOFXEpezDV3Sem9LsUXqQ8fWPdG1A3gX1G5QuhE5eHffwb5oV5MEDlnSBQI77H9bC26B/eqJQdG6oMU4vaXFIUh4pNUCUYeCIAFzmNjpugJaoVF91rvqQzPBrYXUs0mMI914kraa+7PnnyaCmfRC4cZN0S5reIZFDB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330981; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jwm9621z91g5ejh66qzR8sDVgmYbQJeu03ozidcRtC9vgJQ93d/BIMfNPGojjarZFGqzfyAx6PrqnQqzOrEUZgR+QiNx1he5C31KhDCqgqzTo2EYvvvw+WVewqV8Bw6q3rBeD0O/OdyHECnLOrWARMybmOb5seEvEydVjBKKn/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x7DJ5eq0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x7DJ5eq0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=x7DJ5eq06rtHXQQCUOHoCiMTKc
	vkKf6iF3kBVSHFqScyLXBo9FpF+vl07SpeBNouFBWNHkzg/gCT9CTAzo9WAnaj/5cp9WSDy4twNwf
	SljwX+/60rQduXd583rwnKE45ctlZqI4gHmAVn2LKxWmnjLWjcDXXQpu847L6L3ja9goR2jrd/9B+
	UeiDoPM6VMPcAapskLW4fdutOoeDyu6y13ER6Xkjn8X7Ub7wR4/fGOOyVEcEgkxTu59Mq//ifpfSO
	uRAvsI7+nBdM63BJiEE4x9XMc6LSEqnE8H/uKOtg5NEgmlyOPEfxVFOW4ZExMYZZnCQfAOoxtcF0m
	um2cGn3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uXZ-00000000bZq-1QtE;
	Tue, 24 Mar 2026 05:42:57 +0000
Date: Mon, 23 Mar 2026 22:42:57 -0700
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
Subject: Re: [PATCH 22/41] hugetlbfs: Stop using i_private_data
Message-ID: <acIkYc8dtI1kTfY6@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-63-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-63-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
