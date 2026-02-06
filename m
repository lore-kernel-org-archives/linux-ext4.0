Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46626D4CD;
	Fri,  6 Feb 2026 21:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770415124; cv=none; b=Yj97z9TLZt5AJ3IxtDAoBK+TcX9KNdsN5zUq1lI7zgthE0rCBsjlDGw+HHJtOfrShNHkaLuSN+ApDPxjG3Wi6H2XjX5Mmy4HJyHgZakyTS9V2qcQaVP2KlPkxsnxSRsbvNYZ/ZRPHPOIjugUODwAjbJA3RHEtEY83IbR/4WmrZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770415124; c=relaxed/simple;
	bh=XWLdYpExWOhQ8xx4rvs0QiLJcGXanS6gF4321sARViI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlCjEOVi6kdZW3xfARfYlxtNvFgFc6RIcuYEwtfN5QfLz7UF+H76TdBZW3dlX/9jv4mJeiKDeleiX78lnQ3oe82yKsHeuoco1XFFseS4ZlTTdRmsdnTArForiXsJv82VwetfwZ+eyYHfm9ey344ugHkJNA5Is75lxVwHTNq8blk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMOAJytA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMOAJytA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504A6C116C6;
	Fri,  6 Feb 2026 21:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770415124;
	bh=XWLdYpExWOhQ8xx4rvs0QiLJcGXanS6gF4321sARViI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZMOAJytAlWtuj/beGLAvDP2imKErAYZZvWvYM7B2Q2cuLWS0NByIoOG32jZr4FYDX
	 +HPKTuu3tu4p/CVUR5rp3IVu3WMLsLZjeErDC8F0JbOPk0A3j0dq9HqpsXCOReXw71
	 lNI///xrVNqZW9Fdc+zzjPTxjxdXhDJ8qObK2rq8SqbMESn7yvbDlwDEfKIHShuQil
	 52rwd+HJ/9UlSa10i+PW2sFH9lIqbqLkydHOZ9A/x6YMDNm3RZAgBGRH94j2C7ShVh
	 gB1x57mXdz0p31WsJ1yVfpyQKrcGdt3ZfHzBt86bBhAMHk/hSdqmUt2BQNKlNTt2eP
	 cc1Nn5fsUUKpA==
Date: Fri, 6 Feb 2026 13:58:44 -0800
From: Kees Cook <kees@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH ALTERNATIVE] ext4: Treat s_mount_opts and mount_opts as
 __nonstring
Message-ID: <202602061357.1A2A8038@keescook>
References: <20260206214613.work.184-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206214613.work.184-kees@kernel.org>

On Fri, Feb 06, 2026 at 01:46:18PM -0800, Kees Cook wrote:
> Effectively revert 8ecb790ea8c3, 3db63d2c2d1d, and ee5a977b4e77, and fix
> 04a91570ac67 to treat s_mount_opts and ext4_tune_sb_params::mount_opts
> as __nonstring.

Ignore this patch version, please. Darrick's archeology
suggests it is not the right direction to go:
https://lore.kernel.org/lkml/20260206214502.GP7686@frogsfrogsfrogs/

-- 
Kees Cook
