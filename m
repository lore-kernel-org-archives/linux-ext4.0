Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A778D17A300
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940811; cv=none; b=sm8ShTx/g2LfVbw0YRKd2dwN3PBGd9QgO57mdx9hUXI+PHADWmWVoqJa+pwEBjmjKg2rY5TBBHAaxOmbYeIU1l3AXyRxYGtfRpb/JTZqPNmw+opTxINpXoXRqj+BLAI1XcSJqD0wamPww0owOh6SMmdqNlG3hkB3sc4rGKd8C6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940811; c=relaxed/simple;
	bh=ieXoS6LLteuEXFQ28J/3fC5XqbGUwcT25I9OMdKpE9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+VpJoqax+edIldS8LS5a4QtwrseHlwHkeXfSTGxOHUMQvmDA0Aq/meoq9X/+3Q0+V/3R60513adpdN/INn3Kq1On2633qYBKMv0ACqIY2icQX8iNaNOwYIbdHjyEVfOBiQDPnyK6/JbZmNalWQrhLXYaOunLV2096ak/I/7n50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Edrpl+Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Edrpl+Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B03C2BCB8;
	Tue,  5 May 2026 00:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940811;
	bh=ieXoS6LLteuEXFQ28J/3fC5XqbGUwcT25I9OMdKpE9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Edrpl+NrhPH1rICrVYTUP0kOlHqk/evIfsFN0BjddWeL330RxpYHdHMwM/plzBisY
	 JNHchDipe1+j5q3KJrQ0EZySAuZ2jXjrI3pUGpNdwGqwuY5Tay8FGULTnsLZ80SMUn
	 3Zr4bZbEphdfjP9fwhnACloeMDAQMBdm7U2rkatBXm+2gm3g1tokkmZvNYfGrcTT5i
	 s9RIYtrxOo6vj1Qi7L/TVLG2w+cdV0dymE3A4yfWPAc1t/1XRUHXVlwDUzo2rEZ8Ze
	 1p3Loyc2yulJxB9B9zH6W5GOjcy4LDIff4GYtooUM/zoVakwPk5N4V7VI1uq2QvFR3
	 tUb0ohpccVQLg==
Date: Mon, 4 May 2026 17:26:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 7/7] fuse2fs: fix uninitialized variable warnings
Message-ID: <20260505002650.GH1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-8-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-8-tytso@mit.edu>

On Mon, May 04, 2026 at 07:33:01PM -0400, Theodore Ts'o wrote:
> Clang treats use of unitialized variables found by static analysis to
> be serious enough that it will emit them by default (even without
> -Wall).  So let's fix them up.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

I wonder why gcc doesn't complain about this??

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fuse4fs/fuse4fs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
> index b883083f8..928473268 100644
> --- a/fuse4fs/fuse4fs.c
> +++ b/fuse4fs/fuse4fs.c
> @@ -2216,7 +2216,7 @@ static void op_mknod(fuse_req_t req, fuse_ino_t fino, const char *name,
>  	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
>  	struct fuse4fs *ff = fuse4fs_get(req);
>  	ext2_filsys fs;
> -	ext2_ino_t parent, child;
> +	ext2_ino_t parent, child = 0;
>  	errcode_t err;
>  	int filetype;
>  	gid_t gid;
> @@ -2311,7 +2311,7 @@ static void op_mkdir(fuse_req_t req, fuse_ino_t fino, const char *name,
>  	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
>  	struct fuse4fs *ff = fuse4fs_get(req);
>  	ext2_filsys fs;
> -	ext2_ino_t parent, child;
> +	ext2_ino_t parent, child = 0;
>  	errcode_t err;
>  	char *block;
>  	blk64_t blk;
> @@ -2990,7 +2990,7 @@ static void op_symlink(fuse_req_t req, const char *target, fuse_ino_t fino,
>  	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
>  	struct fuse4fs *ff = fuse4fs_get(req);
>  	ext2_filsys fs;
> -	ext2_ino_t parent, child;
> +	ext2_ino_t parent, child = 0;
>  	errcode_t err;
>  	gid_t gid;
>  	int ret = 0;
> @@ -6042,7 +6042,7 @@ static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
>  	struct fuse_cmdline_opts opts;
>  	struct fuse_session *se;
>  	struct fuse_loop_config *loop_config = NULL;
> -	int ret;
> +	int ret = 0;
>  
>  	if (fuse_parse_cmdline(args, &opts) != 0) {
>  		ret = 1;
> -- 
> 2.53.0
> 
> 
