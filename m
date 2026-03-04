Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E23988E1;
	Wed,  4 Mar 2026 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631755; cv=none; b=C/IwzPBJ09+5jl6eIYgxQlEK9ISC7+tSgXt7C3nVfgxIIo/0uUMzONjdXcdCgRnm4Tyjc6cXNkryhJ2icY5LBknDwI/ZEKLFTWAAMHm0H0fq0maY/PJ1uTVUDOfQgNIfzrRlFcnEuHWniRWUhmpRyV7Mv3zXPQKiwhmzzBYcP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631755; c=relaxed/simple;
	bh=DKbslS42HEzdZOw7zPbvYkD46CkZrv82i3vagssvN6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sde9KBrZVBCvMcz2OKUFw1v7TRhdsgF7rSv/BDi1mU2eAKv9u4BDHSuf2GjMq4mcxktRBvDoRPUMWTKXp4KzNxvkkzQK60jOCskiHqg0F4hXnDQ2EUbCQaD6KJ/fcAl7eOGE38NGX2T+JdWUsSOwhQs7jXqtoNiQwYKXUyIv0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AIuiOEt4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AIuiOEt4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DKbslS42HEzdZOw7zPbvYkD46CkZrv82i3vagssvN6M=; b=AIuiOEt45JuHm/tFitR7YG4fTc
	9U4D54oGLMfswhEFp4xzd+HP6pIT+5bvqVMLBs2Z/JmkEjnEcWhxAGAmG6jgOTCvXFYwX3621GvjN
	LDgkLlPgvsEivdn67XU7/spbOJJkiOg4W0emwCxLnmpk1ZiGnf2zebopnSKISxCh05Dlx8S6/Vy+3
	p1Jjj2W31iRs9p9nl3iSk3HarZQx7i/lYryFavjj7JffWgLXQu2rZ2TxpwlcMBB7jaj79Sj1vZQaX
	kIKwRX2f6eH3HXj8Ux36TSWsUv64sDYYE0tSy/JeJWivTNZMVX6+V1Jd/PVVWGm8RVb5+SPvsxhOZ
	fsaoK0nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmUj-0000000HGga-2UOC;
	Wed, 04 Mar 2026 13:42:33 +0000
Date: Wed, 4 Mar 2026 05:42:33 -0800
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
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <aag2yYtENaE3SFwF@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-63-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> Instead of using mapping->i_private_list use a list in private part of
> the inode.

Similarly here, I'd be this toward the front with all the other
switching from i_private_list to private members.

