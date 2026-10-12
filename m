Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0CC40960D
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801276; cv=none; b=XPraK17ZkkPHFn9kuiLyV5kYF+HEyl9vY3+qr+pECLAhS5Z4JDwsyfzzo4xL1nnwPxSdHNy+BqPToP+X/mUcXIP7386yjSLCwdxlCQnL/Og2DHVlIkr0S92MjLbpfxCSBzRSo5D5rJGYskZzu111Ng9Pbqe7kPOFtIgZk4MomtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801276; c=relaxed/simple;
	bh=Ny6Q7APH9UKKBRSv6M+L9pMg3ppc/Wab+BpYW7FfON0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SQnSQI4Hzc64w9QadB1zpFkoE7dwB5Wf5S9j46pcP7emKt7rX7T8bO+Cd6KJRHhxOYVDYRJS8OevECqqzGFkxbvIjMFs90x6ianLfyHQPvzzlAUCS4XaPJiIVgmJHVKz0gfhVWsyWbqC4oHrjBAog0pNs0R0U5WQ8Yvloo+hkek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5n7FHK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5n7FHK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA7C1F0089B;
	Mon, 12 Oct 2026 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801264;
	bh=pEP32TfIQTY92CgM2hSel1hja9NRiEbzeFqjQqLR3EA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R5n7FHK53lRh5/x9n87UA8yx1cugkTp1noqycB1yP7X+zBU28d9FUjWyekZk3Ni7q
	 5UaxCPhoSpF7QkBP7RIKtS4XDgydfc0qxCXz64Woekw5R3efMqj2fz42gjdiV6T/Up
	 KAFgWb3ziEfblsUruejtBIZu0rQzeluNeZVmqOQtUlhok9anr5Oco1bj/uLvp+Fh52
	 f9PUgSB75BIZtYhwv9Mohx29q2neeVnwhhjrksqF/kJP0a0uvHMTwgqw/zrWpU8XHs
	 tIIvKdMg/ktzLUUMn4v+NT5e90Kzh4TETbM0eDzkD8JIgAHQSK9o9JlI4N1/GGceUE
	 S/aW0yNbZnsIg==
Message-ID: <sashiko-outbox-167964@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 01/28] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, dsterba@suse.cz, "Joel Becker" <jlbec@evilplan.org>, tytso@mit.edu, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-1-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-1-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:34:23 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ecryptfs_lookup_interpose() opens the lower file of a regular file to
> read the size from the header. If that fails it calls make_bad_inode()
> and returns the error. A new inode is still I_NEW at that point and
> nothing ever unlocks or puts it, so it leaks together with the reference
> it holds on the lower inode. And an inode that was already in the cache
> gets marked bad for all its other users instead of just losing the
> reference this lookup took.
>=20
> umount then complains:
>=20
>   VFS: Busy inodes after unmount of ecryptfs (ecryptfs)
>=20
> That's a WARN, or a BUG with CONFIG_BUG_ON_DATA_CORRUPTION. The lower
> filesystem reports the same when it is unmounted. Use iget_failed() for
> a new inode and iput() for one from the cache.
>=20
> Reproducer, opening the lower file read-write fails on a read-only bind
> mount:
>=20
>   sig=3D$(printf x | ecryptfs-add-passphrase - | sed -n 's/.*\[\(.*\)\].*=
/\1/p')
>   mount --bind -o ro /lower /lower
>   mount -i -t ecryptfs -o ecryptfs_sig=3D$sig,ecryptfs_cipher=3Daes,ecryp=
tfs_key_bytes=3D16,ecryptfs_passthrough /lower /upper
>   cat /upper/f      # EROFS
>   umount /upper     # VFS: Busy inodes after unmount of ecryptfs
>=20
> Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D1

