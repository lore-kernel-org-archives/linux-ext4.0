Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657832;
	b=Y5lMr4egfDRQUQMyj0aWcEvqzmYRANxARzN4tm4aBaGRXT/EXgg5dBuah7a87XESSmnJ
	 ITZQ0tP3rHfsB2EFSyX1LGrIgnVOdAkgLWDWnbIDGzjORSu3QKDDd2+RgNUhsKrhA4dSa
	 Nt6A5aSNne9wHfkK2L7gQX+SxA+3JqiPqXqRKxtUdpOnNwxBciGcbVfKixCMYFc0baZSi
	 xyInTMqq5T2K1bSxzhBisg2RsbBWf2Rwk1I0nbM5kMoHF1svDE2YsHZXlT0sCRYB7f04K
	 BH8OyE7hzJLENEbPrWABOM9h4yFYdKOrf1XT5SgWwgg9ofTeO4QQhLWyqGONWB6JERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657832;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pmfRH6jAjkYm9OQ8lNeokYxFTyGlHB7AhPxEuoWezKQ=;
	b=ucrUWc0FrmLefVkGvad7lDBvUO0i2gMxqJn4S9l/mRMsod9lE0+FW3/235X7qqyxUjx/
	 nR4PogdXeyqHY+aOy2a5cgW6O8XKPEjzaabEv/Zna9y7BQV6gpzJOycbJeb705vAizz3C
	 goE25tRlRnVi0CZL0r+4K3xUyWH5xZVfNCEO9YzkU3PEs0dy0/BlUNGbGbOjtH2nZv6Mo
	 SwRoLRnjGs8psccamwyVQ8INJO33iV8XVKJbI9jLOR/MElfkWNs90LI36fOFxHochtnEd
	 V2VJk/Vkdu0dGOpR1IJGSQG8AEf17gNGhgi4rAM6bQN5KvT0WTCmmvZHuk6Cj1IzkrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cdKc/E+l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ACB606A333
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cdKc/E+l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6741F000C4;
	Sat, 14 Nov 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657832;
	bh=pmfRH6jAjkYm9OQ8lNeokYxFTyGlHB7AhPxEuoWezKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cdKc/E+lIqZgJrvDVXDBdJVGfSHm0T/8D/ITz7+huLnMhQEBqdVhrXK9q3EvOtLf1
	 3S4WZaZfn6VpYLNV5Ph7BpkyIjWC4lAezI/JHpus3ALma8fZyciOKn9INuJZRQLE/w
	 Xs42il5MHzes+tzHJ3ksLzIq26WWozc8TPGhD+w5nCVixaiMqd+OlrxwD2+36T+j34
	 l1f2d+QWJRztAizWXAVYez1OhmSoeXc3RWCjpHZJFphUTKrD/dX6NdwOK7psjxt4l8
	 YKNNzu+72DArWCe2zef8g1B3UbKSwBCepuwtBxTJmq8X79l1rrL+3GEA1rpK+MHYOm
	 sF/ZGOpCaZi9A==
Message-ID: <sashiko-outbox-214480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 29/33] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-29-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-29-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:51 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D29

