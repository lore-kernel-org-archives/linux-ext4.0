Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5C2288C3F;
	Wed, 25 Feb 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772029004; cv=none; b=or5tpjCrjed+7l1BuhBEkNOHiTO7woPhhlJ89OfZfWEnyR8+32f9KiBps/7KAQgI8CbYVrkRqjo5d3SHxE0FGNp22gpxZ8DQ2u9wIgXHmVLDxQ4sL9FBRjb5/eT3z+jo0M2fRoUWVsT2hhHHMQJbIrb0X9tT5U6Zj+Yeq0fE8Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772029004; c=relaxed/simple;
	bh=67Y/eQf9Mv1ECigVJ7DGKEdMWEnkGupQ3A/1Sqz4/UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LN7SWlYZuPmpsEMxoWbjmSFWSLF3CYvnWqemnwnUGOJKaQHnbX9IF/e1GXkPmsKrxq5T/aJ73GcB4TV2FKICJCI9QGMmLLcrPgunfWoLquT4SpC8MKE/i0BwiHuecSz6Tbf+VcYxIULZmwnCmrQE8pckWQCUMWTQ40NCR1Jc5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5901968B05; Wed, 25 Feb 2026 15:16:40 +0100 (CET)
Date: Wed, 25 Feb 2026 15:16:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, miklos@szeredi.hu,
	bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: allow NULL swap info bdev when activating
 swapfile
Message-ID: <20260225141639.GB2732@lst.de>
References: <177188733433.3935463.11119081161286211234.stgit@frogsfrogsfrogs> <177188733484.3935463.443855246947996750.stgit@frogsfrogsfrogs> <20260224140118.GB9516@lst.de> <20260224192653.GC13829@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224192653.GC13829@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 24, 2026 at 11:26:53AM -0800, Darrick J. Wong wrote:
> > That sounds pretty sketchy.  How do you make sure that is safe vs
> > memory reclaim deadlocks?  Does someone really need this feature?
> 
> Err, which part is sketchy, specifically?  This patch that adjusts stuff
> in fs/iomap/, or the (much later) patch to fuse-iomap?

The concept of swapping to fuse.

> Obviously this means that the fuse server is granting a longterm layout
> lease to the kernel swapfile code, so it should reply to
> fuse_iomap_begin with a error code if it doesn't want to do that.
> 
> I don't know that anyone really needs this feature, but pre-iomap
> fuse2fs supports swapfiles, as does any other fuse server that
> implements bmap.

Eww, I didn't know people were already trying to support swap to fuse.
