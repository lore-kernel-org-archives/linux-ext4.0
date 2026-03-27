Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD59139B484;
	Fri, 27 Mar 2026 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592546; cv=none; b=S5LOQeRm8xi8CxXBRYdMLzREXkUdrgWxfwLxJm1R8TO0gWXtnp85CLj+8EcmO+ThZsTKEedOcvTNswyAjT4KTvyKQsGCqjlRkAbFbPyonlj5IhEHcAfc3zq+3fPhri3nLBvBmDTf0/vXrZC2GudTjvy/962yVmz7DXyj+lBciQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592546; c=relaxed/simple;
	bh=r7HCTHYUFfQwB1AnmmoNDM1xdUIQR6x6PxBReIWtx+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=il1xAlO0sfsCZhUIGT2ftoaVZzUG3oUUsDHfWATL2Xl8fZPJ0RrOXUxmv8QzFo5gbpnhgcXDqGzXx4O1HlWFdFoTmciaClqzxI44gj1/HJLgQg4Z0On2JtiGvfQ3/hmW7GAX2s7At7p8rY8mxKnRYjsAYii345jE1SXFyaddxys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IkRI44qb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IkRI44qb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r7HCTHYUFfQwB1AnmmoNDM1xdUIQR6x6PxBReIWtx+E=; b=IkRI44qbd3PTpzO3/QVrtkxOIa
	UdkRK1WNceu1VkN2FAz2VYZTY87vmdmh5ycJw00nJFxbqsWpQwUJVovSF4eqtmMCtypEy3l6EO5FE
	zFbGNcEpK3QWUjXgdsJaytuVTkh8sI/mW8q7W9SQs2ugKWHEHYP+owYjVJkDN8x/vbT7ztUkfe1CN
	BqtCHxS6B6DgLfmgZK7ubM4z0ZcVEEsoVg2ocnFUxUgS3ly0wMRCzhMRL/ZKklGPlhhHSCX4GSE3r
	SsDmtdDTGNoQ9JMhikWjQB9Tsgz3lFsT9/imwdmCQO5u7SXUOhokx5Jiw9ApUVDU8bH7mwmsE/q/x
	2JorWLSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60aN-00000006nbg-3hZ1;
	Fri, 27 Mar 2026 06:22:23 +0000
Date: Thu, 26 Mar 2026 23:22:23 -0700
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
Subject: Re: [PATCH 14/42] fs: Rename generic_file_fsync() to simple_fsync()
Message-ID: <acYiH4ByDc1-nPqD@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-56-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-56-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
> -extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
> +extern int simple_fsync_noflush(struct file *, loff_t, loff_t, int);
> +extern int simple_fsync(struct file *, loff_t, loff_t, int);

Please drop the pointless externs, and maybe also add the parameter names
when you touch it.

Otherwise looks good.

