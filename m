Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABB830E85D;
	Fri, 20 Mar 2026 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774038703; cv=none; b=fBmj40A4oyTbzj+86CRBTXRjJkfJ5ZV4PCsFf6cq1rZ5ZDHLyfHvs6Rpovi5+YDWktF33OTXXCB46Px3+TUzbNpATni8dzFCP8aidmKsMzLk6gEBFHwJAVMMxeUtL7yhxaW0OPbkkuMPHapecykS70Zcd9fWepOW77DHNPblJ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774038703; c=relaxed/simple;
	bh=i0s+LzSLkC8i53m2t8mMgkVZFd3f8MqMpwRKN4kXtQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+jqLOfkwAFx0hrHW0OmhORUuMpoi9AESzr/it3hBQybU4uWPLNL5mvF3vOtVOETTgHf+8LtIIJFZ8tkf7UGupUTas6NZ4UgnRAeUakQT2bRlZwT0qfG2esnaJzi++pLvVSlzQr+L2hJcGDDt/jtsIuVHrAuGMfJoPTuwO5AhZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZMh6tEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZMh6tEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43027C4CEF7;
	Fri, 20 Mar 2026 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774038703;
	bh=i0s+LzSLkC8i53m2t8mMgkVZFd3f8MqMpwRKN4kXtQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZMh6tEV4IKEd/VfHWbN0d5M8/HTySYyMtAlrBM034uuy50zGzyr0QSg8TyBvGNQs
	 iqyi0/Z5nt1Q4KjytGu+u9M2zJ1S1d8owDDchFDCc8G1Fi3Zgh1nUpKh9s9blc7lAO
	 5eF+d00phhvQ6B9RJkRm5F4frQt1YDm+kTE0uyCpdbJbyJC1jcZiDKYCYNbn3Ce3eJ
	 WsqyOvJdmPHGhKF+z4TlZNV5zEJESLFOf69j4uI3fYQg+6WqyEmz3sywSqcuIj3iVY
	 jaOds8pTK8YRLsWrmy8gHzheEfq3I3WLjS1QZZxGOnukppKCWnNOXXCw6fmz0xG4Al
	 L+/g+yLitGiRw==
Date: Fri, 20 Mar 2026 13:31:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
	Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, John@groves.net
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260320203142.GB6254@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
 <20260318213129.GB6004@frogsfrogsfrogs>
 <c7866006-bd17-4fd8-a603-bd3016fdfeb0@gmail.com>
 <20260319160836.GC6004@frogsfrogsfrogs>
 <CAJnrk1Zpxv1CyUn2sbN2j73M57F8r4foyDQQ0Df_g0Ev+yx-Qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1Zpxv1CyUn2sbN2j73M57F8r4foyDQQ0Df_g0Ev+yx-Qg@mail.gmail.com>

On Fri, Mar 20, 2026 at 10:04:29AM -0700, Joanne Koong wrote:

<snip>

> > > >>>> - easier to maintain vs. having to maintain each filesystem's
> > > >>>> userspace server implementation
> > > >>>
> > > >>> Yeah.
> > > >>>
> > > >>>> lklfuse cons:
> > > >>>> - worse (not sure by how much) performance
> > > >>>
> > > >>> Probably a lot, because now you have to run a full IO stack all the way
> > > >>> through lklfuse.
> > > >>
> > > >> How much is "a lot"?  Is it "this is only useful for non-interactive
> > > >> overnight backups", "you will notice this in benchmarks but it's okay
> > > >> for normal use", or somewhere in between?
> > > >
> > > > Startup is painfully slow.  Normal operation isn't noticeably bad, but I
> > > > didn't bother doing any performance comparisons.
> 
> For the CI/filesystem testing use case, could fork() help amortize
> lklfuse's slow startup time? eg start lklfuse + pay LKL initialization
> cost once, fork for each test, and each child mounts its own test
> image?

I suppose you could prefork like that (with some difficulty) if you had
a means to convey the device, fstype, and mount options to each new
child as a mount request comes in.

Though if you had a way to do that, then you might be better off
shipping a canned kernel + hibernate image which would "unhibernate"
quickly, discover the fs parameters, and immediately engage the fuse
server.

> > > >
> > > >> Could lklfuse and iomap be combined?
> > > >
> > > > Probably, though you'd have to find a way to route the FUSE_IOMAP_*
> > > > requests to a filesystem driver.  That's upside-down of the current
> > > > iomap model where filesystems have to opt into using iomap on a
> > > > per-IO-path basis, and then iomap calls the filesystem to find mappings.
> > >
> > > If it does get done it would be awesome.  I don't think I'll be able to
> > > contribute, though.
> >
> > I wonder if one could export a (pnfs) layout from the lklfuse kernel to
> > the real one, that's <cough> where struct iomap came from.  A huge
> > downside to that solution is that layouts don't support out of place
> > writes because pnfs doesn't support out of place writes.
> >
> > > >>>> - once it's merged into the kernel, we can't choose to not
> > > >>>> maintain/support it in the future
> > > >>>
> > > >>> Correct.
> > > >>>
> > > >>>> Am I understanding this correctly?
> > > >>>>
> > > >>>> In my opinion, if near-native performance is not a hard requirement,
> > > >>>> it seems like less pain overall to go with lklfuse. lklfuse seems a
> > > >>>> lot easier to maintain and I'm not sure if some complexities like
> > > >>>> btrfs's copy-on-write could be handled properly with fuse-iomap.
> > > >>>
> > > >>> btrfs cow can be done with iomap, at least on the directio end.  It's
> > > >>> the other features like fsverity/fscrypt/data checksumming that aren't
> > > >>> currently supported by iomap.
> > > >>
> > > >> Pretty much everyone on btrfs uses data checksumming.
> > > >>
> > > >>>> What are your thoughts on this?
> > > >>>
> > > >>> "Gee, what if I could simplify most of my own work out of existence?"
> > > >>
> > > >> What is that work?
> > > >
> > > > Everything I've put out since the end of online fsck for xfs.
> > >
> > > Is pretty much all of that work either on better FUSE performance or
> > > fixes for problems found by fuzzers?
> >
> > Mostly the iomap parts of fuse-iomap.  It's a huge complication to add
> > to the already confusing fuse codebase.
> 
> imo if you did end up going the lklfuse route, I think it'd still be
> useful to have the generic iomap infrastructure pieces of your
> fuse-iomap patchblizzard added, for future new filesystem
> implementations that can provide extent mappings to get near-native IO
> performance.

<nod> But, uh, are those patches going to be reviewed?

--D
