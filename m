Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE43B95F7
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773240020; cv=none; b=sWH1xBjsBY0qbK4OfuVId5Usl3k83VGnqIPFlpPpxSMoQb8hEE1CQfUm3XOS0zbFdodO/h3jQDyBx1W3o9NsyM1yuSUIIivfh8d8qTYDjW/YiQSYzH0MkfzI4BbeRBGRk/llrfrSpCKrKIL+lRiWoxWXsEedKIsm4+fAFi3J3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773240020; c=relaxed/simple;
	bh=rTEN+k3+Fcmxqj9XhmaWL0uVgoYNvz8Mn6Z/4/Sxh/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgm/TeAKSULB7b04wx3PRYB1EwUhZPKbcy3pvWSL1d1+w0xDtNw+P+TPoRqcPDhHzzPWZ5am+V2+BLPfRziNvZBqrZL/0PTWGbVqthu4eQ8bXjQ8+nfklrpknjUDyCGZxrUU5SNrJMSgez33hw59yYs/ZXTkznoPRqOW2D4WxZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=l6Xy0pjo; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="l6Xy0pjo"
Received: from macsyma.thunk.org (pool-173-48-111-151.bstnma.fios.verizon.net [173.48.111.151])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62BEe8OF014208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 10:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773240010; bh=AgjJem37quBMwOLs2gRyRDzSNy5ini477BlMc2kgBUg=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=l6Xy0pjompAtzutNsTRyTm4/eyuuOjz+bQjOwsFwghkA2i+sqUmOlkRNISZ4fFCWz
	 7oF80F4dmMNwpUEu8I/NPDzNxXiJHeSuvruos6RN0qLTy3oJnle5Ld3nY9XC5eHPE0
	 PMVPUEiu5Cyy9VEMLUpIg20vmm6TN1baEpdTE3dDNPYHypZM826Ej6RI3+d3Qbdlse
	 dVnqpqzOJs4Vw7SSYYqKQZ9nLqsvAtAgzPlRnwzgjqzb9YbEKym+pAzL6K/6OX7chB
	 gISBHEJ4EfsVzpDa1+Emgo6OtQQdtQWmF7mrLHiEVSEBoWILHcvSCB29s4Mk5qGeTG
	 ujbdcxBgdTrCg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 018DD5C71B92; Wed, 11 Mar 2026 10:40:07 -0400 (EDT)
Date: Wed, 11 Mar 2026 10:40:07 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jianzhou Zhao <luckd0g@163.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: KCSAN: data-race in _copy_to_iter /
 ext4_generic_delete_entry
Message-ID: <20260311144007.GA69804@macsyma-wired.lan>
References: <6c4b2013.6d16.19cdbecff3e.Coremail.luckd0g@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4b2013.6d16.19cdbecff3e.Coremail.luckd0g@163.com>

On Wed, Mar 11, 2026 at 04:04:28PM +0800, Jianzhou Zhao wrote:
> Subject: [BUG] ext4: KCSAN: data-race in _copy_to_iter / ext4_generic_delete_entry
> 
> Dear Maintainers,
> 
> We are writing to report a KCSAN-detected data race vulnerability
> within `ext4` and the block device layer. This bug was found by our
> custom fuzzing tool, RacePilot. The race occurs when
> `ext4_generic_delete_entry` modifies the `rec_len` of a previous
> directory entry (via a 2-byte write) during a path unlink operation,
> while a concurrent thread directly accesses the raw block device of
> the mounted filesystem (via `read()`), executing `_copy_to_iter()`
> which blindly bulk-reads the buffer underlying the filesystem page
> cache. We observed this bug on the Linux kernel version
> 6.18.0-08691-g2061f18ad76e-dirty.

Any attempts to read from a block device while it is mounted is
subject to arbitrary race conditions; there is no guarantee that the
file system contents accessed by userspace is going to be consistent.
In fact, it's practically guaranteed that it will not be consistent.

So this is considered NOTABUG.

					- Ted
