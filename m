Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792421735;
	b=L3/v8PMchr2QEppJtCcsOYTr8kM0nZncaa1o5QBV9xlXJZMoivslwFeCFBsHcd3bS6b4
	 9ridQSpYOE5FDqU0NlQIcZZ88aZRgRvjU7yswYeKOoVoix1kPOnMcwMINbnv/f6TlOolU
	 gCH/4us9Izfum0xW73mMB6GtfAHqEO7aP1HPDXtsA9YYG1I2IVaMj7mN5xEWQW5sU8dSs
	 HC2QExNhRmdmdqCjBkVzPAsjqKDBY+B838zNb/LAnEUbWHmBnNxDJGDyOjeya+rwgEPTq
	 TyfB+JmgnWd5OTiaivX8wpZHeNnx6BBesa5ae/wnL3YFk7b76l+pNCmTvNe8fd6pnYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421735;
	h=Received:Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 Cc:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 Date;
	bh=jkaB9Lue+EKqZ8Ocn17/+W4uPmeJpQ1cOLK03P2mny8=;
	b=b2zGYNWrZUWpBWPr6yTm69truX1vQfklNqaI4r2hjD4xSRQ96WNNcUmP4kgl0O5P4qer
	 T81EDyfOqWb/dXdHfieDK5H8uT/NeRSwV0CXBpA4s+7e0u0LeMBPJDIaKnXAGDzprDVVj
	 rAfei2CpyeZgJQLS7QNjxAhbPcvtoqZ0W1R7rLteYbE16EtdhYHlWB4hr1pFkUxXe/nT+
	 JWLh+l03f+NGfTYV6cnc2UsBF6BWeIjf/4aXG/eGURIxHWVHRL9cJNpV/R48uny7yRqnI
	 qARyesQu3uFeZb7ZQ7uSxNjnwLHKSAq6xXWnnNajiy+8+8F6tVpt6HjjuDgoCZENaEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Z/BAfahE";
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA4E60705D0
	for <linux-ext4.vger.kernel.org@localhost.mlmmj>; Mon, 19 Oct 2026 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/BAfahE
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4CB6513F6
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421735; cv=none; b=nh+70JOnPu4S+QWyZ2SrIww0TS8YCE6yUUBdGlDr8SOoHUuTMZ55hCnj9SFZz1SRyyWxCyNpGRAYlcUD7j1s11rHNEmJbpTwvaImSxYg1e4u2YvgfRAPeN4rXOseQWuMqlIZ9L8kWmTAzYrKKTPgvpINkeQF4xx2JJXA7FCRj+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421735; c=relaxed/simple;
	bh=SxPJ22E4T19D/2+WSHnyFKwee9vjqQWcl6PvEzRCQC8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jQ0eWfIEb6nyL1Ea8ZWkJUQFWn+xLJ4rnbzqUqf7PX0VnfWlvnj/XX6vK19iCDrXW4ss65CykNBwQ7Ti9wRMwxJscxnzHlxiM7rT9HS3vyYbo3SI1V8xi0NfCUauO7tyiGqI+PByscZe1BYv6DwP4+zGHwegQVhMMIyp1+kVXi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/BAfahE; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36F71F000C4;
	Mon, 19 Oct 2026 14:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421734;
	bh=jkaB9Lue+EKqZ8Ocn17/+W4uPmeJpQ1cOLK03P2mny8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z/BAfahEL0ZHwdsXVbLu7QcQsPPsKBn6w9nFqxuvlZ/4rsrWxWhArui6xQZbuSZqf
	 FYffen4jv9vB+om6B+pmHTDR2hL129RsVlE3wFgCEwHvilF50qUgHHa6Z5ylwvnp0A
	 lYvqhIlglZ47n1mg4IRCW1ptEujAxlB2yp3ZJEV93Dt+ZiNmf0vtwdAltRpXP38ANq
	 HY1mLXzrOPXV6nb+a9k/nkwRJ18rpI1MQyQwixDs1Omfh2DnxCdKBV9mwDLKYfaDSY
	 TrQsz96BBI3m9DffU//b4YePosXsxrycroxBHEZydUX0K1AwmsdktF6JFaTKbJ985E
	 Vi8eswAmte+qA==
Message-ID: <sashiko-outbox-177558@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ext4: set EXT4_STATE_NO_EXPAND in
 ext4_evict_inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-321-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-321-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:55:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Yun Zhou <yun.zhou@windriver.com>
>=20
> [ Upstream commit 2c0e4fb511f97467dafc91b6afb3414100289081 ]
>=20
> An inode being evicted will never need its extra isize expanded.  Set
> EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
> to make this explicit and prevent any unnecessary work in
> ext4_try_to_expand_extra_isize().
>=20
> This also provides defense-in-depth for the s_writepages_rwsem deadlock
> during mount-time orphan cleanup, ensuring the expand path is blocked
> for inodes under eviction regardless of how they are reached.
>=20
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windrive=
r.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-321-sashal@kernel.org?part=3D1

