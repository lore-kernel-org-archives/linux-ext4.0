Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104457;
	b=fgdLo+WeVARiyF+d5RDc8dOitNzG1+1CosgTI7nAsmHN4HPEcWH2XXEtnceN8zeoDSK6
	 AsCyBjmV3h4/X97ueq0a37afZwYDUAQ2OkKxI/g6Wn4uDO/QQ7H3cnn3mVRL+oJwSlJnF
	 iK409gknRxSo3G4YwyVR42k4euoMFTVb/opVhdRmn9JhE2KxM4dxol2W2UdL7hwwQYZFF
	 5FPXG0bl0lAZmYUfc9co1TnHPx7FtMKMvJX2+TjoFK4jutWbeEV4ihwG8O3A5hTm5Ye6K
	 8JY6XdBE0tiTRzRtidcmtOcFZWAjbSStIgdaVruupy+vtywHAm0oqYeyc6t+YjlIAbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104457;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fJz2QcngoqXGY5umC9kKldGHoJ/ig4KS4b6v3wUoyDw=;
	b=oDK3bHcDIEKOHCDD14qPF6qOQ48qkBvzkfO7A62tVNy2d1/UTbQ0NPROnb6Z8BgjdS+A
	 LFFgzjER7/DMpE9eAd8XYkRYaEL9vSJvGlJudrO1EznWx7OAF6yWwrCr89C1UhX8No8AM
	 kUsfw/OgaR78NL+6RIC7txXMuDbE53h8MHFrKWCcCgLNFdt6kYgJl4luJr8X45llnkYDI
	 casVQUHsTvpp2TRmYY61ZOfTQPd/d9k9/2lj/6nUSRiXqxkTcEj1WgRqBPQ1tvzpkTsXA
	 MRVXZMEAolJZCxYNEd+k3xBI9BMKev56jtVEcjwBgwh9XcS7J8OEHHQaH8lsEFmB5Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOn5jO8g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E5C606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOn5jO8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCBD1F000C4;
	Thu, 19 Nov 2026 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104456;
	bh=fJz2QcngoqXGY5umC9kKldGHoJ/ig4KS4b6v3wUoyDw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=UOn5jO8gfzzjLLiXlVEY3wJhhFqLkP3RqwGRbmlJHFLKz8Gh9tXdzb/GnuCkbGdgq
	 paRbEONBhwjT9H591pn1Djk6XoaOqER03PIw4mbpAt/SgTDU0C5ooB/rhe6YTV155+
	 GulwZSbYnUcZcoRGbfc1k346bYrWplW0oPrNCF3aDNyD6VXu/0u0o15y+P4ANt4zxJ
	 uHtC4NGnb+sNJ03btq+PDECmDiy6j2kjdFgKolHq3TN4lMcFLxd7QFN8gE2ciNi/aw
	 WCWhGp/vMS0ZW9I1VLhhi2au46MdizN4h5X+2LQME3ozvgKq67gRLmqmjMtVLEm3CH
	 f8m3PeTvfST9w==
Message-ID: <sashiko-outbox-223472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 08/26] ext4: expand KUnit tests for fs/ext4/inode.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-9-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-9-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:07:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Expand the ext4_inode_test KUnit test suite in fs/ext4/inode-test.c from
> 1 parameterized test (16 timestamp decoding subtests) to 26 test cases
> (41 subtests total) to comprehensively exercise fs/ext4/inode.c using an
> in-memory VFS superblock, mock block device, and deterministic block pool
> without requiring a mounted block device:
>=20
> - Extra timestamp encoding and 64-bit round-trips across all 16 boundary
>   vectors, 256-byte inodes with 34-bit seconds + nanoseconds, and
>   128-byte old inodes storing signed 32-bit seconds with zeroed
>   nanoseconds.
> - Raw inode CRC32C checksum computation and verification
>   (ext4_inode_csum_set and ext4_inode_csum_verify) across legacy
>   non-csum filesystems, 128-byte inodes (16-bit lo CRC), 256-byte inodes
>   with i_extra_isize =3D 0 vs >=3D 4 (32-bit CRC), and bit-flip corruptio=
ns.
> - Inode block count encoding and decoding (ext4_inode_blocks_set and
> [ ... ]
> ext4_sb_getblk_unmovable, ext4_read_bh_nowait, ext4_read_bh_lock,
> ext4_sb_breadahead_unmovable, and ext4_free_inode) and export the tested
> entry points and static-helper wrappers with EXPORT_SYMBOL_FOR_EXT4_TEST.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D8

