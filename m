Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450E3A6F19
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784644207; cv=none; b=Z5Zh8QudxevSLkvyx4rwa8Y+vJsjSUGVaMcG90n76t4ZVxfnaMX82ABBLz9w/NCJh3vskrVcIKoDkg+cO0zswFucSzb9r9cAIa+ubX67D69uJN+2Oe368SmQ//tGoceKW9ISN4nQiJzf2FxnIvlWtuBOMG17Lm3zKEdcjehfaUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784644207; c=relaxed/simple;
	bh=bFFk8zgkySDPWs21DeUVG7O0wL5elAJGSodVRejPgwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvkqeMiqs500FE4TooZfr/H7F6Pj80AhS6xo3B46m9/3/6OWaKiWJJGKbNjkcq6hzUpl0O+0opzi4IsrQzeqZVm8HGRy7eBkm/RmdE7L+TtrhCNyFR3zYOi3yFSaJpONe/BGyuphaBnB6JOBpHDWLhvpSb0Sxxvm1roMZUFrn6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RF4Jl5Og; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RF4Jl5Og"
Received: from macsyma.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66LETtwl023742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 10:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784644198; bh=ouFWh6IaU+DPbLrIKJfznZDajsuzKSi5rlJeA5mT0so=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=RF4Jl5OgbM59C7taleWFMJPJr5ZCFNnBhVEhAkh6Zux/OiNWlTxYgW4h3JewA4m3t
	 VIGcP4yJEOEbfUHnCh6M0VCz9s4JcfCtUS3zOhmVupd2vZXU69wvmVeJlxmSETIiaU
	 Q1IarBHOQihh2nomAl2at8agiEOFM0ZdlL2558EBo0m55Z6Ily/pDlJvhKZ+A8Y7Fr
	 a5sKHTJzWLsFr2jW3+WVGwQNS9aNX+XESIW5e+35ydhK3zHMMcDtcvYdxguR7cZlYc
	 7UlantayhN3SCjTVX8QY4S5694sxQHusV/4AyvSEhKMAHnX35pv3GRmLnX/MnXM81v
	 9ut+LWTdKoXlg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 0522FB8543B; Tue, 21 Jul 2026 10:28:54 -0400 (EDT)
Date: Tue, 21 Jul 2026 10:28:54 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Helen Koike <koike@igalia.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-dev@igalia.com
Subject: Re: [PATCH] ext4: skip i_extra_isize expansion during inode eviction
Message-ID: <al-B7eVSy_jtDBgD@mit.edu>
References: <20260715175253.2171303-1-koike@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715175253.2171303-1-koike@igalia.com>

On Wed, Jul 15, 2026 at 02:52:25PM -0500, Helen Koike wrote:
> __ext4_mark_inode_dirty may be called from the eviction/free path (via
> ext4_truncate ??? ext4_ext_truncate ??? mark_inode_dirty), which may call
> ext4_try_to_expand_extra_isize() that could create a new EA inode,
> wasting work that will be immediately discarded.
> 
> Skip the expansion when the inode is transitioning to freed.
> 
> Signed-off-by: Helen Koike <koike@igalia.com>

This issue has been addressed via the patch[1] "ext4: set
EXT4_STATE_NO_EXPAND in ext4_evict_inode".

[1] https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windriver.com

Thanks,

						- Ted
