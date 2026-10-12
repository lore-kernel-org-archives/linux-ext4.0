Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687F34752B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802056; cv=none; b=MzULuI0Yu3ybGpxrMwGbNHVaF8e5bJIgxWokdD+He7QZDx9LA7ukZeYcqt851ZCWi+zeOAzQmqc7/Mxd/lOkADsK8dkhAihQDyg9tI8dmk9D5fXYPsswIn9aQ51ULlQfZXs4bJKBXlQlnN2esm6n80Tw2/NqgWlSDH7Re1YCGMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802056; c=relaxed/simple;
	bh=kuovH0i1xtaJVX+R+ImLrvbYr6c2wMgSLmLs6Gw58es=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hhlehqvVxxU1cm8YcqjQpqMXmO3ToHLn3P9cArKJh6OsdlcxQS34yBJtWwlJ+MX8zlX+Y8xihMMocZgzaQT8kETXelt50Uo5DA72MKO7VYxZRj1883vowK/shHB7jyiw+hNwn5IF9+X7Irbqh4oLY4MHYg17S8w3L6ugWSn4LUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPiqhy3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPiqhy3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF29C1F0089B;
	Mon, 12 Oct 2026 10:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802055;
	bh=26pZZBaQRNTMny1vhYsI4pP464tSljAVWv3756hP5Sk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dPiqhy3K6y3RZdzFtG2ES705KdeL7NPmzNMnUrLXLktjShIGR7kX8ew07LHINak7c
	 QzKwscnZu+byf5spouD/8AQaA23js2ztmoNbA/QMz9hlAh6KFGiY98u8ANv7oMXknG
	 V3f5BYUmB4iPfZH+a+uMT/RBtNXhJBqzOqO/zZlC2vyeuInW9CL4G35zdFasV+W5jU
	 A2Ic6XX3qQlhl7yRfNhDaDLdDzIYNQZWSmYd4Z1+NwTeOj6mSX8HQGIln7RykCk+Po
	 yo+G5qFUpCvpsLFVSxwHO0t2DvQEnPXUESX5uvn66DTF8wcXrxE9uHPgWOfrLIrymK
	 yJQx/yEzNKn1Q==
Message-ID: <sashiko-outbox-167984@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 24/28] selftests/filesystems: test filesystem errors
 while frozen
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joel Becker" <jlbec@evilplan.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Mark
 Fasheh" <mark@fasheh.com>, dsterba@suse.cz, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-24-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-24-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:47:34 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Add tests for filesystems that hit an error while they are frozen:
>=20
> - ext2, jfs and nilfs2: corrupt a directory, look up a file in it while
>   frozen, thaw
> - superblock stays read-write and shows "emergency_ro"
> - create, write through an earlier opened fd, chmod, mkdir, rename,
>   unlink, truncate and write opens fail with EROFS instead of blocking
> - same again after another freeze and thaw
> - remount keeps refusing modifications, going read-only works, going
>   back to read-write fails with EROFS
> - write, error, remount read-only and umount without a crash
> - write, error, sync: fsync fails with EROFS on ext2 and nilfs2, jfs
>   still commits
> - gfs2: withdraw while frozen, thaw, "withdrawn" shown, writes through
>   earlier opened fds fail instead of blocking
> - freezing a withdrawn gfs2 fails and leaves it thawed
>=20
> Everything skips without root, loop devices, the filesystem or its mkfs
> tool. The ext2 variant also skips when ext4 serves ext2. Children run
> with stdio on /dev/null so a writer stuck in sb_start_write() can't hang
> the test runner.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D24

