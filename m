Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F138BF6F;
	Fri, 27 Mar 2026 06:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592571; cv=none; b=iZK4thIEXXxWvf/dICJsAp9bUcSF1vZuZMidXqQcvhxTUlYO9i2IDEzn2E8A1t9BLSOazEiGNlNY9nDC/2tmcyeoRpFG//bDGb9g2bZEsZQgxW4Egi5eELvFfBUl32MgTJp2tDmTcbexeVz9DJ8MilkqGCWkqEUXazJ9iy+QyyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592571; c=relaxed/simple;
	bh=7tOS59SYBV2Xl4rD7sZmCPHjc9f7vtoL0THKAa/pszU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzxEb2ZNk6HX4PHVtvpGh82ZMm0L34RFm0KKyDJqlYpcGJ2QkgU38L0SpNvpUbHiwGxxeL8SYE9mGPhEvAsVgaph3PqHtZKlujVPzgDJUzVvUJo3/qoO2KQRXp7siVzcvbMDbEbcYAK8oQDgREB5MABubRaAbPr/dfSX05JTuBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CfB8A93h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CfB8A93h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7tOS59SYBV2Xl4rD7sZmCPHjc9f7vtoL0THKAa/pszU=; b=CfB8A93hmZpVjxpErL+4TlDGBi
	ZZs+iglw064x+KxCFmbS1Dn6uhOtdk8ZDFiuHXYAKxReHdmZ6Pv8SncVdi+wPW0Hy5JYo6ZRf/Gn0
	3twkSnp1XvatgoSmY/RANY/k9vCppXLz2BiSOK31aIAEh8KNEIuAxSrhwW+CLaj+sY/qLXmsPIrl2
	eDq/62Ob6qaaDw1d28zlkmtVfUW86em8h7Yv86oTqCoMXZ55Aq8znbgHBuvTIIvLXPOTnWvxPi+S3
	3Pj7Qy4fSkAsmK1zCOXQeS/RjcF2NH8hhybx9Ggs0quX+pEUBK0M23o2g+U1tY0S9SgdSuO0REXdN
	1KqRN/ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60ao-00000006ntr-0vTS;
	Fri, 27 Mar 2026 06:22:50 +0000
Date: Thu, 26 Mar 2026 23:22:50 -0700
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
Subject: Re: [PATCH 22/42] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <acYiOrzqSVez6rnm@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-64-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 26, 2026 at 10:54:16AM +0100, Jan Kara wrote:
> There are only a few filesystems that use generic tracking of inode
> metadata buffer heads. As such the logic to reclaim tracked metadata
> buffer heads in inode_lru_isolate() doesn't bring a benefit big enough
> to justify intertwining of inode reclaim and metadata buffer head
> tracking. Just treat tracked metadata buffer heads as any other metadata
> filesystem has to properly clean up on inode eviction and stop handling
> it in inode_lru_isolate(). As a result filesystems using generic
> tracking of metadata buffer heads may now see dirty metadata buffers in
> their .evict methods more often which can slow down inode reclaim but
> given these filesystems aren't used in performance demanding setups we
> should be fine.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

