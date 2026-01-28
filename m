Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4B32E732;
	Wed, 28 Jan 2026 21:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636342; cv=none; b=OwKNnKeELu21TDuN7LRoWHMeATB1quAVl9Pong/h3qJ/EpvvqGdwTtnIsQdZWCvzQ/lBW/H0lQOi2ShURkBuIRoz7/sjP+kRRxOsGN5EojFczoS3Cv6tYDTLOnuPuj+8PUlN+cE+fQh2CON0ECra50UKqyQQUOWp5QdaRfIjDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636342; c=relaxed/simple;
	bh=9T7+GBtaepLJzNLa+Zs+hyWDHHppxYz7YfDFEVJEOI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGPC3Q/XTUb0vlRk1nQLXhm1gKarIwy8FMNnGFtVQB6nzHIZilNAiijuSX7xqmAkFA614agWseXiQxBSBZuEh/bHIxN7GiBjYD4DJ9P1t+PaIQ1SblJFkWzIvk5IdStS7Lvai5r0A2s1gmjid2DzSXjSfqkY0HCsnAxITxuT2YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W/YX9qgE; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W/YX9qgE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LFY20aXr4oyNthpI0ftb5zOXTh8Shnm4hJYKYI7JCmo=; b=W/YX9qgEQwrUf4tYRGEF1H+S8F
	ptwtJynZTZ9puxoo5CBVM5H7tjZd2cDu8aIFH8SI0yND5nDzkDI0XUrbWW+TAC/vlJHMuYjviuHz0
	PtqkjeP5hNuFg6RVTzVJFEncEQZrqvTkQ0N5N8SheTBIcjCVeFAl4eNsnPVSaJ70vSmOhXKWIbjbc
	Pt60oMyUxrRtOKPSQ39fmeRpuCZi/jbXIhDlr6M8dCukDQR1QbhbtQM4qE2cN53K0qfsKNLan1ZW+
	FFtSR8O10b2e34uT4G8YwmZV5g/BRpBykoSbmI+5XAbIMt6hcyp7P7GRy365lb7EyrdLG+qdMuS65
	dkoLvbrw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlDFV-00000009e0I-3Xv1;
	Wed, 28 Jan 2026 21:38:53 +0000
Date: Wed, 28 Jan 2026 21:38:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 11/11] fsverity: use a hashtable to find the fsverity_info
Message-ID: <aXqB7Wlfx62bAjqF@casper.infradead.org>
References: <20260122082214.452153-1-hch@lst.de>
 <20260122082214.452153-12-hch@lst.de>
 <20260125013104.GA2255@sol>
 <aXaPph6Yi-hzf0J-@casper.infradead.org>
 <20260126044432.GE30803@lst.de>
 <20260126201206.GA30838@quark>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126201206.GA30838@quark>

On Mon, Jan 26, 2026 at 12:12:06PM -0800, Eric Biggers wrote:
> When CONFIG_FS_VERITY=n, there can still be inodes that have fsverity
> enabled, since they might have already been present on the filesystem.
> The S_VERITY flag and the corresponding IS_VERITY() macro are being used
> to identify such inodes and handle them appropriately.  
> 
> Consider fsverity_file_open() for example:
> 
> static inline int fsverity_file_open(struct inode *inode, struct file *filp)
> {
> 	if (IS_VERITY(inode))
> 		return __fsverity_file_open(inode, filp);
> 	return 0;
> }
> 
> When CONFIG_FS_VERITY=n, __fsverity_file_open() resolves to the stub:
> 
> static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
> {
> 	return -EOPNOTSUPP;
> }
> 
> So the result is that on a kernel that doesn't have fsverity support
> enabled, trying to open an fsverity file fails with EOPNOTSUPP.

... why?  If the user has built a kernel without VERITY support enabled,
they're no longer allowed to open files with verity metadata?  I can't
see the harm in allowing them to read these files, they're just not
protected against these files being corrupted.
