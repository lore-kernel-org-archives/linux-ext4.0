Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2FC3515DB
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824367; cv=none; b=KnNktutXKzPM+i0ZfUKhLODQkwWhUyOa9qHztzzBNuqRFsZSB2szbsmBCEw8kYNKUNkaYiulBtqzI7ORQYzOzu9UYB+mj1sDf1JGMeLOMTbVpCFHmRH1176adE14pKUxTQrMO5gEZp2S8y4kNCtduDHg5lNHzkuIvT1AcK3H/Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824367; c=relaxed/simple;
	bh=3xA9+ZNTl/sGF6rclOxo8DYl8KQFuO75/Ryo2nEQudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WebuxaujH0W5v8XnGxvelmRNNlZGupsvdm6U4c0wyXDhb59BLeyCeclSk2Ma7/1nIXXNcKKNSt23h/Aydd42S+LW/ErQuYKvWnr6ladecAreaq9QzrF6LUSL3yC65rDEOtwtEboaiYCUmKm8/azKoLvHSIVJoO5ugo0ZZi2AUqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=IM15lyrg; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="IM15lyrg"
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66NGWRBT017547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 12:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784824352; bh=/l6uPPIeu1aaSxdjQO/YdwZkUrIbBDnoj5rcVkxHBxE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=IM15lyrgH4GQsfQizlcpILDqNXlcY2IHkSWlJYbFKI2X26vKg/LB0MAHoef5yKPIa
	 CK4q2vKgwRg6i173SnebFRlP3gKC5fkIT0PdDtwtGKNNH4n+MZ3NWn1Jbyhbvc3lp8
	 8ndhd+R6tLTBtM+RdGYuPq/RO7jcF2ODGtLm3ui5zWNTvWu5jee5PD3edlSKYjY4mx
	 a5IqWGhRRBYa43dGyUPYMMZYBXidKilwHdtEWBFw3apYLazQZ+mQQ+zNF9RVDLrWuU
	 gy3SU5o2N+6eu8uFNkyllGRlvXFav38BdfKygJVZaj5yuzswhRV5peHLzZaTkt5r52
	 Ew6Ipk3Ep3PlQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C3F01BD259D; Thu, 23 Jul 2026 12:31:26 -0400 (EDT)
Date: Thu, 23 Jul 2026 12:31:26 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 9/9] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <amJAxFjWXiSzjNd7@mit.edu>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
 <20260714080044.4038124-10-yi.zhang@huaweicloud.com>
 <20260714084203.971381F000E9@smtp.kernel.org>
 <amD3fZPiCKwUqhGd@mit.edu>
 <6213263f-27e4-4d2a-b6ef-f63093f89e69@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6213263f-27e4-4d2a-b6ef-f63093f89e69@huaweicloud.com>

On Thu, Jul 23, 2026 at 11:29:44AM -0500, Zhang Yi wrote:
> Therefore, I think the correct approach is to modify
> ext4_convert_unwritten_extents() so that it returns the actual
> conversion length, and only returns an error code when no conversion has
> taken place at all. This way, ext4_alloc_file_blocks() can use the
> returned conversion length to decide whether to add the orphan list
> (within the same handle as the conversion operation).
> 
> What do you think?

Yes, that makes sense.

I've checked the challers of ext4_alloc_file_blocks(), and at the
moment, in the case where there is a partial allocation, we return the
error, not the number of partially allocated files.  But given that
the callers are doing fallocate() that seems to be fine.

I'd suggest we should explicit about documenting how
ext4_alloc_file_blocks() will handle partial allocations before it
runs into an problem, so it's helpful for future people who are making
changes here.

Thanks,

						- Ted
