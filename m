Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794251297;
	b=c2vcGt3dvX7Bly1045/A2VAngiBWhCTYNsdSS/LpRT1Iz/5DyW3CEJgvu/P45Vs0ND+E
	 DcOXtLKF2z+2WQpGEi3xKgFIElJGvw56e4fJ8gv6/SfwOWP7E0mUKf167QtVlNqA6kBQv
	 Qf7NQsv8O/TFm1GvTuqIt0kTsjv6gWozxxSwQFDY706L6sFsNWAX641B4i7dy0TcoEft3
	 Q/SJzbjVLG3jWmCIQJLNgF9psUFvIYQGRJNNznDRhkI++4DLzwUMT/eDLydJA0CxIh3vf
	 tahB5xyIL9aRmm48vKBKXCaI/3pP3NdjVvA1005Qd+Z+wBfMOWwU9yUJ6Kg+/Y5l8Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794251297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lJ52alMpwz45ocugmWyPm7s4kaLhQKhIMtTJlTFERiw=;
	b=nhAmYwHmkxcjicaS1e8NDIg8VhR3VPKQT4JMZsdqDhPBbL4i1LCJ0jUPIDJAh+MBJAHQ
	 boaQWz5me/2zS+z+HjjDSnGyPBpXOZQQDmXp7UojLORoeuGHBBdhlmwrQkNyHlP4tLjt8
	 Wh/58HERUGHqUbYKeq7w4W1ivEmMr566wRdz136Uzh1xqWTa7L2UnKuJ7ZqC4fxU1DepG
	 ThQ/930MkNz/OSCbLRSstEMrzoITy7cSbzb/eZXPLkMKOywYTY71+5bjaj+OETdONA7kf
	 itIiwEX43wAcnReWcXt5wT3eMT2mrxT0B0tdbzlKwj8RrDMioBMvCrpydApdF5hWbFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGFoP4UV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BB8606A321
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 19:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGFoP4UV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BBF1F0089F;
	Mon,  9 Nov 2026 19:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794251296;
	bh=lJ52alMpwz45ocugmWyPm7s4kaLhQKhIMtTJlTFERiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eGFoP4UVrmocpbKBuslFeNqbywrnXLQ0vEng7Q0VTECtokdoIFhcGGhBtpBT6/8hL
	 l7p1WKdyxTDoGN7BAkp9/eM/SDls1dhu9s+cRlQYb2nkfS4d9GAOqEEyXnQwV4U8Ar
	 sqoQ0SkP/wpvmReFtivicGnXDV0qK003xwMULiUcfjEPyTFUoDe0I+GR32WksQMQhb
	 Yq3JZrjGXz4CTokdkypNl3CSDLoB+bIaUPG40Js8i4T+9d5NYG+DW1fQ5Fn4dsp99i
	 Rrp3HdAxyvEq76oCJOMD+BBmR+bWttBnjrzAxq4wVXNKG1T83CtTQQROnDsFUEOklX
	 GeHTcgf4xvKjQ==
Message-ID: <sashiko-outbox-205460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 14/14] fat: drop mmb_sync() from
 fat_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-14-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-14-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 19:08:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> fat_evict_inode() to sync. The write-out happens before
> fat_free_eofblocks() updates the directory entry again, so that update
> stays as asynchronous as it is now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D14

