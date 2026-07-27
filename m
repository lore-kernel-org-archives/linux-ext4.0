Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47705309EE7
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164767; cv=none; b=C4NWI1woR35YFGGB+XSni0dHFaIXXdcKlvhO+cYA9QD83n6+AKPMHTHO8USXAmFkSYzlud8egT41SQkq4rReYfSHtmya1MufYmlAA/AEP7cGIEsNAFAKMBVaSbyMN2gOGtEy3uQApHGRx1bjy/E88L2WeuIcQkW3nZT55x1VO1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164767; c=relaxed/simple;
	bh=m4+gpkxYAXVaGp4+jIn9SEt1HLlLOomFzLARU16PglE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLkY/m/DjGCDyYDbUzcV0208RKq+iKB8viQ2q87CYnYWXS6aFkwsaNwQJFBW3G1lhIh5ymSYFKFTm9KbHv+fVnC9n5x27hS4VhGXB+dw5U9uZs+6Lw8uZbdxu6QCZQ9egRsY0a6fEu7DVh6OWaC6/5fJv37bTicIsLUkiQuw7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VIKeDeF+; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VIKeDeF+"
Received: from macsyma.thunk.org (pool-108-20-43-42.bstnma.fios.verizon.net [108.20.43.42])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66RF4vcF021997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 11:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1785164702; bh=VFUfpxZMKrf43WdnFqE9kXx/WRjgl+EWIgbkDk5d9vY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=VIKeDeF+aNyervOAEGF4lUHv24sttAiDCsow9CNdQ80lBSIR5ITAbdDWm49Ss9iC5
	 m+XOAfZOmfiKFRk+hqD1NChbPHsN+4Zr9ItTvHoTnwyTcEbfwHATqq4dqAThQJJvE/
	 /Q5xnVgHCCBXTZYEBFFAMKF5HEr3qIYl+NDNM04miePxgzFmiuMp9dJm4PyBPHJxfD
	 m/uyHnxaHC0dK+mzrxjdVA4o8UzSnS+rW4FZZycwSBevS6JH1PEjsUiB0bEiFVvRvM
	 X2kzLspPYjQatHgAt3lHhouqlpV4x81WmagEPNvY1pCLEIH1IXv6eH60XrYjk+1Ap6
	 6QWS6Ta+IYK9w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 661FFC2C9DE; Mon, 27 Jul 2026 11:03:57 -0400 (EDT)
Date: Mon, 27 Jul 2026 11:03:57 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] ext4: phase out inline data write paths for
 regular files
Message-ID: <amdhvSR2YL-3AJKS@mit.edu>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>

On Mon, Jul 27, 2026 at 06:54:32PM -0500, Yun Zhou wrote:
> 
> The inline_data feature has been a persistent source of bugs in
> ext4 over the past three years...
> 
> The root cause is architectural: inline data requires special handling
> in write_begin/write_end, writepages, page_mkwrite, truncate, and
> directory operations, with complex locking interactions between
> xattr_sem, i_rwsem, i_data_sem, and page locks.
> 
> The benefit is minimal: inline data saves at most one 4K block per
> small file.  In practice, very few regular files are small enough to
> benefit from inline storage -- mostly only small directories gain from
> it.  Major distributions do not enable inline_data by default in
> mkfs.ext4.

I agree that inline_data feature has been a persistent source of bugs,
and is relatively minimal for data files.  Howvever, the regular files
that are small enough to support inline data come really boring filess
where we're not doing the really stressful things that fsx, fstress,
syzbot, etc. do to punish the file system.

I do think there will be some systems where there might be enough
small files (especially when the blocksize is 64k, and the inode size
is larger --- perhaps 4k) where it might be worthwhile to support the
"boring" inline data files, e.g., small config files, header files
etc., where the file is written once, and closed, and never modified
again.

So what if we had a mechanism where we're using delayed allocation, if
the are no open file descriptor, so races and deadlocks can be
avoided, and in that case, we can write it as an inline regular data
file.  Otherwise, we back it using a regular block.  I think this
would get us 95% of the benefits of inline data files, with much less
of the complexity cost.

What do you think of that approach?

					- Ted
