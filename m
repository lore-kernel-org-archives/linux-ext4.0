Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B6E14BF92;
	Tue, 27 Jan 2026 06:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495330; cv=none; b=ejB0fe/AEPpfRXMAeoFSuPpvTbyTVkjjjKRDUF4OozzFaXmNRGvSToedr5wwqtTsybKK5OcaeRGjgtMbWY5VCIYRBWLLlpjIgHeuHQ2m1HCv1dKAhj/a8OMcdDivxZruI8RFKkYHD5Alr2LLplIuB/8jIFjdXqBewsvMM7DAFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495330; c=relaxed/simple;
	bh=B1kq0mimRXX8LQj8FS8Moi/visceHxddCmzC7rqxylg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxaUYs2qAYSvfLBEnbTV3dMpYW+mr+D6BJ/Yy2hyJdCgtndaM8nLxg58ocXgyRmTMeLmyHRvJ+C6ZzKLuthh3PcQz8//mpzAQU0PVCl6FpP1W06g/YpV4pxB1nSvFaAeR08qgu4kSE6JmJeCFooEcH5crW5zXFJOKj7ua/cQ89E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qR32wjGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qR32wjGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3043DC116C6;
	Tue, 27 Jan 2026 06:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769495330;
	bh=B1kq0mimRXX8LQj8FS8Moi/visceHxddCmzC7rqxylg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qR32wjGxWRHt4sD8mPbI7rcQeLPnFCSuBoyBOLMWuV6cfAXqq2hqcyoCNuTuVwXNI
	 8LAEzwYd4U2vqsThpgKu7kD34zAEBrj/JW6F8l3rrkgR/yNBydoRkbbx7n2QVP3BxB
	 lM+TrT14AtPXT1eEet5gRIvAcOx6Y7SITQCVjaP7uG7u2RbA+pkICqumStpVRj3zFX
	 I4SUvd4HjDRdbPhg9apW+UFxMtUsuoTt4LR9zjW4gmx0NKsrraVG8yyJVHBe0tteEu
	 DHwKninryNHDNzdhQlmMZ2GodmOjmOLqR4oHNQlTmMxMEIkpjP1NfFh/zsRVbLrYLV
	 6GpiKRa4Jr3wg==
Date: Mon, 26 Jan 2026 22:28:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, fsverity@lists.linux.dev
Subject: Re: [PATCH 07/16] fsverity: don't issue readahead for non-ENOENT
 errors from __filemap_get_folio
Message-ID: <20260127062849.GX5966@frogsfrogsfrogs>
References: <20260126045212.1381843-1-hch@lst.de>
 <20260126045212.1381843-8-hch@lst.de>
 <20260126191102.GO5910@frogsfrogsfrogs>
 <20260126205301.GD30838@quark>
 <20260127060039.GA25321@lst.de>
 <20260127062055.GA90735@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127062055.GA90735@sol>

On Mon, Jan 26, 2026 at 10:20:55PM -0800, Eric Biggers wrote:
> On Tue, Jan 27, 2026 at 07:00:39AM +0100, Christoph Hellwig wrote:
> > > -	if (PTR_ERR(folio) == -ENOENT ||
> > > -	    !(IS_ERR(folio) && !folio_test_uptodate(folio))) {
> > > +	if (folio == ERR_PTR(-ENOENT) ||
> > > +	    (!IS_ERR(folio) && !folio_test_uptodate(folio))) {
> > > 
> > > (Note that PTR_ERR() shouldn't be used before it's known that the
> > > pointer is an error pointer.)
> > 
> > That's new to me, and I can't find anything in the documentation or
> > implementation suggesting that.  Your example code above also does
> > this as does plenty of code in the kernel elsewhere.
> 
> Not sure why this is controversial.  The documentation for PTR_ERR() is
> clear that it's for error pointers:
> 
> /**
>  * PTR_ERR - Extract the error code from an error pointer.
>  * @ptr: An error pointer.
>  * Return: The error code within @ptr.
>  */
> static inline long __must_check PTR_ERR(__force const void *ptr)
> {
>         return (long) ptr;
> }
> 
> Yes, it's really just a cast, and 'PTR_ERR(folio) == -ENOENT' actually
> still works when folio isn't necessarily an error pointer.  But normally
> it would be written as a pointer comparison as I suggested.

How does one know that a pointer is an error pointer?  Oughtn't there be
some kind of obvious marker, or is IS_ERR the only tool we've got?

--D

> - Eric
