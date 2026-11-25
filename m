Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617974;
	b=fp/m5EkdM5JAqQRUy8C2XdYNpilDam69nZjuXHAnCNk8NRNJAAS9tHevi0pURG341qPD
	 1ebvhZ6JVpdkljjoC1Nie1q3dAi9HlJAHF3jC/cM1PHbL1UtxpslIPtUVXZJmc7pfNWdj
	 kaQ54ieikUcViTW+GbnqAkDYBlZb8qkndcHM/lUBqcXizeG3XefqMUOzfBCg8vqypE1W1
	 AtWZlB7GF7DvuXJbeKlukZzaDjjh+9mu/PuYtt7J9JD6gCzKq+zaIn9dHlxBtcWF1Kqmh
	 u1rcMj+BybYP/R8jQjoei1l8tXtq/h1C6scrzCnuzEJ5yWhi8tfhPsbg1uFnKILCr4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4WTzWTHPaCMzrI/jWd1TG6eoJKgWsBgfif6A08WIfXY=;
	b=gYU5dd9iUloG/BYCpLhpq2IU0LzUSnapjI0VVOavDA+Gih1AjPsSRnmjjwPfDekqeH0m
	 605VBO2D9DL0bK1ZH4+Z8v7EOCtBwpo4yH2Qq+Im9oTxHyVX2i/csl4wVQOSUGMXOCTuU
	 dgYTn43dXhre/DvbQAQ6UhFf8WghROrDjqq21gqsY3oVBAMKY9FGuOPuUL44UdvH0eSwF
	 GDgXuJqCS2rdkKTTYffraYVdVPDbMKk9S/98C2MBRqsrmdsB3hty2jvdGWNSJGyFMAOsw
	 7FTACH384qLqQRqq0dLHS+t2XDjqOsacxMPTzo/M1MIy9H6uiRmzzUp+WvwAVSPncRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gMWywQFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6A5606A327
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gMWywQFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B891F000CF;
	Wed, 25 Nov 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617973;
	bh=4WTzWTHPaCMzrI/jWd1TG6eoJKgWsBgfif6A08WIfXY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gMWywQFsBp7B5IPgAbDprmMHXq4foNz8INQggo2AXh2nN6Qx3fP2S5umlNGgd8CiZ
	 +918qyGt+oO6xcWvveFhzaEog4OPHDdQZJoSK9v+KJEp3kYGQ0cYJQvQQCQpqbNKj/
	 zCAnuRtotq/T+TDTu3Otz8iRfFCGtWFpu8kdYE+miGRhq5eBfHSlM0yODSkTWti0A7
	 GNGYqHaxmDGPcTa5YG4OnniIlJD1I1GnXdTrD/ns69NJ/9Yn9VKcnroem3hbQvnS9s
	 hpXq17TpK6EPEzXJ36BLs8EwlRJjMKvyuEYIDT0TsVVkHEzyhBW+WufdRpGen6QSUw
	 gjlXECzsM5n9g==
Message-ID: <sashiko-outbox-233584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: recompute the inode checksum after restoring
 inline data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGV0ciBWYW7Em2s=?= <petr.vanek@e2b.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125143841.928615-1-petr.vanek@e2b.dev>
References: <20261125143841.928615-1-petr.vanek@e2b.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 14:46:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_restore_inline_data() recreates the system.data xattr with
> ext4_create_inline_data(), which marks the inode dirty and so sets its
> checksum, and only then copies the saved bytes into the raw inode with
> ext4_write_inline_data().  Unless something dirties the inode again
> before it is written out, the inode reaches the disk with a checksum
> that does not match its contents.
>=20
> Failed inline data conversions take this path, for example an mmap write
> to a small inline file on a full filesystem:
>=20
>   mkfs.ext4 -O inline_data /dev/vdb 64M
>   mount /dev/vdb /mnt
>   xfs_io -f -c "pwrite -S 0x61 0 42" /mnt/small
>   xfs_io -f -c "falloc 0 64m" /mnt/fill                # ENOSPC, fs is fu=
ll
>   xfs_io -c "mmap -rw 0 42" -c "mwrite 0 1" /mnt/small # SIGBUS
> [ ... ]
> were not tested.
>=20
> Fixes: 3c47d54170b6 ("ext4: let add_dir_entry handle inline data properly=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Van=C4=9Bk <petr.vanek@e2b.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125143841.9286=
15-1-petr.vanek@e2b.dev?part=3D1
