Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17743DFC7B
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778059763; cv=none; b=eR8jOgQMISKndsNy9vtPOV2k6d/0545EpOGkSLquq3l2SEzS9tXYesxMvY10VLf+NzooDxmfLcQZxJTu90mAwZ+RQxaUYNd2UNinWZ6bNeyAmWXA8Z6gqNUvavhJc1b7at+s9rLvXqCKNpo+yS11wKzXTStc1Pl2S3q/pH7gqes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778059763; c=relaxed/simple;
	bh=KVQvWWpxUJe5gqCLMD9YOF+O2FjcKrRaRyslDb2wVkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rfTeWYfuntGoSI8K6m9z88Alo+U1/9D9EiXAyoDO0fAFuj+074a3bDAx+Y4bxcFuzaQrk9ropM6h0GZR7iPuUX5/f9n9VmowwAJhFVD7vn12bDycKYoK5PRYwECA9JJLwTGAt3G9V+He+l0vEvji1GnqJUsSru7ecsWlBA6Sf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Z1cmmYEF; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Z1cmmYEF"
Received: from macsyma.thunk.org ([173.239.240.39])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6469T0Cq011013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 6 May 2026 05:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1778059743; bh=pZgN0aMFZrjrmipA4aMh+Kmlr4u4lKUzDxFC01KnC+4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Z1cmmYEFNNOedj78/LgriR0T7L5P1pFIt+VHGpeQguC0XIfnxOSweHcjEiTuYOYH6
	 peMKBEaUB9KHc8SfEl6wGdqvc48FCTWcnnYXggHf/sH9srKgYZ2U74bIQQ/C8nhDWZ
	 HZT4bKruS1sgMfloYVZwzW9oZ+cxBkWYLIWV/ghx88eABIBWC/Cemx2K4wPZW35nZI
	 vcMhjdvsaVr7qPDMjdj++lx441ngcFCAxcqOlOpsG4jjqpsnREwXtYRH+gR/Fl6sFx
	 6duLJvc+jccq0jO6lZt3m9psqeb+CGz03XY3mpgb92IGoKQzwNOuc4XsF91mzZg+Q8
	 xlvfrahP/KhbA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id F3D6866670C3; Wed,  6 May 2026 11:28:58 +0200 (CEST)
Date: Wed, 6 May 2026 11:28:58 +0200
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260506092858.GC49070@macsyma.local>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
 <20260505220441.GB49070@macsyma.local>
 <20260505225635.GT7765@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505225635.GT7765@frogsfrogsfrogs>

On Tue, May 05, 2026 at 03:56:35PM -0700, Darrick J. Wong wrote:
> FUSE kABI 7.20 added FUSE_AUTO_INVAL_DATA, which is bit 12.  It looks to
> me as though they decided to add their own MacOS-specific feature flags
> at the end of the u32 want field.  Then Linux FUSE added 11 more feature
> flags, at which point they unthinkingly ported over FUSE_CACHE_SYMLINKS,
> which collides with FUSE_DARWIN_ACCESS_EXT.  Apparently nobody on the
> macfuse end noticed, so on your machine you're getting whatever
> "ACCESS_EXT" does.

Yeah....

What MacFuse needs to do is to steal some extra fields from struct
fuse_init_in and fuse_init_out for the darwin-specific capabilities.
It turns out it already has conn->{want,capable}_darwin, but there's
no way to pass it in and out of op_init....

#ifdef __APPLE__
	/*
	 * TODO(bf)
	 *
	 * Resolve conflict with vanilla API. We need a separate field flags for
	 * Darwin-only flags. As long as we don't support anything beyond ABI
	 * version 7.19 on the kernel-side this should not be an issue, though.
	 * We need to clean this up when moving to 7.20 or later.
	 */
	if (se->conn.want_darwin & FUSE_DARWIN_CAP_ACCESS_EXT)
		outargflags |= FUSE_DARWIN_ACCESS_EXT;

So I *guess* what MacFuse needs to do is to do something like:

struct fuse_init_in {
	uint32_t	major;
	uint32_t	minor;
	uint32_t	max_readahead;
	uint32_t	flags;
	uint32_t	flags2;
	uint32_t	unused[9];
	uint32_t	darwin_flags;
	uint32_t	darwin_flags2;
};

am I right in understanding that fuse_*_{in,out} is private between
the OS's libfuse and OS's fuse driver or kernel extension, so
it's not disastrous for fuse_kernel.h for Mac and Linux to drift?

> Does this work?
>
> /* MacFUSE overlays feature bits with LinuxFUSE, this is fcked up */
> #if defined(FUSE_CAP_CACHE_SYMLINKS) && !defined(FUSE_CACHE_SYMLINKS)
> 	fuse_set_feature_flag(conn, FUSE_CAP_CACHE_SYMLINKS);
> #endif

What I'm thinking about doing is adding at the beginning of
fuse[24]fs.c:

#ifdef __APPLE__
/*
 * Sigh.... MacFuse is overloading the top bits of the flags field of
 * struct fuse_init_{out} so we have to avoid using these capability
 * flags until this gets fixed in MacFUSE
 */
#undef FUSE_CACHE_SYMLINKS
#undef FUSE_NO_OPENDIR_SUPPORT
#undef FUSE_EXPLICIT_INVAL_DATA
#undef FUSE_MAP_ALIGNMENT
#undef FUSE_SUBMOUNTS
#undef FUSE_HANDLE_KILLPRIV_V2
#undef FUSE_SETXATTR_EXT
#undef FUSE_INIT_EXT
#endif

						- Ted
