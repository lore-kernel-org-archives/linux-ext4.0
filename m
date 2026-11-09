Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248325;
	b=X1xm97sSiQFiNJDhuoQ43qvOR28z+/z1kXWtSp6DhtEWRFRu7IpGyy5VZCKYlIeuHWxM
	 BEHEIcf23zFJZ09Kn0BUNBnsm3O55UdUESbvS7WzBUN3ZnvMoNcLmiQnCBwZCnwkrVq0j
	 2+KAQ3W8d+z2+vCjYbe1JDpM1espc19S0p4GaaEmG5H4bzY6ZE8btxqHmz1k8PFDIQHBo
	 JOYCrVLVLn7GjE4kmUuRDTtoRhtia6zoe1v0gpCZENiSyY8d2H0EGvb33fPCzLMmmybP3
	 RhbCUxP8mK+7BrAIiC/zzr3US7UNnCGYJcB+wz23McC+Wf0iHjcZiSI64FMa846Vo5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248325;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=npkma17GLjBx62K9nkPk9vJnjKXcJY0cPk0CTppV0EI=;
	b=PI4U91Wc9scLkUaxrdvwqn2vPE1zjZEz9TjHLK4jwJdwPnqTPVj/O95k/+6020pG4sbt
	 J224nGUAi+OWEaOltTauz3fozSms4c+Rflf2sfex+mXINwQaleY2jlNWphCiY1b+zP1Ly
	 KMnBXyErv3o1QcEICRu+hrfthUe950MQPJYhqDMKwkd2F7/3cq5luTSxGFRQ8h56DD5qF
	 FZ+xMOXfJFrfMwUxsEZVjX8HiAiF5NwWuqBP5x/iEtv+4571vCbjrArt7WeyAUFiZqXPa
	 YjELGAonh2Y92qb9oGaUYc7tzSdZepPw1Vy32IFjV4Ghge49ni/hdHkmM5u0jjZ7wdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViKkau5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8160A2603
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 18:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViKkau5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A01A1F0089F;
	Mon,  9 Nov 2026 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794248324;
	bh=npkma17GLjBx62K9nkPk9vJnjKXcJY0cPk0CTppV0EI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ViKkau5E4oRXou5XQcrPeaYaZC+5fEtrBt1W493o9gmhP+jNss6k+6Zuz5sv7MDQc
	 ZjvF01zf3Nk/xBXuyPt3uG2lZq86R8aQiy+lcreCgDI1+o2664sRJecgvSnC1+Obzj
	 kycJ9ynpPZPeooznPuiaMhVZnBI3x/uS6sAu2qu84WDTc7zOUFpYB+S+YMwZ1qX6pz
	 bUcxYoYW1YfLSiRjODJRi74o4s73jM6Ln03h73n2fsah8wsaeNRjKW6xQIpiz/CL2Z
	 eoVH4MADmReAQxoz9TPqB4CI38YHA6CdN23LJtysqSXlAas3Nms1iDzfyfWomRHm6I
	 urGGLAHZ3L+nw==
Message-ID: <sashiko-outbox-205394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 09/14] fs: don't strand I_METADATA_WRITEBACK
 inodes outside the LRU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 18:18:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
> metadata writeback") ext2, ext4 without a journal, fat, udf and minix
> set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
> buffer that might not have reached the disk yet. Only data integrity
> writeback, i.e. fsync() and friends, clears it again. The flusher and
> sync(2) leave it alone.
>=20
> inode_lru_isolate() treats every state bit other than I_REFERENCED as a
> reason not to reclaim the inode right now. It takes the inode off the
> LRU and relies on iput(), writeback completion or the removal of the
> last page from the page cache to put it back once the reason is gone.
>=20
> But I_METADATA_WRITEBACK doesn't go away on its own. iput() puts the
> inode back on the LRU with the bit still set and the next scan takes it
> off again. So neither memory pressure nor drop_caches can free these
> [ ... ]
>=20
> Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata=
 writeback")
> Cc: stable@vger.kernel.org # v7.3; see patch description
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D9

