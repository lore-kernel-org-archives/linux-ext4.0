Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927302;
	b=BUjN9pUnis8Vevlj7f5lgiw18lhEiCDNlz0RXGtEFjksgdxx2eO4HkpGh0uLH6lbbL9A
	 0Xab5c0AN/3YYawSkNIWZfUZ4knNtGi25OVqv/XKeTpjGiIrId5Mvx4mmfn5wMEsLSw8q
	 mfCSwEDNHYQp1fRaU/VkdYK5SLJGYFIRdRIb4FYcq96xvZbS0HUwMj/0RkSfsrK8DbRVe
	 C9cS2X6udjO/qnPSaoQljYer9nhScTtTkfOgEIC5oT+R0vXbG2NFpM1IlqF+TiqMhg0fO
	 n2Kn5hqXx6GUpqIqRT385kyUecThFcgrm0zsY2qCQd0zbv2C8+ogZ9bgajtzPf9lZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927302;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JZ67Ln6ziaBPsKaIzdqErWNCSGgvnSYlqc/yhQf9HX0=;
	b=2rX2ROQ9tMnIAIRlNPikQgHkbg8vidVakRmo9DakoXIG1GPgYs9U23WUIR8pTGcGDYN4
	 ODvq3D0e1Ag5zr20GWuhenjth/cq4HKroMVofN+OJO2CqedlhGAaIqCxFNHr5vjd7s+vF
	 F54UsLWyjjueeohqBDy26nry1fQtGIaGZJDWcIO2J2k152mO2SXOH+FGM8LbTFTOz4ZOk
	 GMJ2EBzmCBdVQdYlnKZRDCX6zHE7v6Uq6niY2SXsFimdNUGiitbDs6z1V/j+wns5e5Mae
	 qTc4IgpTz8OMMLIP4EFtrbEjPyAlhFmKi+bd1eo1JrnjwqOn6C6gIkAMjPyqWW9eg4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cxPrl4Mm;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D8606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 14:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E55D8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cxPrl4Mm
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AHEsWAV025356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 09:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794927277; bh=JZ67Ln6ziaBPsKaIzdqErWNCSGgvnSYlqc/yhQf9HX0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cxPrl4Mm1T30CBSddcZy5wnEp6gC/wd8ru0R7LA87M2l8dJaIPqQsiEnyxIe2ZUCU
	 eygzAr76BDUzp/18d24nDpDp54kiP9TiW4gx5pRs2JjFcjPA2j8s0FhAxU1sBKC/Ns
	 2wYcU39Se3OKsn0M4KHgbKq8MaZ9WrdqgSJ8RVv/BGGfvXOLpNvakevm0PinCI5Lqq
	 160eXk9lwAXj4dwMpeqCKzXwGRdgDLChvNGzx5Zs/A3xWNx0h5c43cHAOednZoLbE4
	 mItAna7bt2OFZ55xE4AomDkNmIffUWVZKGnCZE56UOJ0rloMcwNFABBHIPxd8yFtoN
	 95wDlCS2Zo9hQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A03EE27D8EC8; Tue, 17 Nov 2026 09:54:32 -0500 (EST)
Date: Tue, 17 Nov 2026 09:54:32 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: David Laight <david.laight.linux@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
        Sarthak Kukreti <sarthakkukreti@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Eric Biggers <ebiggers@google.com>, Dmitry Torokhov <dtor@google.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
Message-ID: <avxe5v6r1C7ZG7E2@mit.edu>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-2-sarthakkukreti@google.com>
 <878q2swoxp.fsf@cartola>
 <avu0X5E298dHRBHY@mit.edu>
 <20261117084727.0cfa196a@pumpkin>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117084727.0cfa196a@pumpkin>

On Tue, Nov 17, 2026 at 08:47:27AM -0500, David Laight wrote:
> > Sigh... I really think these characters are *evil*.  I wonder if we
> > should simply drop those code points unconditionally when they are fed
> > to the kernel --- not only folding to themselves, but *not* preserving
> > them when a misguided application tries to create a file with one of
> > these misbegotten Unicode charactesr.
> 
> Doesn't that assume that filenames are UTF8 rather than just sequences
> of bytes with everything except '\0' and '/' being valid.
> Casefolding is itself so evil/impossible it shouldn't have been allowed.

We would only do this if casefolding is enabled.  For better or for
worse, it's better than what it replaced which was this terrible
wrapfs hack that was a trivial to trigger deadlocks using fsstress ---
which was even more evil.

The other way we can deal with this is that if case folding is
enabled, we change the VFS to call the case-folding for incoming
filename *before* it does its special case checking for '.' and '..'
if casefolding is enabled.

					- Ted
