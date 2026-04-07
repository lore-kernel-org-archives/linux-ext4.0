Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9370537F01B
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 23:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775605059; cv=none; b=MFVbhLLzGpMZH9bWQLgQCCDucL9TwxD8qsPWSEg5xXWN/i03QD5e5lFr3tKq2yAhNMXno9J2Q27nzgmaWI7E3IWfzm/Wr9y65U4rg3VL4iokfE479OskJIccoqxeQ4QIc887dwV1YQd8Dfv7IgPUKEcJ5+sWafw1ZLwEveMhpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775605059; c=relaxed/simple;
	bh=j+99azgYy0vKK3UY0we2bGSE9cNp6pIy4pj3/0pKyY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F02kiLleteBtIH1Xx0wNFqimNbEA46TTCnn0z1fPDxUXlMipz2UUmK+UeQ3785NOdWkpBjr4M/AkyuNB+wELQVB8nBwrwjYsUnWdbEmEC0CZgQfDiCCWSA8nBNpFoSGTdkmW3dMoTjf3MrY3u/qyW8PmnRLgsPVTbWIp5Zz3y6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=YHDvSX56; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="YHDvSX56"
Received: from macsyma.thunk.org (pool-173-48-119-176.bstnma.fios.verizon.net [173.48.119.176])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 637NbI3g013361
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 7 Apr 2026 19:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775605041; bh=EM9+Y65ZKjeH9MFPMAEsNqFW5ghZHnWR3WX389z7zgs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=YHDvSX56xWowlPH5og8N94jX3jyGLIipHmE/UaTZWlKBq2jllSEXNIE4NWB1XKBjH
	 9aPFePl2TxCAbR2nopgEvDR4aGTVspF1xglEL9jg3gyXaIy87KQun+TJOgzpIiLyyA
	 pbQ66vv0xqi1MXrFYqxBjyv5o6AByHPDqS2/T6RCIOg3PgoR41PUGt+VNdfFeoTrHM
	 VwsF7dgQv1Eq3In9tk1O8ngvue/bl/Ki9PcS7LmtZzb1LBndkAL0F5niujUT097hqX
	 qW6eWVZHy0E2IKqmrHxQByUbOIAUf7yN5gdegPxPQs4hcUbLdZQkZkL1mPXhaNZ/4Y
	 WlQJw0odGcRPw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 5DC516230A04; Tue,  7 Apr 2026 19:36:18 -0400 (EDT)
Date: Tue, 7 Apr 2026 19:36:18 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Sean Smith <defendthedisabled@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, david@fromorbit.com,
        brauner@kernel.org, osandov@osandov.com, almaz@kernel.org,
        hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260407233618.GB12536@macsyma-wired.lan>
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407000558.417-1-DefendTheDisabled@gmail.com>

On Mon, Apr 06, 2026 at 07:05:55PM -0500, Sean Smith wrote:
> The patches implement rename-over preservation in all 5
> filesystem rename handlers. When rename(source, target)
> replaces an existing file, and the source has ptime=0 (the
> default for any newly-created temp file) while the target
> has ptime != 0, the filesystem copies the target's ptime to
> the source before destroying the target's inode. This runs
> inside the rename transaction, atomic with the rename itself.

Yelch.   This is so *very* non-Unixy / non-POSIX / non-Linux.

I understand why it's convenient for your particular use case, but
rename(2) is fundamentally an operation which works on directory
entries.  We don't copy over extended attributes, or Posix ACL's, or
Unix permission mode bits, because (a) that would violate POSIX and
historical Unix behavior, and (b) because rename(2) is fundamentally a
directory entry operation.  This is despite the fact that it be more
convenient if we didn't have to copy over things like extended
attributes, ACL's, permission mode bits, etc.  So you want to make an
exception for ptime?   Yelch.  Just Yelch.

						- Ted
