Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355C8261B9B
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773845188; cv=none; b=EWlYFnuIb3VgKgGlTqRW2CCrXdt7iDF2TPJTgfXZwtmr/Rrrrg50vuRbUN2B4gC+Akk95mwv+ov1xbGgn1wCs4H9MQumorecsLOGN4B63GXsAtsWUEfLOBNeVCf5BhsUsJQOh3GQTLbCuWnkfThpn5Awv4gdiRgMxO+ADf9FrFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773845188; c=relaxed/simple;
	bh=E3hkf7oJJHGAbkP5IiSZnym+Y8ReXAsW0vJHLINye7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohENDhAVJBLCrdlM1PjabO6RPAT7SvBqSnjhnCKbjMA+iG8WA8tq5YNyBipcfN7lBlFcb9w9l8HiCS0MLtRDLhvd/Q6/X5Sfv+jX5Bcg/KBNW/4Z9q+WvyR5AgtsgSqpoLCy9bZI8n85lZdBhNosIQoTCepNUVEYMd12sEtBNg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MDBNTWDB; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MDBNTWDB"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62IEkAUX002854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 10:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773845172; bh=Ipml5wMNShVyp75/WWElayr2ONTOoHO9x8HhhqvmQ6w=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=MDBNTWDBtrzmCK0H4IO3T1IenRepJMqIjELzs42ew18QyqQSA5Arn7Fb3ZKk99DEj
	 bWMCqA+f9SLepMDJO1B/NJ6DPY0wNLtklnmdHo4owGzeqcEXMGQrktNYMPDIXvfZac
	 0T50sD2fD4MXGPlNIDhbaJeST4V5sRu6oLoDfK59Q1hA4j/2BQYX9wJCu/ZHCUzaAL
	 HDVXLn37fNLJepJspYk0JgzgPf765y3gPp3NixeIrxcSr7KBFyJ4+MwfV3a0IBrImw
	 OsswJxyPQrZR7bHV6ZjWAD6axVkYCrRcspA26IwCzYm7iPFnU8fbFoKkrAPQGBPn84
	 eaH/Rb2UzSWlg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id D122C5E200B9; Wed, 18 Mar 2026 10:45:09 -0400 (EDT)
Date: Wed, 18 Mar 2026 10:45:09 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: adilger.kernel@dilger.ca, tahsin@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        r33s3n6@gmail.com, zzzccc427@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: xattr: fix out-of-bounds access in
 ext4_xattr_set_entry
Message-ID: <20260318144509.GA82331@macsyma-wired.lan>
References: <20260318075842.3341370-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318075842.3341370-1-gality369@gmail.com>

On Wed, Mar 18, 2026 at 03:58:42PM +0800, ZhengYuan Huang wrote:
> [BUG]
> KASAN reports show out-of-bounds and use-after-free memory accesses when
> ext4_xattr_set_entry() processes corrupted on-disk xattr entries:

Can you send us a pointer to the reproducer?  And does the reproducer
involve actively modifying the mounted file system image, either via
the block device or the underlying file (if a loop device is being used)?

    	  	    		   	    - Ted
