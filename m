Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0065021CFE0
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783692384; cv=none; b=KI2tEwUloOw7XoLTOrnbt3uDRODC150LKUe+6ONcDkvWm4Xp8NzhNVF7sPifDh1PeAKPz+d3m31fKMMy5C2kVKknTqLVjZvefF2+bwZPYoIlNPR4c6gzLhs5n1b/36/lxDDcR4lYGVCwQImlmiBud7dr8pgm7q4uZv9t+cEct3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783692384; c=relaxed/simple;
	bh=BSeqkT/sEU5VxdBERoioOlbKUWq/F11AD9eueJxDQiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3bJW4EOYYKIC2qZwhONwd+Ks800EapVToW6II/qonl+YVPYTyYpi/cLKpbOGuEXHvVwaeXeXhkIo4W/pZCXmDe7AN/qnpLysGgTcvNh98eXhoSlxHFF/FUiywfM/ScwDU7uRcr7S+J8KkFXikD9vsRY+5mLHk3VV3Kco1TLZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=izD/LZLr; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="izD/LZLr"
Received: from macsyma.thunk.org ([151.240.45.41])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66AE660J028346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jul 2026 10:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1783692370; bh=3zqoMSC9CKLV7T331cHIk+yii31h/xyMfRSAoEynpd8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=izD/LZLrNcYJlmA98WB7rJMHDCpuwZoblZaecWzVR7nBh+GXIC4umyXWcURJwfi0O
	 6WWuP6xzMThrqr7JfhOR6kog63mYv5R4jV/p/+FTxd/4cu8RnmuWtHW12s9koFEwjN
	 YNh9Mrl01WjMvJJVPmGUR8ZzA4vN3J2OXvT+D/XDES2ClRO/+8O7i1TBRLW9PytlAH
	 YPkL8fis/pizDGNdhWCqoRPSY3m4lVzwbl/SiRkbm+sBBDmC3kxya1BQJL3D5TtdcE
	 bAGEMPy20l/7WMYAt5Vep+DWJ1CNX7U3ee2Bs2hB3d3YpsZue3iv3C8RQz28oy/iwR
	 L9tXi20wtyTuA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 09B1B9552B1; Fri, 10 Jul 2026 10:06:06 -0400 (EDT)
Date: Fri, 10 Jul 2026 10:06:05 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Longxing Li <coregee2000@gmail.com>, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Message-ID: <alD7q_AUlNaUwAup@mit.edu>
References: <20260709075613.854-1-coregee2000@gmail.com>
 <ak-mQ2DnbaxIO_WU@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-mQ2DnbaxIO_WU@casper.infradead.org>

On Thu, Jul 09, 2026 at 02:46:43PM -0500, Matthew Wilcox wrote:
> 
> (also if this patch isn't AI slop, it's doing a Really Good Job of
> pretending to be AI slop.  Why would you choose 'unsigned short' as
> the type?)

It's AI slop that didn't even bother to run it by an AI patch quality
review process such as Sashiko:

- [High] Skipping `queue_work()` when `igrab()` fails causes a permanent deadlock
during inode eviction by stranding pages in writeback state.
- [High] A data race and logical flaw with the 1-bit `i_rsv_need_iput` flag causes
permanent inode reference leaks during concurrent I/O completions.

Syzbot also reported the inconsistent igrab state issue.  So it's AI
slop that wasted resources both with Shashiko and Syzbot....

Longxing Li, whether or not this is AI slop, this patch will tend to
cause me to distrust any future code submissions form you.  I suggest
that you test patches and look at the code much more carefully before
sending, if you don't want to have a bad reputation as a patch
submitter.

Best regards,

					- Ted
