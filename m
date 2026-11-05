Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882730;
	b=xCAKUYSccpBoMlyNexzxrf73JrSJQKoNAtkfqgRTHsaulVbFxz+PuHvMaWtKHrgwQjRz
	 XaQmMmARcfycLTxdgmTw+jox49f1evEf1iQ3DYgOSXgWzWe2/PA0P/C4dkYjBYQKE1kRP
	 paAhb1SLTmXL0CwiHYM22nvm0Ch42adGRD9WPZbPSPSms7rEFmHr/4a1M4J/FY/j+vC8g
	 JE1iz3iH7O9FiCtAyxc2aCIn8EM767H1wTdsWuy/gf/REp0Rf53xMqvFWCG5NjDc06DAn
	 kpnOFVVPBui9CDv0hgCWPWZnLFKGA5pyQwFt1ZgdFA/Wrvc49eRZgJqqu57+3HgNR6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882730;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dext2L2QaTfLDcsFpkdAEzlchq5bNOcNvU8UcMA7jbs=;
	b=lHOgao/+1rGmxkLvdwKryBkMFiUe+HXx5eI07vBTbhmUcxu8fLOxajz9r2j9OeX7KSGa
	 +CegZMl1/+RpHEMyUOKA5kp7St0NDYpVZtSIVyBqqpJ1a/ydce0mMMWVAI4PbBted6//Q
	 ntnL36h+0P1GASj/FPShYc9LAfqdj+Xk6etyzb1WQ4GuIRL+S5TYsc0FvsIIQjLQghzWt
	 naWtPw+yF6yi6Ol9WQnh1NXFmlx+9Kx+J8NMD+TvYEOp0mX5G4d3SOVvAxS6tz1gfHTJ7
	 PI8ttj3F/uY8t4XBr+PXYauwhVgsbHQ78b4/ewQ0RUmLbntWdO1tPrrFx85sXLo21Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GhuVK0Uc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E579F606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GhuVK0Uc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F31F000C1;
	Thu,  5 Nov 2026 12:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882729;
	bh=dext2L2QaTfLDcsFpkdAEzlchq5bNOcNvU8UcMA7jbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GhuVK0UcseIoY8OWxKVxEJvlt2UVIJ2Gn0FfD+muAf/s0FAskDRnnOKRcNoF3HdVU
	 s5Zs8QfrVD8jODC/iTWVtciT7Ul7e78Zd8yAi8+2PYK0UZ3q4GZBnDoWQO+FgczQYI
	 4Xdbi+VX+CEiumfLCu95MjXOr1QdKq+3rdqrOUgmCUj8RWCJQ7EYR5I7CpKRksoC4G
	 uhLqsOgAtcg2CZDm0a5sAdwX4l0hhHRLl7zZOAxfJ9DJVYgF24jie7SkKuI2mcISh5
	 NaFIH3lj3wvg29jp/6s5wCDZh/LbPUSxLh/h5jiQmslHdTqsUvmCU8aMSGEfBQzpSn
	 MoJuyge8B7SBg==
Message-ID: <sashiko-outbox-199051@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 07/13] minix: add minix_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-7-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-7-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:45:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the block that holds an inode out of
> minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
> minix_sync_inode_metadata() is going to use it to find the block
> without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D7

