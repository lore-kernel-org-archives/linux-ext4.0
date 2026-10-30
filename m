Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376612;
	b=AzZkscN5MpHdaZNyhtw6lgI74k8RSb98rzSG1fDpJn8PvLmH9hbO+4Q+EiD7LDk2I56O
	 y/u117c36la39ABAG9jrTE+FPjvwjcVU8dG2dq/Kx9//yQ24go4IBPPsgRlF1u8uxMh/E
	 wWbSZNlLpX/5SjyfCi7qH7WBknvoi7D2b4+RFBmiCUehnFGyEQWEy2tDcNnMgd93dJ5bn
	 EUrJNuvh72cPd4g4I/FoSMbN0iaxxvbiE8uh1Ev1iDg+4i44/9pQH673qSG7DsetPeV4x
	 NDUgcqFk8xS4uoaiOZ78rRnsmHRgeSCMt2N5Lr6hmacjdXkCe6xuEO77EZ3R2t0fciQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376612;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LHN5XnB6jmpOGTIpZ92Lw6hYITw8Eowot/v5Y8qpLwQ=;
	b=4mB00ThADbbcaJyfLysPsIn68zq1zJKyENXeI8RxNqLSxAWs8JP4Mfs9c1dgOzIr7zVX
	 swT4IpaLkFjV30eAQQx5PnPacHRL0PWNo9vuf8o0OhH+gBH7Wgl230ZXXnFvUzkKXCxgp
	 PFN7YGGeo2IdWG7vAF0WfqDoPb6yXDXWbl2Gm8eFHzQMnvXD7yK4Ys78ckZBpg+r8b+pi
	 8XBmOMSiiey/2jabFoC675M2rXWcXo0LpF5VPhOPwqIBPgQxktYM3t0is17VJrDibUsRu
	 NHjyvfZ+Ul18C6BKROtpl9ioPIKzG7THe6l7yddMKYXKcQ790sHtkDAFf7sC4sYkpew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h2/1OFjw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D64606A31F
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2/1OFjw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C711F0093A;
	Fri, 30 Oct 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376611;
	bh=LHN5XnB6jmpOGTIpZ92Lw6hYITw8Eowot/v5Y8qpLwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h2/1OFjwuhr64e8Y/TndLaL5PDVbRx3INEcOFJGiXqGjs1olTtjYXFfghFcQIO101
	 DmKg22/c8igfRxfpdPL1H3qdYXPBGhX2liVbY0G139I+kS4fR37ZVAMI1P9sXYVWWg
	 bAkTrL/YhJQ7AYBqzwgSBi1tgSnwhlXHSt0bPlyD+ZjkEiKK9gri7/Hsk4X5OUQv+8
	 LH3aiLMgaKJejyWkGzwCm8CUGL211LxDDY3U0HhOcdRSOnmh6AiIBf+eZU/LgZbdlQ
	 qvjqAWL4kEo3cmd2mhuYOe4jdd527/ZJnga2Dni6x3dPxWnrMZw9cxpzsEtvCiZTz3
	 r/wYX35JO/Pjw==
Message-ID: <sashiko-outbox-191246@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 27/34] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-27-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-27-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Since commit 94f7f6182c72 ("efivarfs: automatically update super block
> flag") efivarfs_ops_notifier() sets or clears SB_RDONLY whenever the
> efivar ops switch between ops that can and ops that can't set variables,
> e.g. when tee_stmm_efi is probed or removed. It does that at any time
> without holding s_umount. efivarfs is frozen on every suspend and if the
> ops switch while it's frozen thaw_super() either leaves the s_writers
> rwsems locked or releases rwsems nobody holds.
>=20
> So keep the state in efivarfs. The notifier sets and clears a new
> EFIVARFS_OPS_RDONLY flag instead and efivarfs_fill_super() initializes
> it under efivar_lock() so a switch can't slip in. fill_super doesn't set
> SB_RDONLY either. systemd mounts efivarfs before tee_stmm_efi is loaded
> and the mount has to become writable then. create, unlink, setattr,
> fileattr_set, write and opening for write fail with EROFS while the flag
> is set. Like the SB_RDONLY check this runs without efivars_lock so a
> write racing with a switch can still call a NULL ->set_variable. That's
> not new.
>=20
> efivarfs_reconfigure() only refuses a remount from read-only to
> read-write while the flag is set and returns EROFS. It used to refuse
> every remount without "ro" which would break option-only remounts.
>=20
> With read-only ops efivarfs is mounted "rw" now. statfs() doesn't report
> ST_RDONLY anymore and access(W_OK) succeeds.
>=20
> Fixes: 94f7f6182c72 ("efivarfs: automatically update super block flag")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D27

