Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376608;
	b=DF0202hlYHJDILSOt67vzMVzfBe4wHA8cM61czAHd/fqf3xBIGKZ3skCh3h6YmuPB4gs
	 iIufY4Emk9YiNWhqXVXR65nqhgFksx2rqLv54W3POKrsTAkkG9lUb/DBNpFH+pY71YZI+
	 xD9mYOeVa7+QidB67C8zSWl6DAxgC2AIpakZ/B7cXv37wzKi2tA/hF+3e9ouvt4sNGEsx
	 FDtGauvCs3jhLQNFZ3mbs3DgyTLDpJ1xGg4f/jIyPbuLINcNCWWJrcXD0FQFNSM9bu9R/
	 UTdYCeV6b5wOfKxpe7FPTOmat50U4JuSRQaj8U9Uvb/eLbhLlD+lFGMVB2/ltC3yZsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376608;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xmz7REO39lGohzDAMG5DwwHZQ+ud2JILsZnkVUYx5o4=;
	b=ObdTBQV+mDWzWSztEgMshAX0NleI4cwhT4AfHX1tfY+0pRBqBws9Q+QAUS0cD6Q19vBg
	 jWWrICle8WAho3btPJHPHMKZOTJtpizchOS9wU+MyPk6T19U1ZF2p8JYIIb0VtnvBnVi1
	 DLYHekaXKB/a/EvjFsgsFqrFEXPG003/lkV1GqeobRvHJputZ2KsswtRI1MahqUtyFItW
	 9afT+v40eyB3lmHkFJkaRuBrjGCsP8gu3t69npyfMElJtiEqlH3n1abrkE8Ae5iOQ+jGE
	 2DKaaFDT1luojn3Kd2CbxI5WyI3oHUH3oSEuC+rD+hrn6BPOKhem4KQ+3NGkKOr98qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIFI9tx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5342606A324
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIFI9tx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1BA1F000C1;
	Fri, 30 Oct 2026 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376607;
	bh=xmz7REO39lGohzDAMG5DwwHZQ+ud2JILsZnkVUYx5o4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QIFI9tx6oWaz5i8P+YgsRKB5OT6ngRWg7aVvQiViZk/qO+ZnPouv3o7ELGpxVtUKI
	 ceYLgt4cf1G+/IuAid/chIFN9/iXeGA9/ILsvhbTDoMi4uuxER1LHC4uPEIltFSDAT
	 dzlOFb6lsbjtoXUzqV+jrYigy7tafl/NXQd9CZ2Q+i8R+ceAXMTbr59cN25Y48jw+N
	 LRhZmMqDobHH18PZ7EDAwLHL+j3z5LXAmYdn7djmd7HCe0kZD4tkcpB8apPn0d6Ub3
	 vwL5/dGVVzcBh0HlEeIsXkuWBtRukEc2J5PDmLLrqgBbqILBx5LHCeqM/cwbaPPUxN
	 OrGOq/Zk0q1ww==
Message-ID: <sashiko-outbox-191241@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/34] zonefs: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-22-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-22-2f44f64f0b66@kernel.org>
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

> Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
> the VFS does now. /proc/mounts and statfs() report the filesystem as
> read-only again. zonefs_set_emergency_ro() still prints the warning
> once. The check in zonefs_seq_file_write_close() stays so a failed zone
> close doesn't make the filesystem read-only a second time. And so does
> the one in zonefs_file_write_iter() because the loop driver, nfs localio
> and others call ->write_iter() without rw_verify_area().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D22

