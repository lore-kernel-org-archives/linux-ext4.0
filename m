Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A9C402BA9
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802375; cv=none; b=XdNIPkpPkfGgRy1zAwjUCxauQygvion3TATob617IX6Y1lMkkGAe3aWhPD8Nb124khj+fgirbTOvtAwos1/FV80fAwgaOYGyLf7AVWv1Ucx/W7JuplL3/Y3SO40UtWJRe6iAWjWpKniPtecE1f+W6zxJLKp4XnBM/57i0uIOJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802375; c=relaxed/simple;
	bh=/BPtkIx0EYJklFRz85IXOitOhXDtSXv+QS+C4cvH9tk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SCGpAnjljy6dOr3oQ5gJx5pkYsuaXfMekx46Pyow3EZCVcTQOAMXuv3dTtmuq/caCfmAEElsrYaQ8Z6cQm4d4vF/ReI64v6sHNbW7pgwOPWeKmOwm0BQzzptGDlS26heOZk6SV+5sM+KiTI6dmZ1K5f9wusUtBPU9kRHcX4/SYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olc/CbVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olc/CbVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7BC1F0089B;
	Mon, 12 Oct 2026 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802373;
	bh=/BPtkIx0EYJklFRz85IXOitOhXDtSXv+QS+C4cvH9tk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=olc/CbVe2TIRqblRK8GJ0/ToMg3WBZjBYS3CX2NSFHCG5WAZ3IXyOvOd+xEo/amAq
	 ctf9tyY8nBr+VlAQypd4zhSoIPmeY1TvJAYSy9L3qRKcs8uuIac5faDVY/Bf+rBSaD
	 q09Rze8WahnVvQ6u1j1CDHNVzxPc/7xZ9ovc/YgzEnNLYHr9s5r3otjoIRukG1kOlQ
	 ornzyeI+by30alh6hKFL5mAK+dsTTit0lDy5BjNxvAkZXSSQYGmvDq9Vyokci/qvCd
	 ujHE4xTbsZJW1zduMTsWrubDzAwyQMeUoE/PIT/lpznvcePDvTuv/Ph4onwJNvUEZ/
	 WE2exjweT/OlA==
Message-ID: <sashiko-outbox-167992@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 26/28] selftests/filesystems: test ext4 remounts in
 the emergency state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: tytso@mit.edu, dsterba@suse.cz, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel
 Becker" <jlbec@evilplan.org>, linux-ext4@vger.kernel.org, "Mark Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-26-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-26-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:52:53 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Add tests for remounting ext4 after FS_IOC_SHUTDOWN with the default and
> the nologflush flags and after an error with and without a journal:
>=20
> - option-only remount keeps it read-write
> - remount to read-only works and writes nothing
> - remount to read-write fails with EROFS
>=20
> The tests need root, loop devices and mkfs.ext4.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D26

