Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792961129;
	b=OYFHcBEQM9VO8UgpzNLCL2VQ2sYPMnfVSvRHAfok4rB6TsRpXwTI3ZUCflVh0oyiy8mD
	 U86prFEsKkNLBe6iTNqW+GNLdCbllMIcwnUmRo23OvND2LceebtRjOlNd17lDBqxkGOUE
	 pwsEffA/h9dZUkdb2urw2mSlDTVN3STDfcFGcjWMcgMQzs5qELdDVZb7X3+J2ieGFC3D2
	 JqiupmDfKY/lhvMKTZd0ZeqWTEpfvwpBTFzSfGbhOcW6elxnTI1JlsX4YK5GPK6GM8q4j
	 H3G1LdClR1+1/ngjvws4B6rZLIHnJCqj+k+i3bPFikEQtebotmPd2Vp6EqLIIDuvR7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792961129;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4wur5jinhyQ0oFdYBtVqmaOt4hh/iGCpnOE46Qy9qtY=;
	b=4W4f2ckwShTa8DNZoIcObXEVuU9aAXOILDkujtjBckZWbxiB3eBjF+X/LXh1vgMYxjG9
	 rhz10I/7vsRd1DOV+WSFehkXNutP+pPWQ79cphbNzAF/24/8w8L0W90u+vuEx9Oj7KYo/
	 8wiqPKvj7VewFA5gXQrmisz4k6MMTYn2Gl4+gtF4CMOSq2XbQ2Shf7SKNNlcylnRWvHI6
	 VPwznhPFghIE0glZHV+z2m+uWzl074OUR9Ol0L4iSUPnE9OfR5JXBm/bSI8OkrhpB8R1d
	 DyraJWOfhtAAdR5gj3W3wU6JACF+qcQa+W37+wUshZmkIBnma0ibDNswhFjO9B2zuXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QAsICc3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BD5606A31A
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QAsICc3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484CA1F01825;
	Sun, 25 Oct 2026 20:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792961129;
	bh=4wur5jinhyQ0oFdYBtVqmaOt4hh/iGCpnOE46Qy9qtY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QAsICc3kTIV9wvVgRrl4UALx11r6G2tS1AkILT+w2Sh7CmCSRhC9jwTfGD8y6zDCd
	 6uMupMpVBdbFkjtRKT4IiydBv3z4dPWvvnLzWI5IC18s8G44N8FX5s+CsEVU3jMVuY
	 6LHyvDyjgnh2ivjUv20RFOreA2SQY5bL5xYLPbKugx1o3Hs1drLIl5XxSQxXiMWx8s
	 fmLCvkqH1BeX6/XcZWKh2ynZP50AiUvs44h7qmKcOycHNJGMHBZkzVBQMEwYR8KdWq
	 SiNMRAPCoETwkmKwueqDhAx0IiKstHksZ9IjiZEh+mS/nWGUozUhJygvfLfxl46c8G
	 rg+lpySLoWV1Q==
Message-ID: <sashiko-outbox-184440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext4: fix failed migrate freeing extent tree blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lukas Czerner" <lukas@czerner.cz>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261025201803.3043712-2-lukas@czerner.cz>
References: <20261025201803.3043712-1-lukas@czerner.cz>
 <20261025201803.3043712-2-lukas@czerner.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 20:45:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> In case ext4_ext_swap_inode_data() fails it will clean up a failed
> migration by freeing the extent tree in the tmp_inode. However, in
> case we already copied the temporary inode's extent tree root into
> the original inode, the process has been functionally finished.
> The error case clean up calls free_ext_block() which will free those
> extent tree blocks while the original inode already points at them and
> the filesystem ends up with multiply claimed blocks.
>=20
> Fix it by resetting the temporary inode's root to an empty tree right
> after copying i_data to the original inode, so free_ext_block() won't
> free the original inode extent tree blocks. Move temporary inode's
> i_blocks as well so eviction won't try to truncate metadata blocks the
> tmp_inode no longer owns.
>=20
> Signed-off-by: Lukas Czerner <lukas@czerner.cz>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025201803.3043=
712-1-lukas@czerner.cz?part=3D1

