Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BEE48A2D9;
	Mon, 12 Oct 2026 12:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808110; cv=none; b=pbZhjRjr8xu1j5N0n+9M5ydBHiC2zBXr1gjQLgz3dzMmD5PNYPAul2FLE44KAHx2DKseTuFdNPs7fpQxSLNixJxwqLp7966IuCArJUpuIRaRgm0RvFg6VLFwMOXf97nni4sekIMfC7Rf/5nGWyhYu69zCWnwcej78u8yglr9cHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808110; c=relaxed/simple;
	bh=Vcu/HCEhq7DCjXml6syCX/GU4xL1ShWeVZsI2fAEF+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ad/WuSaKnOVzoqDHdoQWiRi/ydaB578KD5JPq8Fc+0VOeD5zlr5cwETsqZxS/cDyt2W2CmoKbilwokuxhQSDvPCwCZgRPbU9VlawI5XwAW2lHALxqfVhnaGdrTa92jaG6LFgJi47Cya3uovmyL52dfKUSVeFJy77mTQaW1NWdcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bxyaLWFe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bxyaLWFe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vcu/HCEhq7DCjXml6syCX/GU4xL1ShWeVZsI2fAEF+I=; b=bxyaLWFe1xOm5MqyME5cDDfZtW
	vnHPoWJNVGDqEvkizqlWW7LmT2g0aHxsjDKdLiNSkvFto+mFcBE8ckjqnBgAQFB9Ftg19PQ3lNydP
	UpBpDAtj7mrkG0p1B9AjyWfJSKKfMp3B7DFQKnqS3LR6jMPFf23AWy5944e3OoCeLlZZChdwkB9oT
	r1kXxvUNWvMalf6TOaCJ59T1eOCHR9DIaFhUPPsRHgJUMEf17tV6oYIx/gZGWUrPS+XCmYqqES56W
	WLHJXORYvIz0Kk4Bf9EfUJgSy1ZzMrromAORGowD4nqUkDH2ysx/0ubBUKi8xtoEmDyIHbbnXdsfK
	6Nq4p+NA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGF8h-0000000ASDK-1suX;
	Mon, 12 Oct 2026 12:28:23 +0000
Date: Mon, 12 Oct 2026 05:28:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: daejun7.park@samsung.com
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] generic: test that preallocated blocks still read
 zeroes after I/O errors
Message-ID: <aszSZ7Y2f8sIorpU@infradead.org>
References: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 08, 2026 at 07:18:24PM +0900, Daejun Park via B4 Relay wrote:
> +# dm-error table sizes need zone alignment on zoned devices, and the check
> +# needs a mounted file system.
> +_scratch_mount
> +test $FSTYP = xfs && _require_xfs_scratch_non_zoned

The canonical way to write this would be

_require_non_zoned_device $SCRATCH_RTDEV

Otherwise looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
