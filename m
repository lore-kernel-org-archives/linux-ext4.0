Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631532AAC6;
	Mon, 16 Mar 2026 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773684249; cv=none; b=Y19U7HEEoeQTTo+rVB8/Ce591n0Hi3HDjy8kTKbxGTu4wh0RK0OHOpdAiadxR61pWwWV5v8AVX5Jga6EsmgiLhCMN/tg4e6rB/aU2ozRfddo7chAQbKm7awVLzy2sfjMJnwuwSwbYKFtaYyVJ3tGAegRcM08168xMhhJjcqFXiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773684249; c=relaxed/simple;
	bh=MdzIdWQdB6/0O+Y3X+HfYwTMzesqw9GBvsSVrhKiWzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldKxxZvb37kKS5K4JkzZTHdIpMSwYFUtbQTxGVVBlFKHczTbPmKNUI/TrRr/z14FUDFFETiU2gloedMBIxdDtxI/31DHOjRWMCDrK9FrtvqQ0oEle0TpCfvfhMP8fcAEwQUFdfYcuFGlWl2fweZUCz7vTH/saCKaHdOgS7QyEdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GljNzK2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GljNzK2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BFCC19421;
	Mon, 16 Mar 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773684248;
	bh=MdzIdWQdB6/0O+Y3X+HfYwTMzesqw9GBvsSVrhKiWzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GljNzK2Qmgwm+ydpmr0DnrZIk33VV2XlvRY2TTmh/QTQaPmdwlnkUm5su0R7GBEDJ
	 AgSahsxxb2J+eSadkK8Lj5pE3aScRcu/IxhoAwNmxi8vwFHiOIjMXRQcd24q+YG6EW
	 bg/q48k81FOLHPJ21rKyg5j9TyTZFwcRCprIcUtQzfo28zSLv0KCD2Zn9lOHlCHdGO
	 drYatWgZHaTbsHjXOE5F45J+FeAPZiKsxaOpVMWLp01f60QhCDgeZjFLpvMnH27Nry
	 K2MKh8C1eyc1e1JcVVssqGqnJubc4xYqzMR1p3JDiOLVESFnoH7xkggmdjDHAH9oeA
	 3XP8bTXuD3HdA==
Date: Mon, 16 Mar 2026 11:04:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
	Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, John@groves.net,
	demiobenour@gmail.com
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260316180408.GN6069@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>

On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
> On Mon, Feb 23, 2026 at 2:46 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > There are some warts remaining:
> >
> > a. I would like to continue the discussion about how the design review
> >    of this code should be structured, and how might I go about creating
> >    new userspace filesystem servers -- lightweight new ones based off
> >    the existing userspace tools?  Or by merging lklfuse?
> 
> What do you mean by "merging lklfuse"?

Merging the lklfuse project into upstream Linux, which involves running
the whole kit and caboodle through our review process, and then fixing
user-mode-linux to work anywhere other than x86.

> Could you explain what the limitations of lklfuse are compared to the
> fuse iomap approach in this patchset?

The ones I know about are:

1> There's no support for vmapped kernel memory in UML mode, so anyone
who requires a large contiguous memory buffer cannot assemble them out
of "physical" pages.  This has been a stumbling block for XFS in the
past.

2> LKLFUSE still uses the classic fuse IO paths, which means that at
best you can directio the IO through the lklfuse kernel.  At worst you
have to use the pagecache inside the lklfuse kernel, which is very
wasteful.

3> lklfuse hasn't been updated since 6.6.

--D

> Thanks,
> Joanne
> 
> >
> > b. ext4 doesn't support out of place writes so I don't know if that
> >    actually works correctly.
> >
> > c. fuse2fs doesn't support the ext4 journal.  Urk.
> >
> > d. There's a VERY large quantity of fuse2fs improvements that need to be
> >    applied before we get to the fuse-iomap parts.  I'm not sending these
> >    (or the fstests changes) to keep the size of the patchbomb at
> >    "unreasonably large". :P  As a result, the fstests and e2fsprogs
> >    postings are very targeted.
> >
> > e. I've dropped the fstests part of the patchbomb because v6 was just
> >    way too long.
> >
> > I would like to get the main parts of this submission reviewed for 7.1
> > now that this has been collecting comments and tweaks in non-rfc status
> > for 3.5 months.
> >
> > Kernel:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap-bpf
> >
> > libfuse:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=fuse-iomap-bpf
> >
> > e2fsprogs:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse-iomap-bpf
> >
> > fstests:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuse2fs
> >
> > --Darrick
