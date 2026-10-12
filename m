Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABEC40B38C
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802507; cv=none; b=Um15tekhqR7N29T29Q1llPYJ7K2QwKp37Zoex6Tp+ZmlVAj963oyl4RFSeFD+xXdNacJfqCOsh3Sg6I7/UK9WE+DdM0fgs8FvNVePF3FDeXRhEFlMaQwIHn5pH9AZWZ3v9UX0gwv0FG3H5ZoEonzbJfFkP/kntjQxnJQUCmmd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802507; c=relaxed/simple;
	bh=fFDTV4tknej5/oC553x/1wpk3lPrWmgTvW3kL2Q4fnc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=X17Ix64ndUL7ny2949wc0dHCaGU8G7y1z9tWpQaP2X/Bv6FIetzfcRWKT1oaRMdxxbfmUZHGzq5uV3JC9rZSo8aVMKlDhlZXybcma/C8gXj3jkehPdjsj2ltDcT8ktt1jd47IzfPDhp0zXbIM/TQuUipIv1vmsfdaDbhI8iZ5i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0+QAlMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0+QAlMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ABD1F0089C;
	Mon, 12 Oct 2026 10:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802506;
	bh=6sMxjOVVzKcbzkN9mK3nHJc2Trc0FTForDcdmKptHZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M0+QAlMY9G9wtQFFzEau4A06+1NWw0Ca6vIo2hG+mCw48HQtJsGAFfkUp0LdAvIVY
	 Riiia59FBSe7CgBEkS/s77aplPwxgu1U07qaErC6VgQSnrONIY2eluBJV14N8/Fon0
	 j2AG3JU1vXLcFSGYj8KZZutTiCXqc7dBdnP7E+E3qKw13w3ssaPZbw/QzE3vSSED5D
	 /9qTzQf/qpIwXhS1ajyI+A7mGF80zX45rOWMVUuXbw4ZVUHdfNgSkC1Dk2siewckMn
	 dOFgoAPZalcvw8lOF1m0QOotLiAMqVEMaMzMciii2ukb1p0009CndTOUm2+B3QZipa
	 0aGXXzshF/DNQ==
Message-ID: <sashiko-outbox-167995@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 27/28] xfs: allow remounting read-only after a
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, "Joseph Qi" <joseph.qi@linux.alibaba.com>, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>, "Mark Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-27-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-27-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:55:05 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> A shut down xfs can't be remounted read-only. xfs_remount_ro() starts
> with sync_filesystem() and xfs_fs_sync_fs() fails with -EIO because the
> log can't be forced anymore. So "mount -o remount,ro" fails with EIO and
> the filesystem stays read-write. And emergency remount (sysrq u) asks
> every read-write superblock on a block device to go read-only with
> SB_FORCE. xfs refuses that too and reconfigure_super() warns before it
> sets SB_RDONLY anyway:
>=20
>   sysrq: Emergency Remount R/O
>   forced remount of a xfs fs returned -5
>   WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#0: kwork=
er/0:1/11
>=20
> With panic_on_warn that's a panic from sysrq u. ext4 had the same
> problem in its emergency state.
>=20
> [ ... ]
>   echo u > /proc/sysrq-trigger   # WARNING: forced remount of a xfs fs re=
turned -5
>=20
> Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readon=
ly remount")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D27

