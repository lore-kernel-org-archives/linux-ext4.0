Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6E632ED27
	for <linux-ext4@vger.kernel.org>; Wed,  3 Jun 2026 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494699; cv=none; b=mCFmr99BarERn14A3h82TkO3HoVm8ofIOwB2Pijh5WHzAdYb4OtuQN8ASy1gCWpz2CcwRnoPrE+28RKauBk2yq7a9/ogelFiivdUwdJmoXlBV23SPI4AD2nclUekhKjBd80PbP1f8dCqO68MZrJksBEoIh8IhYrpYJSyQXyxVjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494699; c=relaxed/simple;
	bh=vLObSHUtdaDzo1YOX8o6bf0FHy5ZK5YigSq3JHwPFlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKtSNdnYz28Qc6S9+MoNkRZIc3JT+aQ8zxhhumVeQS5rN9fS4Yp4tc16zBz4W2w5D+G14n82AeTou5zJWeKQOUNvT9mVMj4nxTQZ5nUX+y67vAQAMwoT2LGpSyRy4de/j9w5X2gzfS+p6SSUZJLmhgiR6gXb+jB/oN2cYeZA3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=NKcYAKGx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="NKcYAKGx"
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 653DoGua026124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Jun 2026 09:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780494624; bh=eTnOwFQTcngYAJlRJ+MALwnYXJnPHJMI8XzuwQM5fsA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=NKcYAKGxv8EQp4lu0Z0XBUSCuzI8zHt6mSdzmhjZxsjes/74lSNhp5mTUiBPz5k7I
	 x8n7bSOU7bbtds8bbysVLNkhfWhfAJ9+zVN6pbpzfH97nswhrYuebBvNn1bpEVRv9F
	 h3F46hxr/d0Urs6uXUoPKJZkXjOsJAkWZxHSpX6RUxqdgnAJtnWqsoxQ1ODjGatAq2
	 egcWnlC1JJLm3JT+IcLoY7MsPVk2BNMRySRvtjtxIBEMmfy5Nw9WYXUQVga/xho+/b
	 6tF0c35IXZQcou4LetXdv+ISPL1QtWHKiOcrJscYm+tLkqpr6a+ZA3gbcU+JbvyI7c
	 j1FmXnSnSsgHg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A909035DD60; Wed,  3 Jun 2026 09:50:15 -0400 (EDT)
Date: Wed, 3 Jun 2026 09:50:15 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>

On Sat, May 23, 2026 at 08:54:22PM +0300, Mike Rapoport (Microsoft) wrote:
> jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> allocations larger than PAGE_SIZE.
> But kmalloc() can handle such cases with essentially the same fallback.
> 
> Replace use of __get_free_pages() with kmalloc() and simplify
> jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> freed with kfree().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

So historically __get_free_pages() was more efficient than kmalloc
since previously the kmalloc overhead meant that a single 4k
allocation would take two pages instead of one.  I'm guessing that has
since changed?

Can you explain to someone who hasn't been tracking the changes in
kmalloc over time:

  * How does the efficiency of kmalloc compare to __get_free_page when
    order == 1?  What is the overhead in terms of memory overhead?
    I'm a bit less concerned about CPU overhead, but it would be good
    to know that?

  * What does kmalloc() do when a size > PAGE_SIZE is passed?  Will it
    return contiguous memory, or return an error or worse, BUG?  And
    same question as above; what is the overhead of kmalloc() when
    size is 2*PAGE_SIZE?  8*PAGE_SIZE?

Thanks,

						- Ted
