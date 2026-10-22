Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639088;
	b=iJr1a2pwJrn+kweVJIvkH7BicC7siLFTVBwzD6cJu8s35bf+xsruL1YmqV7eoIUFhuAH
	 SrkV9iLsf7iUTBNZiMQUOdRflvFDqo/QN3Av4vUrCuJ82O+fG7r2szr4Do8X3VCN/ssga
	 xLFzR9HVSJceydE5oLM9YDowV2Ro6qApJ1sVhmUhWoiJmdZNlA8Itpjc2S81mOty/JNTq
	 TXX7QpcdhVCGIGAczTIp2LD0ZRuW2y5KP2Wq+/0Up4AfUKiEnAoYy5wAxmnnTArFjc4rL
	 yOKZDxAEGF4pDbpukuomrbfiXgfm+bIaRcM+mv7GgHLhownu86vtiRLUoaau4DB0YYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639088;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=urSY6DBJ2Gd9BPxDsLJvqDlTd1VRvQLXO5BLOcbgq2c=;
	b=WW2TaR4Hq9KGQ0N0uYE1CPI9ve6p2H4yr+VlR8N2tYMo0y1mlRuc2Y7DNWMeQMe3xj8f
	 ItXgQI4OmeW3UAw38161Lcq/ykv5VRtZvtpT9J22aUPVQIqQ5/btgMOOsV2jxXnDQpjS1
	 wtcNuQQN6bWfjMKP8Aa7mkxWRK0FZlU0UKsQcDF7JLfz57NnNZJ/afEy9DC7oNxBuAQet
	 5x4m5+HQ1p0fYxMl5UNGGaa2vXSUTcmAs1yKzgjYZ4Oy++alOuN/1Tbua9l7oNttLnJd1
	 sNH3YtHCzIANVX6AQGb4E+46AOGZPvmTXVpVqdLUSf6KDuZw3FftKV2dhGxD4yoct2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfWsxrAH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77A060A2630;
	Thu, 22 Oct 2026 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfWsxrAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA921F000C3;
	Thu, 22 Oct 2026 03:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639087;
	bh=urSY6DBJ2Gd9BPxDsLJvqDlTd1VRvQLXO5BLOcbgq2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SfWsxrAHyr+NHZNl5UU9PIMKwhM0GLTD3w2w10HoqW/LsOt6mWL3DRb0VQ90+CHG6
	 7wLBCnXxOxZH3vQexfT8ZPdrbssdW0d8asVf9QPP41Fwq4aQyjjijau6ehg/MrOzQM
	 j/XePZKMacPSFFP3hjAX4/e9i0WAnjTzAceg6xe/23J32eBYXktm5sqmWGoMKDmsu9
	 ufCFb8g84FbdcnrVQ10OeOyOYFGAyj/EOd/32ftpZzElTcHNSq7yGMoli8ZdM5q5Im
	 UykolKZUtObQ3t97FCW7cn701By0Q8YD9aqDN+uR4F2ynZrfPHToAI/A4CTfccuSb+
	 ACzvvPv/aKrVA==
Message-ID: <sashiko-outbox-180939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 38/41] devpts: allow UUID and GUID owners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <0c3bae750fb443d5207a30a2e32a47a724bca5cb.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <0c3bae750fb443d5207a30a2e32a47a724bca5cb.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Terminals are given to the user of a login session: sshd and login
> chown the slave to the user, and a pty opened by a UUID or GUID user
> gets that user as its owner. devpts keeps owners in its inodes only,
> so like tmpfs and ramfs it can hold any kind of owner: set SB_I_UID_R.
>=20
> Without it, sshd's chown() of the pty of a UUID user fails with
> -EOVERFLOW and the session is closed.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D38

