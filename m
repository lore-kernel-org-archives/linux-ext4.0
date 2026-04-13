Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA663090F5;
	Mon, 13 Apr 2026 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097281; cv=none; b=nXt5Qf2K7GmV1aO1LAvKRNGxm9vRm7umuSqYgKq0G13r4moT/0iS325DwuBh84eNxL3W3wzF+zPawmNxlqcqyOU5gFObMWMEiHnggf8yyEJfWR8j8jn53ctIuWPQnHBKsjhLcJz1erbbmr5Suy4Poxd1m/7I3ga9aRLu8aSOS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097281; c=relaxed/simple;
	bh=O8OYQDMTExEI2f8C5otNWcIi+vWaO5lcV5O0bPD3+/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ol2PbUXcuWD61SbY5TZz7loj1hF9FzBBU39J+3ngEbo3d03bxeT0fl6YwfupVmZd9XL5re7grTbkTzjZ9NyJL5+udtwRs5tLph0tDa0C0xBvMn/5jZsx8zPXSrOnX/VYTLHQYuqCJfw3xCGJR9nwxxQGU9bZdVxv9plnWQESA+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6VFCxQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6VFCxQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E702DC2BCAF;
	Mon, 13 Apr 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776097281;
	bh=O8OYQDMTExEI2f8C5otNWcIi+vWaO5lcV5O0bPD3+/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u6VFCxQ0V2BTAC75VtObWrHzDFZwbJkiViMywbC1VlhZ5UQa+ibJfD3os2LiOCBAu
	 OpWoW0YP/MVxI3SFaUmGnMfz8og7/bV+sD8mOH4fAuCj8LeM1mtwoMf0gaGdKW2w7R
	 aGVbp7kdnJw/KoxDEARMgDZVvaLtBDY9oAGeht302Jkz3grWNj5g9VZDoe7QsYwIK1
	 FZnodkk/38IliedD3n3ZU2AjXkfaueN0BruCcprhWlTRuIDcycqz1wnbkZ93x/lKgR
	 Lo0zubLVpxQdvp4tY8lk3vOXvXwpxrHGpEFqmxcny9VySDqrw9K2yqBFVrLG/vo9mn
	 /Dea+mIWGgvXw==
Date: Mon, 13 Apr 2026 09:21:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	fdmanana@suse.com, ritesh.list@gmail.com, naohiro.aota@wdc.com,
	wqu@suse.com, Disha Goel <disgoel@linux.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] generic/765: Ignore mkfs warning
Message-ID: <20260413162120.GV6212@frogsfrogsfrogs>
References: <cover.1775802601.git.ojaswin@linux.ibm.com>
 <afee4fedcc9b3685df0e05800d82b88d27f977f8.1775802601.git.ojaswin@linux.ibm.com>
 <20260410165435.GU6212@frogsfrogsfrogs>
 <advRgjl1tG4PMc6V@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Mon, Apr 13, 2026 at 02:34:11PM +0530, Ojaswin Mujoo wrote:
> On Sun, Apr 12, 2026 at 10:38:18PM +0530, Ojaswin Mujoo wrote:
> > On Fri, Apr 10, 2026 at 09:54:35AM -0700, Darrick J. Wong wrote:
> > > On Fri, Apr 10, 2026 at 12:06:04PM +0530, Ojaswin Mujoo wrote:
> > > > This test validates atomic writes for all possible block sizes. In ext4, for
> > > > smaller block sizes with configurations like:
> > > > 
> > > > export MKFS_OPTIONS="-O bigalloc,quota -b 65536 -C 131072"
> > > > 
> > > > The output can get corrupted with warnings like below because clustersize
> > > > more than 16xbs is experimental:
> > > > 
> > > > + 16 times the block size is considered experimental
> > > > 
> > > > Hence pipe these to seqres.full to avoid false negatives.
> > > > 
> > > > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > 
> > > Seems fine, though I think I'd rather mke2fs get patched to fix this.
> > > 
> > > I'd let the maintainer decide if he wants this, but ... I'm not sure if
> > > he's actually going to receive this message. :/
> > 
> > Hi Darrick, yes I'm preparing a quick patch for this. We might still
> > need this so people on older distro who wont have the e2fsprogs fix dont
> > see the failure.
> 
> Hi Darrick,
> 
> Looking at it again, I am just wondering if its really an issue that
> mke2fs is printing this warning to stderr. Isn't stderr the right place
> for errors and warning (even non critical ones)?
> 
> Futher, mke2fs has multiple instances where we print warnings to stderr,
> should we go and fix all of them as well?

"stderr" meaning "standard error", I'd say that errors are anything that
prohibits the format from completing, and only errors should go there.

We ought to kick this to the ext4 list though...

--D

> Regards,
> ojaswin
> 
> > 
> > Regards,
> > ojaswin
> > 
> > > 
> > > --D
> > > 
> > > > ---
> > > >  tests/generic/765 | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tests/generic/765 b/tests/generic/765
> > > > index 09be53db..b7cc70f1 100755
> > > > --- a/tests/generic/765
> > > > +++ b/tests/generic/765
> > > > @@ -64,7 +64,8 @@ test_atomic_writes()
> > > >      local bsize=$1
> > > >  
> > > >      get_mkfs_opts $bsize
> > > > -    _scratch_mkfs $mkfs_opts >> $seqres.full
> > > > +    _scratch_mkfs $mkfs_opts &>> $seqres.full || \
> > > > +        echo "mkfs $mkfs_opts failed"
> > > >      _scratch_mount
> > > >  
> > > >      test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > > > -- 
> > > > 2.53.0
> > > > 
> > > > 
> 
