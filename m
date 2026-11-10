Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794348006;
	b=GL/PaC3Ws9ITwTbRWOul7eCkBZDAFd2kgBmWGh36+ueHu35vKhlc2Y8r2okVeCsv2h1R
	 zDQWqzDFJ4MTrDoduoB8dqqVSKtQ0cwcVAKPT9Tc0+94Hu5716Roc7l3g/mUDCfEQL8Fz
	 aEaQV8gqLCH2k7Vg3+wJAhblxVlN0bS/dtDg9E7gTKXwGOYXPY2sIicIM32aRWxP4fmM1
	 Cf3ksdPYhlI1ARrX9uV6nbLR6aUwpYDn3BOEwE5EZgVkMrpLJXpikRSwBYArpYJKUScEH
	 dDX5JhXs8HYxPDvstNXqi6ILlLORY+FpqUa3IkfqhWdErWB1hpfNqh7CwR06WyynwDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794348006;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gSi1Cem5uo/nHM5eotKecOrdsXKahxKBDl5fLDSMhvk=;
	b=A0cl51dZoCgcZn8PZR5cM3igAYzIDaE5qQo8LB3nXXyuw/6P9oQmSI4NltqjU8GLCKoG
	 aWNwFFeta5RHIHKiupp8MwMRwa6S+AxVhwPM2lH2Bj6OOnRsBrnSau5XWeOgvMpGUZTrQ
	 bhDizUCk9tL4mZ6EKykTYxqdrZL5gBVB7WYV4lbLcrIAzaJlwxIQ/R0Sg+zhonIPggZKG
	 LdPHox8ph+pJix5Heplw4B+8rhd8UATGN0qe9U66+GvY3CqBPO+l5DXXRXiBO6S2gSz2u
	 dlDmptwiBDaITktCrjI4VPmzMep3FsOk6zwOjiWnO4jX5g3Chqv+Ir1OD2vB8QhY3KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVycrJem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACD606A325;
	Tue, 10 Nov 2026 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVycrJem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA391F0089F;
	Tue, 10 Nov 2026 22:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794348005;
	bh=gSi1Cem5uo/nHM5eotKecOrdsXKahxKBDl5fLDSMhvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JVycrJemQMYteTNBsZxUIffQQQPnmrdfGKeARGla+1IErQkChKMhQGOQqlFsfFuhx
	 iwIJoL9qUTODeU6AXawH9JQNrAydyCRqIIZbUIV5s97GSGrL10gNf3kHcDT+5OUruy
	 Q4A/l5PfIpgDURJVTAxCGWrV/XmVD6HaFcN4brBwt1NHeMAiye9Wr1IJu70oJjCdtn
	 XPSDMt6ALnAU6hffPYN51LzE3iM3nlgmmW4NNuqk/GDMMyDuPDB0Rj+b81J7Eztgj4
	 4mfjQRZL094u1Ft6gJOZoWL8bPLzEMTw7x7xlRLHKixpz8bS4+KWY7fDcq9FGXfsPL
	 m+JbHKkaOL78A==
Date: Tue, 10 Nov 2026 23:00:00 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 09/34] exfat: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-kundgeben-charakter-womit-db0a0035bb5e@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191228@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191228@kernel.org>

On Fri, Oct 30, 2026 at 04:09:55PM +0000, sashiko-bot@kernel.org wrote:
> Can __exfat_truncate() and/or exfat_evict_inode() check
> exfat_emergency_state() to prevent metadata modifications and discards after
> the filesystem enters emergency read-only state?

Pre-existing.

-- 
