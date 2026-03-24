Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322733A6B62;
	Tue, 24 Mar 2026 05:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331794; cv=none; b=HOt1va1X+aRgHtWw9fzmrOfmTLooCVZgttopcEd6IY/i1/ZmHrJuGORcSiSHNvMx0PP8W5OAm//o9qLCtsW24koT+2nGmnL3HwXkljs8duO/9INbmcbGDsdun0izwo4SaXGzDSDHXBbPeUc0Q6w8nLirxFshjOHCosBKNFc3hbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331794; c=relaxed/simple;
	bh=/95oFOjhTgKmq+1zsKFw6HDfMgURvP9+0Jq3M/BVzd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWcUVkGpl2ODGWuL3SEo3XnNdmakLlwsudNJsMUJKhiABOvcDH3IokNHuxEUyiRVVVdAtuYhxuLOmrvHFWHKODCHb0icooxUJR4yak1vhVT9Zs7qtzXBBzziGXeh7bEBQ1guudWsn4tocbS3A1IxbnUselLiNgEr2egW+SCN7To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VnGsK9o0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VnGsK9o0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MtO3UkezvPYDI1WseWZT+CQteeNIipdQ8FHfP2vxTes=; b=VnGsK9o0awm0/1LzaVAbykaRkw
	qZDn4CDccSHCQiyLLsYSKCs1xHas4u9P1CpUmZMFnOO6qAS5xYwUi2Eisf2wzMuDKZ8sc5olGjvMf
	40fdgQnRay2l7/FL8S1+WyeQf3fSMj5CZxMslBWSABpvxhmL+7cg4uYS9y7uqHvoAwXoHcX+WgHf7
	iuguqbxqwODOSesNkJkHbtM02yFjpAcnJI3ZgPr5ZFVSTzal78Sw0YTko04XwYvDi5x2DWIle26Rd
	dttrRYD7Jj5ZAzA0oUVF+Dy8pl1LEb0eGQlgNz3L6sRF2gYJesDj1NSosj6cRRm5BHvGMXzrhXFfc
	jKbz3UMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ukg-00000000coL-40EL;
	Tue, 24 Mar 2026 05:56:30 +0000
Date: Mon, 23 Mar 2026 22:56:30 -0700
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
Subject: Re: [PATCH 41/41] fs: Unify generic_file_fsync() with mmb methods
Message-ID: <acInjoDTJAz62eUp@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-82-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-82-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:36PM +0100, Jan Kara wrote:
> Taking inode lock when writing out the inode seems pointless in
> particular because there are lots of places (most notably sync(2) path)
> that don't do that so hardly anything can depend on it.

This is really something that needs to stand out clearly for bisecting
and documentation.  I.e. make this a patch on its own and preferably
before all the other refactoring that already is affected by moving
between the implementations at the beginning of the series.

> So let's remove __generic_file_fsync() and use
> generic_mmb_fsync_noflush() instead to reduce code duplication. Arguably
> this leaks a bit of buffer_head knowledge into fs/libfs.c which is not
> great but avoiding the duplication seems worth it.

You could just pass a callback to the generic version.  The cost of an
indirect call should not matter compared to the rest of the fsync code.
That would also be a nice thing before all the renaming, as that means
we could add the version with the callback first to unify the
implementations and then the file systems are switched away from
the buffers fsync variant to explicitly pass a callback, or to not
pass a callback when they currently get the default one.

