Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5B246AF0F;
	Wed,  6 May 2026 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778078054; cv=none; b=omgbHkuJX4ELJpGIX1cJWwi1cdG2ReoeAsP7BygXdPlKejbNUaXIGdMxf7vHE6Xu3QZBpBkdkrRIaRmRT3/WbnnaVNvxay98wD/Tgf8VtmJlu4QDfwF98te9hN6Ywmq2B3wnm/6V53RW0x+tepgzPv0kQTUo23yOygBT5DXjXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778078054; c=relaxed/simple;
	bh=KzJaDkP8gIuv1rzeEWn0SEz9DAZ9C1moARBZfpFXUa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyEIfFU8JANLTWqbcYFTXqnkUgIxutKvA8fTrCkU/AkjBNhXQDQWJ7rY9LtGkzwAQWlXrP3cNrpDcgoW6H3aA4FSiqjukUW51wCMfO259n0pqjUzmOBIyf+s/ClHlR7Tj3avN2m/x/9bhQpkkAM9k7H9B8OlV8eneIO+AgE+WdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6pw9lni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6pw9lni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E29AC2BCB0;
	Wed,  6 May 2026 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078054;
	bh=KzJaDkP8gIuv1rzeEWn0SEz9DAZ9C1moARBZfpFXUa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P6pw9lnioz9idCO98K7lGG0cK1vT+vsrskUP3LjZsqwttEZJFOE9dg+o2alsjTyEk
	 XkdCHipYtuRAufdTP5Pt+Hoc97t95/FbadfC3RY6W513+O38Kgu03pQgGbRQ78PcYe
	 /AQS0kdChoxWzF2cRBIlsHj7Y8NuVncmLyA0BPn3PnxNQm4lu4Ta8B09acnJjx0Wz7
	 kbJu2GNYE4hEH3mVVz62BTL2d3Xnj56qCJmSS0fnjhJMvk1rm423OFC4SYkbQZU32c
	 a5MmE5i2Wc47WkcIejIWrewmt5LTQ7KQPzGvqdjn1UFni/XV8i43lREWoseGUW9qex
	 yeGo40+jetBQw==
Date: Wed, 6 May 2026 07:34:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260506143413.GA2241589@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
 <20260505220441.GB49070@macsyma.local>
 <20260505225635.GT7765@frogsfrogsfrogs>
 <20260506092858.GC49070@macsyma.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506092858.GC49070@macsyma.local>

[cc fuse-devel]

TLDR for the fuse developers: Ted and I discovered a collision between
the upstream libfuse feature bits and the MacFUSE feature bits, which
causes macfuse to do the wrong thing if you try to enable symlink
pagecache.

https://lore.kernel.org/linux-ext4/20260505225635.GT7765@frogsfrogsfrogs/

On Wed, May 06, 2026 at 11:28:58AM +0200, Theodore Tso wrote:
> On Tue, May 05, 2026 at 03:56:35PM -0700, Darrick J. Wong wrote:
> > FUSE kABI 7.20 added FUSE_AUTO_INVAL_DATA, which is bit 12.  It looks to
> > me as though they decided to add their own MacOS-specific feature flags
> > at the end of the u32 want field.  Then Linux FUSE added 11 more feature
> > flags, at which point they unthinkingly ported over FUSE_CACHE_SYMLINKS,
> > which collides with FUSE_DARWIN_ACCESS_EXT.  Apparently nobody on the
> > macfuse end noticed, so on your machine you're getting whatever
> > "ACCESS_EXT" does.
> 
> Yeah....
> 
> What MacFuse needs to do is to steal some extra fields from struct
> fuse_init_in and fuse_init_out for the darwin-specific capabilities.
> It turns out it already has conn->{want,capable}_darwin, but there's
> no way to pass it in and out of op_init....
> 
> #ifdef __APPLE__
> 	/*
> 	 * TODO(bf)
> 	 *
> 	 * Resolve conflict with vanilla API. We need a separate field flags for
> 	 * Darwin-only flags. As long as we don't support anything beyond ABI
> 	 * version 7.19 on the kernel-side this should not be an issue, though.
> 	 * We need to clean this up when moving to 7.20 or later.
> 	 */
> 	if (se->conn.want_darwin & FUSE_DARWIN_CAP_ACCESS_EXT)
> 		outargflags |= FUSE_DARWIN_ACCESS_EXT;
> 
> So I *guess* what MacFuse needs to do is to do something like:
> 
> struct fuse_init_in {
> 	uint32_t	major;
> 	uint32_t	minor;
> 	uint32_t	max_readahead;
> 	uint32_t	flags;
> 	uint32_t	flags2;
> 	uint32_t	unused[9];
> 	uint32_t	darwin_flags;
> 	uint32_t	darwin_flags2;
> };
> 
> am I right in understanding that fuse_*_{in,out} is private between
> the OS's libfuse and OS's fuse driver or kernel extension, so
> it's not disastrous for fuse_kernel.h for Mac and Linux to drift?

Yeah, the easiest method would be to carve out the darwin_flags field.

If they still want to use flags/flags2, then they could probably still
fix it by redefining whichever feature was added later (probably
FUSE_CACHE_SYMLINKS) because right now they're broken, so it's not an
ABI break to redefine the symbol.

Either way someone will have to talk to the MacFUSE people about this.

> > Does this work?
> >
> > /* MacFUSE overlays feature bits with LinuxFUSE, this is fcked up */
> > #if defined(FUSE_CAP_CACHE_SYMLINKS) && !defined(FUSE_CACHE_SYMLINKS)
> > 	fuse_set_feature_flag(conn, FUSE_CAP_CACHE_SYMLINKS);
> > #endif
> 
> What I'm thinking about doing is adding at the beginning of
> fuse[24]fs.c:
> 
> #ifdef __APPLE__
> /*
>  * Sigh.... MacFuse is overloading the top bits of the flags field of
>  * struct fuse_init_{out} so we have to avoid using these capability
>  * flags until this gets fixed in MacFUSE
>  */
> #undef FUSE_CACHE_SYMLINKS
> #undef FUSE_NO_OPENDIR_SUPPORT
> #undef FUSE_EXPLICIT_INVAL_DATA
> #undef FUSE_MAP_ALIGNMENT
> #undef FUSE_SUBMOUNTS
> #undef FUSE_HANDLE_KILLPRIV_V2
> #undef FUSE_SETXATTR_EXT
> #undef FUSE_INIT_EXT
> #endif

That works for now.  If macfuse fixes themselves, then I guess we could
turn that into a configure check.

--D

> 
> 						- Ted
