Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81734558208;
	Wed, 14 Oct 2026 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991889; cv=none; b=pkrm0PXF59fejkFZOdT5jSlj2Bn6KUl2+voKi7omRz2m9mTX59h4mphA8vsgoK7nkcz/2YPh2I996kiXAtXcy1xYvGQ78FjnhVYtOhIhIIphBWCIVi3ExwfVepoQaUUmj9+YzgfcAOOHYwbl0ycYFSyMvlJn1OuiWhePtg8rAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991889; c=relaxed/simple;
	bh=iKZ3aGEdfscwoJ70kEowDrAwTFYYPeETaEYEwPqCo/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhgMI803dOcjDXVF7Vv6awGKEPIH7KtMgXwqMeTzKG5fNB1vZO6GaRr8dLODzBbfSzRY4kS3ZXAEoxHeFx+wp43QmQoLhhsO6tOvaWU6ribdPtMLmSaZQhmm+/w7NqE4Fch2kez3npCs9+ytdpnnBboijpvDqRNLzwf9Su6+iA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IATR+unK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IATR+unK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA091F000C4;
	Wed, 14 Oct 2026 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991886;
	bh=Ajhaa4iSiy0zriTeNazJ1uXpWNnraNgiMsRWr0QtmbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IATR+unKo3edPCn5nmYgpUvYBQLEoaM7r1CJEUX0lYMVHB+Af69CoBuuy/G70dh+r
	 ewiz5JV4HWptSnc8oLEgO9LJFlsyRy3ITc0dt99pell3JI9/HeM82JdstoErZSB/r3
	 z+G36XqtopdAlkCBJ+8WcHH6fo06mXM+PYSg2tpT1AR0aUFPfEGUQQHFR04Etu9DQn
	 0Kuc/enHFZkF8DNQwIn+HG/4iKzr9yYeQoJbvNsDIKCGLso8ZJpor4GSiCNNLrBXMh
	 OKYdWTFaZT+DG7iubx5Zykc+zhWg1Y0PAWB2ynF9R7WOSJ7ORo+oHmpgyaiNrOYccs
	 EwUoys73JxL/g==
Date: Wed, 14 Oct 2026 23:31:19 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: daejun7.park@samsung.com, fstests@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>, 
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] generic: test that preallocated blocks still read
 zeroes after I/O errors
Message-ID: <as-dShqu7w8OBYm4@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	daejun7.park@samsung.com, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
References: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
 <aszSZ7Y2f8sIorpU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszSZ7Y2f8sIorpU@infradead.org>

On Mon, Oct 12, 2026 at 05:28:23AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 08, 2026 at 07:18:24PM +0900, Daejun Park via B4 Relay wrote:
> > +# dm-error table sizes need zone alignment on zoned devices, and the check
> > +# needs a mounted file system.
> > +_scratch_mount
> > +test $FSTYP = xfs && _require_xfs_scratch_non_zoned
> 
> The canonical way to write this would be
> 
> _require_non_zoned_device $SCRATCH_RTDEV

Currently, there doesn't seem to be any usage of
"_require_non_zoned_device $SCRATCH_RTDEV" across the existing
test cases. So I'd prefer to leave this suggestion for the
author's next version, once it has been properly tested and
verified.

Thanks,
Zorro

> 
> Otherwise looks good:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
