Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135880;
	b=AOBy3OVdiNViOTMvmztegcytSr37JCfL4xW25vJMHUwZw3voit6O0ddi1QM7uMz2UTtD
	 HC/ZTWPQPMJu864S0I1O6qoKOg8KRCBtELEzShNgK3ahbmK8hfTqhSWClNwVCyfzx36TG
	 W53mragBkEVN4B0RP4LMo68+YvKZqxV6ZK7nLh6QFpinaugvPga31CGQV7gJ6XU6uGhZC
	 tyfMJLl1Eg9RHXxNeXf0uACycKpVEaK2jfZMOP814IuIkpy0eu5FnuCp+ZkwBfdXQVLjC
	 VU2C9xJK+K/f3CGvGVGl0ujD01XT9w4b8cDqyaWBjaqT82nQg85iWjUSbPZVIUQTCUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135880;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jwMTpYbJUy6OjMwBa4RqIbhmtNbfoThYgOHPYb68w5o=;
	b=XrCqPq4apsX+VA3iN5EVE+yrpKpELNml8Wy1RzsJcGtdhstGHPf3hUZ+ekN/cBmguUWW
	 4uWYkDVsBzLYdXefS85708Jp7qeXPuTjsJIXGhjfaaCMnlkYBGhv4jQ7eRJyIuvgriAqs
	 Byw/JvxBJ2Nn/I8RlF0Swi4ozTEbxZVt6umUNs1WHK3ygniMNjmCvuZI/8+4K/T5vSxqx
	 nRybQt7/A6vQ4KoP/frpKCV6iUJFGD8Pk6iV0m1tvVLWuB41YEOXWdlhFtE00SXqTrfMi
	 KZylf+XubAfEOY89YvDKuerpgoie+J0ZBmoWNwvmNR/Kl8wLfnGJyLV5oe1v0Qfc1ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCUp49sU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788AB606A31F
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCUp49sU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F341F01828;
	Tue, 27 Oct 2026 21:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793135880;
	bh=jwMTpYbJUy6OjMwBa4RqIbhmtNbfoThYgOHPYb68w5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UCUp49sUD2wro2njAENsF0d129w6mVBhApS1FShn6f7yppeFMTBwYDi9JT2sNjD8m
	 knWI4sZ53312o0BaDSfNeCok0oGpaFcNtok8HiQnE35qMfo/z47PBJmTj4Y/lwdBcS
	 UjO6zec49OQAvE15PVb3UrT5f1EitDLTKxsFSW0yH3YMcIAGgVBBej8RxC4ZEoS0JY
	 CqTgPVpiW2Dt2kI5hdUR8trq5DYzVJzfyJWo0ZPosAZr/kUDgA3qsAqmCkUV5t1Vt0
	 3+qf9PSqN7FzqoFag45AxPere9m/pibpZ09slGieWAiB8qNJJK9Lbe19/YoLlbEyO/
	 ES+eJ2uM+8Tdg==
Message-ID: <sashiko-outbox-187117@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/10] btrfs: set SB_I_OVL_USE_SYNC_FS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:17:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Metadata is changed in a transaction, and btrfs_sync_fs() waits for the
> ordered extents and commits it.  There is no ->write_inode().
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D4

