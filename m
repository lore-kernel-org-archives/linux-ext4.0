Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBF930AD1A;
	Wed,  6 May 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778085576; cv=none; b=iiiW5yYZShuNViNxs+VrhJwSs38lJw+7pK1UZIdF9Har+uf+rQliq5By8ztTuBum9P2Q8XKkXIlUQPc6lJz+7lthDSSkFMZOuqEh0CRcbttnzid+p+TyB0ofMQiQ+y0wUlTJUCqtrkMsK/n/Ra7UlxyoNI90lsFnZwoPZcexDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778085576; c=relaxed/simple;
	bh=JZScTMhYDrtXo3qo/qIcHOinHboPNrrOUK36uTb5gdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4u1T1l07tIhMCtQd/y/QuBzNwMRLnKc2GxkIr2daddCJj5expPB3iOrQwLKEWdXD4yosHZoCTRdOpic6exn9CyakXNLU9PdisPxe/l1ghgdkiT4Z8Kg/Lo4EiSiZMQv+ZLJU0e14HXq/o7rqrDw6xbN79kln5ZdkNbNP5O9Agw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aizxmlLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aizxmlLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE39C2BCB0;
	Wed,  6 May 2026 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085576;
	bh=JZScTMhYDrtXo3qo/qIcHOinHboPNrrOUK36uTb5gdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aizxmlLm1VxihnL3ohHcBMe7o+Mc5fiGzW5O40RyC6yg2B/xUe496lVOAt0rmgaUC
	 uVdNv4l9PhluM5GmzG0mP+Fgq4+395iH2RUwMhnT56aHpm0UuxnllhoZONB3dL18N6
	 ZdHjgsZqq20YDnaDd9SE2CkWZzWTt53OKsuC4Sy/CTQCaUugdiAwI79FKrL41VrWW5
	 Q3bjdVUW5EzPBXRebWTQRvshjgIB7ux7DKKqcDdfCSVCn0qn4mJIO6JxyumKJCC6IJ
	 26m27G1IQ/Wlju807uXsJzJm8/3o0kFgkxAYE0KYYll2ippBaUmfPTAdvDDWDQ9+m3
	 TEuB6NnBaG6Ug==
Date: Wed, 6 May 2026 09:39:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260506163935.GB2241589@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
 <20260505220441.GB49070@macsyma.local>
 <20260505225635.GT7765@frogsfrogsfrogs>
 <20260506092858.GC49070@macsyma.local>
 <20260506143413.GA2241589@frogsfrogsfrogs>
 <20260506150833.GD49070@macsyma.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506150833.GD49070@macsyma.local>

On Wed, May 06, 2026 at 05:08:33PM +0200, Theodore Tso wrote:
> On Wed, May 06, 2026 at 07:34:13AM -0700, Darrick J. Wong wrote:
> > [cc fuse-devel]
> > 
> > TLDR for the fuse developers: Ted and I discovered a collision between
> > the upstream libfuse feature bits and the MacFUSE feature bits, which
> > causes macfuse to do the wrong thing if you try to enable symlink
> > pagecache.
> 
> This is the patch for fuse2fs and fuse4fs in e2fsprogs which works
> around the problem (tested on MacOS using macfuse 5.2.0_1 from
> MacPorts).  More details about why it was needed is in the commit
> description.
> 
> 					- Ted
> 
> From 67f1ec55a1309abead16cad883e38b798a567191 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Wed, 6 May 2026 10:51:56 -0400
> Subject: [PATCH] fuse2fs, fuse4fs: Fix MacFuse compatibility issue
> 
> Unfortunately, MacFuse is overloading the top bits of the flags field
> in struct fuse_init_{out} for MacFuse-specific capability extensions.
> This results in an attempt to use FUSE_CAP_CACHE_SYMLINKS when linking
> with the libfuse in MacPorts will end up enabling
> FUSE_DARWIN_CAP_ACCESS_EXT with MacFuse.  Hilarity then ensues with
> all non-privileged access failing with permission denied.
> 
> The change which is needed in MacFuse is described in a TODO(bf)
> statement:
> 
> https://github.com/macfuse/library/blob/ddb630db8327a50b6670ef5e4f5e6da82a549e99/lib/fuse_lowlevel.c#L3415
> 
> I plan to submit a bug report to MacFuse, but in the mean time, work around
> the problem by disabling the overloaded capability flags on MacOS.
> 
> Link: https://lore.kernel.org/r/20260505225635.GT7765@frogsfrogsfrogs
> Link: https://lore.kernel.org/r/20260506092858.GC49070@macsyma.local
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks fine for now...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fuse4fs/fuse4fs.c | 18 ++++++++++++++++++
>  misc/fuse2fs.c    | 18 ++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
> index 92847326..2739da92 100644
> --- a/fuse4fs/fuse4fs.c
> +++ b/fuse4fs/fuse4fs.c
> @@ -120,6 +120,24 @@
>  #endif
>  #endif /* !defined(ENODATA) */
>  
> +#ifdef __APPLE__
> +/*
> + * Sigh.... MacFuse is overloading the top bits of the flags field in
> + * struct fuse_init_{out} for MacFuse-specific capability extensions.
> + * Avoid using these fuse3 capability flags until this gets fixed in
> + * MacFUSE
> + */
> +#undef FUSE_CAP_CACHE_SYMLINKS
> +#undef FUSE_CAP_NO_OPENDIR_SUPPORT
> +#undef FUSE_CAP_EXPLICIT_INVAL_DATA
> +#undef FUSE_CAP_EXPIRE_ONLY
> +#undef FUSE_CAP_SETXATTR_EXT
> +#undef FUSE_CAP_DIRECT_IO_ALLOW_MMAP
> +#undef FUSE_CAP_PASSTHROUGH
> +#undef FUSE_CAP_NO_EXPORT_SUPPORT
> +#undef FUSE_CAP_OVER_IO_URING
> +#endif
> +
>  #define FUSE4FS_ATTR_TIMEOUT	(0.0)
>  
>  static inline uint64_t round_up(uint64_t b, unsigned int align)
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index c46cfc23..0f2a3c35 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -116,6 +116,24 @@
>  #endif
>  #endif /* !defined(ENODATA) */
>  
> +#ifdef __APPLE__
> +/*
> + * Sigh.... MacFuse is overloading the top bits of the flags field in
> + * struct fuse_init_{out} for MacFuse-specific capability extensions.
> + * Avoid using these fuse3 capability flags until this gets fixed in
> + * MacFUSE
> + */
> +#undef FUSE_CAP_CACHE_SYMLINKS
> +#undef FUSE_CAP_NO_OPENDIR_SUPPORT
> +#undef FUSE_CAP_EXPLICIT_INVAL_DATA
> +#undef FUSE_CAP_EXPIRE_ONLY
> +#undef FUSE_CAP_SETXATTR_EXT
> +#undef FUSE_CAP_DIRECT_IO_ALLOW_MMAP
> +#undef FUSE_CAP_PASSTHROUGH
> +#undef FUSE_CAP_NO_EXPORT_SUPPORT
> +#undef FUSE_CAP_OVER_IO_URING
> +#endif
> +
>  static inline uint64_t round_up(uint64_t b, unsigned int align)
>  {
>  	unsigned int m;
> -- 
> 2.50.1 (Apple Git-155)
> 
