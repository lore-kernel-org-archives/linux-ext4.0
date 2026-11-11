Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402761;
	b=ziBd9DgJReX+YnGShEiAsmZVXBcAUt+1R5VMqC3iG2Sz556jM67h1j+Ez6pQ8aO2bKgz
	 nXz4nN5rO095F2ozdhPSjXG9Tfmelc2XxfFWV1HeBMKsC20saAGyTp/bSGSJHpJ7YINpN
	 5FPAqOqFN31c4b7ajpbL/A17BXnnjMaW9rxzyF+Ajovl+08uIQqSg4r8S3w4FWvqKBtIp
	 4kaKBEFd61gOWsA+Zh74ts6T9xryTjN+EyUTUXe77V4/T6rWoZe46ALaIe97XtpLrKSmv
	 kE8BOX82ZYdyRMFQbhLTQtHrV3B8NGHr4o2cE8Xii54x7T7QwjpMgjvS5CHnwf+t6hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402761;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ph0Chqhn6pJT0dyKmptJBlvBZvZRWZHet3QapqSwHnk=;
	b=NAuVTm+/Us2aCD0P460TxGcuLkUyVGZ9vGqbQgxi/P+Hcq7XmnF+5NapzgN0oYvyQC66
	 xM+O+b89cYA3iyFcNjrSMT4ZaZg2qdnczlux4sqoCO+ruXc68tCGtAJJokn88ADCrJ72m
	 veO6B6ZMsYUBtTYhiRgcWFkjMrzEK8j+dLhG+r/KT3DMRFQO1W0UC+guY6KZIZymtgHib
	 84fe3Dr37jrLyMMrShL3WUJ9v380uCo+sPEdnSW7z5R5Hauh+msjarqA+C+doBI+vjln/
	 h2EuB2mDG8J9Cjfk2FJk1jeFe/Q8Sig1bgXGZi+xSR7ymmCqQroMoCnGFF9hpT8cvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=li79Dabz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5CC606A31C
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=li79Dabz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD27C1F00A05;
	Wed, 11 Nov 2026 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402761;
	bh=Ph0Chqhn6pJT0dyKmptJBlvBZvZRWZHet3QapqSwHnk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=li79DabzQBL1FvqQ2wniSehzGlKNGko0FZ4od8Gk7tgNOON5wZb+8WfqzpWZOBLil
	 g2TBQ552CkdnXdFQLQcC7JrrMu9ViHqVnqAy1E7lwXGlNesuEVEUSMdcnlAsUfCPVz
	 e2yb8h2LWsBKN3xiMBawk7+scx59p9UvHka0Mo346RSDljsz+epkviyq7IIrIgS2RL
	 2urVgtQFarb6fBtw6zPjS0MvvlxD/4jCu5B58mZ5P6upicHaeE5dol8zi8ngNNF2bg
	 1a0pe3kOK8V5jjBIZ8ckwqAafh+bKxi2sLuykJ268ebcuv1hZL+fZN3xlymqbcex0S
	 VqP02/Uy9XE2Q==
Message-ID: <sashiko-outbox-209048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ext4: make bigalloc support optional
Reply-To: sashiko-reviews@lists.linux.dev
To: "Max Kellermann" <max.kellermann@ionos.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261111125242.1078620-3-max.kellermann@ionos.com>
References: <20261111125242.1078620-1-max.kellermann@ionos.com>
 <20261111125242.1078620-3-max.kellermann@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:12:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add CONFIG_EXT4_FS_BIGALLOC, enabled by default.  Disabling it omits
> pending cluster reservation tracking and saves 8 bytes per inode.
>=20
> Reject bigalloc filesystems before journal recovery, including on
> read-only mounts.
>=20
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111125242.1078=
620-1-max.kellermann@ionos.com?part=3D2

