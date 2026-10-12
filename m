Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C433B8D78
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802780; cv=none; b=p6lc+Z2pXjR8KLW2dQFueZdadSAQglzlVfULloDXKEl5z8zsaX+hLBRIU7ZcFnFF1EDhBs3eQXmmJeag/ObDD55jNO31ctC7GusvWH0hKJQV+t8MPKCoBB7souHOhp2/Y4+i33yjGMKQYnzOrMX9Kpi26ubEBAztX8Y6Nui3vBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802780; c=relaxed/simple;
	bh=mR+i3VOaeFcHdk+7WkAM4e51Vu9BRuXznnKyk5oS1+o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=t4MQl6wSNiqyqBZjjaHG9c0tP3JUVdXY/AS7qb7ymqyuL7OTNI55zBMBtiw44VjDmwZhV/ohj8bDtEBcbVRjLntl/wgVrQh5rD6r49l6v5rt4j7pjORp0J+GpWXT/SwRgJK+8ZVxu3K7lzgrY0gcPudsCynghTjj6SaWdyXeKdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrFRR9lC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrFRR9lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5A31F0089E;
	Mon, 12 Oct 2026 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802779;
	bh=tX3TE5CQuROxSxKPac60egGE975d9sjLazY+ND92GFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CrFRR9lCcmwKghkYcholDJwrNJCtLKLtTShZFw2L7DR2efc0SmXXZd4gPQqA6mKq4
	 lOljhre/P81jqgeIU0QOgeByE1xkERzkSu0EYZ7Nc534nGqQRPR48l4VN/Osy2J6Ry
	 TSLwOstUscVEuZvgdnAw0UGfcbdFQYWPwzL1JAz2/DLNlMjW+lCYa95DMuROp2Drzd
	 KP/nfWdtiZcOIYCuGou4bbiQH1v/kQEaJbOoZbl/Sbe1xkC1EJcUy9l/Tyj52/dNFM
	 Su6xfItYzF74ERl+0qViZwbBRlkGeqUu+i1I/g1LKbEX301D9gXD8NcvaVPxx9ltBs
	 qLT7Zz+do38oA==
Message-ID: <sashiko-outbox-168002@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 16/28] ocfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark Fasheh" <mark@fasheh.com>, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-16-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-16-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:59:39 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> With errors=3Dremount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
> on every ocfs2_error() and on local mounts also on ocfs2_abort(). It
> does that without holding sb->s_umount.
>=20
> freeze_super() and thaw_super() both look at sb_rdonly() to figure out
> whether the s_writers rwsems need to be taken or released. So an error
> while the filesystem is frozen leaves the rwsems write-locked after the
> thaw. Writers hang in sb_start_write() and so does umount, forever,
> because ocfs2_shutdown_local_alloc() starts a transaction and that needs
> sb_start_intwrite():
>=20
>   OCFS2: ERROR (device dm-0): ocfs2_get_clusters_nocache: Inode 5652 has =
bad extent record (0, 16, 0)
>   OCFS2: File system is now read-only.
>=20
>   [<0>] percpu_rwsem_wait+0x203/0x500
> [ ... ]
>=20
> noatime matters, otherwise the atime transaction of the read waits for
> the frozen filesystem.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D16

