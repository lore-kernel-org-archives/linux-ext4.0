Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD871A681F;
	Wed,  4 Mar 2026 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631854; cv=none; b=BUbRJz9Oz4g0FSMn0gVC+p1Y6Z09NnteaOZNG+2EomsU4qYnqkRFjY0anlIyPHFSESYZcN9z31yRKc85zOGmaF3KZNFgQaUgmJuyfoZ7BiQr1WC2O6bbpLcbAAPh9rYvGfbx1V7f5YfyusyhHHfzOhbjXTcl9gUNHZd1dBPX788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631854; c=relaxed/simple;
	bh=g3INtWbRSN0jgkldjcsYoJmKTSHqyloAGHQW144zmBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuahwIA+THK1QMcX6ETwQdK9ztBW8SeZqGdJV99HBdiM/HIkseqygQWoMpi2S8TkI0DMX13fUcnz+Q/65AifOw7XsPVv7z+CRslfW/oyOT1BwTNDmWZJ4N392+RQmSf0KvGLccT7GvAKu1+zyNC+pcD+Hh5qgTHSmTpnOtYwThc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e26RPWy+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e26RPWy+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xF3nW5vCC+iyBfuzvDC1ioxG3TRa3zdtOomhQDNrMX4=; b=e26RPWy+p372QzL+jnAnKcXN/M
	wiH2eMkftY9mJ4kH7/PqEDDLyQASUDxtKvKcZSJBsI9IapRavsleLku9Je4wUAoAl2On0zT2i710X
	yk25Dcr19xceiZLdFy76P7cxS7b0/cDxSsP9p25uPvGLL2d5K0b1kiNnOVl0VRntIQViwwQ/B47hF
	6Wzhu2fkE29yGMmhLkRrlOlptcw0CxSzXFA8lL7DderxkOUndrseIfKfSz1L5JPgHv6OgjklHpub+
	C9ZsHmyOyq5U+NSxcm+c3OxzDSkcPcBzsLsrZjbkT+Pbx6Uz+vjuzBQz7PhggUbwxiRgViLK665HL
	0tw8wkwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmWK-0000000HGqK-2Rgh;
	Wed, 04 Mar 2026 13:44:12 +0000
Date: Wed, 4 Mar 2026 05:44:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
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
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <aag3LLGJPNAYNeCU@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
 <aagxU5f1AI3y0wrw@infradead.org>
 <4ji4ihp7tzhxr35t2vgnswfskrjnsuo4eys4klblnor2b663pp@x3khuzh7cxhv>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ji4ihp7tzhxr35t2vgnswfskrjnsuo4eys4klblnor2b663pp@x3khuzh7cxhv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 02:38:41PM +0100, Jan Kara wrote:
> I was looking into that. Passing these to sync_mapping_buffers(),
> invalidate_inode_buffers() is easy. Passing to mark_buffer_dirty_inode() is
> relatively tedious but doable. Where it gets difficult are calls like
> bforget() and most importantly try_to_free_buffers() on bdev mapping where
> you currently have no way to get to the mmb struct... We do have
> b_assoc_map pointer in buffer_head which we could switch to point to mmb
> instead but IO error handling on bhs needs to get to the mapping from bh so
> we'd then have to add address_space pointer to mmb for these uses. All in
> all it's doable but I've decided it isn't really worth it.

I guess a backpointer from the bh list to the mapping/inode would solve
all this?  Or am I missing something?

