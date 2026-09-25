Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D98349E148
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790341594; cv=none; b=OVuk7N3zQ+LXcXAELtaQWU4ew34kql0H73S0tue64ctJzoaP6xwBPTCF+x/iKovPryyVyLE81LQjxnkAV1udwKlW+8XqQ7zpG/emUtXzADt3s7sK9G4KGB69FPIENmll/cKGx7Ky7YMFA7zDERl4lja1sxyjBykDY2wT2Vnplo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790341594; c=relaxed/simple;
	bh=AgeSdJ8ToAnVIAokP/7LJXIuV37Tv8CTBms3+JwOwas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cV0qpl8pmgvfY2fXEcEETsYSeZaIWrN0gWjb1PrfQUHs9Hwa29h28+2q6JEdR77Y6u1NQwGOX5gHO85OH88TfJWERF1X4RlpHC2csFGv0658wA0fJsvNRV9o0Jml8bsWQyqa0JzVuK8vJ+nGCqNGFA7CmdjOc4xoM41gG/2zh/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXMvHLzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXMvHLzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F0C1F000FF;
	Fri, 25 Sep 2026 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790341592;
	bh=an58+dywmNJdEJtr2fcD0mhdpZqj1VdN8YTzgeL2WR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EXMvHLzXcGoGMpKyBHVWkjNeFgtrn6AsJEQL5It29Vl8aHYapdqGh3FLrxAzpsb04
	 Rf5LSYSBR/sxToXJhqbfycMzmvknzruhXQivPFNtnoByGtqajNqqR0k9agEr4nE/3Y
	 GGBegkNUwOxM1UTvzr61tpIXRLmY8nnmxw8ZAd8wW/AaL9872W6bjzTSbmqxU03N+n
	 7VjEtE2Fj8sKk8K99le+KCrk22cDK4KOT4iQu8gauSoWLh4ujoDi4sTAvvi5Eza16U
	 DsbCF3LnysWsY3K0WnPF7L8XrK+jc+2Xm+q3SpYUlyKAuo8nO9raR0LN9ghnf6FgOD
	 cT5sie85KSCeA==
Date: Fri, 25 Sep 2026 15:06:28 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, dlemoal@kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <arZx1GSVS61EFaiQ@ryzen>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
 <arSMwd1bGO1vrif-@mit.edu>
 <20260924033200.3615554-1-matthias.goergens@gmail.com>
 <20260924040030.GB5048@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924040030.GB5048@sol>

Hello Eric,

On Wed, Sep 23, 2026 at 09:00:30PM -0700, Eric Biggers wrote:
> On Thu, Sep 24, 2026 at 11:32:00AM +0800, Matthias Goergens wrote:
> > For the entries, my plan is to start with the roughly 160 T: lines
> > that name a repository whose HEAD is already in mainline while
> > linux-next pulls a different branch from it: one small patch per
> > repository, sent to that entry's maintainers as its own thread.  I'd
> > send a few first, to maintainers who usually respond quickly, and then
> > the rest in larger batches once the first ones have landed or drawn
> > comments.  You know far better than I do how maintainers take this
> > kind of tree-wide cleanup, so I'd welcome your view on that approach
> > before I start.
> 
> Explicitly documenting branches in MAINTAINERS sounds good, but in
> addition to that, HEAD should also be made to point to the correct
> branch (at least in repositories where there is only one main
> development branch).  This can be done using gitolite's symbolic-ref
> command: https://korg.docs.kernel.org/gitolite/index.html#symbolic-ref

For the record, there is no need to use a gitolite specific command,
regular:

$ git remote set-head libata for-next

works.


Damien and I (co-maintainers for libata) had this discussion offline a few
months ago when Sashiko was constantly using the wrong branch.

Assuming that you have a 'fixes' branch and a 'for-next' branch, which
branch should be default?

The branch to use depends on the type of change it is.

And many maintainers can go a very long time without either merging in
'fixes' to 'for-next', or rebasing 'for-next', so critical fixes might
be lacking from 'for-next'.

We decided to keep HEAD pointed to 'master' as that is somewhat neutral.


Kind regards,
Niklas
