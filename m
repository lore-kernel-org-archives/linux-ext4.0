Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF092E040E;
	Thu, 12 Feb 2026 10:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770891109; cv=none; b=bkYW3+LeoNRtimQgdzRKTY3qJRkY+wn/1hX2kWV+2OLOXucZ89/42jg5FglmUZJ+mCS3xR24JEXqELIKc7geRa1tS4gZ9Lm1cvkAdoH8QOg7xr/WyeimO0Iw31Q/Nj9tiXuj/UMBrP2gzuJkcqSdY/7YFuiwDHnQf0Lqrmwufrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770891109; c=relaxed/simple;
	bh=02odUGS0UD+ubBm3bc3OVqHMb4hikW3j0yQ+PaU080E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX6cweGYpzVqRm4vfJ68kmvLQzE4m19QbKHmKQ0src0SQ4qbM72mxcovznCHpQ/fDSaDwEg41s2jmEyS+Tbqm5VZ9mDHt6fCmz7894txex7+pWhyM+gRkVxfafthmpvncDGmI5hrSvsYRpNeMuUidRA5mODbt1lwBpLzvfq/WxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 984CA68D09; Thu, 12 Feb 2026 11:11:43 +0100 (CET)
Date: Thu, 12 Feb 2026 11:11:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] fsverity updates for 7.0
Message-ID: <20260212101143.GA7951@lst.de>
References: <20260212012652.GA8885@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212012652.GA8885@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)

Note that this had a merge conflict in linux-next.  So unless that
went away, it needs a merge resolution like:

https://lore.kernel.org/fsverity/20260203053604.GC15956@lst.de/T/#m291294c1f6b7368d3c426ee47e6d23dc854b3ba6

