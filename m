Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38E52ECD34;
	Fri, 30 Jan 2026 05:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752117; cv=none; b=icspu2KPYnSFy8UhznEIKqEfqdORN7/2jN7eFsAr2l3+dljvmB/2Zs8uv6h+PtCuy6DqqXJ3tQWAgYvqcfhL8sLQMsuFf/uJ1h0P+wuwCcLxg3IEmDKhFOto4KO+E8z8alv7GnLh0iurHrytdkw2lvPMZEgitF46pEDYwiu8uXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752117; c=relaxed/simple;
	bh=ftzOb2Yr7oF3gNHLYVV8D5bMfB5p0bllJS5k5q3NHsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0OiSNR6fR/0L2Ot8m9zfZ5lPlxvcN9A3wbhiiZvIQxw40pFxdVlDII9WpsG7rKhq65i7S/N/NPnUTSW4gksKLq1yavnqVOrwwa/E3oyeHNTCJkxq7xOc5ctbnHjAzgJ7948GWULsdaoF+N6H/miqDJ1UXYlfdblT3XAgprBzRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20A8268AFE; Fri, 30 Jan 2026 06:48:32 +0100 (CET)
Date: Fri, 30 Jan 2026 06:48:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 07/15] fsverity: don't issue readahead for non-ENOENT
 errors from __filemap_get_folio
Message-ID: <20260130054831.GA622@lst.de>
References: <20260128152630.627409-1-hch@lst.de> <20260128152630.627409-8-hch@lst.de> <20260128234814.GC2024@quark>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128234814.GC2024@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 28, 2026 at 03:48:14PM -0800, Eric Biggers wrote:
> This patch is still incorrect: when IS_ERR(folio) && folio !=
> ERR_PTR(-ENOENT) it falls through to folio_file_page(), which crashes.
> See https://lore.kernel.org/r/20260126205301.GD30838@quark/ for a
> correct suggestion.

Sorry, I missed that part that only applies to the version after this
patch.  Fixed now.

