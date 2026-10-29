Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280728;
	b=1YgI/gM39iuRaik3UGo1EUsfCCnorrza7HIJtYErMWMbrSyEd2PBeb9ffDmaBmIa2hxZ
	 s/7V2Gls7LOPmLgqpkQsgv/soV6XmR7gVJtj9IvFeoLQyUdngheOSArihYD3eJJvKKzOH
	 bYS6F4qwOt5SxnMflKGiSHTH4VsTRmhgJvuEXZIycR8t7jSjETTX71PgO99sQw8HAmZ2T
	 mJlWFIuZUB7GJ56OGTC0uva3cBYscyftl98kKeOSnqpPHZ2CLa3ZIkHsN9Ihs+xbldmRz
	 JXgBQZa2XlmnkbKoBO1kHN9z7PyWHKi7nUMNTZsza+XYhqT4hOUrNtyhq6qRANFB0iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280728;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dI43z4AhsdS5aJX4mwzxYWlHw4ZqOByf3RtDtz/xUes=;
	b=QqyZji9KEJKYJIPcFxmfoIVczf3DtgvART72ozCeiGJ2sOBExmZMLxHkb/20yL87p6eJ
	 3QtgTvBsTk3B4IK+m/iDvi/bbiFKcs2d4FIwsjRaRVgW62fFu8VN7yeeom+XqgQeAQPZP
	 Dj9j8OlXEIVvQoyDQXwOot6w52zEJcS+7WVa2JrLGtE3/P8gtIvHFcmxnx8QpjLHkAwwA
	 aKVdztfZ62e8JDeqYeaoIcqhm30nFtLOajhDpT7eDBO1b7mi0OHawxdea+t1FW/s8T8zH
	 e6OnSYoFMnx5de86d+yHhrkb0QghkyJjfC8UeptkLUBet01Z8+teyBQiy0WuZr3ovAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yq1Rkd4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF7D606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yq1Rkd4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ED11F01825;
	Thu, 29 Oct 2026 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280727;
	bh=dI43z4AhsdS5aJX4mwzxYWlHw4ZqOByf3RtDtz/xUes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yq1Rkd4n3xUFxmS8axW0dn0x3RzbXNV07FqC0y2LWNC2ElZhpU5PW50kZzrTLRoP/
	 FM8pOUfz40tlPvA5twBMvRJe6yhhUgvkdj7pECZpxJrDyji3sD4UYOiSb4xqqkAmgp
	 GQMJbulE6SRSXqfVgs7AwGvK1XC7ypRFYVhqgjkPhcVB9lVv6wkixBRiMh52cMP6Ao
	 IUj5MD7abs9LsLjRr4HMIZc6V9BoeeHGZ0DSk6RgtDfy8XcMvXE6CBZlIE60oV+OJB
	 HnFfAIUbh9UOjtl0Ss2sjU091Y80bEPsLY8oaORZFQ1HUcVpPKvKoEoyBVvWkD3z2d
	 kxWGSCbUMmWjg==
Message-ID: <sashiko-outbox-189385@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 3/9] ext4: add ext4_inode_loc_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:32:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the inode table block out of
> ext4_get_inode_loc_noio() into a helper. ext4_sync_inode_metadata() is
> going to use it to find the block without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D3

