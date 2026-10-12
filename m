Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2740417BFE
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801256; cv=none; b=bebIJvDntK75qsET8Ds7w2S5t9qPtWUTDgaoMKyUr+ZRe8EI17sq747t6BPmFJ0LFceTGawXcbJ3cylPNCnxa1KthKJ5S1nZseMuQfNidvTjPrsE3VOTU9jZ7vZwtTc693n3pkbn4WsDNsCRwRUHn2fFP4IO7/MRf3f+BC+lZk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801256; c=relaxed/simple;
	bh=GLoNU2UZHZ9XfQIoiudbHiuxAgdXi9M8L7maAGP96Pk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bEQ/8h+eYUO4Ed5K9z0gr3NDw3/Xi+wFTiEQmnQsR5blRazzEguwXzhsyl/QN1YrZxUBMnkUAC/+7tJvAZ5/lS3d3InVImvxN2MHOyoK0Cqm8aL7pBeUpWH1B3u9aZVrk2zoycKpNbND6gyWrcbNLqmJr7HyeeWHeM4v8mIAzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zr3A92gL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zr3A92gL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD7C1F0089B;
	Mon, 12 Oct 2026 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801248;
	bh=KyYknOoNEQ75SRmVcUxN3oZ76lLSn7x8H49GfvWj0jI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zr3A92gLcmW7kkLzyTJN5j0EhimRjSdyBdTk5r7t17vJ+DTxITdxa//ubY4vAbsFq
	 wqD3pWAo8cFnc43gubqUkZgOJlFnCRNygyIBlkYTW9JtTOtH51+NgVUbODhBZvrl+D
	 c0qQ62lPSPeennx1yyCWAkXzeUYdi7k6gM96B5T3N+z1PqO6PmhsffNfE5xVLI2+2n
	 cl/y+0VX7VjMg4BMyUqOrolHM6/odd2+AI9rNfjj5J09bN4eoI4/CXIYJAPos81oz0
	 uKp07pdctUCDxUDoRW8H+dAvkgNBf2nfigSXimp3kio8kBvGdrPjCHcHA6HwbbqL0+
	 khRePjDysBwiA==
Message-ID: <sashiko-outbox-167963@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 05/28] nilfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel Becker" <jlbec@evilplan.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz, "Mark
 Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-5-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-5-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:34:08 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __nilfs_error() sets SB_RDONLY with errors=3Dremount-ro, the nilfs2
> default. That happens without holding sb->s_umount and from any context,
> also while the filesystem is frozen. FIFREEZE doesn't block reads and a
> lookup in a corrupted directory gets there:
>=20
>   NILFS error (device vda): nilfs_check_folio: bad entry in directory #11=
: rec_len is smaller than minimal - offset=3D32, inode=3D17, rec_len=3D0, n=
ame_len=3D16
>   Remounting filesystem read-only
>=20
> freeze_super() and thaw_super() both look at sb_rdonly() to figure out
> whether the s_writers rwsems need to be taken or released. So the thaw
> after such an error skips ->unfreeze_fs() and sb_freeze_unlock() and
> leaves all three rwsems write-locked on a superblock that is marked
> unfrozen. Writers hang in sb_start_write() and umount warns when the
> rwsems are freed:
>=20
> [ ... ]
>   # or umount instead: rcu_sync_dtor() warns three times
>=20
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D5

