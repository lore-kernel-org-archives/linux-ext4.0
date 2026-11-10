Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347984;
	b=3HZ/I1yQxBPBPwfqK0EJYDSRi9hxkikiVFJ0CWHcqR3WVLwJRZoxC+CeLAB8Khs89r9e
	 Gq0FcphHPl7HNbHcuAVHn4ZDqdMJOPS7Nqfu1WZBWhe3J4yr+dfxIBGzC8f0h4Zfn1d+V
	 dfd/nHuEh1tbbydIJAJ/c0xWzb96i4GPGDA992mQkWoeJZw7Q0QkjEHJH4kSAGodIns44
	 LUyeHhiecYIoomHCnJ5Zd8/hp+2VKT2detW0vTOZR39jt48tLaNhOnK03OWOsGul2V7RS
	 muqgWRpkwVxyfOdzk9+FOEYjaDPG7Tr4bv2i30NgTS9IKaPeQlMaq+F7/orbVu2zJaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347984;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sSI5fSzHXT6l17Dh1aqL0HL8Ya/c/u8QoksVrlo85Oc=;
	b=vlWEnn2OcTU8lgLuBgrfMx4R1RisJWoxie50pZNJOmDrtib1sEcV5iscbmNDN85oTOUB
	 sU/bHME2EhygCJ2voFUUkJ6aOTzNO4Vff+7FwsvjyaOp7giiJF5vzmzCK3PXMcugx7tV8
	 lajzvN8mAdSAcGNOM4wGbbCVGxAwjb4h8LVurDQki83qfkoWEazDZtzEln+OOpEfuyjYV
	 kU8chGFgVJb3KIHZnylj27j81vm5dhwGc0MUi+r6+BU1kv5ylYVU10fZUZgMDOXuJP0zo
	 z/8CnRsojQI7jLMJLek/2A5odnX1C8wU9PB/O4OU6G5cKE/OnHOkP84MB9Zoql2Ko1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k07W8ph5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0309606A31C;
	Tue, 10 Nov 2026 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k07W8ph5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB3E1F0089F;
	Tue, 10 Nov 2026 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347983;
	bh=sSI5fSzHXT6l17Dh1aqL0HL8Ya/c/u8QoksVrlo85Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k07W8ph5jDucWyYd1JAfrEw4i6xY04o8KKCSMcakegRQzZa6WBYF/iiSupP9LnPJ6
	 PqRhHexhugKYQxif88bLv/RmfKXZebt0jM/KU0AoU7X/Rvq61mdIO9FJhp2BYx92kS
	 p4IfKEBA/29+u3ojBvJItjPeNy1gDzVaKYKHNh0QJMp0FcqnToCGYHvHu+0j4vs2lh
	 6l9GcvDZOpU9QKqBiCWntZiVc7lisJ/D0GY22YgK9BHJp/qwHkFYO1cN5SLvdma2T0
	 YcK1DObxEoQMnj0ObSoLKNC4Sggkxu1v2pCbXzPTs5E5lpGJXBDIfiFdtYdZPgCyQ8
	 L6MbrOl5ir66Q==
Date: Tue, 10 Nov 2026 22:59:38 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 07/34] fat: don't set SB_RDONLY after filesystem errors
Message-ID: <20261110-zehen-rammen-unabdingbar-81907ca99042@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191226@kernel.org>
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
In-Reply-To: <sashiko-outbox-191226@kernel.org>

On Fri, Oct 30, 2026 at 04:09:53PM +0000, sashiko-bot@kernel.org wrote:
> However, the dirty directory and FAT buffer_heads in sb->s_bdev are still
> written out by bdev writeback, mmb_sync() in fat_evict_inode(), and
> sync_blockdev() on unmount. Wouldn't that flush the deleted old directory
> entry along with a new directory entry containing start = 0 and size = 0,
> losing the file or directory contents and orphaning its cluster chain?

Right. I'll drop that check.

-- 
