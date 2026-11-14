Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657834;
	b=Fo54wxVTmzdjs7i8A0onolaaz3In6ZgwOoE+paC5u97DYfWhY/75gttGygKc1iQj+wSS
	 P4OmtHn0TE4DYiC1yPEpjPaPSq/TFWGBJRt9NQFP3svK3Vcfl0uJUk8WArnzJhyYJseC/
	 OYJmmMhGLtbC0BzgQXIUZx78sO0tRNl662U+YOgVJSNM2w8iw01XZK+zAOiIq3Vs0VR0L
	 PgT3PBVHBdq5Aiob2eyQHqYcl5v54Qy62YznoTHDJbhDzyNjEIswwSGmw7dV4d852Z8gG
	 TvOjMtwktwpANAk/jQfvrkK044Souj1+R8468ldlANS+MJJs3ogghGWzdeXnun08o2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657834;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xFINoKU1kPDIv3Vg1jdGriiWa60P1WBowOguZfSQ2N8=;
	b=HI/J47WzTvIo3mTs2yeZnXk0+JetlH61Yg+c5XoUTsBENXrU7x7w9MOf0i0EaMgsVDVz
	 je2NiKXjmsoRSwX2F14sxxco4cUQXlWsHnbYlSwYYDsOUWF04oS7A6e/NfZJrw8IQRbwO
	 UdV17vntwtp7O4H3jcmSiDyNnXIllA//laz3ZWhU9ThGGg1euOpi66pk5HOnKUYfT9bzY
	 Et59RvywSd10UisyHuTcX2ug2y3qTrpjjAG1J0ID9WsmN6uA9eukzHM2POsHHQPs8axqI
	 SSf5s2qAkR5VGhXC6MVnhbxOlELo0Op9QdfKL7ddcurG8KOzxicnsSjFCnsC1BVd5Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LTlwSDK/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC48606A338
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTlwSDK/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5C21F000C8;
	Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657834;
	bh=xFINoKU1kPDIv3Vg1jdGriiWa60P1WBowOguZfSQ2N8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LTlwSDK/W/svMtn+8xV3c92f571oeCMeLDaeh9f6OweBO14mmP/7E1rUBi3+aRP8d
	 32f6mkX+SW5eVYcqWjmrT6M0W4EQoUoLy4q4BMiDUH74Qv6Dw5JW8gbhV7OzZ3+jfu
	 KvBanhfiPyfNykQm00KtprQzMRp98XwsRkarvjb3z5YcB1AwX0f4mcXmnVQkqmQq4F
	 dnYCvGGcCFwJzd42pMHcVMkrjkur+BLeZB5QmOTLUCR3lxwu+LqKI1zMBcoV9evwIB
	 3Jkumv+PXjvDZngP2RH+0fDSgwiVDrxwNCtQLnesrbnSEiUqw9Op/rH/OJEameJgiH
	 efQerBuJaNVPA==
Message-ID: <sashiko-outbox-214482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 31/33] ext4: allow remounting read-only in the
 emergency state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-31-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-31-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __ext4_remount() refuses any change of the read-only state with EROFS
> while ext4_emergency_state() is set, i.e. after a shutdown or an error.
> Neither sets SB_RDONLY anymore, so a remount to read-only fails and the
> filesystem stays read-write. Emergency remount (sysrq u) asks with
> SB_FORCE and reconfigure_super() WARNs, a panic with panic_on_warn:
>=20
>   forced remount of a ext4 fs returned -30
>=20
> Becoming read-only doesn't need to write anything. So allow it and skip
> everything in that branch that would touch the disk: sync_filesystem(),
> dquot_suspend(), the s_state update, ext4_mark_recovery_complete() and
> the superblock commit without a journal. Going read-write is still
> refused.
>=20
> Note that ext4_emergency_state() only exists since v6.15. Older stable
> trees need ext4_forced_shutdown() instead.
>=20
> Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
> Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D31

