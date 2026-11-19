Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105066;
	b=ZPjKuZYlMtg7B+2YC8sy8IPwuKMquXM6pPVYgwEX6bIvbd3Bi32FUaA5RsSMFqx1lnop
	 ZfRJMuGQtVEEQLlVApOBeh3Om/qFT0GjUv0k7GMhKIaraLN082HTXPESIr0akNlpxPRcm
	 w1l4HsQDRxRGqKhEAaaog9SrIRpDn2Rv9ofE3MgxZkZgMwx8hXneGJrlrIwWC/JFH6Ciw
	 r1kaA5+5HIICNlyjpXdcFnoijk1isMAAu3tICc1YLiUkokapYx0Kc0CmdPMsPBz2ZrKGx
	 gmL0Ti2nlJQZD/VXEPPt0U+Cz8nFoXf8pSQJn8sSAGRF1cu5VgrvjwO31vXDU7ZT/vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105066;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ek6wOWWUQmRiXAOsuufzKptet3xneruwSETGHFu9nRE=;
	b=ZMo4ZOPJMp2qCpJ+kgwVoHbcpR9nDPLWEVY1ujMpG7DQ8uKrDn0McXcAUndZYNGU1hA5
	 WqXzz6vAn+h3l0b38VKPTv98IeCFNqek18Lv0I2vezAFbaGHbFeMwrlBCR5x2RrSCWtgl
	 jGjOFEPonzHR1uyQSN7kttHep7amZNr4B0CiOlh3uNNIZF3Mya3gdTvaIRnWJ3l8d16oX
	 Pp87QXiil41K5FSFTNWhPBnkbT8mOsi+O4lHvLK4po6OhmECPC5amZhvJUkHz+ttJCPJw
	 nENYAvxCT4RTBKQPoJ1j/fzQi+mO9ynrMQ/9JMV1hEobvcGwtpreMBWWEQTlqmMi+VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GtqWXo/x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A4A606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GtqWXo/x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844951F000C4;
	Thu, 19 Nov 2026 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105065;
	bh=Ek6wOWWUQmRiXAOsuufzKptet3xneruwSETGHFu9nRE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GtqWXo/xgUZXNcwm+hzrxwJWJ1NBk8h+kjYqHvBKfW/XD7IfRzy97uJxaWBnHR6xT
	 9leXvmb9aLUm6d4aRhIu7gAeHE4gRcbDuhgMaKFOzZa1gihLXPElXn+I2fSgKS1HCD
	 IN++7WVoz3R+jZ1I2QcwKdnuF1ORJsVtHjQpf93u9xePU0hd62dArf/npRbSf8QIvV
	 4RbF4STPSbX2ZU6698mvJVlsJ1tT5bW4yV/JYsbcsc4P7Mll3vKYjIM/MY9/hUasos
	 8Qi2q2+NBzwvfV7AcgwClqJvNPsHz5ZZmMXNhlHuf2/qWofwZ+KvoZNSZM5hzncp87
	 ddIbtGtl/SP1Q==
Message-ID: <sashiko-outbox-223505@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 25/26] ext4: add KUnit tests for fs/ext4/dir.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-26-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-26-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:17:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_dir_test) in fs/ext4/dir-test.c covering
> directory entry validation, hash-cookie helpers, directory llseek, and
> both linear and HTree directory iteration in fs/ext4/dir.c:
>=20
> - __ext4_check_dir_entry() and ext4_check_all_de() validation across
>   valid blocks (including fake '.', '..', and metadata_csum tail
>   entries, as well as encrypted+casefolded extended-hash entries) and
>   corrupt rec_len, alignment, name_len, block-end slack, overrun,
>   out-of-bounds inode numbers, and full-block '.' entries.
> - is_dx_dir(), get_dtype(), and 32-bit vs 64-bit HTree telldir hash
>   position conversions (hash2pos, pos2maj_hash, pos2min_hash, and
>   ext4_get_htree_eof).
> - ext4_dir_operations open(), llseek() (64-bit and 32-bit HTree EOF
>   bounds vs non-DX s_bitmap_maxbytes/SEEK_END bounds and cookie
>   invalidation), and release().
> - ext4_htree_store_dirent() rbtree ordering across major/minor hashes,
>   64-bit hash collision chaining, and ext4_htree_free_dir_info().
> - Linear ext4_readdir() across multi-block directories with sparse
>   holes, deleted entries, stop/resume, unaligned f_pos revalidation on
>   i_version change, bad checksum and corrupt entry skipping, and
>   ERR_BAD_DX_DIR fallback clearing EXT4_INODE_INDEX.
> - HTree ext4_dx_readdir() across multi-leaf next_hash continuations,
>   mid-collision extra_fname stop/resume, EOF handling, seek reset, and
>   mid-iteration i_version refill.
>=20
> Export ext4_dir_operations, expose thin KUnit wrappers for static
> helpers in fs/ext4/dir.c, and add a KUNIT_STATIC_STUB_REDIRECT hook to
> ext4_htree_fill_tree().
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D25

