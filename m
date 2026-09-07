Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD319B5A3;
	Mon,  7 Sep 2026 22:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788819220; cv=none; b=q7gis3eGqylwA5grdjAKjsbvbZ/1GJzSeQvRa32FZwM07wz5CLp7VuKah6QAjqGRnIRRldPhyJOMpcpvQ9mSmqvCKkdBYqu+kq0D+Mkl3jKOrb9KKZPSL0OkIi3f5ole3M+/+wz10uHEahiMmDRffxx0WTE91FPe7y07eyGhy9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788819220; c=relaxed/simple;
	bh=+qe6ytbyTQ4oj4VE0v+4RxMRunN6UnQmesYUuA3wVqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKCMxJl91h9huI/MEardvOxoSo7bmVWLtpPjrcgSZdS7Nz25ZtWw3YuBE+TOmUENabUSENipCybvKXeNleOeeq7RYGFgwRqrzwJ1FTURN6SaAJZ9gDTqKGzh+A9nTgRr4tLxI1zR3c4HkiZmGQQdNiNfKYWaxn61p2OjLuSE//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEB6pn6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEB6pn6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EA31F00A3A;
	Mon,  7 Sep 2026 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788819218;
	bh=ZgKjfsHtYgTqWKaNbFLCtnc8X3K6sKxBe2W0c8nQIqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QEB6pn6R+9hLn9X+eMFooE3mUeIcWRiOKERE1noHKZ8Otcb5UVOcEx91RLYcetOJ4
	 Ar4FWFZ+9YEDLqsNCJ6CXj4eUT29uongnPVU6Muw8DxABAGSclbXCiWroDT1tw8krS
	 +NTSRBna/XbEc2pXEc0Ul+DR2umQYSypy8iOgYC6J/wNsvqk/K086/w8aK5pgOftg0
	 sIgeYOUFBg4beFgQ7l8yj+BLn5c34jTxRh45CdlThPYPBMqrtg6Sma7jXMnY4UaGub
	 1moMJUJ9bGpaanDtIFKwuimyJDtzAhb5VjhERampXIDK6Rsr0YYLEnWweTh8JKqjnD
	 KRj7cGW4O89pw==
Date: Mon, 7 Sep 2026 15:13:34 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marco Elver <elver@google.com>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Jan Kara <jack@suse.cz>,
	Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context
 analysis
Message-ID: <20260907221334.GA1619741@ax162>
References: <20260903101843.3462767-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903101843.3462767-1-elver@google.com>

On Thu, Sep 03, 2026 at 10:16:38AM +0000, Marco Elver wrote:
> When WARN_ON_ONCE() wraps a conditional lock acquisition (such as
> down_write_trylock()) on architectures relying on DO_ONCE_LITE_IF()
> (e.g. arm), Clang's context analysis (Thread Safety Analysis) failed
> with a false positive:
> 
>   fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not held on every path through here [-Werror,-Wthread-safety-analysis]
>     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
>         |             ^
> 
> This happens because DO_ONCE_LITE_IF() branches on __ONCE_LITE_IF()'s
> return value (__ret_once), creating an intermediate branch merge point
> where the lock may or may not be held depending on whether the once-flag
> (__already_done) was already set. Because the merge branch condition is
> __ret_once rather than the trylock predicate (__ret_do_once), Clang
> cannot reconcile the lockset at the branch merge points.
> 
> Fix it by refactoring __ONCE_LITE_IF() into an unconditional
> __ONCE_LITE() primitive and redefining __ONCE_LITE_IF(condition) as:
> 
>   (unlikely(condition) && __ONCE_LITE())
> 
> This simplifies the implementation, short-circuits evaluation so that
> __ONCE_LITE() is not called when the condition is false, and ensures
> that DO_ONCE_LITE_IF() only enters __ONCE_LITE() when __ret_do_once is
> true.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/all/20260903072759.GA1750084@ax162/
> Signed-off-by: Marco Elver <elver@google.com>

Thanks, this fixes that warning for me across all my builds.

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

-- 
Cheers,
Nathan
