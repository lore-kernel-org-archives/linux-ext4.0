Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF44D0CC7
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361840; cv=none; b=GyOdUXbyC8uIrp/xTjY9Xczpf8KIkMExZHWQM6arLhwtbQm2dXzZ5ULsAn9ONioGTAUwBHcNMe1A34neOZJ83YYKpZepa/Dio75a40ij4z2v/z1GgURPC5ov+1iAZawArDAUIB0Qq2zcPaevFYrfa7lU48kemVJSNx+sEdGtOHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361840; c=relaxed/simple;
	bh=GKVQ3o24LarrEzki5fB6F0RmYciTpe3bIg0OscAKcqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoFl3krWENfv2zlx4fdfsy4NFZYW8qe0VifWc+hHwrR5RNsiwPL57OaYtcleqCs6L+QxrY8fSbFIoFwhGgvlZjJjUPsaUqpHQzatyAMDcIF99BC+BBrrCs/U2+PLZsWMYcYZWymg1kSe3IueSWd6Kq97ToW/0PhJrQ3RtbsPO5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2wiiVKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2wiiVKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEAB1F000FF;
	Fri, 25 Sep 2026 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790361839;
	bh=jgEXWNXcBTLWnFlPo0q6usz5RDEdFmnaB/xTaLoRXN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j2wiiVKexr//DzZeTI8mhD89BX3So6s8+/zOmkJGsgO/RH2EV3P0unuPhwqwCR4Oa
	 0GWiYMSoTkTwDFanmMVNuCqlNg0DXYZrHtx3iKoHK/Uc7gbS334ZKgdRXFDHWkQPqa
	 IqvchZDTdeu7dzDj0y4Ck0ZOM8NWiuaQrG2jL6STrAyjTeC0t/0sji/pVlDlC1GSKH
	 H1ImROCvHOuu7C5RbuMUb4WO08+UzOmtIrFLvqECTrisP5uwedjVyOJq+n1swEZKtj
	 /M265OFzlx6H7SRTRz2G5QuPHY5OclxvkRIijkGh5DKnJ2aBOko8qhcKjy2XQN0jr5
	 JTPNb0pVeoXOg==
Date: Fri, 25 Sep 2026 11:43:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Niklas Cassel <cassel@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, dlemoal@kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <20260925184357.GA2060@quark>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
 <arSMwd1bGO1vrif-@mit.edu>
 <20260924033200.3615554-1-matthias.goergens@gmail.com>
 <20260924040030.GB5048@sol>
 <arZx1GSVS61EFaiQ@ryzen>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arZx1GSVS61EFaiQ@ryzen>

On Fri, Sep 25, 2026 at 03:06:28PM +0200, Niklas Cassel wrote:
> Hello Eric,
> 
> On Wed, Sep 23, 2026 at 09:00:30PM -0700, Eric Biggers wrote:
> > On Thu, Sep 24, 2026 at 11:32:00AM +0800, Matthias Goergens wrote:
> > > For the entries, my plan is to start with the roughly 160 T: lines
> > > that name a repository whose HEAD is already in mainline while
> > > linux-next pulls a different branch from it: one small patch per
> > > repository, sent to that entry's maintainers as its own thread.  I'd
> > > send a few first, to maintainers who usually respond quickly, and then
> > > the rest in larger batches once the first ones have landed or drawn
> > > comments.  You know far better than I do how maintainers take this
> > > kind of tree-wide cleanup, so I'd welcome your view on that approach
> > > before I start.
> > 
> > Explicitly documenting branches in MAINTAINERS sounds good, but in
> > addition to that, HEAD should also be made to point to the correct
> > branch (at least in repositories where there is only one main
> > development branch).  This can be done using gitolite's symbolic-ref
> > command: https://korg.docs.kernel.org/gitolite/index.html#symbolic-ref
> 
> For the record, there is no need to use a gitolite specific command,
> regular:
> 
> $ git remote set-head libata for-next
> 
> works.
> 
> 
> Damien and I (co-maintainers for libata) had this discussion offline a few
> months ago when Sashiko was constantly using the wrong branch.
> 
> Assuming that you have a 'fixes' branch and a 'for-next' branch, which
> branch should be default?

Probably the one that most commits go through for that subsystem.  For
most subsystems that is for-next (or equivalent) rather than fixes (or
equivalent).

> The branch to use depends on the type of change it is.
> 
> And many maintainers can go a very long time without either merging in
> 'fixes' to 'for-next', or rebasing 'for-next', so critical fixes might
> be lacking from 'for-next'.

I rebase mine at least once per release, and I think other maintainers
should do that too.  But yes, that can happen.

Really, people sending patches should pass the --base option to 'git
format-patch', and in the vast majority of cases should use a base
commit that's in mainline or linux-next.  Then it's straightforward for
anyone (or anything) to apply the patches without any knowledge of any
subsystem specific development branches.

(Note that can work even if there are prerequisite patches that aren't
in the base yet.  They'll show up as prerequisite-patch-id lines.)

In the few cases where that isn't enough the sender should be super
clear how to apply the patches.

The fact that it's often so difficult to apply patches is a very
frustrating and mostly unnecessary problem in kernel development.  (And
I run into it a lot, since when reviewing patches I like to apply them
and review them in proper context, not just work from the email only.)

- Eric
