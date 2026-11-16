Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794796243;
	b=eBH79/ku/vLukmq6hh8C44trmvnISnnZrOjc030F5eqzM/TOv4BPBwIOzHjO1GnHuIxq
	 x/Xig3MmpuYtKv8To9y74xLKVXfn8M1WYQxuUHTVcvy+i/2/QZiZE36YLA+ArO1ey+LUO
	 FBs4tNwI3lZTv/nyy5ZM27yZb1yf34I0pqQtpphiyVWnygLIXSztE2Q8RuH+EU4Lwog0k
	 Aa16wIDVOgLSwGkpMKyXfFOi2aO6cHVVhKd5ju+J8BLGRbQXNstLITILyjwFhQK4i3cDj
	 XzVUVWAd93OurpFtKJ7xhiJp+7IGfFdWk+V/O9fcgVwkhQgNQ0fVWvXREGQRHtgIEAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794796243;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bmlbPEuH5016/m3y///sfppyN/LmGtskrjPe/6SeYEU=;
	b=0fPAxYuOqo/vbXeTyeb94PTv6kajK8kLDDpmhHZeJTzxcbJMyS9yl8I5sPzor7Wz/nNg
	 WI+qS5KAIpylLo5jql10+4sRIWFobckE/Iz+ZRmun/q80BtLORPBF+smBC8CEKucXGVFD
	 sWsTUHtps3RQ+QXeIrawXJqrZmBlCqamBZ64y53KCJIAd/R50C8RXHZ+TO3iSQ5Tk3UF8
	 G/DSRPJEEzk9V0S+cwZS3bhK5BIbnV2zrSczC7bU1lKw0cyfKbHZcN/o4ZU5XN0O/oVSS
	 cQ0WAwg1VAQESmud0zIw6VPe5LzD253r6PS0VI2ssOlUYoWayeQjBvnqrrrUOB0tfwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvThnVnk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5E8606A32A
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 02:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvThnVnk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3851F000C4;
	Mon, 16 Nov 2026 02:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794796243;
	bh=bmlbPEuH5016/m3y///sfppyN/LmGtskrjPe/6SeYEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CvThnVnklWDIWsN+Iocej4m9R0f3cjsvnw41YV/8y4TMkxag2BwQDa8+USR9R/YE2
	 bIXNbfc/FVyBOtZl/s/qdWQhkE3Jk3I2fFv7SYgUNMNiSgvEkjx/f0oDDqRg6yLqTn
	 8H3/aBrlv1nRDT1DdXQI40z+rUTuZQg6wytVin/P/2KWqf7SCQ7PQM811GKuT15U7k
	 lA5vVPIMN6QvHq4QSi5L74t9Pyujfglu/NvFpd/yUPF8WwT0uO8eFm7MgEjhWsRsxL
	 IFWYt6j5t+ro+WZ/Re818rFy1/ejQjOJ1tc1aQ8HUAhypCsV526iTc6f02D0cMZlKG
	 itxAY+NfpgZ/A==
Message-ID: <sashiko-outbox-216081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: free HTree fname rb-tree at EOF in
 ext4_dx_readdir()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Wiseman" <chriswiseman@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <18e865672dda2d41.3137322e32332e3235332e313736.36f4d7.0000sendgmr@google.com>
References: <18e865672dda2d41.3137322e32332e3235332e313736.36f4d7.0000sendgmr@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 02:30:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When ext4_dx_readdir() finishes scanning the last HTree leaf block of
> an indexed directory, ext4_htree_fill_tree() sets info->next_hash to
> ~0.  On the final iteration, once rb_next(info->curr_node) returns NULL,
> ext4_dx_readdir() sets ctx->pos to ext4_get_htree_eof(file) and breaks
> out of the loop without calling free_rb_tree_fname(&info->root).
>=20
> While ext4_dx_readdir() frees info->root when advancing across leaf
> blocks or resetting on seek, reaching EOF leaves the final leaf block's
> red-black tree of struct fname nodes pinned in file->private_data until
> the directory fd is closed in ext4_release_dir().  Processes and daemons
> that keep directory descriptors open after reading to EOF retain those
> slab allocations for the lifetime of the open fd.
>=20
> Free info->root before returning EOF when info->next_hash =3D=3D ~0.  If =
the
> caller later seeks back, the existing !info->curr_node check at the top
> of the loop repopulates the tree on demand.
>=20
> Benchmark results (/proc/allocinfo, 256 open HTree dirs at EOF):
>=20
>   Metric                                  Before        After     Delta
>   ----------------------------------  -----------  ----------  --------
>   ext4_htree_store_dirent live slab   1,007,616 B         0 B   -100.0%
>   ext4_htree_store_dirent live objs        10,496           0   -100.0%
>   /proc/meminfo SUnreclaim delta        +1,246 kB     +133 kB    -89.3%
>=20
> Signed-off-by: Chris Wiseman <chriswiseman@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/18e865672dda2d41.31=
37322e32332e3235332e313736.36f4d7.0000sendgmr@google.com?part=3D1

