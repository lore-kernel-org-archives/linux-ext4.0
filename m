Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016816;
	b=JUleMELBOBOwdsDGJby3q+e5CJiiSt9CkKAtw8PBxrm46rN/1ofI1dr66S5DGbGir2RG
	 u1XC6j4vxdHqdsGr7ZRYtqS3kmQrl4AuZtIqX84h4eIV8VdHnuZwN5bCHSNR6mWJBc7KB
	 93AlKwnIAy+P8UY/GaoHv0rP04SBVY355QXd0xnItCy+8tc6BKAPEIiYkvV8HxzcwlVb+
	 ht5Sd0WBLhBAL27HNbuM9i8VdySTN8tvJAy0beYBZOhoww3G4N2k+OTG4et7TTsjvgaVL
	 WLldgC1RCKb7i3yesmpRoV4P1Z2x7ftSW7FkBvjMecj70sYc0Ro7amtVshkgoDiZ4eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0a56h9jn3YjNblMmNGzA48Nq1LcpE/B0RFFS3WWvrjc=;
	b=kDY9ZbF5dlrwcF28WGWryUE5lr76iJjKfOYLbVTuxtGMdW0XY1siA/d1XdZD1aFH70oI
	 fI1/qOFnC0rMD1o3xJim+hS6ZQFI3rWbPIjIiEfAGcODWl2cRLDVnsl++mbX2DuWavdCl
	 TiXPua8amNRhq3xes4qsEMC7uL4o9sx+VfdbE6CNEgn2YVo54IzGYIzbB7q+132xNTcJh
	 pSABkLnw+joZf5kidsyagxNJzj7X1KVEnVKvvhnRUF/pjUk2rGKb2BOjOxtGCvRMRA1LZ
	 NNxMAarg6wlGfGolxOSHu8V+veqqnyVlukJRaOj4SZvJGu9rCsViUtlVkIcgdDRPF6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+ucMc2e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034FA606A322
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+ucMc2e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E791F01828;
	Mon, 26 Oct 2026 12:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016815;
	bh=0a56h9jn3YjNblMmNGzA48Nq1LcpE/B0RFFS3WWvrjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E+ucMc2eC7cIdeULJRLyRkVMMwxJeAeo0fAwjXKQZ5NTlzk7u321O2TVUyvQ1CBoo
	 tEeV2I6Q99KhMB9dusGl2gQ48qChycVpE2EJ2jKIlIyv2kC1DW6GFxVP3KX/VKG0KE
	 mymtrjG/Z73MdhFVCJmdMdnbeRT4p+zE3GTselha9PFBUuoUR8HF83JPPgde5S2G0W
	 eO97CiostZKN1bihPziWTlGeC0J7uDpkS652avwoSP1N1il3cELNLE9GBckx66M1TZ
	 5kQwNkhXFOa8c8LIwMEhLBEzK5qCXHCRcG9StBFIc19EYNrmuCXdzWSaeyLJ/BPAUx
	 eGJFJr++mDXWw==
Message-ID: <sashiko-outbox-185188@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] ext4: return 0 instead of stale ret in
 ext4_iomap_writepages()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261026115131.1735014-2-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
 <20261026115131.1735014-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 12:13:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> smatch reports a "missing error code" warning:
>=20
>   fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? =
'ret'
>=20
> The 'ret' variable has already been consumed by the
> ext4_emergency_state() check at the beginning of the function, so its
> value is always zero at this point. Returning it is equivalent to
> returning 0, but it is misleading because it looks like an error code is
> being propagated.
>=20
> This branch handles the race with ext4_change_inode_journal_flag(),
> which flushes the dirty data and drops the page cache before switching
> the inode to the buffer_head path, so there is genuinely nothing to
> write back here. Return 0 explicitly to make the intent clear.
>=20
> Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O p=
ath of regular files")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026115131.1735=
014-1-yi.zhang@huaweicloud.com?part=3D1

