Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657825;
	b=BvRbCWt1XXs1oYBK8pM/QJmzWt9MVva8VNwE8mRuyN3oRz3bXGtQpoqOtBAbSmH2qksP
	 LaCNGIxt31vDzwwo3krjOxAT8Re7OZ0ie+ZOcvPyLGM0BezlcgEr6wTss5VC/morLTtA8
	 fTUy+XkKBzPUoSoMmVTwfHCDEtfe/wckH6NdqaEv0W3Y1t5QavfyYdOfZuVvKNsGYLwxr
	 LL/si8x5E1ydKxdhE/nW/Tpyg37DSoZ9kYAoerAKMGMN8I+nWenJcLFpe3IHvv0wM5bvV
	 oTXyLTpl3vYkuhZsYba9/D3dOCXXKvLwdGNC43PI/J/SAItXfOVAQGppc4E4DDJYUeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657825;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=usSt64dnq4b2xfx4xaf8LW/0CzhxOxuBgV/IPnkBcB4=;
	b=p1TqwJnhcii4aHNfa0dsWI2ernxBfz8NLdx/RrI1OHkwK6jhsROX33+4MmPEg1+/wjwL
	 9jFwwn6fMqy6K6hl/Vj4LslgbodOC7QcIZJ+xzZ0EYZJ3MZUxPYcBJO7+lq27DdpMXnjg
	 hJjsnfKSp9EjvWGw98WoZcJUAHJNMRdopP9fCjBsZ2Mammeb3XHnLF/B1E7QeU7cHxtz5
	 5Hy7MDmLEbSWiNFejLm+4XT8thJ3fsI8lkqDqzDADpAOziNhkFfTiiRv59pS4+HoRPDj0
	 FVhGRRdsUcIMJR1P2Vij//ygqT76KUIr1gjaeX9UClRWZMnUxs/auMLUQDjnl7qhsmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MxIYThr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9828D606A332
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MxIYThr/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C9C1F000C5;
	Sat, 14 Nov 2026 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657825;
	bh=usSt64dnq4b2xfx4xaf8LW/0CzhxOxuBgV/IPnkBcB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MxIYThr/IlUMZreck89hcb5lXTBFeeiq2/dPUNWPtZCrC9ANLMlLPIApsukW2mCpr
	 oGDBZ5/dU/FrJ25nBgbj2QIqpm1eSsqt/rfzNOunOLNF6Z0Nuh6PpgFrMPWAn96+ik
	 X/+SJOlACdKYqi/Ayf6DloNt97S3t6hTCqqqQnNVhR12WMDr32qZcKKfOoVtrLGBbX
	 Wif6f6IHG+MNgLN3/vVRUygRTV2mJ2t+YucQ0ANv80gLNocjSOosRQW5bwAmXmNHIr
	 s+rfQBWURy4AeKq5MoGqAMUYwiGlIrTRBRDGK69CqvtYTH26sqCj0y/eReYI8Evs+J
	 JDj6yZqBGb5Ng==
Message-ID: <sashiko-outbox-214472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/33] ocfs2: keep the current mount options on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-21-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-21-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:41 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ocfs2_init_fs_context() doesn't inherit the current mount options for a
> reconfigure. But ocfs2_check_set_options() insists on exactly one
> heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
> So every remount without heartbeat=3D fails with EINVAL, including
> emergency remount (sysrq u) which passes no options at all, and that
> WARNs for every ocfs2 mounted read-write. A remount that does pass
> heartbeat=3D silently resets every option it doesn't repeat, e.g. noacl,
> errors=3D, barrier=3D and preferred_slot=3D.
>=20
> So start a reconfigure from the current options like exfat and gfs2 do.
> Asking for a different data or heartbeat mode still fails with EINVAL.
>=20
> The next patch stops ocfs2 from setting SB_RDONLY after errors. An
> errored ocfs2 then stays read-write and emergency remount would run into
> this as well.
>=20
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D21

