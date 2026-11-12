Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457800;
	b=QSGGeil8HE+aNY/nW1Lm+i7dqxV0AzA3aWjeNjKP1R2INvyVp8I1Um5Mlt8Pu7YKsO+N
	 rCca8xUb8vgLTwo/0iQreWbsapI633vMNzhbn7EsHP9sOyZVi2JoGMtHk+4E6YHCnA1Vf
	 eumKeT8qohQk47FxsjX6bzrTSGxYQD1moqDwAMtfJRB1BM/tEFw1YUbqDP4aqgBhIxS0h
	 lqyJqZxBD/DXl9QtpaDk/NdGbAM4l9KxiAHEEcnkGxAHArCTZIQoINH4p2TQ6ulFJctVH
	 +ueiB6NPZX8z7HoMy/Mcrx4qaU4QMvilpSfau+fEpEsc1YdmBugKbXO4qNSIHxfaHyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xTNWi1JbAF9559eqcBhqmsQ7y99z2F7KJRIBtZaSKa0=;
	b=wkkJLk1FxeleLzPrPwdZqo6i8HIv71fJcc6/u0FNapuMmS+T39LiPrPRf+RAzCp/O3PN
	 AFa2YyBvM/K+ZgcvHpnJUSsD2hydjl7fRqCTiwXJFbz15SINy63diNa5HAKVNQwLNHI63
	 ea+hfWrM3b3VcVJFdMsAzNC9S08zfCx0XJOEzczhTrQ+dozbEilzs7cs3A6rqDBVFIga5
	 HWZKK0hSGYd2RzVqNVlSAJO+8+W8FN6QvU5Yg1Dfn1mq410OlzsPwH3NXrmvzpLVb84/N
	 IMEkGzTJbK7Zhw8yRdJeYBYjiIEDwOnZ/PdBEPM+JcwmWTCwirO7ovx09C9H77xpbGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0HZ4PZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CF606A33A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0HZ4PZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B361F00A0E;
	Thu, 12 Nov 2026 04:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457799;
	bh=xTNWi1JbAF9559eqcBhqmsQ7y99z2F7KJRIBtZaSKa0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=f0HZ4PZQWhaoZCxMmiwpsWomNpvcoR6TbWTHhjocYtTqwLHGQKpl8t0nOE983RZm4
	 PUqAOHR4Bf4aiWW/HhtcNPJTK1FVmVR1tjhLUJ/6xi/GSRooSk7rfgb/8aZmGvhN7H
	 3jpFGJb3LzKzSqVeeVwDmYmJPcvbVUlsjYy/l8yKntzwuE1cP40MhfcDxLw47sgNO3
	 DIlBUmugMjTYqdCqqCxq4DMd9ws0i3iBaLMK+rE8hMAYjvmkfytt4vSzmmtkkAogqL
	 f1t61SBYpNqHF7lhixwQM3SCpAuNrjQLP2n0frJMeYmaBSuT4wfgOKfuKPWEM3l8JO
	 YNvycw9jycEgg==
Message-ID: <sashiko-outbox-210341@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/27] ext4: add KUnit tests for fs/ext4/mmp.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-27-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-27-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:29:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_mmp_test) covering multi-mount protection
> checksums, block I/O validation, and mount state transitions in
> fs/ext4/mmp.c:
>=20
> - CRC32C generation and verification in ext4_mmp_csum_set() and
>   ext4_mmp_csum_verify() with and without METADATA_CSUM
> - Block read/write error handling, magic validation (-EFSCORRUPTED),
>   CRC mismatch handling (-EFSBADCRC), and buffer cleanup in
>   read_mmp_block() and write_mmp_block()
> - ext4_multi_mount_protect() validation of out-of-range MMP blocks,
>   EXT4_MMP_SEQ_FSCK rejection (-EBUSY), EXT4_MMP_SEQ_CLEAN claim and
>   ext4_stop_mmpd() teardown, active/racing node sequence conflicts,
>   check_interval clamping, interrupted waits (-ETIMEDOUT), and kthread
>   startup failure
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D26

