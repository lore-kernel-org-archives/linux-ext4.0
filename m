Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFF81E7C23;
	Tue, 22 Sep 2026 04:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052553; cv=none; b=S7WgUUwvDsite6/AOcdtRdumrw0UmNqOt9EPF3uun1DJDQVeGGeCJWou2NnpUR0IacY29V26gpw8KG0wpulKbF+YUP0krZgs/DO3f+d6J2IoXrPmBIm5QWEwQyCxQrj2DpYBb2Lu/n37Z0HatXS6TiVParAzz7JPmIFF0Dx47yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052553; c=relaxed/simple;
	bh=Vg/0kIyF/M4aHooenMaZ4Qi2RuEOD//XcIWaW+UqI90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjRS8E3u/8w89TyxAqrSqorJ3JgCE/R3MHAscij9IAa+uGBhlOcSAjkOU4DyKuTtEsjxscubUw+FGrKrlhgx7SgCrOvtC8Y2kr9W67I2UYu5ILfgG6s8k3mX/hod4ZjG4L5FWuz26jEn8xB5BjMQUqV/oUVp1KpyRWqBQIZrVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kX/nQi9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kX/nQi9y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B122E1F00893;
	Tue, 22 Sep 2026 04:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790052551;
	bh=H2dQ5IwId8b4oSAg6B75W82dleLPSnQZOhZ2301gLjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kX/nQi9ymk4rzimSmjqTKrirJsAKiKZVWu1kl1uKKoxrtPBHif9gzPnyEjn4nO+iV
	 DbTojIkbcmzrxcryBrj53pRWkp/CHLM3ihvXcYDsGiTTsRp7IxDDczlJp+ZrvgLXXc
	 35xbJohu5KLyLG6zHd49eMKIVm+yMI5qzlNGzPY4QUp2CDaKAwfqy2KGMFpCj5MdlK
	 Nd2uzjNHEmlXv+WHOUi447FR7Db4yfZFU+SUZW46042Hb1aszv/AiJmC/fPhfjL1LD
	 OUA23VuCDdiofpQrl5Z60UBxomvST2ELRCmTvq2NNMXadUSnJ4rq2FtvneQLF3zlvj
	 y39cBhJfTCY8w==
Date: Mon, 21 Sep 2026 21:49:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, dsterba@suse.cz
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <20260922044911.GA6239@frogsfrogsfrogs>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
 <20260918113212.B80601F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918113212.B80601F00899@smtp.kernel.org>

On Fri, Sep 18, 2026 at 11:32:12AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] xfs: XFS_BMAPI_UNWRITTEN corrupts data on realtime files
> --
> 
> commit 03f3992d52956762d29c7c4c4908adeac76b8662
> Author: Andrey Albershteyn <aalbersh@kernel.org>
> xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
> 
> The __xfs_bunmapi() function is used to remove all extents past EOF. This
> patch adds XFS_BMAPI_UNWRITTEN to remove only unwritten extents, leaving
> written ones in place. This will be used to clean up unwritten extents on
> fsverity inodes.
> 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index ba6a9611f6f9d..69364abbfd011 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5279,6 +5279,10 @@ __xfs_bunmapi(
> >  		if (del.br_startoff + del.br_blockcount > end + 1)
> >  			del.br_blockcount = end + 1 - del.br_startoff;
> >  
> > +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > +				del.br_state != XFS_EXT_UNWRITTEN)
> > +			goto skip;
> > +
> >  		if (!isrt || (flags & XFS_BMAPI_REMAP))
> >  			goto delete;
> >  
> 
> [Severity: Critical]
> Does introducing the XFS_BMAPI_UNWRITTEN flag cause data corruption on
> realtime files due to how __xfs_bunmapi() handles unwritten extents?
> 
> If a user creates a realtime file, writes data so that EOF is not aligned
> to the realtime extent size, and preallocates space after EOF (creating an
> unwritten extent), subsequent calls to clean up with XFS_BMAPI_UNWRITTEN
> (such as enabling fs-verity) will process the front-misaligned unwritten
> extent.
> 
> Because __xfs_bunmapi() falls through to the legacy realtime misalignment
> logic for unwritten extents:
> 
> 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
> 				struct xfs_bmbt_irec	prev;
> 				...
> 				/*
> 				 * This one is already unwritten.
> 				 * It must have a written left neighbor.
> 				 * Unwrite the killed part of that one and
> 				 * try again.
> 				 */
> 				...
> 				prev.br_state = XFS_EXT_UNWRITTEN;
> 				error = xfs_bmap_add_extent_unwritten_real(tp,
> 						ip, whichfork, &icur, &cur,
> 						&prev, &logflags);
> 
> Could this legacy truncation logic forcefully unwrite the written left
> neighbor (the valid user data before EOF) to form a full realtime extent,
> effectively destroying the mapping to valid user data?

Yes.  Either we don't support fsverity with rt files when rtextsize > 1,
or I guess we have to figure out something else?  Only removing full
rtextents?  Or just leaving them in place?

--D

> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260918111539.1003439-1-aalbersh@kernel.org?part=13
> 
