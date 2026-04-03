Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B2427EFF7
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189895; cv=none; b=NTWSKhQ+Sc93TT4sPLgfzxLwO2fISdDJxSI1gEQPEuRihGJjeB+uQDzAHhJKYt+SE/rlqVT+WEaTqX0YzOESQwMnjCNLKcwPTAJ3unWtFtsY4wqQo/YRQNwlE6vzc6Muac1A7F7yblNL5B2q79ZZN/dJbTwJfFePW0dWkpVE2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189895; c=relaxed/simple;
	bh=1XvAJroVsdiH03IWZxxIRklsAhkvn3FmlGrD72/C4HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phTcByDoOmCeZNPqamYpqUM0+3DJwn4V+oxwcts76GWi//VSgeQC28qiHZacOxWCyvKUSZ97OjWMHRlKDAEEbc7GhjYf8y0EzemW4ukKjQ8F3z4ohVRGQ8y+W2Wj4hPI9YM8CSBsfeaGK/82Xgyk+NSUJtrys8kX7IW09FLHbpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=terlKr/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="terlKr/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE09AC4CEF7;
	Fri,  3 Apr 2026 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775189895;
	bh=1XvAJroVsdiH03IWZxxIRklsAhkvn3FmlGrD72/C4HE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=terlKr/wb/YYYrLfdayPBN3y/iCErr0XFHQVv9DhBhM7rX7lCmBqlsPGrShiLV/8H
	 bCUp5YP9AaqQkQsS2jZtjtXQKgofvMpEHsgQI75rb4kbHydZhoRZh8eQIRi40781LW
	 oPabyvqlIxpFXlJM0zDiI1HMCXOD/d4hRXzIxsBzoC5xbEpYKUS1vYETUoYsdGDxV6
	 CnUMCgAu5kRtB8UipK+LYKbCn4bhuueXcquRY+DMlHPkL0mugyxMHCVd5Lnc3DAFXv
	 dSaLad8xyjr3yvipcfoio3sNOH3ACdqOOFAbKI/D5emcdEJn+GoRVhEfA0srABt43j
	 X4XUwLIb7Y2cQ==
Date: Thu, 2 Apr 2026 21:18:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] fuse2fs: fix build failure on systems which don't
 define EUCLEAN
Message-ID: <20260403041814.GF6254@frogsfrogsfrogs>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-4-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403040328.2385083-4-tytso@mit.edu>

On Fri, Apr 03, 2026 at 12:03:28AM -0400, Theodore Ts'o wrote:
> MacOS doesn't have EUCLEAN, so we use EIO as the closest error code.
> But then we need to avoid a compile error caused by a duplicate case
> labels of EUCLEAN and EIO.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  misc/fuse2fs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index dfbc98636..94e289fab 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -5870,7 +5870,9 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
>  #ifdef EILSEQ
>  	case EILSEQ:
>  #endif
> +#if EUCLEAN != EIO
>  	case EUCLEAN:
> +#endif
>  		/* these errnos usually denote corruption or persistence fail */
>  		is_err = 1;
>  		ret = -err;
> -- 
> 2.51.0
> 
