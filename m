Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9513815C0;
	Fri, 27 Mar 2026 06:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592443; cv=none; b=LCzdQYF0tiiIgkMabrchEzTqXOQJNTc3PuS97iz8mO5s+rqnany/i0el6s04sIuJSpVAenksAZ4x8FqTGbZbof5a77zlAhmo4derHbhsGEVjhhFHF/apOuYU2LS2rKdnyBhBQPUjk1ktQLa7ly4MiRnCEOWCPDK9IuLMGoNWvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592443; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcCSPdHdPcB0yXcCo/KL8OU9DW7/54tdGSoG6fuYzQEGMTr7B6608ALzjVVvSHH5kJGrcF84YS8WWLJevgotIivBV2FQ0dbeOAKcys105967KKD+dkzNx1KEudglL3lrWbgbvVr5MgSbJGtyk7RjFZvA8U2pbKowCKC8Zjwnc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yux5iMgi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yux5iMgi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yux5iMgiQ83LVlWc4CbBpbSR9d
	YBSjhEy4Yj/kgNXa0UbPLwMS/JBVvWNutfQUYukXysijvFulmbijYzqduHwPl9BwMyHe0AmrOSKhn
	eh6kLdph7lzkskZa029TWqLMG6vIaptp3iBcYN1/MIZ25hkCaEPhsucQN9TKF4zpkLDp2giHBidz0
	9GiVoG2qqFPwyYkO6apa2+DZCU5QyyVao8eXHO0de0I2JAXXQ6wJbxoc9niBAyzAk8m7DM0+E0faF
	3AisFD0e0tujjAPOOJcqVe1Qkz5olge1HjOt/rZeQFnazeJt9InWIuSNfH5bYj0lDtUtUSxe/14R9
	VCgOG7ZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Ye-00000006mFp-1cC0;
	Fri, 27 Mar 2026 06:20:36 +0000
Date: Thu, 26 Mar 2026 23:20:36 -0700
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
Subject: Re: [PATCH 05/42] bdev: Drop pointless invalidate_inode_buffers()
 call
Message-ID: <acYhtFaMQxhTsOBW@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-47-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-47-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

