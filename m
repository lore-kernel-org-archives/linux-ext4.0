Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D5233D4FA;
	Fri, 23 Jan 2026 07:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769153079; cv=none; b=IQEqnLqtqf9iaYCTTpOSho3labv+poarASsVSZTxxr0EUjZN+TgJ0O4ukFjXIvcdkt12t5yoj0BIoWwAoZtkKVhdgHBWoXSWoDdgmY4gZthkbc4V/iGXnezTtCnDVPiq+XH4DVRQ94aZgttMKazDlpnrV/FMZKKmJFUF1hdD3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769153079; c=relaxed/simple;
	bh=Tdc9xwIa7aB3BlCpIOjUKl9IwWx6UPKNoW05Ii8kmec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kw+wfACKWzc3IT77qat361gLZ8AkVZetX/CpLU3qTaYe4G4MsKBOIp1dlILSTdwa+rD+eFgZthR2rAkeiEjcYNySq7ehiOEY9ODBB+rI4aep257qAzcffEQOO+Tk/qY/FV6ESzPKvWsrcr3kGiAoqHsfEFQffGGOAC5bsYG34BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 06C25227AAE; Fri, 23 Jan 2026 08:24:34 +0100 (CET)
Date: Fri, 23 Jan 2026 08:24:33 +0100
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
Message-ID: <20260123072433.GA27421@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-8-hch@lst.de> <20260122214958.GG5910@frogsfrogsfrogs> <20260123051556.GC24123@lst.de> <20260123072329.GL5910@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123072329.GL5910@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 11:23:29PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 23, 2026 at 06:15:56AM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 22, 2026 at 01:49:58PM -0800, Darrick J. Wong wrote:
> > > Well this is no longer a weird ext4ism, since f2fs also needs this,
> > > right?  Maybe this comment should read:
> > 
> > f2fs doesn't use buffer heads.  So this is just because ext4 only
> > implements the easy parts of ->read_folio and ->readahead itself and
> > falls back onto the generic code for the rest, which then had to be
> > grow hacky ext4-specific bits like this for it :(
> 
> Yikes.  So I guess we shouldn't genericise the comment to encourage more
> people to do the same thing ext4 did?

I don't think so.  I actually need to send a ping to the ext4 folks
that maybe, maybe they really should handle all reads into the page
cache in their own code so that we can hopefully kill this entirely.

