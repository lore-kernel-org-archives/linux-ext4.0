Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B688CA6B
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 05:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774504049; cv=none; b=O+VtUWA4FrmuZBYKY8y0HSZ1EzzkjuK0nfEo+YKgi3RifosoNBsQDxKPO7uxrbmQQeWzsW6K5nAcPswTf+PcE017Tp3prD9HK/yPS6RhYVkuBOdI2MTiWquE2JoeDYTOwvVuT3K5Ddv5djYg23YgCdHFdwwYH8GPG60Ujjma2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774504049; c=relaxed/simple;
	bh=PtB41byst+ee11TRU5yQt29Jx2yogSytmfW0XJOMcU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mkc6BRTP6pUNPpc0dzPnN6uB5A+qxKTgmqoUFUfMylCMiFcQa/oM7SzMU+r4/oItU5fjEVFakp7HwRZNxCswVVjpEMx9ebXHg77p+aL3gXuKjLbSjji59ZVy2u2jaKl6C/AdWjrmiBOERqGHCOIaCbaO81Y8JumLaMHMmUJd6TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=isrxw1f2; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="isrxw1f2"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62Q5lJ6P014577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 01:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774504042; bh=UdPEIcyb6ST0uEqOqYxIUNmRP8VjLTSZANdHFEcKzIY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=isrxw1f26DvDnCxEBFntJdqlVabayOiRo9B4ChcS9PNqvLHA55YynIQMOziupkwba
	 GAxon7GlnDtqUmnIoqi4fLArHXW5mTL9lQTkcSA1agYJEnZfHoCk+mtQG7Co8qRDbI
	 NPZIa/TUl2h+UMPw+IPEjEq2ZR50kTzDPthw1eh7uDWrncjKy3yGHSRe5ruVbnx9D5
	 MZ+c7FxDLiLu+ScIX5TUPguPCABFQEva79jYTxINBYPXucB95hNMIt7O6KkWUa6GLq
	 0hgPG3vCV+FCfFdiBb5t9PcKYG69NMuRfOYNHCfkjOtHb0iMd1m0mUBRu352+/wOqt
	 oNcphxRZgrzDQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 22B485F5E22A; Thu, 26 Mar 2026 00:47:19 -0500 (CDT)
Date: Thu, 26 Mar 2026 00:47:18 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to
 prevent out-of-bounds access
Message-ID: <20260326054718.GC4383@macsyma.local>
References: <20260224231429.31361-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224231429.31361-1-kartikey406@gmail.com>

On Wed, Feb 25, 2026 at 04:44:29AM +0530, Deepanshu Kartikey wrote:
> When mounting a corrupted ext4 filesystem, the inode's i_extra_isize
> can be set to a value that leaves insufficient space in the inode for
> the inline xattr header and entries. While ext4_iget() validates that
> i_extra_isize fits within the inode size, it does not account for the
> additional sizeof(ext4_xattr_ibody_header) needed by IHDR/IFIRST.

Actually, it does more than that.  It also calls xattr_check_inode()
which should validate the xattr block in the inode.

So instead of adding the check in ext4_xattr_ibody_get(), we should
fix the check in __xattr_check_inode().  This is preferable since it's
more efficient than checking every time we try to fetch an extended
attribute, instead of validating it when the inode is read from the
inode table block.

					- Ted
