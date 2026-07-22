Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D95242123B
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740056; cv=none; b=Omlk9mSqldz/FTfyaLKY0oCJ8w5bsxznrDbZuRNShN4+FiBDgMGLsEdHYDWUz0BWBmucyZ1+PetYrL5hxlNjRMQCG0gzd/2edx4nXCHF0nc69Y/aZGnWcXsSL8wKW3YEdVkyAy0uA9yMVpCs8eK778HjLwugiws8X+67K7Mo0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740056; c=relaxed/simple;
	bh=kUZbXwnpjPnZZdsjfaKmF9reZqXqBunFYt4xSWwGcYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oX+cneBk4j8ugbhriSb1/uGKIm4DXAc5Bf0i9oQFr88GQyXtNe7dO/UL6Ykdy4cVWcwRFQuOog2EqfVZ7FX7bWz7HISrmfKZrYe6mtmaHGgdqlQbfSJnS8x12ivRSG+2KyGX0t7vVAnVOHBppxGaUHbEfj3sjXtF7/tV0J/tmK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Y0TTXM4v; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Y0TTXM4v"
Received: from macsyma.thunk.org ([104.135.218.223])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66MH7DES013826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 13:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784740035; bh=kgbA8A3pc+ck1OKMHCgGDO3bWA5fNAN7z3mksbHMBqc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Y0TTXM4vYJh0V0747j6CKEhP7W1LwaL1zjdU00ktqofUmKrcdud6tQnRdocPQpdg4
	 wMSJyKsw1hUnBizxqTf8dLhxv+RXgcXsSEi/l4oaVhVgBKY8YEEx5UT74zfSrHeQLV
	 xSgt/086Hr4tn1V7K6XeIKMDDhgKKJwD0iUFAqJwPN14L0t6meSHggQhVGsxgnWHgG
	 lbrfe6R6u4vtJw8sWPo8JnGrgbeshVFzXssdL9fUm+gzlsTG+swwPsZt/sSRyL8BET
	 a6LkMqJgy74cKoRt5FzhekoeJYurrhXmnvoq5W3YkerRWZr5fBRAUp5enDK4GtYwAc
	 B9wavlmcueVFg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CE81DBAA19E; Wed, 22 Jul 2026 13:07:12 -0400 (EDT)
Date: Wed, 22 Jul 2026 13:07:12 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org
Cc: Zhang Yi <yi.zhang@huaweicloud.com>
Subject: Re: [PATCH v4 9/9] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <amD3fZPiCKwUqhGd@mit.edu>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
 <20260714080044.4038124-10-yi.zhang@huaweicloud.com>
 <20260714084203.971381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714084203.971381F000E9@smtp.kernel.org>

On Tue, Jul 14, 2026 at 08:42:03AM -0500, sashiko-bot@kernel.org wrote:
> > @@ -4701,6 +4729,11 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> >  		pagecache_isize_extended(inode, old_size, epos);
> >  
> >  	return ret ? ret : ret2;
> > +
> > +out:
> > +	if (orphan && inode->i_nlink)
> > +		ext4_orphan_del(NULL, inode);
> 
> [Severity: Critical]
> Does passing a NULL handle to ext4_orphan_del() here corrupt the on-disk
> orphan list?
> 
> If ext4_convert_unwritten_extents() fails on the first iteration, epos is 0.
> The code skips starting a new journal handle, jumps to out: and calls
> ext4_orphan_del(NULL, inode).
> 
> A NULL handle removes the inode from the in-memory list but leaves it
> permanently linked in the on-disk list.  If this inode is later unlinked and
> freed, could this sever the rest of the on-disk orphan list and lead to severe
> filesystem corruption during recovery if the inode is reallocated?

This looks like a valid problem; it's possible to get to this point in
the code:

        if (!epos || !new_size)
                goto out;

where we've already added the inode to the orphan list, and we will
then leave the inode on the orphan list.

I think we need to fix this by checking to see if orphan == true, and
if so, we need to start a handle, and then call ext4_orphan_del() with
that handle, and stop it afterwards.

Do you agree?

If so, are you OK if I just drop this last patch in the series, and
you can resubmit with the fix?

Thaks,

						- Ted
						
