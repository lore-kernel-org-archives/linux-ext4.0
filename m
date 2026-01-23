Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F9B353EE1;
	Fri, 23 Jan 2026 05:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769145366; cv=none; b=Qdx3lQnCnjadw57U3sTvbpX4NHyRqDMEgifqsZpnXjUgj+H75JwnsKeBSRTyZcqSxrzBNZmSivbva45tRZ+nz5JHE62OgVqfFeq1G8zeQaJX+LHF8HGCFfQJub5AGkn/Rbye0J0J+1OT1GwVfuGeF+rJ3uFZnyeJcsCMqFq9V7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769145366; c=relaxed/simple;
	bh=r1hVY/caW5RZFIGr7pytsN4KAkj7MG876N3Cs2UxY2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1vko7VyHgUbaa4RH+KNXG7di0y37uJqmC41CD3tvlx2J+PnwZGM90cAnr/jPkuZ+Fa4+bj7j3mJg284rpvF3Zz7Mpx3ZePbFuP+ral5hXspuNyWgjvOAa5EbEU+bvBafnd6N1UwoxtPTv7pRvH/opJE9Zd0OqiDWGUw2Acg8gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 40876227AAE; Fri, 23 Jan 2026 06:15:57 +0100 (CET)
Date: Fri, 23 Jan 2026 06:15:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 07/11] fs: consolidate fsverity_info lookup in buffer.c
Message-ID: <20260123051556.GC24123@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-8-hch@lst.de> <20260122214958.GG5910@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122214958.GG5910@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 01:49:58PM -0800, Darrick J. Wong wrote:
> Well this is no longer a weird ext4ism, since f2fs also needs this,
> right?  Maybe this comment should read:

f2fs doesn't use buffer heads.  So this is just because ext4 only
implements the easy parts of ->read_folio and ->readahead itself and
falls back onto the generic code for the rest, which then had to be
grow hacky ext4-specific bits like this for it :(

