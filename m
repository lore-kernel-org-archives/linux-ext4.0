Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7603ADBB4
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801851; cv=none; b=ZhIgMhe3pzU/ZugL2cyw3aRMfmUIyVOySjaSvNpWdPYYes1tQCu34hSI1JbPFwA6QF6VjAKbMErNbQdoqAyMgVgZM4cJ8hp18JPobyK48PpVnbVOFffsF6pTcBY00gT/t8Ji0J8LzmFUZoFDWDJdND/yQ+BZMFoW+QoDOGYW+00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801851; c=relaxed/simple;
	bh=Lck4R6ZM8OeA9UHv0J72ey9u+8a0elv66sHywQ+M0Ec=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XfJAK7olB/T9d8FG5pYZRwmbeCijxoV4tbiwSgYFAWfr7PQcepbcYyvVjzgpspsqZzqukacLxXi1O8+UT5RENBYdE9p2+MoeKTwR2t0iuNZ2pcAh4lvPXXOV4xmgC7Oapdb5FolPNDYcw9nNQVRu1LDuBqobYhRVxaz07EEuBHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dE4Pd7nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dE4Pd7nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4A01F0089B;
	Mon, 12 Oct 2026 10:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801850;
	bh=BeMKxdVmvj+xV5nUV17HMDp/3ahpkWVSo/e0g95V5+0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dE4Pd7nnJdT4Uu0X5dx9JYG3wvX3SbN0OAkUyCZ2n1loWTGW2QNjZI2bZlc46eu+4
	 2vAp+5Do1foJa49Hyu+3KhmnDtZ0ZuzjBQLOJgBQByx9hEmsnxMJrDP0e27i/h4r21
	 i+qQjhNThV1eGOnpWeK8235ShYql2Wp5eGYHvrbMq/Rcq3WCgY1yyPDR0NfFEilw+z
	 GVzK7zSh1uIv3QszFh6EXXF9yPhIarbRvLEo+pUuURIkmfix8k6dxzmd6/Qo1PKRHn
	 hEMrNsOPPOXOZ71ZfAkQMH7tiLv2ADI/cSIZVh4xIVS+cV2Fo5QFEV6J2ztWtibMKz
	 3C1hHk/nFbbLA==
Message-ID: <sashiko-outbox-167980@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 20/28] gfs2: wait for a pending withdraw before
 remounting read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark Fasheh" <mark@fasheh.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz, "Joel
 Becker" <jlbec@evilplan.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:44:09 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
> withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
> stays set until it ran. A remount to read-only in that window goes
> through gfs2_make_fs_ro(). Its log flushes bail out early on the
> withdrawn filesystem before FLUSH_SHUTDOWN can clear SDF_JOURNAL_LIVE
> and then gfs2_quota_cleanup() hits its BUG_ON():
>=20
>   kernel BUG at fs/gfs2/quota.c:1532!
>   RIP: 0010:gfs2_quota_cleanup+0x562/0x6b0
>    gfs2_make_fs_ro+0xf3/0x2e0
>    gfs2_reconfigure+0x42e/0xfd0
>    reconfigure_super+0x437/0xb20
>=20
> Just flushing the withdraw work before the remount isn't enough.
> gfs2_withdraw() sets SDF_WITHDRAWN, calls dump_stack() and only then
> [ ... ]
> same BUG_ON().
>=20
> Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D20

