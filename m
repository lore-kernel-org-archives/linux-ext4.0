Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7929B799
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775229336; cv=none; b=gKr5SCYtEWjjeIBj2IZZq+tDp1G8IIHsnRX/JMm1bvDC5ScUf8St2nUMEXwvZc0c8r/n4zcOzc4fl2jSPUBq9DpqNH6ettAGSAVrt4JdZOWkOCr2DNNy6+5q+TeVVkYSn5QKtvEL9GNWqmVoAyhXm3YQRo/66czXglLeSpUjS/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775229336; c=relaxed/simple;
	bh=UplDLhOZLXJ4/pVnqeRz1aozsvR7UuquHAnE22s4p4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gllme+Kx78JQpVJXnFQ4wRYAnIbWHQSt+F74PlQ70oYWYEnm0z3WR503T5KNvIYXE3pmeoCF6L+Dc540kxUDdZF0bUqz1iHRk47Z6AReCD3MCaon+frih5BrJ1Bl+ukM2TqActZ9tPeWXfS7Qv6tpe//SPx7kqIWAnQN7GdNCBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfvYl5aB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfvYl5aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1CBC4CEF7;
	Fri,  3 Apr 2026 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775229336;
	bh=UplDLhOZLXJ4/pVnqeRz1aozsvR7UuquHAnE22s4p4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DfvYl5aBlFSkYuqBzBLxNKBp+x1NjnOVa+f9yBAv7RXRfgoF5sEjFL0cq95KdSBZR
	 dfVTJtKvEf84E0HsvViEgABU2ssFRs91KqMfQyI5XwaLvZW8hLwVilP8chstD2Dpj7
	 xF+V9ClmrwJLA08to763mbD+zLnjZ0yEVdo26o3bdldnr75gFcfkssZKiQG0CUmQk/
	 z5cu3qmGRXy7loLbCRZ7ZuxkjJxPwHdn3ERyNJdhivYGckEN3xZtKREUdBWCUqVzwI
	 GjedEGnBj6AyVGbTymga5jF7aAM63xcxbS6z1H9H9jMlxh/Ur/MWOR0ugforhDQnMj
	 62TZ1SJ9o33Tg==
Date: Fri, 3 Apr 2026 08:15:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] libsupport: fix portability issues with the bthread.c
Message-ID: <20260403151535.GI6254@frogsfrogsfrogs>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-2-tytso@mit.edu>
 <20260403041624.GD6254@frogsfrogsfrogs>
 <20260403115313.GA12260@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403115313.GA12260@macsyma-wired.lan>

On Fri, Apr 03, 2026 at 07:53:13AM -0400, Theodore Tso wrote:
> On Thu, Apr 02, 2026 at 09:16:24PM -0700, Darrick J. Wong wrote:
> > > -/* Define to 1 if fuse supports cache_readdir */
> > > -#undef HAVE_FUSE_CACHE_READDIR
> > 
> > Huh, there's a lot of churn in this file.  Do you have a magic script
> > somewhere that regenerates config.h.in?
> 
> It's "autoheader".  Whenver you add or remove tests to configure.ac,
> you need to run "autoconf ; autoheader".  If you don't run
> "autoheader", then even if the autoconf's feature test enables some
> new feature test, say HAVE_PR_SET_IO_FLUSHER, the feature won't
> actually be enabled in the #ifdef.

Aha!  Thanks for that tip; I'll go fix my dev branch.

--D

> Cheers,
> 
> 							- Ted
