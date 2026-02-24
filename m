Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A4233ADA0;
	Tue, 24 Feb 2026 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771941682; cv=none; b=lCqYllf2ab1RnB156G8M+Mot4uU69/Qf3IvsboEjteLsz+fhMhClLYpirJuLb+zy3wRkAr2Rzm0189kTBjQxLqFPAB5Gl/FUF40XD+tA680vfj6tQUXYAhuHto09NZqy3orftDrnZ63mqEugvyfXt9d2iboLOui/GULtj2uWu+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771941682; c=relaxed/simple;
	bh=sBsOQPpLrZzU5mkoq5b6thjhGKFDFhe9Nt+bbi+6LWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEo5pUNG3XnhsqrosWeJT37nYpfqJKw7QfQ7RFO9nlrRennEM9qeHnj95Q+rLTy/bKgld/gJCvLiAO5J8UUlnQuxiXEFBpDqtHmUhV1OYwixsKqP+AaPC8HPArKvUX+x4oPUVx7ufwZShMH3lsv04jstD82ptwE5g8RQflrrW8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78C0A68C7B; Tue, 24 Feb 2026 15:01:18 +0100 (CET)
Date: Tue, 24 Feb 2026 15:01:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, bpf@vger.kernel.org, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: allow NULL swap info bdev when activating
 swapfile
Message-ID: <20260224140118.GB9516@lst.de>
References: <177188733433.3935463.11119081161286211234.stgit@frogsfrogsfrogs> <177188733484.3935463.443855246947996750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177188733484.3935463.443855246947996750.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 23, 2026 at 03:08:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All current users of the iomap swapfile activation mechanism are block
> device filesystems.  This means that claim_swapfile will set
> swap_info_struct::bdev to inode->i_sb->s_bdev of the swap file.
> 
> However, a subsequent patch to fuse will add iomap infrastructure so
> that fuse servers can be asked to provide file mappings specifically for
> swap files.

That sounds pretty sketchy.  How do you make sure that is safe vs
memory reclaim deadlocks?  Does someone really need this feature?

