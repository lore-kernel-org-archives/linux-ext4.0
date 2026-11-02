Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644728;
	b=tpjYVpomRX649jdL4cO0xGm2EI5KZHAT+1P1TpWsZEMAIpl6az8SXBaZANXpXBbO1XBI
	 epML4Yq1264C6EqpovLn0ZW3ggJlOqS5Wg4jWq3RWY7D70Dhufv15C1JiYqbyFlKGvsFw
	 QP6kfPzd3N/DvjwQSlgt2h4Q4rXSnDUu3DKGshx8sPZEFkz3Xb7w3lbrL7k5RaqsvdPdF
	 wLQyBPX5xHNUsSMbeSkD9/FHaMIrsz6lXBwPLsIhwAyBoJWEdAmS5J9b0Wm9rKPbUtRgv
	 UXQKu0fkue0nUDM80FdwQgDE3py6SMllcuaqAZOBPnpc+Lm+oiWzd0riETc55gz1+SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644728;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WW7QvABTN+i3P2XAj/2HnlkQo1LdHu0hSe67V9VCU7U=;
	b=yu2b3UESFbjgpiVYGplrVNDNY/9i402+WHh7tZyqpFdFbSgog4PW3WH+BXO193qsbBdX
	 BX2KPmdod2nSGxq/s2ZLat+b8eCq4fN9l0wMfJG6g++PBmh1f/O3oA3v7JEBIdyjqFRRf
	 zPp5T9DImouNkT6S0/FK83j4L3MHcRHlT0Iry3A2ZlLUxt3qpaWNixZmLUJZrJ0LcqOdj
	 MXwSmlAefffRh7UenmjoHvSkdz0HDPtLHdfl33RsvozDyXzy2gq60Dba+U6tDYrziz2cV
	 rMcAj56f+hZN80JdisIWnGEWulGrt46rzBNwshnwln47tBn9qBLoYk7vDJK19s+Vmfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1qmz6xk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB265606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1qmz6xk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891B81F00A16;
	Mon,  2 Nov 2026 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793644727;
	bh=WW7QvABTN+i3P2XAj/2HnlkQo1LdHu0hSe67V9VCU7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N1qmz6xk0yFvKWSdB6sTRmWnbskcLp2O3O9aGcfXcWDVVLW0A45mDHkGhOoYZ8dJ+
	 x+J6xRM+3mFQPqEONJYT1dPEt19/T7Iu7Lj+rmCCrkCpXsvsdcz5FWYK27OhiTllHx
	 3p3LAXsmtRvK/B0yulRpUUHV3ls5Cm4aoUOw08PuADn2IWI8G6h7VVcQipFQsp2jxj
	 9/W87z/+cg+lPJJPqSCXykADQJW+k7KC7lMMzBH0UgSfuBwxKeB4Y+z6W99wI6XBRI
	 8+lQEphuM4q2cl6Vm9Fp2kIRAiUyQsy21RAtcjWDF8wsP39fImAfqJyL+hm2OV7Ikc
	 v/bTkZNq/cWGg==
Message-ID: <sashiko-outbox-193955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] ext4: don't zeroout if we have inflight unwritten
 IOs in non buffered-iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-4-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-4-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:38:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When endio conversion of an unwritten extent fails (e.g. ENOSPC while
> trying to split the extent), ext4 falls back to zeroing out the unwritten
> portions of the extent and marking it as written. This is safe only when =
no
> other in-flight writes have valid data underneath other parts of the same
> unwritten extent, otherwise the zeroout would silently corrupt that data.
>=20
> Commit ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
> changed the dioread_nolock writeback (non buffered iomap) and dio path to
> submit I/O without pre-splitting extents, deferring the split to endio.
> This means multiple concurrent writes can share a single unwritten extent,
> and a failed split on one of them could zeroout data belonging to another.
>=20
> Fix this for dioread_nolock non buffered iomap writeback by making sure t=
he
> writeback path increments the i_conv_pending_ios counter when it encounte=
rs
> an unwritten io_end, and decrements it after all the io_end_vecs have been
> converted. The existing checks in zeroout paths then use this counter to
> suppress the zeroout fallback whenever there are other unwritten IOs
> pending conversion, preventing silent data corruption.
>=20
> Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D4

