Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DC32D77E6;
	Sun, 30 Aug 2026 04:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064339; cv=none; b=hZAY+SB1DMMuwkYrl/tbPZYGNdBL4RPKRpoWhbrUr0EZEjEQLNa+meIVvpKToWp3Vje7ssWxvzi993/kOQ5Gursz66WaOn0lSVOgGSbAaQuV32luXAp1HWDtKbXydZlG8qK7VJEiiP7rqSFalzxY7VCzavUjrcHMVjBnxHdIHbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064339; c=relaxed/simple;
	bh=/6/Kudc+rto/PiO0BGoY1rVw2Jh24n3qNXrado/+7k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIniT66MWJN2alxBh5oVh7TnqLbP1uUVvPubR0ypcyaHk/qv9NdKGQGXCU28YnoFns+u5ZtZ0/qAGwM8Ct5lmO0fgoUh30ETDVqGBFrVWkQtryl7xgEbDiFISCblwUOAT4GQoFgX+OI76k+CEazfhMRh3cVV1FLXFl2xpeXmdZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GvgsSC4z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GvgsSC4z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X3Vph7s0LxXOOxnknxssBy1Vh6d6iLqKfeqP8yyMQYM=; b=GvgsSC4zFzBVYA9pDs1drldvKc
	wyntdBfuse8LjISe+HCpWn7bHFTHKL2j8EJiqFRNDTBuMbzHVXe+x8/6VonGp/SNyacdPg0nPXT7l
	YxDwY2lGlbrcg+W4k0aamVXIxRVcnx63sMh/kWyfpHmGlWMQsR/Ox/wwPBOfSq4Z1V7PICwfgTGK6
	zHpsjiVqmabpqYrdCz7fmjEB+yIKAEKK/dc7uGqDJ5j1yP6CB/9yspAjFk0F2L3sXoC/l7/XoqLwr
	SNymM/e2cAxNMHXKI7dLht3mp/iYwFejSTwYVaUq/zFY9RTMOnsLgjn/x79gZ+uQGHGINZyrwcYNI
	kuwCTsXA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0XDM-000000001yS-0qMQ;
	Sun, 30 Aug 2026 04:32:16 +0000
Date: Sun, 30 Aug 2026 05:32:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jeff Layton <jlayton@kernel.org>, Anna Schumaker <anna@kernel.org>,
	tytso@mit.edu, Chuck Lever <cel@kernel.org>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 9/9] filemap: Remove FGP_NOFS
Message-ID: <apOyT6uKUPY5P_JR@casper.infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-10-willy@infradead.org>
 <20260830042742.84E321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830042742.84E321F000E9@smtp.kernel.org>

On Sun, Aug 30, 2026 at 04:27:42AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Low]
> Does this removal break the build for f2fs?
> 
> Looking at f2fs_write_begin() in fs/f2fs/data.c, it still relies on the
> removed FGP_NOFS flag:
> 
> 	folio = f2fs_filemap_get_folio(mapping, index,
> 				FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_NOFS,
> 				mapping_gfp_mask(mapping));

Hi Sashiko, the tree you've applied this to for analysis doesn't include
commit 35e5554ec14b which removes this flag.  That commit was merged
into Linus' tree in 115bd364ab20, please update your tree.
