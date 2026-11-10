Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337908;
	b=al1HTi0oH9krUFc0R/vUP+T4xcZPyOytLnj79mVircQnTsu9SpdOe8fRzazOxFXwFb1P
	 QZUrmDyZ8HmpoN2K5xso4MuLROSkKz8kM5a1d57z2Q/jjo4ueJtveqqSrU7l1gdnro1AH
	 +gLrRt/CC6tssrKvj9qdaowEaqDiNzsGAdZwgjk/gZuHbgipDZ235zf4drRPt0yoaph+K
	 8kGPwmU5B6CEsK7whk/opJaXnmaOMiLoPvfQMHX2D+K0ormEK8QqOM+6J7xqytpDTdxEm
	 /E+gcmY/YENTBdLw6FFgwJDps1SIuAOOl+aWyM9zPhO0YfYU4djtHyReXBOT5dOJldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZYvcW1zQ/4XTwv1fhcbvF1HalQWKeqBSrws+ta8IyUw=;
	b=pEJRopEkpOz0cDjWIWUTiq7rwIg4BVBh2BpfiqmgB/lMUTwy+EPyr7tBfiTdB1P4uZ8u
	 WD4yZYCe86j5NaLbKUjp4zhTUccfuVRkGtFcJWyZugnW88QyN0sKKMV5okUP3Y5/3/e2H
	 V5KsonxKVSZFWBmS9xtDyWOysPK2lItnh4Yeq6iDvu8HDuUrK38oNHhziDzsaw0gH6CeI
	 QfH6zqdtgNNjvGlYLgha4A/eUcudvvEGvp4nnRWf6EcOuvTZDXa6fm9hG/likHBJtne9U
	 kWjzbDetz6NLOr5xckTySldhhpG1azldTkJ0igOWAjXAeiGv8P7o3S87dOwvwlSsCHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOJmCHzH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1DA606A321
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOJmCHzH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74471F008A1;
	Tue, 10 Nov 2026 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337907;
	bh=ZYvcW1zQ/4XTwv1fhcbvF1HalQWKeqBSrws+ta8IyUw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oOJmCHzHHvJtU1y4bRMOEF/KV90J1rke4Q1TkE0qiXU0R84XnJk+ffoHc5TS0kE6S
	 3oyUh1qXVbv/4wwi4iMfnByJnhOEYLbWLjXq69hN69wgdEfUNdOgD1hJOPvMhcmPEp
	 px7ac6WMo3+u50drC9FRjdm4EvNirH0Yc6ZAgaFSSgBWV8bSn/D170VvNjn60GFCoR
	 5/IhnSxuaBns/LHFUrAuNiVlviKnE2Xy9saMG57YBXIidUQ9YXSbpA7d3jQUgpdXUg
	 jCpmjfX0stc7lupXEY7Yhi/1vi1+QLvgRKCHYd93yI+QrzXH+tb9rpMR5M8x05VLk+
	 6zVWRS1QZLC+A==
Message-ID: <sashiko-outbox-207641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 02/11] xfs: flush the shifted range before changing
 the file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-4-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-4-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:11:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> If writeback of the range to be shifted fails, collapse range on XFS can
> fail with its hole already punched, and insert range with the file
> already grown.
>=20
> Both calls change the file first: collapse range punches its hole, and
> insert range grows i_size. Only then does xfs_prepare_shift() flush the
> range from the offset to EOF, and that flush fails if the writeback
> fails.
>=20
> The fix used here is to flush and invalidate that range before the file
> is changed.
>=20
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D2

