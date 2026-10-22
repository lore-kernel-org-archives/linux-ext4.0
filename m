Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792685215;
	b=oQFXT49rQq4InEoRLH1ulSDg+9EUxEjzZ/1Avl0njAFtFLPko/X6vRuK2TnBH6lEV9dF
	 uGjBElzRic+BjvOjctd9QaOpu24dILNOvI/mTvLjqvjJ2vZP2kuR48KsaVzA6nXbhOgz0
	 9F2D5zVaGvVgzMCG8iO0A9ingF62GNz0RwHLW/rVgcOOjG3fC/rkY9tB7lpQCenL68dc1
	 zanM2AM3vNdtYQduvmd7uidFIDEt8am78Js/h3aGY711tNuI9Wrw6wUrrdfWHOR04scil
	 ZEB6zqYGDlxJWImCpqumkAoOmDPndeEbXbO9T2hcYS6R0kPfodf9c7/2FpjhykgO0hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792685215;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Z8ebFhxyUq3IejLsdLklQXfwFNOjlnZJ+50Y/W7TIVM=;
	b=C1qdeOxtDtB0nO3q8bEe6kYOiwBYLPnt0hOzRBm8SXttS8Ag/PkyawbgYoO7gzEhQuKm
	 U8kjLYiq9enysaSQhq9+/WtFiU4kKGJZaVH4eSWFVlJ9nRBiFD7Ueu9HNV0ub/8m+oi1s
	 mDEqfKyLQlklwS0tLZXZ9HaU2XZ4qtfmNcO13UoZZOgEHju+XIomGcTGyK9aGYLZSRDHP
	 XPt/zRQ4+CpnjzdEz915Lexe15wyF9dNiF4d+34AmufvUYABvweJD30WHnkTX4RknwOiE
	 ZU9ZCw8P1H4CrLMFnXvlO7nTvkuzVZecA0mI2qdSdLPgBKLamdSkp8pQozvn6gkxYpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=c76JrIXE;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF476606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 16:06:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF476606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=c76JrIXE
Received: from macsyma.thunk.org (pool-108-26-156-23.bstnma.fios.verizon.net [108.26.156.23])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69MG66jB005218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 12:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1792685171; bh=Z8ebFhxyUq3IejLsdLklQXfwFNOjlnZJ+50Y/W7TIVM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=c76JrIXEAM1iMeUYAUi8NbMxRenYXmXfZFDqlFV+hryG+Ix/clCxf31BGnESaDlgY
	 F00Gbc8ZtqG62kUErDSL6s5pfUPyBuKOW0yC3Y96oa6PXqzTEiYLZZmrbVb1PymX1u
	 hRug9Q9fDzy4U9WlRtPtEIAv6Ih1zp/6swFGwBwlRsjCijOeBVh75sA7KDN8ivO2fl
	 hUajlbiex1F45FtCSRJNEoERRWRVoWD5q/a6xA6h1OdiRDc3kkfrCHSVURXbHoR+34
	 jytcvJXLG323NebYPRdje9FDs4056ZoZk4hsEyXN3Rv5khp1u42qT9/DHmoKaDFzgH
	 iCHD4TraanZSA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 638F4220AA74; Thu, 22 Oct 2026 12:05:06 -0400 (EDT)
Date: Thu, 22 Oct 2026 12:05:06 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, riteshh@linux.ibm.com
Subject: Re: [PATCH 0/6] ext4: fix buffered writeback error handling
Message-ID: <atoySP5ez1SwWh0X@mit.edu>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022145241.2950379-1-sunjunchao@bytedance.com>

On Thu, Oct 22, 2026 at 10:52:35PM -0500, Julian Sun wrote:
> This series fixes error handling in ext4 buffered writeback. It prevents
> stale data exposure when mapping or io_end_vec allocation fails, reports
> unwritten conversion errors to fsync(), and preserves concurrent io_end
> flag updates.

Hi Julian,

Thanks for this series.  However, we have just landed a significant
change to the ext4 writeback to add support for fs/iomap's buffered
I/O.  It is currently not enabled by default, since there are a number
of features and mount options that aren't yet supported by the
buffered_iomap codepath.  (Thanks to Zhang Yi at Huawei for his work!)

I'd really appreciate it if you could rebase your patches on top of
the dev branch for the ext4 git tree (I've sent a pull request to
Linus so this should be in v7.4-rc1), and determine whether any of
these concerns are also applicable for the buffered_iomap codepath.

Many thanks,

						- Ted
