Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639091;
	b=qWcLuir/4+hateEguF0lo8SQgtXyfh9dClqgiUsPGSgPCwOcnHsbjHKKNsyFnY52Iw7t
	 JZz2cAJnAE30SPzFHoNQTIReFEKcZXM3cikkS4YN6SLvAQJereIzP4GgmfYAwuM+kBS4q
	 IAALZBmVz1Nnzno5pBntSmwz1uS+xChKHHivbTtr4Cdtdy/TrwRhq9kyuzQ9w7Mg4Fkun
	 PAfSiHsjUV6rvv62LpO7ykkXLkdOWDbhwyazKJZpJOZajmib3gujVtW5YtJmL2yJg/qK/
	 9wn2B34a7U6/b96uxga5zFhkO8I31aoSRJsPfu6iaQyf0NyytNslE7QrLK3JLAuFS0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x6Bpq2n4HJl7d6OAzed+TlEsP6f3XOTqcJnP1zmOOqo=;
	b=XTpZFL0SRpso6UHHL1G5lJ8xc2gLg2UUZTNmjL3vF2C4l7vouAgDx8DA2E/nsbaE2EEU
	 T8GloktFYXRCibQTkysXMLy+6jp0NL8DyoMEKGFHKywiXH+8TxjuUH3lNUhYoz6TAutwt
	 MbGp6iTEobzERLOQ6UM3IEKaHajl/asHJG/cYOjMQaqWwjZhJWRQhmk30gYLXtKbjiXBw
	 jKjR4PM+Myo7UxPHamGgTs18TJSdPIpI1i8ClvAAK8wcGwZL5wvtdeY/3UHJScDfEVdWE
	 wlZ+xNaphTTXbsIVxO1XN0DR6zsQBTL4OyAhFSiC3w7uDJpmmeyXk7tnS0ifuItb3sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VPe8s2vY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A9C60A3802;
	Thu, 22 Oct 2026 03:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VPe8s2vY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020841F000C3;
	Thu, 22 Oct 2026 03:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639091;
	bh=x6Bpq2n4HJl7d6OAzed+TlEsP6f3XOTqcJnP1zmOOqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VPe8s2vYKSKFsRN81Vy3721Af7VJTiGb6ng4HZRjfIaYLPS/ljlMvMtDsC9efMrJs
	 yv1EvPz0Dx8X2mI3dqM24TYZ7zUfQ1XB2V/T3U1c+WYU7arpi8irLDn2O2/4blFzpf
	 fPksK0YWt12j/BfRwEedveh/38OlWWjwu1zk00RKwnQp4de41QjxcduOMPBza1o/zo
	 wtml27nM9xajgDlsR9KahdlCmYMEM68K/G/ZZ53BgDWrYsT/ZcFWAN6gCEFSenhpHw
	 JrKmag9kCmppG3fS7Ni8cT7vULzb+KlBMxFvllF49pmadCwjIjzIMza95ty+TORhdp
	 C3SkIJaHagZiA==
Message-ID: <sashiko-outbox-180942@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 41/41] Documentation: uid_r: describe SMB and
 NFSv4
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <59c60ce7d56e4198e148dde225c10313df019359.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <59c60ce7d56e4198e148dde225c10313df019359.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ksmbd's login extension and SIDs for UUID and GUID users, NFSv4 owner
> strings, and what AUTH_SYS and the SMB3 POSIX extensions can't carry.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D41

