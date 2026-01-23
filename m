Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DA7396D0C;
	Fri, 23 Jan 2026 05:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769145151; cv=none; b=d/SeGlw7kEk5zKCKcf0t1516cfXKx2mqmnTpmPAkb51DbGxi7CgYWdW/+/ssBYe4Z8OECDKrFVAwUOIkcRUWj/N7DeBK3XFuJpFSoBO3O0VzYZFCVHar8oF0vxc4WtzvqB0URARh/NSGOJ3OnMKCTolF2a6R2rXlTbk9H6lw/ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769145151; c=relaxed/simple;
	bh=f9ZY//WP7sMGr4/l+Rf2qgx5FluM0DH8X2K6UdTQ70U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EY9w+D4qbgg58/nydGQUhX9B0RuLk00v0Ih+/ocPPAGgY2rmdGN5oH7v+4w7PMf77NXvrUQ4jSIAeq/CngtN9JdgpsIPpkOCd228qLeOmw/I/NFQzF594T9svzzzMEpUpw3fQMSJJtWQg7VEN6Lgm6HTvUcFkEmBZ7DaYG1uy5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A85EC227AA8; Fri, 23 Jan 2026 06:12:16 +0100 (CET)
Date: Fri, 23 Jan 2026 06:12:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, t@magnolia.djwong.org,
	Eric Biggers <ebiggers@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 04/11] fsverity: start consolidating pagecache code
Message-ID: <20260123051216.GA24123@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-5-hch@lst.de> <20260122212700.GD5910@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260122212700.GD5910@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 01:27:00PM -0800, Darrick J. Wong wrote:
> Nice hoist, though I wonder -- as an exported fs function, should we be
> checking that the returned folio doesn't cover EOF?  Not that any of the
> users actually check that returned merkle tree folios fit that
> criterion.

As in past i_size because this is verity metadata?  I think per the
last discussion that's only guranteed to be true, not the folio.  It
might be useful to assert this, but it might be better for combine
this with the work to use different on-disk vs in-memory offset
and to consolidate all the offset magic.  Which is worthwhile,
but І don't really want to add that in this series.

