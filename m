Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1742D97AA
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899988; cv=none; b=BeMn0a5W9LZlbpYlRXxUqnTzqAjGgplrgWukz0xIXADrsPoWOs3pLQCADtBY+8U/30f5KsqphFZySzp15VddLi+GP8873BJlvCn0ylQJNwrh/ACoeNGaM6p5AKZwbDBjtfudFit9t+WTmfmehUQwIKYBL2j+05jkFS9l/cvWhrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899988; c=relaxed/simple;
	bh=HGSifeCFkPOFM5364fIRHH6ybA2lLzYLiQfk6BfCT9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nh6eLqCvbP/+eA+9vxuK7WVzJGrYgfFXRrs/i8/i1nOa+4sNC4zXlZJmRDIIx68e1MnT0ebgo3FLz5XsYUpt2m8nylarCM1FmRGI91bZieUphpayLdVjX6TEVetLDXF2Vrpks2pFz8Q7Vd8N9XZtRQ3JAPH4Iw7ji1B0l99/xkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HyI+ynTK; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HyI+ynTK"
Received: from macsyma.thunk.org (pool-108-49-209-71.bstnma.fios.verizon.net [108.49.209.71])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ODWKxJ028769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 09:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784899945; bh=s8aCIQGBFXj0mN9QYuNYXh3RRlWtO91NRA7l9cPcCw0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HyI+ynTKQVXmQSzNPNj26asPenORVzDGCWp8N3Z7k7bwF7XWPxPMbqfdZanF0NNul
	 gA89UfUp0pJX2jz1OoYIOIFoXd/6d2UXwtiKc2p1MqQpIKx94IHxrJ2CmWu+lbNOtl
	 bMSRwi1+UWaJ7Do5ClEWNIbJ8XBuQoQ7YjtwnqFocSv7veRJ4E0SqO8AYWbLiQ/HPh
	 3hA9OYHKANqF7700+kDKkn2XRwZfN4lxRNFMdTp1z5Vt28+nQZsLidrJDWHiRCUy9o
	 FCRnJznjRLhHs1y25NqlMyZw+v371wn1rEMhwmqktKQVVVrkDBElQyTGz3lmFoxXbc
	 dUZbAlNr+ZMpA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 055C2BE8094; Fri, 24 Jul 2026 09:31:20 -0400 (EDT)
Date: Fri, 24 Jul 2026 09:31:19 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Christian Brauner <brauner@kernel.org>
Cc: Luyao Bai <bailuyao1997@gmail.com>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not WARN when starting a journal on a frozen
 filesystem
Message-ID: <amNnKl4V7DPrBHX_@mit.edu>
References: <20260723205036.661832-1-bailuyao1997@gmail.com>
 <20260724-gaben-sachverhalt-medizin-312848359765@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724-gaben-sachverhalt-medizin-312848359765@brauner>

On Fri, Jul 24, 2026 at 10:11:01AM -0500, Christian Brauner wrote:
> I can't say whether this is the right fix but it feels hacky and racy
> unless this code holds s_umount - which it may well do.

Oh, it's worse than that.  From the Sashiko review[1]:

> [Severity: High]
> Does returning -EROFS here cause fsync() to spuriously fail? If userspace
> calls fsync() on a file with dirty pages while the filesystem is in
> SB_FREEZE_COMPLETE, since fsync() bypasses VFS freeze locks, it seems it
> would hit this new path and fail with -EROFS instead of safely blocking
> until the freeze is lifted.

And it's not just fsync().  Any caller of ext4_journal_start() will
end falling into this codepath, which means most ext4 operations
happening during a freeze could very well fail with an EROFS error.

> Also, is there a TOCTOU race with SB_FREEZE_FS here? If a background
> writeback thread evaluates this lockless check while VFS is in the
> SB_FREEZE_FS phase, it will evaluate to false and proceed to
> jbd2__journal_start() where it blocks on the journal barrier. When
> ext4_freeze() finishes, it drops the barrier and VFS sets
> SB_FREEZE_COMPLETE. The blocked thread then wakes up and starts a
> transaction on the now-frozen filesystem.

Luyao, I'm curious what (if any) testing you performed before
submitting this patch?  And I'm curious if some AI / LLM was used in
the preparation of this patch?

Thanks,

						- Ted

[1] https://sashiko.dev/#/patchset/20260723205036.661832-1-bailuyao1997@gmail.com?part=1
