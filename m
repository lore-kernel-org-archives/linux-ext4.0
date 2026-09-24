Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFDF3CF1FF
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 03:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790219749; cv=none; b=k4SQLWEM/FaFKyAX4cOmc5vo4Uz7Xgk+b09BElCXcDC3sEon5Z+ucK0BceDX0GROo/e2DrCBkjFfvzY19+KLFZww+TMOkMFYE135UW4+Mozxwy8m6CLDwlKKDt6MUb+o2pyNBtGDC2e5hirmg/KefXxWcage/OSMQITIrlZt9W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790219749; c=relaxed/simple;
	bh=bhu/rqzXemk3BM9DJa6ar+T9kYtB90wULXJgs2gFVFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sz8m9fORizB//YWRZ0dPSHFBVTqz+b1fGFUtA8BS8xFF2TQB2rTeUJJNMnxQO3bW2aRjWoo/RDrhdwatW/C0/nvwj+d3++J6qrnpzDBmlF597vsot8zrD+OJ+MZ64I4WriwsiplLOtKVGdt9neDAGF6izRsClpu6D5PzSERYwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Eb7Il2eZ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Eb7Il2eZ"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68O3FVG5014404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 23:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790219733; bh=KZsBXg52nXo7zN3bpuZfOqRlTfU0WCsT8niqJsH9hy4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Eb7Il2eZ/Qb03m1PVXMYeOG5kkEpI6DDGorOYmx/uV3EzkEjm5PAlRGE4ybIFiOfJ
	 xEgPHrUBKDWuEnSgTorG0FyeG2P16NwfJrbyvIR77nO7RST+kOe6tMPLdvi6HlK3nD
	 tJ1n8KhV5lGM4iVHc0JYiboXKPsqqJwU8YE7N/8r/pRXUufmfH6TbKVp7g3kg3Lnm5
	 k7hyRizM9yltONY8Dgop2AEvaorGdsZoQXryW3d+DnEngStvRRb8EXJUQ8iRpYM3FC
	 joAaBy2pRTrWi7wExfRaDBZATWC2afyIqTlW0BiKR6dTOt/LyQKaMV/reCpvx2rpN5
	 1+PV1nuvyuKhA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 7E9A61CCFABA; Wed, 23 Sep 2026 23:14:31 -0400 (EDT)
Date: Wed, 23 Sep 2026 23:14:31 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <arSMwd1bGO1vrif-@mit.edu>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923101749.3505886-1-matthias.goergens@gmail.com>

On Wed, Sep 23, 2026 at 06:17:49PM -0500, Matthias Goergens wrote:
> The ext4 T: entry names the repository without a branch, so tools that
> default to the repository's HEAD select master, which still points at a
> merge from October 2020 (96485e446260).  Development happens on dev,
> which is also the branch linux-next merges.  Name it.

Huh.  I wasn't even aware that you *could* specify the branch name in
the T: entry.  A quick "grep ^T: MAINTAINERS" there are only a few
repos using T: that include branch.

I also tried looking at the documentation, and I can't find any
mention that the git branch could be specified.  Maybe we should
update the documentation for T: in a separate patch to the MAINTAINERS
file?  Or did I miss something?  "git grep MAINTAINERS | grep branch"
didn't turn up anything.

> The Sashiko review bot, for one, falls back to HEAD this way and has
> been reviewing ext4 patches against that tree.  Its review of an EA
> inode refcount fix reported a Critical double decrement and an
> undefined function after applying the patch to that stale baseline;
> neither holds on dev.

... and I didn't know that Sashiko uses the branch specifier.  I
wonder if ext4 is the only tree which might have this issue...

   git log --merges linux-next

... nope, apparently not.  I see a lot of branches which are merged
into linux-net which are not mentioned in the MAINTAINERS file.

Thanks for pointing this out for the ext4 MAINTAINERS entry!

						- Ted
