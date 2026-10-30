Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376617;
	b=ubUfNQQSNsSAG3PrvLzVzZNZhkBAE5rDIwQJwwg97gOagqtYsOtSnI4DGw9jVR7ViwNf
	 U21oL8ZsqCHPO3TN3oD5SBL6p/0VkglN5ujAflAodL1odULdb/vS4wXo6nkj4mQ/sXShx
	 i6J863QsB4Mq0UojLnrLRcMZWGZEcTGPsQ+VsT+qDZ1EKaH8dGfE2HIoZD4MwauSXmt+4
	 flXB0Sx/Mqlx0V4RtjMTzUlhehmbPkk5llg4h5PSBwLYAiVrY6HnXo0C81LhWLVF6m07K
	 OyBeqzUyRNxbuU3z8vKdNIKLMbalFYPw1xkwdvkpGWqqfAaTf63rx3baDDqObbCrPHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376617;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3qXhVkVMj6bZamW3dm6B2TBZzFl3WWdq5Lm83GcfpLU=;
	b=5dEo/W22FeAnrfhE1fhosY0eTVtYvz/W2EKs65gyvSgAGAjYsiVuxs89Pqnh/QYwoqYG
	 bIuN0DITz5n5UTAnlIlTRnnkIBXftKtCnqAnYqt640yBFBMbtiTLnpcy4ISfH1EY9GC4U
	 gqRdmKEvmmEPqdXisEEMfksCJ6e3CJYs6WUYBaaDC9wSUBSyQ6ptzLtpmGSXqZULenLId
	 oWDU34hD6B9aU8cLFEqzQ+kJZ5Teu8HwRKaLPIYf02aS5ms9HL2ClxIRzCe4NAM42tKCM
	 S5jmucs5NiQhXBoErTdW8VLb05lMD5Msp871rGbqJpc1hOg461/RPJHXYehv4lS4Org==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFKuBwMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1293606A32E
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFKuBwMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D31F00A17;
	Fri, 30 Oct 2026 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376616;
	bh=3qXhVkVMj6bZamW3dm6B2TBZzFl3WWdq5Lm83GcfpLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HFKuBwMf9uRLyZoAq+dpyvD6rQvmn62D6+pcMAab28B4BtTXkDgZrtV8WEfJ/zEf6
	 4mqALCpWB3Xh8/QB5rXXAqvvLxkZPC2cR+KT9th+7TFQNcGzIDmfrNEjZlegVt0dfm
	 O8cpjMnw4lMbpqNhm9yoYvbyjH1/o25hpPREAIWmSNxdGNYJgBpCvnPzJGAejm+YUz
	 n1ns4yoHZFDG4qHi9ZK/Va0aD/zPeo6F+SLMNCT8Uy5oG0K1cUEmdOD9O7LmHpw/oE
	 /tzLavgC1mWseJipI4AF1GT7Uf+qQYSD02tmctuNQYp5eHjOrCVB1mPOzwwhzEZWsi
	 Do5vC49celgLA==
Message-ID: <sashiko-outbox-191252@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> xfs_remount_ro() starts with sync_filesystem() which fails with EIO
> after a shutdown. So a shut down xfs can't be remounted read-only and
> emergency remount (sysrq u) WARNs in reconfigure_super(), a panic with
> panic_on_warn:
>=20
>   forced remount of a xfs fs returned -5
>=20
> Going read-only doesn't need to write anything. So ignore the errors
> from flushing and from freeing the COW and post-EOF blocks once xfs is
> shut down, also if the flush shut it down itself. The rest of
> xfs_remount_ro() copes with a shutdown like unmount does. And refuse
> going back to read-write with EIO, xfs_remount_rw() didn't check for a
> shutdown at all.
>=20
> Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readon=
ly remount")
> Cc: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D33

