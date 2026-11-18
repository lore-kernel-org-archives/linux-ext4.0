Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012011;
	b=hIhsssHZdnkfwxeJM+HRvkCRZPvP/NLG/MAENDLZCsU/FZjC8jVEpWKgCc46DOeeVK2/
	 boDrV2MZkoPJdR/7ih517OS8u6qI5kJxI5T7o2a5IkIX7lFJWIKgkfWmJuu2nCLAk7oIS
	 I9KPN7B+LNGnqJ3ikoDEHBTKY79WvBI0Qduy4Snyek5QyTevo5Nc5t1K1aGU+I4C0NLy3
	 Yl4lyRQX2bGRbxJ79rEdeBA8bOpy0RWN6TxrOtGb3Rf0I95325ikylZ0BwqWAf/vMjybc
	 /f2Q5NVL8zIwpORd1ZM0NRRDERQWPRYcZj3e/72sPB+U8HBRdg77EK7FvjTY79a7FDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012011;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qbLRN0zV3BKuuC/K5aaeUCgukUpb5jt3XGVWoKFDT8I=;
	b=h/qMr1SUGG4iZaZOXn4xLr0C6XDZNkhJaRaNHK7vlEQ/Uov3JpwlYed1a9KCBF4aWRDD
	 pPP425LrwnBI7Tc1AwmUG/WjRZAdv49zme9QZVXIUYHZQmhsrpZ6Hd2oRt+RKp9LVlnP8
	 idO1B1keM6AoXch3yUPpsNmy1cX6Sb6233OGKVMYANbMc9xIJpCVMR2H2+ZSNEkPT/C0L
	 sv0zTD2jMXmOk+N8fqAmylreWkY9MqK2DnIBCKK3KaBWkLqzEtbbCO5T7av2LpMXKvVvR
	 fFsXcd4lTcpqUTTJhbwiQxUY6DVEjZOJ2tyNT9OHoWgE4IRcPML2lCPjpKKShuSsmmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hjk5PC8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9E660A2600
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hjk5PC8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC9F1F000C4;
	Wed, 18 Nov 2026 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012011;
	bh=qbLRN0zV3BKuuC/K5aaeUCgukUpb5jt3XGVWoKFDT8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hjk5PC8eAhNGbOXXdtPdmb4am4p4AdofAukB5LtZ2VVD+NRCTK0TAaTsSzdbpFffJ
	 4uTAbrMvHVXpdoeOKmJkNBSBcAJK1eL3pNEONTABb3mXYQW11QXktfFOB1abkVzmwM
	 493FXVAUYPJDJYc9kyhMkUM0XDj6imLWmx4yEc8fLyyj8bGlb3HW/NT2o1eDtgws0/
	 nTo7lhfyYhcxVSnoO1I42BXzM+0gRJpDg5u3xlqwT31IgS35BkCNxN4Hra+6NZ3Lcp
	 5Mfu7XhBVF0pEPIhoYYkciwVs+x8yZaRDSO2burnoUOCwu/8BL+QVAJapM743RA1wx
	 +Z2/rMPSjsODA==
Message-ID: <sashiko-outbox-221200@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: reserve inode write access before unlinking
 entry
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
 <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
 <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
 <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:26:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] ext4: missing Signed-off-by trailer in commit message
--

commit b509da876656fd700f861cfb297b84e9a09eede0
Author: Alan <3164729207@qq.com>

> ext4: reserve inode write access before unlinking entry
>
> __ext4_unlink() removes the directory entry before decrementing the target
> inode's link count. It then dirties the parent inode. If the parent
> inode-table block cannot be read, parent inode dirtying fails after the
> entry has been removed, and unlink returns without dropping the target
> inode's link count. With errors=3Dcontinue, this read error need not abort
> the journal transaction, so the directory update can be committed without
> the corresponding link-count update.
>
> Reserve the target inode location and journal write access first. When the
> directory entry is being removed, reserve the parent inode in the existing
> branch before deleting the entry. This makes inode-table read and access
> errors fail before the namespace is changed. Keep the existing namespace
> and link-count update order, and release inode location references on eve=
ry
> exit path. Fast-commit replay can skip the parent update when the directo=
ry
> entry does not match the target inode, so only the target inode is reserv=
ed
> in that case.
>
> The original source-derived injection at the journal write-access boundary
> is not evidence for a committed inconsistency: an error after the journal
> has already aborted cannot establish a committed transaction. The relevant
> failure is an actual inode-table READ EIO before journal write access.
>
> Tested on Linux 7.4-rc3 (torvalds/linux commit
> aebb7274476403040d582c61478df8f4a7bf9cd3) with QEMU blkdebug and
> errors=3Dcontinue. On the unpatched kernel, the READ EIO leaves the direc=
tory
> entry removed with Links: 1 after normal unmount; the JBD2 trace shows no
> journal abort and records the transaction commit, and e2fsck -fn reports
> an unattached inode. With this patch, the same error is returned before t=
he
> directory entry is removed; the file remains present with Links: 1 and
> e2fsck -fn passes. No-fault controls pass on both kernels. Also built
> fs/ext4/namei.o with W=3D1.
>
> Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
> Link: https://lore.kernel.org/linux-ext4/tencent_D60E766CE07D3A1847B81DE9=
BC37B4466908@qq.com/
> Cc: stable@vger.kernel.org

[Severity: High]
The commit message is missing a Signed-off-by trailer, which is required by
the Developer's Certificate of Origin in
Documentation/process/submitting-patches.rst before the patch can be applie=
d.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_6D3188701BD=
3C36F588C221C4CD924FB7809@qq.com?part=3D1
