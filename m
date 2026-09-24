Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66D2931FB
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790222433; cv=none; b=mqwXXNoxCdLpc0qMt02SKvAggO4ewV5csQOqnvzskLx9Lmit65EGtxfdN/yisLYuibe6o0Idd4T4OBBO1C+JNTmaLEhEw/sPq8qDKxeDx4c3/VhD9nCSgOSEBplUScGRmtVrzVyhkWzor2TMVeOZm34o6hULP6uVCLbZTAjjgT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790222433; c=relaxed/simple;
	bh=8yoExV+A7v6d6Va3ZU9FeW5bY/4IbDIV68Ws4icaJwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsCySlcn5DYrlQuRGjtVlvTOXCsZydgGlfDfmH0laAVw4Vsaj14CayHL5S9+DtKGBZsNymukN2XjXxyq0FlKdTr9lZj6U0CKWoGyacCnfZSj6Z9i63h7pTSg8WsV1GQfnVY3IWPQIBQDlL4UDao28pOnZSt8nb3dh4Fqz0/b394=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+l2DPep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+l2DPep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75261F000FF;
	Thu, 24 Sep 2026 04:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790222431;
	bh=+QZoUUNEo9gq5D1yxWPiUrE3wiozEwciNLDQDQWZCr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X+l2DPepras8831I5vcNTiesjpP24og2WhMB8GzoD7gUoSZS4Zfd6SIg98gt8zqOu
	 4SQh0LyLfDl7fxUbVoYnzVfeExFabxjZDLslWf4JPlEUMaphfQlgQ2f+Tlxw/eWNK/
	 I/q2k8F2F9nnVll3UejmA01uia5EHapYrtzEmHp4cw5vOlEgiQ75PpUAih2F8OmcV/
	 IVxwVyEP9qkdfdeSg7CIfcDlM0Kgf/BEEBNsbjji7ISUlNumLdMDS9QhMCk/aq8q5S
	 WFir8PtdZd8q4UfZrA54A4OwYHsj49xTOtadl2dt/xKhkF8WONt7bMTwUohD2/gCMd
	 gvCWqzQXaj8mw==
Date: Wed, 23 Sep 2026 21:00:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <20260924040030.GB5048@sol>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
 <arSMwd1bGO1vrif-@mit.edu>
 <20260924033200.3615554-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924033200.3615554-1-matthias.goergens@gmail.com>

On Thu, Sep 24, 2026 at 11:32:00AM +0800, Matthias Goergens wrote:
> For the entries, my plan is to start with the roughly 160 T: lines
> that name a repository whose HEAD is already in mainline while
> linux-next pulls a different branch from it: one small patch per
> repository, sent to that entry's maintainers as its own thread.  I'd
> send a few first, to maintainers who usually respond quickly, and then
> the rest in larger batches once the first ones have landed or drawn
> comments.  You know far better than I do how maintainers take this
> kind of tree-wide cleanup, so I'd welcome your view on that approach
> before I start.

Explicitly documenting branches in MAINTAINERS sounds good, but in
addition to that, HEAD should also be made to point to the correct
branch (at least in repositories where there is only one main
development branch).  This can be done using gitolite's symbolic-ref
command: https://korg.docs.kernel.org/gitolite/index.html#symbolic-ref

That is how https://git.kernel.org/pub/scm/fs/fscrypt/linux.git points
to the 'for-next' branch by default, for example.

- Eric
