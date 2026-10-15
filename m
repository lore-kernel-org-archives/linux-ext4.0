Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA2E3F6C4F;
	Thu, 15 Oct 2026 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044080; cv=none; b=aM8qRuuyXlPgkpwlaV6csWJAXzJEUfNteI7vuMkXSrXUFK78FbMuzr5OjhWtHystdg2ZcDSRYCE371ZEwg18dKXRErFa5Ua/Sy8ROxuCzr1F2lOB6z2prkoPEHqc90ltWp7Rj5NbwME3R7gjfzfh148CJ4ll3QLWnC2dGeSvFIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044080; c=relaxed/simple;
	bh=yNWwLJNUe27PTpOZDm7kYZKqvUh+lxcDBcU2eCbm/xo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMCuUG7sZnUQLwQ4UM8fQzvOelnS/bKew/wwSMW3avKroTP6Ykug7xkjJueAJRLh5gGmHCCQOmHIYwQmpdyQf3T0r1x/BjwR4r6/kOy38v3wvpYzgKvSClsh5ScAmWL7kwhixsvuqw9dEfrweslAM6RldpV5OxXdbHJd87p842Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hyElGmmR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hyElGmmR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f87sO/qlSeKDi99L8UORDi1aW7xU11Y7h44nzkU55Sw=; b=hyElGmmRU9Bo/yg24cZxEjXSDm
	9+qmyC/D+S68VBoa8d69rTllZLHpbXeuko/8+zkNInEAkuHRWGJ8KqhNJOkZtroNuXxpK1uNGhMPp
	Kx4vG4xTQ73y/SDN51nounOfMJ+lTjQKsEaTJKEapOUHE6OG04ofxx8dUQgfsnR2zqzAJWQVjgvkG
	oVgtKjZ+ZNwekEQyW3OMAnIlaFbquMw4SJZLN9Z0iRHlBF60HzgYCzXBiIrwyh8Hxi6Tt3w0xlK7X
	QkoXLZVX/BoR/IrxdLggUQqkY0y8eVJzPZUVIqIaQ2R92++X0Rb7wBVs1UC/LYCFzovwpghfpOsWY
	KP7hNpqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHEWi-0000000Guf1-2aXH;
	Thu, 15 Oct 2026 06:01:16 +0000
Date: Wed, 14 Oct 2026 23:01:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, daejun7.park@samsung.com,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] generic: test that preallocated blocks still read
 zeroes after I/O errors
Message-ID: <atBsLIUaY_6os5Z6@infradead.org>
References: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
 <aszSZ7Y2f8sIorpU@infradead.org>
 <as-dShqu7w8OBYm4@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-dShqu7w8OBYm4@zlang-mailbox>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 14, 2026 at 11:31:19PM +0800, Zorro Lang wrote:
> On Mon, Oct 12, 2026 at 05:28:23AM -0700, Christoph Hellwig wrote:
> > On Thu, Oct 08, 2026 at 07:18:24PM +0900, Daejun Park via B4 Relay wrote:
> > > +# dm-error table sizes need zone alignment on zoned devices, and the check
> > > +# needs a mounted file system.
> > > +_scratch_mount
> > > +test $FSTYP = xfs && _require_xfs_scratch_non_zoned
> > 
> > The canonical way to write this would be
> > 
> > _require_non_zoned_device $SCRATCH_RTDEV
> 
> Currently, there doesn't seem to be any usage of
> "_require_non_zoned_device $SCRATCH_RTDEV" across the existing
> test cases. So I'd prefer to leave this suggestion for the
> author's next version, once it has been properly tested and
> verified.

Hmm, plenty of _require_non_zoned_device all overm both for
SCRATCH_DEV and (hidden in common SCRATCH_RTDEV).  Although
in this case I think it needs to be SCRATCH_DEV anyway.

