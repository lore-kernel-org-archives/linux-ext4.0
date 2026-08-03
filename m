Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFA7391849;
	Mon,  3 Aug 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785780717; cv=none; b=WGgpJ3VrpGYbw8MG+QR0hj4oZ6VxyXmgqfn9weDiJ4Xo42qskRVPKhneI380MOoAZWA1F+h+OI1SpwQ9x+dQ9qhDKldR6cxXNLremVcMzC8geri0KsX311zEBivvcuhOTsapHVSabk2EzCcjcL6Z1eYf4Y9iZYzBgf65oVqI2fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785780717; c=relaxed/simple;
	bh=d/ZeSMCbCC8dQV1LOdaRk5DHw8kdFfNWBbvmPPEm6/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0XRZHeW39pCkD6i87y+Im5CLO/xG/eu9DEw4FbTk0v3AY/4jjn3U2YwwCi13UiwKLDs6TfvfjAbrdhrC23gtJA9UeviwmiZJ8WsC+IhYUZpB+0e7JwIg7ST083FJwt9WD026HZMOl81jcble5tnClUoM6BeLhvytu1lc3+gUTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fk516/Jb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fk516/Jb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n0ZYH0Xx5UmHM0muRg3r7vjff97B6hFGQcsr7097gNY=; b=fk516/JbHprxtAGXsM+NO9ikf0
	lVwJIIspR/mCQjJicMytrd5pVv4U32RntdMNLEWZcOqMQa1O5LS2gNxNAYW4sSLQJdAMVO+Ldj9DB
	XOu4BL2jpWhH2ni5uPxXE8Wnd9RszzKggTbr+NYks4YWB2/P4AQPtjWZC4oaeD0Y9xAdofw0cwcnj
	W2gNgaeGA6u9M85l2v+cRmZRGPbdZOTRHqlVdi0r6hIAityiNCUpYI4wyawJLTc0YmMeT82aqDRYD
	hY08m6WybHcfFoZApf/WpRIaFjfBlk7pwqLgXQ0Rn8dC8Qrv0Ku9fFq+R3lN+oXu7Iyek9HhuRvSu
	jCGKdVEg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqx8f-0000000EBIY-36b4;
	Mon, 03 Aug 2026 18:11:49 +0000
Date: Mon, 3 Aug 2026 19:11:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data
 directly
Message-ID: <anDZ5YG-Ljflv7Vm@casper.infradead.org>
References: <cover.1785621505.git.coshi036@gmail.com>
 <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>

On Sat, Aug 01, 2026 at 06:00:47PM -0400, Chao Shi wrote:
> @@ -330,6 +330,8 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
>  	char *addr;
>  	__u32 checksum;
>  
> +	if (!bh->b_folio)
> +		return crc32_be(crc32_sum, bh->b_data, bh->b_size);
>  	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
>  	checksum = crc32_be(crc32_sum, addr, bh->b_size);
>  	kunmap_local(addr);

This is awkward.  How about ...

static inline void *kmap_local_bh(const struct buffer_head *bh)
{
	if (bh->b_folio)
		return kmap_local_folio(bh->b_folio, bh_offset(bh));
	return kmap_local_page(virt_to_page(bh->b_data);
}

(this is also somewhat awkward because it feels like we could just
return bh->b_data, but kunmap_local_indexed() does some ... stuff)

Anyway, it all gets optimised away on non-HIGHMEM.  Or if it doesn't,
you can force it to ;-)

