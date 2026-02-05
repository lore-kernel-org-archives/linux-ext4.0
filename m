Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A42FB962;
	Thu,  5 Feb 2026 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770311744; cv=none; b=ViGiaGnDOkJEebZklevrME8L+8MGpSbwV6tcc+/3uJNggZXZR0jN8Kw4yxoFVVdEULB4m3WT9CivOgsNT3dCfaFai+364MoGl9jpUPpevRQ1YV06BqQ8nbnmZiWHBzRzR89aNxTOMGgnoKodgMYpn1MBf06OduX+nkBUeMmgmA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770311744; c=relaxed/simple;
	bh=8XEOcoBijugmmX95CawGn6yWtr31oDeDOH4cP/9b28Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss4OY7g3xv72NV9l9PXxjZnr1w3TYl3gcApoD9PDcZLvx8zOWWbhWTnPMmJELomTuZOSywgaPCBG8hgGK1/voFaBfzoxXl3xTMnRbfxSN2lLFY89hcN206kTxtwe3/CVtxEddRD15OQyauwme0dAqleuG4Sd5iyLWcoBCYug5dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0JvPia+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0JvPia+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C42C4CEF7;
	Thu,  5 Feb 2026 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770311744;
	bh=8XEOcoBijugmmX95CawGn6yWtr31oDeDOH4cP/9b28Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e0JvPia+Z2zSx94XQfJVgIe9gkygPK/mOm9zJI4sltdJZOO6db5/av1kElJ3X1KHN
	 aK3mDejo6hZDYiOnX3x7ryW3VZ+Z46iKeVye9bs0UtC3OaKUTwFN+DS0hfBFU5R8g+
	 4INwcE8U98XwqoqM9GiCkvD/HbhzION66K1xbEg9fM0GGJN1fpVnMplyKpJDGZgsAU
	 ZFi1JXK2IXEfqSLXGC/uEgG83KsSvHQtExtKxad4hgttCm6NJDQIergTsZCK4zM2e3
	 unJO/wPQ2ECiq87c8rcBt8mKG/YOBt2uq1rrXOUbwYKuiOr2phaFYaFOHE/2lptieW
	 LYZXUJXSHvg2w==
Date: Thu, 5 Feb 2026 18:15:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/620: force xattr leaf format for this test
Message-ID: <aYTQNBYBYWElNuan@nidhogg.toxiclabs.cc>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
 <177005945316.2432878.12756542407523044780.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177005945316.2432878.12756542407523044780.stgit@frogsfrogsfrogs>

On Mon, Feb 02, 2026 at 11:11:28AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that the kernel's parent pointer update code skips the attr intent
> mechanism when the attr fork is in local/shortform format, we need to
> bloat the attr fork to force the slow path for error injection testing.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  tests/xfs/620 |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/620 b/tests/xfs/620
> index 42a30630f50ac0..47e042b937eb9c 100755
> --- a/tests/xfs/620
> +++ b/tests/xfs/620
> @@ -55,8 +55,11 @@ file5="file5"
>  
>  echo ""
>  
> -# Create files
> -touch $SCRATCH_MNT/$testfolder1/$file4
> +# Create a file with a 53k xattr to force the attr structure out of short
> +# format.  Parent pointer operations on a shortform attr structure can skip the
> +# attr intent mechanism and therefore do not trigger the larp knob.
> +truncate -s 53535 $SCRATCH_MNT/$testfolder1/$file4
> +$ATTR_PROG -s x $SCRATCH_MNT/$testfolder1/$file4 < $SCRATCH_MNT/$testfolder1/$file4 &>/dev/null
>  _xfs_verify_parent "$testfolder1" "$file4" "$testfolder1/$file4"
>  
>  # Inject error
> 
> 
