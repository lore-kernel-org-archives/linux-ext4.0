Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657832;
	b=c9v6pyxA8jlRP6PB3GbRdoNElY/mgTnQ7zR9ch3jKS21CrOFJB+UztoVN0TZ5dnPG0Du
	 t/jcZT0f4FrWszYfUti1ZbYXmKxmZqVZ5hw02lJbCwiTQyujTva3SW6/SVzh1/MvHK3lm
	 EDvWC151cC/+dbJ/GKpY2YrJPVd+GleOS2phrDZObYas/AcqH8hMLnJ5nJ1Vr47lHnlhj
	 z7al/OGvGnX0Dtpc2iljZYY6gng6pse3qb+bM6HRy3y5imFUJM22urkEks/f6xDsNiKiq
	 va2x5CAtCZaqXTf33xIBF/TO4+HIK1xO/7y9qYszfIexzpj1oBOrlQtCVLL62jPZ9Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657832;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=arX9uUYpigtj4u6D1KEGBZI+q9pllnDFBqeFK9LhNXk=;
	b=lagLl/kTfKqA7GCwG5vvacH7owluN/JHpPOhxa8zpRCABTUM96u6QWu+2LWi0piGT9ez
	 +aYn4JB8a470RV/et0J+T+na4zjJE2gqaBVh+GeTIqWwHT9siui9QDDf+rTSYrrUatADS
	 LxOTqwm672ou13HguAGEsbN0ouZmYDVQqfMXp0z1alHQ3RDkkm5+GApREC8MoNyglmAau
	 KoN4vUMTH+6aaAjHhl1edibWmjxcDyE9JCGNs5ed47Jdy2NLzrc590y7vFs9wfzmytnyR
	 zVcwmX4WJ4246tKC94ju9n3cHQP96mrv8jQ2ZVARG6fY6hCGSckFcu0rYnbyjGyaSyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NT3eDysA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F2F606A339
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NT3eDysA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE21F000CA;
	Sat, 14 Nov 2026 12:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657831;
	bh=arX9uUYpigtj4u6D1KEGBZI+q9pllnDFBqeFK9LhNXk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NT3eDysAOfiEdj5pV5PNpFy0hYBetclmTTaVV6jV0/1jZIT0fnv0GNBK/oKDyXXoc
	 BDgS78PdzaK9DPqvk2zt7PF7fOeJt4QMjMcJ6hyM+EJIw4en05KJJw6HCij/OWiw6C
	 QQ2YrgmhnE3LLg/TmgfAtsDQBopKrMXzD5hlAcDB/DuupN9knX4H5t+EGSdvM4pEA3
	 9I10Q1AP/XGFjgG/LtBRY2pE7xjYlSmf1xH6dYyt1uUK/Qst6Ds4lYgOFd7MKipK5J
	 wJM7Scv3dhrDlnvQAt7k8PgMath5f6Be9GlQRdd3vsHguWMNqR3j3VjMqXV03Z4463
	 y1tKqphI8yMhg==
Message-ID: <sashiko-outbox-214479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/33] gfs2: don't set SB_RDONLY on withdraw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-28-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-28-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> do_withdraw() sets SB_RDONLY from the withdraw work without holding
> s_umount, also on a frozen filesystem. FITHAW then fails because a
> withdrawn filesystem can't take the freeze glock. Emergency thaw and the
> gfs2 "freeze" sysfs file see SB_RDONLY and leave the s_writers rwsems
> locked. Writers hang and umount warns. And freezing after a withdraw
> fails and leaves the superblock frozen.
>=20
> SDF_WITHDRAWN already stops all modifications, so stop setting
> SB_RDONLY. A few things have to come with that:
>=20
> (1) gfs2_evict_inode() and gfs2_quota_sync() check gfs2_withdrawn()
>     next to sb_rdonly().
> (2) gfs2_write_inode() returns EIO once withdrawn because sync and
>     umount don't skip writeback for a read-only superblock anymore.
> (3) gfs2_do_thaw() thaws even if the freeze glock can't be taken again.
> [ ... ]
>=20
> Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait fo=
r it to finish")
> Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D28

