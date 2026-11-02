Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644712;
	b=c/cWy6k+841RqvWipJwA9AYLkibgFvNPpbl81190i1kUh+QdpH80SnpVWgstpljbhNmH
	 xIcCqrPl0bBAJmHPlblx9kVrfsHjHTXkVWV39PFhho4CqpE5n5l1oKVLvdrJStBi6oMU1
	 WQUPp8h92cMLTU+ZcizfcQS9FMg+urwCefX6qAMVcMP4gGH77lNfxkc+7JiKm4YJf3TqO
	 opUQJ66mN3TzWpE6YPhVnOwJujVuhTyQx6ZsJPe3cUT8J6xOwebemTUApHbCKRCZG9JHO
	 scKS5MjgIMRkSVlupy2TvCFcdv+Uk2tBffz0Y5Hjf/g631UUSPN1aMmCUXQFYMV7iEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644712;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lyRzPwJQu7/2RDWhy7SJxupORVoyFO2MxoF2kw5GBmg=;
	b=ecZpKwHQjx1ZKys2GZDVEcEQXvqVZrOmMCOb1URC2hE05B6v7rzgaHjnkGgJwhQEGV9y
	 LsJgVOfWemlA+dqE3O3GcFWxjAhDRH4ozqnWNAV/Mh/yKKwvQ4t0dy4/wJVaCEZe+J92h
	 ZuP4/v9R/4ntcjWLG8KmV99qNKHaSL6V5L6ky1yKPFGQCpyE8SubR73oY46y17RHchuPg
	 x5GstiPj+a0r4ArEJnOckMrEtuhHzL6OWSWQlby4RpV5FR2GV8mn2avEkoYBXUUko+Wfg
	 FnUn4hJvhTcUFh4nyKtYcfohu180EMFc+KBjFmN3UWlSqKX71i5TygvJLCLV4tI5DXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BlOy/9QK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC65606A32F
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BlOy/9QK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF5C1F00A18;
	Mon,  2 Nov 2026 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793644711;
	bh=lyRzPwJQu7/2RDWhy7SJxupORVoyFO2MxoF2kw5GBmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BlOy/9QK4co53YTZHgDQZOieqNteWrI+OyFaHxQr/o2wYR74SB7ukV7qyycLEUsWW
	 lmcXAHzsoGQQXpNo0sUPUpptCzZJqX+OFqvvNr+E57qXPujCouLLFrkpw5Crsu6ww5
	 YFtAlBnl8TP4ZC+swgbe1C5Zgae1Qr0rXr1M7/US3O1C0Jo26ytW07V21+BahKzN+L
	 14YsgfMyxhdVMMl61JzXdmlna9c8L1R4oPzM6jHs7fgjxpFpJsDnQeVjc0K1t43/lw
	 SI38cVn+Fdow4A6yAtWvjxw7ilI8S927bYR813UoOi5YrpehbGZoD90M3tZvf5n0Qv
	 wOrfHkxNnPxrA==
Message-ID: <sashiko-outbox-193954@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] ext4: don't zeroout if we have inflight unwritten
 IOs in buffered iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-7-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-7-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:38:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The i_conv_pending_ios counter tracks the number of unwritten IOs that
> are currently undergoing endio conversion, and is used to prevent
> ext4_can_zeroout() from zeroing out unwritten extents that have valid
> data pending conversion.
>=20
> Enable the tracking for the buffered iomap writeback path by incrementing
> i_conv_pending_ios once per submitted unwritten ioend in
> ext4_iomap_writeback_submit() and decrement it after extent conversion.
>=20
> Fixes: 8c4f6e337634 ("ext4: introduce a mount option for iomap buffered I=
/O path")
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D7

