Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF71A8F7B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 01:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788400116; cv=none; b=qA5OBlOmQbbbtW4BGshqqhkksr75FMORagOtwJ/uS/Spfd8GXYGFDH3sxi9rUsosj70GEnNecWaXUclsQ0hB/60L8BDx7EcB3dN8VkxTMSRmfucSlGpTEDupBckit5tNWjmAdXi+8WUgretohgJCyqQx+EGE4XfB5sEi0ZPZM44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788400116; c=relaxed/simple;
	bh=QjdU6x97UIFNWjlIdOIn1rQzz16ZMJAhF/LN4x1vx7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRFmc6qMkeT2SFCBw/Fj66k5T2yjS/UgRRF8qzbN00z2U0Mz4OuAeltnFX1dmj/R1wdaVzh1bJJR++ZX+KVWodAUNtulTM7YCRoIaO9ANV3oFjEzONCOukiOZpLSY+p5soOU6i+wI5SboGGwB2s1CkzzpGXQGmQmyZvpVmNhyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=DdlGPc4N; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="DdlGPc4N"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6831mLic013037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 2 Sep 2026 21:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1788400103; bh=w0SgfTIsVWTdZ+Uib4oEP3tpsMjxwIY3ixRPXJFTVT8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=DdlGPc4NgU+ESshZF72snGz8A4ltt8kFLvxkhqBqplsGvzM/GWuE3EmX1TC/VsYT6
	 FMGnfJAhF0NnEf9e9mVmxouJPRgmo9WKd5J+63Gb4o/XJNrPgwwFF4LXDFWaQ/5pcb
	 Uu8LpQ9s9X3x2g9H9py1W6zVOij2ItCWloG7sHlF3q4Qf+DmBXuKjbfnyM0Hhcbt6J
	 +Ccj0if/yGT/7gaefkaUV2UKlnE1H0PgLccjDPM1ZvPpOtZqgGeU5xFkvg33rSaGYg
	 wRy5xmpAXbmype7z8C6SOWrH7BjcnwTs8/Y/s9fNA1YYerK/zyhBESXAD4v6prnUhp
	 skkd57r949GNg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B9601130F233; Wed,  2 Sep 2026 21:48:21 -0400 (EDT)
Date: Wed, 2 Sep 2026 21:48:21 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Possible regression: ext4 lsetxattr returns ENOSPC on malformed
 image since v7.3-rc1
Message-ID: <apjGcCYzNVZaH9Y7@mit.edu>
References: <20260902160352.A55AA600BB@cobra01.cs.unc.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902160352.A55AA600BB@cobra01.cs.unc.edu>

On Wed, Sep 02, 2026 at 12:03:52PM -0500, Hengyu Liang wrote:
>
> We found a stable ext4 behavior change: with the same malformed ext4 image,
> a large lsetxattr() succeeds through v7.2, but returns ENOSPC on v7.3-rc1.

What happens with a malformed ext4 image is quite frankly, not
interesting to me.  How we handle a maliciously corrupted image is not
something which is defined.  This is *especially* true given the use
of the mount option debug_want_extra_isize=104, which is not a
real-world use case, making this case doubly irrelevant.

(We've never actually used the code path which is designed to simulate
expanding the base inode in the two decades of ext4's existence.  This
is because it's rare that we want to sacrifice bytes for all inodes,
especially if the field is for a feature which might not be useful for
most users.  For most features that might only be used by a subset of
users, using an extended attribute, although it's less efficient, is
the preferred approach.)

Cheers,

							- Ted
