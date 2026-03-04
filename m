Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D039A056;
	Wed,  4 Mar 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631794; cv=none; b=eIr40oWpPQ9yHKSNEeujI/IDMA0qtkYZc4P7/OALHzmDS7LbUxEsxiB4F+Uk+UqT8uANGqE/OB6xPBZFPZzNM4LE3seF7yS3FRBchpM3qwJVs5SHRXS1k89qvJCQpH1D7CBcVTtxYKXllIsRj/sBlbn7F2eM4pwLF76jvxf/eVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631794; c=relaxed/simple;
	bh=YswS4ZhweG5nXP69iV2NfQWA1aV67PYjoZKIoMQxlRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czKzNT31NkljFZpbcBEQX2BFGtPPErvRB3GynAPy3y8DRuHjG7pUsHm/qOaF0iZXi0sYHPbsEo6bA8aScjXOwN7RO7J0cjx577tbQU7E3iHttckLbxSUY4SK1jfChBWvfkNpyIteka3Pht5EesrQpbp2dBxIk3xV2gpmI3Aorqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jqgMF/Fx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jqgMF/Fx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CAfZkHMN+opoY06dpw99BgOAeytYWPwk19vIdsy8brk=; b=jqgMF/FxZOpA38UVzfY0NWo4Zg
	sORLBq4hswh8Bi/sbPv8wVl1TF/C5CWVQq0d/GclUXtWJ8SxusjddFSJqZOBugK0v1eLrlyTb6apM
	FrUYwc9ixO6EOXF9Tnkxflv1JLt1LlnXe7kUDq5EXEbNLYIC5JsAoL/6WpqMeH0DR8UtdY1QjvfSP
	cez/cwtSqhV/tMuSQLuzyPpXBWGyb5f39mlZDCwuCajwE1v3tNf/wvQkrOmZOfdKRHZCIxQmas09H
	//LiCBKeNrdKGv6Seo8c8QG2ovuVZHaAqDfZRbE8yBgrG0wYbtI/3TE3EOwLo0V/cB7AZosyRCKhk
	d+bk953Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmVL-0000000HGjC-2Abl;
	Wed, 04 Mar 2026 13:43:11 +0000
Date: Wed, 4 Mar 2026 05:43:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 32/32] fs: Drop i_private_list from address_space
Message-ID: <aag2777h5ai2WQKf@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-64-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:34:21AM +0100, Jan Kara wrote:
> Nobody is using i_private_list anymore. Remove it.

Thanks.  If my math isn't off, this should allow us to fit an extra inode
per slab for xfs for typical configurations.

