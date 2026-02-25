Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5167F3DA7EB;
	Wed, 25 Feb 2026 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039005; cv=none; b=hCDyMtpVe/zyposNwQvZjozWzLJlhC6z5gFcJ+gLxu3vQa3Iv18Uq+KMihfGKMzD48Q2mM5qi1FzN2NIYBMGePDm5qUgM4K+YkXTmAsR+X5TUI7LCjiv7AzCk5Eks10jSaSBd7quKLuZ9XjSWLf8VJzl01YxzgNVCWO90Hr1pCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039005; c=relaxed/simple;
	bh=+54Y2ZaIfsOsI9qJ7/J6L0tufQ7xJ8poQmI0lVmcc/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4oBaUcn3nE9fRVpvv4x06s9KbpkwIjVv6O/XB6x7pzfiTTUN/uutzwDW+mJiHPXh5mi7JJNvk9lGg270rAzuM8iOX1bLVOhfRh7UsFh4iKrCQE/sLdOE9WKA7/J/d7z9LkimaitBLSYRQWjKfMPIXISMIwspTeJxVwS4H4l+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwM+YFF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwM+YFF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C65C116D0;
	Wed, 25 Feb 2026 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772039004;
	bh=+54Y2ZaIfsOsI9qJ7/J6L0tufQ7xJ8poQmI0lVmcc/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AwM+YFF/HAeRvq6xs2PE2tgPQqXk7dDtviEV4m24LKlW3zbrv06H8In7g9ug1CEIo
	 +pL3I6Xl/VMl3/tIyQYQSDcnAv0e1uAG0e9W+j5Eu9yR1ozVpEH+VFbgqr1ol474+f
	 qRe7Kic8JHEQoNx7Ne/2B/WoOFPx17QDrdnhQ3OWm0pAeBR05pS2IASdB6C+KKqxI7
	 o8Nc7A0SDmx3lk9MEyUSZbmknwcd9zM8NwpMOwdAjhjt8TIA8cBT+FQyrG+9qTdy4Y
	 ZV3PZsSXqisUJSNmPg+u5igl+/K9fchj7boSBwbNOZgCothLS2R1i0ZHfwoJzoZjvZ
	 duufAfesWwgVw==
Date: Wed, 25 Feb 2026 09:03:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, miklos@szeredi.hu, bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: allow NULL swap info bdev when activating
 swapfile
Message-ID: <20260225170322.GF13829@frogsfrogsfrogs>
References: <177188733433.3935463.11119081161286211234.stgit@frogsfrogsfrogs>
 <177188733484.3935463.443855246947996750.stgit@frogsfrogsfrogs>
 <20260224140118.GB9516@lst.de>
 <20260224192653.GC13829@frogsfrogsfrogs>
 <20260225141639.GB2732@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225141639.GB2732@lst.de>

On Wed, Feb 25, 2026 at 03:16:39PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 24, 2026 at 11:26:53AM -0800, Darrick J. Wong wrote:
> > > That sounds pretty sketchy.  How do you make sure that is safe vs
> > > memory reclaim deadlocks?  Does someone really need this feature?
> > 
> > Err, which part is sketchy, specifically?  This patch that adjusts stuff
> > in fs/iomap/, or the (much later) patch to fuse-iomap?
> 
> The concept of swapping to fuse.
> 
> > Obviously this means that the fuse server is granting a longterm layout
> > lease to the kernel swapfile code, so it should reply to
> > fuse_iomap_begin with a error code if it doesn't want to do that.
> > 
> > I don't know that anyone really needs this feature, but pre-iomap
> > fuse2fs supports swapfiles, as does any other fuse server that
> > implements bmap.
> 
> Eww, I didn't know people were already trying to support swap to fuse.

It was merged in the kernel via commit b2d2272fae1e1d ("[PATCH] fuse:
add bmap support"), which was 2.6.20.  So people have been using it for
~20 years now.  At least it's the mm-managed bio swap path and we're not
actually upcalling the fuse server to do swapins/swapouts.

--D
