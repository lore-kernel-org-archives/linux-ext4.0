Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C7C329E75;
	Tue, 27 Jan 2026 06:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495893; cv=none; b=K5cY2YHEGEHiUC7MB0GPE5EKNJtYov3L33eJBqEuzBMqYltlUH/+AY/IaPj5a519qhHLb2PqgAcdox+Z5AMmFKYT0SDh8QgRNW9VRHJs8ZfaQwVGjARjBDzkKH34Urg4qzl2iFOWFHL94Cg1vmbEmhg3aUZTRcmtlb8kZwHr8ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495893; c=relaxed/simple;
	bh=1K+WY31iV7ZEnZ/0mZlA3x87xJD0USzaynDP2iXbW+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBsGuiO3mUY6KzLmMOkttG1/nWqz2utPlnavobD3AYXva4lk683BkZuS32PlAt6ymPXRwMSy+F7SSQOxFXs11aHZybqxFFU0uUwvprUs8k4JZiU/LVXExtVrz6cASg9NS0x+Qmj8cMSREPaKFKdDx0pxIgoDs517SWyeSoDlkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F0EC227AAE; Tue, 27 Jan 2026 07:38:09 +0100 (CET)
Date: Tue, 27 Jan 2026 07:38:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 07/16] fsverity: don't issue readahead for non-ENOENT
 errors from __filemap_get_folio
Message-ID: <20260127063809.GB25894@lst.de>
References: <20260126045212.1381843-1-hch@lst.de> <20260126045212.1381843-8-hch@lst.de> <20260126191102.GO5910@frogsfrogsfrogs> <20260126205301.GD30838@quark> <20260127060039.GA25321@lst.de> <20260127062055.GA90735@sol> <20260127062849.GX5966@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127062849.GX5966@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 10:28:49PM -0800, Darrick J. Wong wrote:
> > Yes, it's really just a cast, and 'PTR_ERR(folio) == -ENOENT' actually
> > still works when folio isn't necessarily an error pointer.  But normally
> > it would be written as a pointer comparison as I suggested.
> 
> How does one know that a pointer is an error pointer?  Oughtn't there be
> some kind of obvious marker, or is IS_ERR the only tool we've got?

IS_ERR(ptr) is the interface to check is a pointer is an error pointer
or not.

PTR_ERR(ptr) == -EFOO checks if ptr is an error pointer for the errno
value -EFOO.


