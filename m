Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3040DFDA
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940025; cv=none; b=Q4L49O2JJGoO9mc5EeugQ0MQMgEkHLgW7ezY17q1oQqSZb6dE8iWw87YjVxqGiR5J6GiBfm/5WKHTVgFBWJzlkyixDVPV4EWcMyF/XjePkLpY23K8BAMWxTwJv/QawSpHNtMD27IOU+BQVJju4LLKSdCIFgIe9EboroSWFzVGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940025; c=relaxed/simple;
	bh=BpGSKCuDywMx9D2zpgP7OnEWCBicQ9MMuPe0eXfBF6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoRlYzN4FM98RTl65XilvUEH+X2d83gVGwYtl19YciFcLmmVncTyfta1p2vaOhPUjT+RC96xeIhSb4u3VnHKLJcqCZqNV0s6tJHOfL7OwI1Jp0lEEqbN3qTv13tI2QhvWgkA/c74yA8w1iEsj9qY6CVILI3jjCzUsX4iEf3lDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtftkVxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtftkVxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D0CC2BCB8;
	Tue,  5 May 2026 00:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940024;
	bh=BpGSKCuDywMx9D2zpgP7OnEWCBicQ9MMuPe0eXfBF6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KtftkVxY3Z7wl1Up0Ys00aBJMCxYXB6U9N4CCSPpVvrDHH8rrafusmMWcKWGT3Hgk
	 jSPrx9HrAhiGpt3jtKb69j8Pp61vu/Oy3et95oXTZkr8cn7wtxfEoPR8HwnUFyFnIr
	 4y5RltrcpxOYyKk1/pcAvoaYhPmp+cLQeLfW4n40O+YOxgCgjaa9nEtZqpwxsk69XP
	 t/RpOKTFh5sFEnOc8yh7GzJSFfy52H1oVToGutWP+bwjPL9d8OYccyipgvgfoiADMS
	 GGdHoravyAkmyLYc+RbjxJI5Z2iKbbNfetFNS34cxXNSsxyaVf8TWzGvL0m5ZWxz4T
	 r2sMJTZJrGA5Q==
Date: Mon, 4 May 2026 17:13:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/7] configure.ac: fix disable fuse2fs/fuse4fs by default
 path
Message-ID: <20260505001344.GC1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-3-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-3-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:56PM -0400, Theodore Ts'o wrote:
> If the fuse.h header file is not present, fix the "Disabling
> fuse[24]fs by default" codepath to actually disable trying to build
> fuse2fs or fuse4fs.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Fixes: 239f4b7ac05b ("fuse2fs: separate libfuse3 and fuse2fs detection in configure")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Oops.  I hadn't tried building without a fuse.h in a while. :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  configure    | 2 ++
>  configure.ac | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/configure b/configure
> index a1a270e63..d941ff1f1 100755
> --- a/configure
> +++ b/configure
> @@ -14737,6 +14737,7 @@ else case e in #(
>  		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Enabling fuse2fs by default" >&5
>  printf "%s\n" "Enabling fuse2fs by default" >&6; }
>  	else
> +		FUSE2FS_CMT="#"
>  		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Disabling fuse2fs by default" >&5
>  printf "%s\n" "Disabling fuse2fs by default" >&6; }
>  	fi
> @@ -14804,6 +14805,7 @@ else case e in #(
>  		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Enabling fuse4fs by default" >&5
>  printf "%s\n" "Enabling fuse4fs by default" >&6; }
>  	else
> +		FUSE4FS_CMT="#"
>  		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Disabling fuse4fs by default" >&5
>  printf "%s\n" "Disabling fuse4fs by default" >&6; }
>  	fi
> diff --git a/configure.ac b/configure.ac
> index abce79594..d8f40f5df 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1459,6 +1459,7 @@ AS_HELP_STRING([--disable-fuse2fs],[do not build fuse2fs]),
>  	then
>  		AC_MSG_RESULT([Enabling fuse2fs by default])
>  	else
> +		FUSE2FS_CMT="#"
>  		AC_MSG_RESULT([Disabling fuse2fs by default])
>  	fi
>  ]
> @@ -1496,6 +1497,7 @@ AS_HELP_STRING([--disable-fuse4fs],[do not build fuse4fs]),
>  	then
>  		AC_MSG_RESULT([Enabling fuse4fs by default])
>  	else
> +		FUSE4FS_CMT="#"
>  		AC_MSG_RESULT([Disabling fuse4fs by default])
>  	fi
>  ]
> -- 
> 2.53.0
> 
> 
