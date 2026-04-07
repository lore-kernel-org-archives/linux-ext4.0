Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9609029B78F
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593801; cv=none; b=X6sJqRBKuM3z0wGgbMFQxMKQmsS9MsyYV6NkNqmnef4kYXp/7ysr73hGoU6Gah6PQIVyL7KQ8fAxt42tVaJh8OOL96FGJx40E+dXGIkb6qfwvvAXPTqXWUYcy+uie90lQ3qVedlxv5v49Whkh2GWeaSwnNn+JbB1Al8wZ2jdDqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593801; c=relaxed/simple;
	bh=hPKqGxcFX75924Oi70jSImyLWNDCapoJOhnnkng56wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOIcdVLBKZ2cIbOqE6Y3nRokjuGIXrApqSL056qZ1BkVAIRN/fFqYIcN/PirHdjAF6PZv0NL1MUif4v3jGHpaCuoigbayEK3kPjwwqS8/HA/mRw9NOeH4OwEm9e0MHphO9rT8THWL22QYgnZR01sBy4ejouBdLGOVcnPPbePvjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=LwoiRB71; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="LwoiRB71"
Received: from macsyma.thunk.org (pool-173-48-119-176.bstnma.fios.verizon.net [173.48.119.176])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 637KTjPa020185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 7 Apr 2026 16:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775593788; bh=tOzNx4PeSh81K816hqFT4Aizuwn4JpHSilEiRsWKx7Y=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=LwoiRB71bvhhY4BRbBYrwdaUK0K2cChzTTFZSuFL6klq3d93UDAKEYAC4FotqYwOq
	 ZIcNMCtk21bVSzT/D7exGjuI2hXJ77VR3hcXs6BdWkA8XOsgS9qeyqaUhye8PjdLQa
	 /W8XIwBp1Bls9f2mKw5KiDT4OKNIdLJT1C+vnObcGbabpPkx4DIc0Pz0+01LZp6d8j
	 akLYoB/IDuRQbgG9bywyCEXO7wQpREABAItw4fseSBJJ5YJ0uzyVguZQ5zEn9Y10kf
	 3JeKXKuk+dd0SoXGTZqaRpuAuw91Q9JG5GdTukEtYF0eO1mRAzNQxcNn9JYejmN6mI
	 UDCnaigOgSIJw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 2385D622C635; Tue,  7 Apr 2026 16:28:45 -0400 (EDT)
Date: Tue, 7 Apr 2026 16:28:45 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Ye Bin <yebin@huaweicloud.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] show orphan file inode detail info
Message-ID: <20260407202845.GA38246@macsyma-wired.lan>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
 <n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq>

On Tue, Apr 07, 2026 at 12:29:23PM +0200, Jan Kara wrote:
> I agree listing orphan inodes for a superblock is useful and the usefulness
> could actually go beyond ext4. I imagine the very same problem is there for
> XFS or btrfs so perhaps we could think for a while whether we can provide
> an interface that wouldn't be ext4 specific? Perhaps an ioctl
> (GET_ORPHAN_FILES) that would return an fd and reading from that fd would
> return entries for orphan inodes?

I'm really not a fan of ioctl's returning a fd, but that does seem to
be a thing these days, for better or for worse, and I agree that
having a portable solution that works across multiple file systems
would be a good thing.

> Also regarding information reported about orphan inodes - won't it be better
> interface to just return a list of file handles? Userspace can then do
> whatever it needs with them - open, statx, calling ioctl, etc - so we
> thwart feature creep with people asking us to add more information to the
> interface. This also offloads a lot of security questions about the
> interface to appropriate syscalls. So overall it looks like a win to me.

The problem with using a file handle is that the only way to get the
pathname is to open the file handle, and then call readlink on
/proc/self/fd/NN.  And inodes on the orphan inode list have been
unlinked, so we don't want to allow people to be able to open them.  I
suppose we could allow this via O_PATH, but I'm not sure that this is
guaranteed to work across all filesystems' file handles?

	      	   	      		   - Ted
