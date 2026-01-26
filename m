Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E8230C613;
	Mon, 26 Jan 2026 04:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769402676; cv=none; b=lEkJiP4s0Ypt3oVcYVGJg3KwD0Z+eCnKHqTyzqhXKkvhTFxXqJHDREIp7aQUnoNkimfDzMBOHWg8WY4k9UJNsuMGEaXYo+R4pQ5RIfCLmXrsf1PwczDTG3j+9eBm9ZnHbxJPbVbUFojrDx1sa+gditMyRZhPMriv6Pl7UNfMzSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769402676; c=relaxed/simple;
	bh=bagBlzNDVxaK20m6YpouE39DaLfPFoD0cliWgNaDsqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1JGa/y60hPmA+lWkWJd9vKjxbNgCb9M3Q6oYcTcpq35QfOChIIUQJnQgqfRqAt26/qBRxjB9VArQbDyAlEcUcIA9sgUKF0+VP6QuN+OvRNMpZO/6ntt9hVyYUjK1MJPyg4vajTtbfnpMqFBKXrRouj151yigd7wWtvafEBrnAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BE26F227A88; Mon, 26 Jan 2026 05:44:32 +0100 (CET)
Date: Mon, 26 Jan 2026 05:44:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 11/11] fsverity: use a hashtable to find the
 fsverity_info
Message-ID: <20260126044432.GE30803@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-12-hch@lst.de> <20260125013104.GA2255@sol> <aXaPph6Yi-hzf0J-@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXaPph6Yi-hzf0J-@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jan 25, 2026 at 09:48:22PM +0000, Matthew Wilcox wrote:
> Is there a reason not to do as DAX did:

> +#ifdef CONFIG_FS_VERITY
>  #define S_VERITY       (1 << 16) /* Verity file (using fs/verity/) */
> +#else
> +#define S_VERITY       0         /* Make all the verity checks disappear */
> +#endif
>  #define S_KERNEL_FILE  (1 << 17) /* File is in use by the kernel (eg. fs/cachefiles) */
>  #define S_ANON_INODE   (1 << 19) /* Inode is an anonymous inode */
> 
> 
> and then we can drop the CONFIG_FS_VERITY check here and in (at leaast)
> three other places

I looked into this, but wasn't entirely sure about all callers.  Also
in at least some places we might need the barrier in fsverity_active,
so my plan was to see how many of the checks should simply be converted
to fsverity_active in a follow on and how much is left after that first.
