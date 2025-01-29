Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF45018C011;
	Wed, 29 Jan 2025 05:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738128545; cv=none; b=UCGwo1wg81Xcq9Y2eXjzOIn1rvAH78nqtpq2EaKrxkhCPDnm/+YxkqwEwttgTv176IBBhicEu0W0i36e4ItAKU6JCjGtiY38HRsEfS21vGuA4kHi2d0TbLX/2yCv9NxFwbI7GBIIutgRFRarO7EFHggPlzMw8PqgE+BhU8kP2YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738128545; c=relaxed/simple;
	bh=0I9GyeBN6kdq522yOjTsEvx60R59c6G/cd4mQRy6GVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmlHVjEvHruFHpH09luGFP54mq2OpNkkFU1Z1O1gnQy9Ey8/3JhevmMR+Uh1V0PmUJiXb9X+Mf5rfLUr/uowECT8k4IaK4bO0K4f5pDfxDSD8Oq/Yk0qqal+Ewz9pd70YaxpZEABJhciy3KbXySesvmRL5iGrdy01D0mJMy2UQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23F9268D13; Wed, 29 Jan 2025 06:29:00 +0100 (CET)
Date: Wed, 29 Jan 2025 06:28:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] replace _supported_fs with _exclude_fs
Message-ID: <20250129052859.GA28707@lst.de>
References: <20250128071315.676272-1-hch@lst.de> <20250128071315.676272-4-hch@lst.de> <20250128191958.GR3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128191958.GR3557695@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 28, 2025 at 11:19:58AM -0800, Darrick J. Wong wrote:
> > system is not supported for the common test.  For ext4 this increases
> > the existing mess even further, but the maintainers have a plan to
> > move it to feature checks instead that are hopefully easier to
> > understand.
> 
> They do?  FWIW the tests/ext4 conversions look reasonable as a
> mechanical change to me, but I /was/ wondering what they'd think of this
> change.

Ted mentioned that's the preferred way in reply to v1 after he apparently
brought this up on some ext4 call.  I personally still think abusing
the ext4 dir for ext2/3 is stupid, but I don't care strongly enough to
fight.
