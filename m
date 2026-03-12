Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015522820C6
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325453; cv=none; b=LjFWjNDWvzG6wy+cpi7d2odF+NT40GmXCg13JH6Vhj8a27Kh/xzlyPtpj0FarzZX6K3BJwfxBUQDrgZRYHGQzLb5Y4y+mAQT4eZbaBp0bwFjDT6tUgURc/VOUKXW9GQoYSMflV73zWlKqORKohhzfDcnmBcO06ftUYgTd45BV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325453; c=relaxed/simple;
	bh=i9yT9FeM3/WxOJnh3KbfC7d8LmcD46jw5+8L5fzUCfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8GRRpG/o6ytfNksHK66/nAuGjY04JEu9p+pKdYR+PHCXNqM/A0/QJHj1UNLuig5tmuLHRRWks9lHeNJvSnCk94ILtn/Wv+dR0pMKklOdSFWDuRj5mTlv6qF1zp/z0t17q3IvFad4gs3HUF5veP2JybzIagJT1K+p83ieU11Vmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=TOMti2ms; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="TOMti2ms"
Received: from macsyma.thunk.org (pool-173-48-82-98.bstnma.fios.verizon.net [173.48.82.98])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62CENjJq029865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 10:23:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773325427; bh=8sVFQwueacNF2ffXdVWcLqc510X70XmJe7FWrTN0S90=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=TOMti2mse/vS63BUkERyDjTdBGDKX9GOJngvCOYOhYEkSroDr5qqt4rPynuJHdfB9
	 tATnMAlB23yDhxQ9bZM0AagqjB2A18I4t5n04Jy5g87ITZMWLYMsGyHQRov+nOypk9
	 lk7rLrJvznEhKxcAGwotSYJ/r9bUlcyk4qTYWAchZfPjN3Npy5UgcAkxZMi0p02xq1
	 XpvlAhZz6fTqZLCpGnvU/C4+/dGjkeyj2p/NBFWt8vwtUCoBhLj0GjQAwoX/T0SDf9
	 jkoZNVRG4lGDxb+7tINC0kOAguAQZaRi4Ekdqkwtog9AhcPkFOe9S+4taGOOS8PMiu
	 fPv+VMe78bCaQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 79CB25D0C5BA; Thu, 12 Mar 2026 10:23:45 -0400 (EDT)
Date: Thu, 12 Mar 2026 10:23:45 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [RFC PATCH] ext4: handle wraparound when searching for blocks
 for indirect mapped blocks
Message-ID: <20260312142345.GA4689@macsyma-wired.lan>
References: <20260310122806.1277631-1-tytso@mit.edu>
 <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>

On Wed, Mar 11, 2026 at 10:38:20AM +0800, Baokun Li wrote:
> 
> Good spotting! ext4_find_goal() ensures that the goal block obtained for
> indirect-block-based files will not exceed EXT4_MAX_BLOCK_FILE_PHYS.
> However, on an ext4 filesystem where the two file formats are mixed,
> it is indeed possible to get an excessively large goal group via stream
> allocation.

Well, I didn't spot it; an LLM AI noticed.  :-) Arguably I should have
noticed it when doing my review, but I didn't.

> Since the mixed-format case is quite rare, I think we can simply validate
> start in ext4_mb_scan_groups() and reset it to 0 when it exceeds the limit,
> like this:

No, I don't think that's enough.  It's not just that we could have an
excessively large goal group.  The goal group could also just be, say,
2**32 - 5.  If the next 5 groups are full, then when we do an
optimized scan, we will end up beyond the 2**32 limit.  That's why we
need to add some kidn of wraparound logic to *any* caller to
ext4_get_allocation_groups_count().

							- Ted
