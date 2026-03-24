Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA7B285056;
	Tue, 24 Mar 2026 05:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331235; cv=none; b=BWmDnzOU+T/rE6/dTl8SeHVyKn5jIsZzpzANuliiiXNDY58SUsDhXzoxxbJxh9FXcREmZEWOX7ElGsLhRizx2dW/Fbwud+QL5jvIKdUdvV413v66TJ7MYwl9OAqZDjWAOBq4VIfcll6hNu4W5/oq8ZqUVbezyz9/x09uxaCSG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331235; c=relaxed/simple;
	bh=bS7LrdGPEmtmqwh/nM7R4CqFKodgVD6VqYGv8dwILdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHgKungpv1P/9SE9y+x9Mjc/F3b7S6VkK/jM5KI/Hv6iQookLvMMFAY/tZR+8YmYTyYiBGzQUxQyDKUGS3Q3EeKVUg1Q6KyPzBzXrnAAuD5yAeeqYS/Mg1tb9LE8n4VBJAbvbyUTXQB6wqGDxHOxjB3Mv71NFU10qvC5kjgzzCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qXjs9pPb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qXjs9pPb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W6Vm/30+XKDDAsXGEh8YRVDUyTubbzFSvxa6tRmH3Js=; b=qXjs9pPbBv/4jA9h8OppKIk/xc
	i3rBSyqai4I69+ZVZ/O9dBhCLTH7+mKDTPi9dSH6pvx/XYujKmwZhz17uIoRJVclWXm23QotNoh8u
	cmPxRdlx+peIQLkIPS9hcEmvV8y3bhRiYLcghYLw3KpXZY674gGrJOl7vZTTEHlW1Rgdmq55Jtn72
	ibHv4o0hsW0B2MwNn9y7JtzQxmf9ebatCiKWkzYAeUSX+B9O0My/0olmVRKayq10T1d5Dp2N8zrCt
	DJIYhB+LXvALubHa3zmpmQboEFoSHW1yYSNZvqImxo/UoggUG3hsezpIor83vOR2+GzYnReTiFEnY
	WMjnuWEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ubh-00000000cNO-3Yci;
	Tue, 24 Mar 2026 05:47:13 +0000
Date: Mon, 23 Mar 2026 22:47:13 -0700
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
Subject: Re: [PATCH 28/41] fs: Move metadata bhs tracking to a separate struct
Message-ID: <acIlYRiP41KCqsGM@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-69-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-69-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:23PM +0100, Jan Kara wrote:
> Instead of tracking metadata bhs for a mapping using i_private_list and
> i_private_lock we create a dedicated mapping_metadata_bhs struct for it.

s/we //g ?

> So far this struct is embedded in address_space but that will be
> switched for per-fs private inode parts later in the series. This also
> changes the locking from bdev mapping's i_private_lock to lock embedded

Instead of "to lock" I'd expect "to a new lock" or similar.

> +	/*
> +	 * The locking dance is ugly here. We need to acquire lock

s/lock/the lock/

> +	 * protecting metadata bh list while possibly racing with bh

"the metadata bh list" (or spell out the field name without the "the").

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
