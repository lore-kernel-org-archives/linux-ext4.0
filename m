Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657808;
	b=RRY8Vvrq37hYDeIVTX2IyV2y3F+uuUgw0NdzUOmmzEHWgOKVSD0t7wEi4XikTSTx4oyL
	 TwWt50aiQvppIk7ybyimfPucX+j+XM6pg4y4hGGVpHkcLWNXV4no6+AUBu2mFhIfFUFNs
	 Ih+MhYfcpnbRrfD6RkoaOGU+pyiyeArtAwX97ByTMekae6FBC84Ufxhhw5zi7OF3d4mxs
	 LH2oSEdJapg+xClREFcocfxo24YnjvI4bsBFolALmrsjzi3HMkJneNmT9zxL7JxMKokCj
	 KDvJPZa+Od7I5/fyvDiheN/Ood9KZKgPYKHmn59QSiTtsHpGQBPPGeDnvCaaY0irTwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657808;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ezl36u5Z+4l54JzOZb01teyKDe/vRmWs8s0IIeKEkOM=;
	b=W1cGP4HB5ydfPL0zeMEL0Juf9gYAUQQ6XTxwsClEZBaIpMldhhbZvN/ZQPuu6MhQSbk6
	 cQaT9+v855f+n+HUkrMltMJRt5jZtl1FYDpap8aLSiG9KYMlkx+6P4rwkNR4+l9bBDYta
	 roe51/AvEc55K+fTiJosZjPL9YwQc8K3wV4XrVq4kFI0Fc1jpg60oX7pt5VVIn4DIw1Gw
	 aihHhQJhrp6xCqigpzxxosBg3ZaJyg+3y/GjMHWhNpG7K/Jfs83/L4/wvwZ/OAbXgu2lT
	 YUcp9orwXqNQhnVkU6463KVbc9klxFF9RCdcORRlnfGEGQ+VqjiI8Q1hhySIBPLWUgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmQAWQE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1B2606A337
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmQAWQE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB621F000C5;
	Sat, 14 Nov 2026 12:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657808;
	bh=ezl36u5Z+4l54JzOZb01teyKDe/vRmWs8s0IIeKEkOM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jmQAWQE+3L8TIaqaJoFUVswL7RWqExRJbANZKHv5SN7beX1P021eZNZC8ckyJk6zP
	 M43oJIyKwaNP7aJQ/0UVnG+2VIDHy2NxyV5c4LKHvNIIZElM5kJLoHNRVSO+Y3I/Bw
	 dz53jqUHN+Xhkdx7C4erBWhQqZ0N2jerd2EhSD1vF44GhSR38jAT7Tu55NACs/0eoC
	 rxODcP0wlq53b0DfdQdjh9iJ1Vgr0ngfVy/4r6NPVkVT7fnghuu30nKHQuQG1p1hwC
	 QmNl759y28LZ9WGrF9PG5BrxjAq4EUIMPwKM2qXlfjtlwWIESG3RoqIVWryHJMrQLk
	 buxAOGTw/fbug==
Message-ID: <sashiko-outbox-214459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/33] nilfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-8-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-8-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro, the nilfs2 default, __nilfs_error() sets
> SB_RDONLY from whatever context hit the error and without holding
> s_umount. If that happens while the filesystem is frozen thaw_super()
> sees a read-only superblock and leaves the s_writers rwsems locked so
> every writer hangs.
>=20
> nilfs2 already treats a runtime SB_RDONLY as "degraded because of
> corruption" in a lot of places and that can stay. So call
> sb_set_emergency_ro() instead and use sb_rdonly_any() for every
> sb_rdonly() check that guards a write. FITRIM is refused and a remount
> to read-only doesn't write anything anymore. The VFS doesn't call
> nilfs_sync_fs() in that state.
>=20
> nilfs2 explicitly supported "mount -o remount,rw" after an error so far.
> Now the state lasts until umount like on ext4. That includes a mount
> that reconfigures a superblock only snapshots kept alive.
> nilfs_get_tree() does that without reconfigure_super() so
> nilfs_reconfigure() refuses going read-write itself. Writes through file
> descriptors opened before the error fail with EROFS now instead of being
> dropped.
>=20
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D8

