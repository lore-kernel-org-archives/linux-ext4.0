Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3EF2773F9
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2026 15:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771947183; cv=none; b=ET0rLsH/PnQDrVExJ82x2LUCHQD5drWLM7KkSz++b9Mz6gPmW2I14KnC1CYZ2/bCj22Ld5f/n/1A8jqP8kxNTP48AS2vuThwXS2JkA4MmQXbhFAqqopDGWsaWFx8BnSVmDndh9esHur4ZxBo5by+H+T//EmK9MyTcrJ+YM0mlsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771947183; c=relaxed/simple;
	bh=VQTDYyp2KUyp65Y3HfpJzq+MwHKYQd3K/vE5/GWxUW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkphRMS5DA6n+6Pxvwa5oFVy0/C6I6E3X0ZM41wc4oDmVo0tCKL9dQYBRC6q2fZX8MV/4nm5rusZl5ky8AtNKtom06NjL8Z31i4geuxgJWAau+9hFJgYOW/JeIVeNyNaXmkZJPzZNy0fSSMoU2Qo9X50gcRsJkyBDvSxCotAmfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=iaInRZKz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="iaInRZKz"
Received: from macsyma.thunk.org (pool-173-48-111-182.bstnma.fios.verizon.net [173.48.111.182])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 61OFWSmh014511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 10:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1771947151; bh=LCrtRQLNlXJ2+RMPTomjO9zvY5ULKnNAP+Rx2oaqJTY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=iaInRZKzaFmwbD0wNIxEZWWMO9hrAn0VLeTMlSnaY8bAvNdERtlqSNJqsF2bJHGuX
	 QFTUQ40h14UmMAB+ncnFFpT0n19A1u3+PcUUoB1Kvo7YBT1cJo6vxIluKw5TCdWwnQ
	 CrPTx0zFGW8olNTbS6tCe7DuT9RnRtPPrbW83S4LbIRrCk6L537bh/PH5bXvI4LNZl
	 5vv1Kp2MunTQo7PLw27xom0Qf25XsuYY+gdpSJSqBIpiHvqG+5D+UYF91Elf/qy57I
	 lVz6s9o8sopQ3AAZbLd9bafx/4ccNWwFICzmU70GxeSbGtysyQjvMGflGIkzopWr5d
	 wesJycyrLZSMw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 712BC59B49DC; Tue, 24 Feb 2026 10:32:28 -0500 (EST)
Date: Tue, 24 Feb 2026 10:32:28 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Andrey Albershteyn <aalbersh@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] fsverity: add dependency on 64K or smaller pages
Message-ID: <20260224153228.GC16846@macsyma-wired.lan>
References: <20260221204525.30426-1-ebiggers@kernel.org>
 <20260224145156.GA13173@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224145156.GA13173@lst.de>

On Tue, Feb 24, 2026 at 03:51:56PM +0100, Christoph Hellwig wrote:
> Do we want to throw in the towel here for the forseable future and if we
> ever need to support fsverity on > 64k page size just do a on-disk
> version rev?
> 
> Because if so we could just simply the pending xfs fsverity support to
> drop all the offset adjustment and simplify it a lot..

I wholeheartedly agree.  Especially given the benefit of large folios,
increasing the base page size beyond 64k has enough downsides without
compelling upsides that can't be achieved via other means, I'm highly
skeptical that page sizes > 64k is going to be appealing for most
system designers.  So trying to design in support for this possibility
in fsverrity is not worth it.

						- Ted
