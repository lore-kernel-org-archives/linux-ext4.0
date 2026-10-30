Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376607;
	b=nQHSQlt6X5IoQFfvMGjAs7Fq59Ch0DLwWGR1/bWX8WumV7c3iqHTTtqMyldwxQMvQ32S
	 QTU2gsgYsA3Pbpv6cpi7nJ9DASwXkvQRFBvJoPE9FiAVvgcjl32m/JoN0yOmB74E7b45a
	 KlfmbuW+KGjFd6z+MOR4jWfNe1Jgn+q87c/BfAMKos+V+k37mwNxc0OTeaRqhFUYg7/Pj
	 cSUZRfG5JNPgGQblXjvYUQYfczS+0pzfh0EHqQycx/SWXX1KBsZ4l+a6sVYOpkOSuUJHZ
	 WFSjL1N7LiZKq6/apa28lzXBT5vQ65vLX8Euc4wfLQbWpRhwNl3figP8Z9OhXQiDtHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376607;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e6bYtQjvLfN7vC4UA8hA1lnz+GrfIH23aoj4waZdZBI=;
	b=C2kf+csirkHmHvSgBEIR/ugNmiCItcCdEAbbmZU8qeXXZNXztFxJ60R2sJw/ICNHTyBG
	 NoC6bIyJ1iUoIaSWdX3Y4I1Q9fyDGTeX6phlSvsWnw6fz5rdJDsnJcBn9bOMxRsW5SIi4
	 QXN2Dz7gb4S4YAm94xmXhqwFfNh1cJPlLhRaBhauUknB7lgz+zNXp4tiE46kPpIAhCbIk
	 5VvRTU6f3jp/ptUYzBXca+AqUXBsfwxSrTzyN+OaACAo8ZYe+6iJlUhxfv2rDhwfPoXhh
	 9grjZ3SsI3zfeHM9hfjqZHQcjrUwPJvy1qVjbyPNpm97orFl582f19oh7ofom9JOuvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivxsKfEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5714606A32E
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivxsKfEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC641F000C1;
	Fri, 30 Oct 2026 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376606;
	bh=e6bYtQjvLfN7vC4UA8hA1lnz+GrfIH23aoj4waZdZBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ivxsKfEK0Zd2sNZ2aIW5/J54rzNaWh+bZOAvHj94mbafjNsowGVhO1hw639CbDDQ4
	 X8m8hAG7FkqP/1Qv/wf2SRC8m2aJ8iRzcXB+FgJYNVwG90/dg8YjnzPJuxc9nSpFo0
	 yJb1smg/n3YKGTU2Q4epkTIic913hdPRy1SvRWhtkv26ahDU84qX6cEJUBAbm3Vpew
	 qS0sJ/HZTkUQKGq6Viq7msEJzDPZUN3Knrkt5olTYqVpWHPUEjWr8wqVF5/htb1qT9
	 rDqEJj9e7j1xm7ozEzwJvCsDUxTsv4gQ25mbCaGwP+swK4as0pP8BTLqyZXAubwqHd
	 MzPIb3/NWxq4w==
Message-ID: <sashiko-outbox-191240@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/34] zonefs: don't set SB_RDONLY after I/O errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-21-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-21-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> zonefs sets SB_RDONLY from its I/O error handling without holding
> s_umount: with errors=3Dremount-ro, when the zone report fails and when
> closing an explicitly opened zone fails. If that happens while the
> filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked. Writers hang and even
> a remount to read-write doesn't help because the next freeze blocks
> forever.
>=20
> So record the error in a new ZONEFS_SB_EMERGENCY_RO bit instead. All
> three places go through zonefs_set_emergency_ro() which keeps printing
> the warning once. Write opens, write_iter and setattr fail with EROFS
> and page_mkwrite with SIGBUS. An error on a read-only mount doesn't set
> the bit.
>=20
> The state lasts until umount and zonefs.rst says so. A remount to
> read-only works and writes nothing. /proc/mounts keeps showing the
> filesystem read-write. ftruncate() and write faults through file
> descriptors and mappings from before the error are refused now too.
>=20
> Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D21

