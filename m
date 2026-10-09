Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BC83F3283;
	Fri,  9 Oct 2026 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583478; cv=none; b=nO77U2VT+6+XOwD1b9oUTlDhCoVEA4m47CoUwQ2zq5rLskmEF5KPYyzo6XsNhxeAgU0AZO8cxFu8Du32FS2cZagHI9rsxmhSTj5C1Qm3k0wX0MW8p2NUTbaoaGItqGyutr4xKIvP1t/HfOoYhagQ09q5nEDh5W13iOwjQH22be8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583478; c=relaxed/simple;
	bh=UI36m8o3KOZtsOGxQ+vrTJPlLyGT/pg5OuG8AK7GTQg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hcqsYm8WcHTRjdt07bNKNrbQJ98/d8VKwQa+2ScGbar3YMRgmrf2n19ndBlxsPyrB6je6cp5Nx2gNd2mHTW7NnFnRpba14yWc/ahG70+eom8l2DUqdDFAi/GU002Lc88XuAH4P88C3S0+ryclIO+hHNtcyBv9KyWB1oVUwiWQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYKRy93Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYKRy93Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650601F000FF;
	Fri,  9 Oct 2026 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583477;
	bh=UI36m8o3KOZtsOGxQ+vrTJPlLyGT/pg5OuG8AK7GTQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TYKRy93YZSbVeGyD0xbCL8nquwHbNbLgBJlAS7N+yl5G4RYdl8T0TEIR/gHrKkPli
	 B1zJ9TbAfv/tCpc3YBbysAIsK0gf51nbfhoBjhmcGT/Olr7YgT85dvXtjM/wJVdabu
	 79IqaeHUclVVRCd8G8bKdRk8r1zik8Irf20vTjKB6384/fck/UItaxF+uL4ctr4hUQ
	 QbJuZBaQDw2AvSxNRTQnQtVTlkUXUd5/zwx8zAjTEdaapwVib1oIT/aPAjro3J224a
	 0+WSau2DQ/6uteS21k64qsvRzJfqg8JJvdVszRIDgjqYXyEwVDDzQnoC42OLgoo87q
	 ygjicUQ6uQt1g==
Message-ID: <sashiko-outbox-166124@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/8] ext4: free the sbi after a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-trace-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009-work-fixes-rcu-v1-1-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-1-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:04:36 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_get_link() follows a symlink that keeps its target in a data block
> in rcu pathwalk mode with ext4_getblk(EXT4_GET_BLOCKS_CACHED_NOWAIT).
> That reads s_mount_state in the ASSERT() of ext4_getblk() and again in
> ext4_es_lookup_extent(), and the lookup bumps the extent status hit or
> miss counter, all through sb->s_fs_info.
>=20
> ext4_put_super() destroys those counters, clears sb->s_fs_info and frees
> the sbi without waiting for a grace period. A pathwalk that is still in
> ext4_get_link() when the last reference to the mount goes away then
> dereferences a NULL s_fs_info, the freed sbi or the destroyed percpu
> counters.
>=20
> With a pathwalk held up in ext4_get_link() while the last reference
> goes away:
>=20
> [ ... ]
> in ext4_put_super(), the counters go with the sbi.
>=20
> Fixes: 6493792d3299 ("ext4: convert symlink external data block mapping t=
o bdev")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D1

