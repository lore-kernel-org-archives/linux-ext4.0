Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF92264D6;
	Wed, 28 Jan 2026 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769572084; cv=none; b=WOyFILBmPdWLOUE5mWNlR3OP8OLF6eqorwU70GOmHELeCeiy7VMXtCY+h/CTU5c6+RNBfvz6Seii9tfo4O6HzWe73kZxd3O4MTr/Z6ICb6v0A7FAcwFLjOPUvvYVCGXSqd1SzUP2NIgpS+KIQauzHRpplyFdqOt5lHCGEnL3sio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769572084; c=relaxed/simple;
	bh=1z/y5o6GhTSrzHG4DDhScNrYrVFq/RuPxfpWNR0UWic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivMlTVP5JNuGkd7B2NP27kBU6CbCk8tJUMYQ+ov59SbARAO8QD+LdgEROf4zDTjgEWnzcOaqTp8xHEyiIATXAnL+O+fAEajpMoZFHx5492jsAW8wpW8SCdI9zfyMjK4OOTwBxZp39/ZcV/3PocrI0nRmkPDaOMjsNxmKzEZGrjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 38E61227A8E; Wed, 28 Jan 2026 04:48:00 +0100 (CET)
Date: Wed, 28 Jan 2026 04:48:00 +0100
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
Subject: Re: [PATCH 09/16] fsverity: constify the vi pointer in
 fsverity_verification_context
Message-ID: <20260128034800.GA31178@lst.de>
References: <20260126045212.1381843-1-hch@lst.de> <20260126045212.1381843-10-hch@lst.de> <20260128032203.GA2718@sol> <20260128033242.GA30830@lst.de> <20260128034102.GC2718@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128034102.GC2718@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 07:41:02PM -0800, Eric Biggers wrote:
> two different directions.  Maybe just drop this patch for now?

Sure.

