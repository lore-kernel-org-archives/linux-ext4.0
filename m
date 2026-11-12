Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520945;
	b=U1Yg0mZsnuDKB6mV3E+luCLymFwO74ltqlSUrO7bwux26LcuH7SZoKwRzkp/PU9h+DU3
	 mM+2maoOpTcqP2KrK8/H8RyzFpKx6eE82V2FZFSiSNZx/Jeoa25m+SeSfMDKnnorAbuLY
	 oeQVj4jfhnYvY5oQDosUspUie60IJ9SsgUdyNuHe/zXaLuKXwLjZnMqVOLi0blqJDs2R1
	 /V3GKElOWOeRwR57YwMrmP/QQ+uxgGERuy9HSMQm4ypakVjtbzz6IZfRelRJrzDuhhDn7
	 fSSLsIWrmSvJegKCIdFoveKKosdsgcrXO8dnVbTHK1cnn7nP8O6aPqTBwVIF6Pe76zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520945;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GKqX21QLv7a/4+EGalRm04dk9CAqnQgY+VLIYfbJcxo=;
	b=h9g62o8Z0K50EMfKt9pqb8AiDlputBIi+bbnt8L57uf9Ih7aK6G/6THCEYwnhxRrYyf7
	 +jLk9bLRLI2ApgHaET8bC0iSaZTu04HCOnqa+CE2P7tlt5DGAjKb1GALiPm3hOf5658qa
	 KMGaniUfbJLqAZ10l5YIIdb+hLpswBlSR8xOFICCVkzXrVeoiNwV/n6xxEpR7VFf7PoSM
	 KY53zKVbc0jjVq6R9EvGkZ/xmbyO73f25/5TZd7sbAiwTIhnbz1ePZmIUuZue+3/sSJDe
	 BrNq4hG+7YGeHvCKbihMQEzVaa8PtFMV3Bj0CM6qXkDXTuSbIvicTkCAQbQP06ngZYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HKJA/e28";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8C1606A33A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKJA/e28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98F1F000C7;
	Thu, 12 Nov 2026 22:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520945;
	bh=GKqX21QLv7a/4+EGalRm04dk9CAqnQgY+VLIYfbJcxo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HKJA/e28etC1A9bp2y9NBzkhDp+TwwZdGAmzuT4pfOywJ+JPNhn1DFVeV1+u5GAnp
	 ogtErfa8+6pXVGn9I6IJlD6Ac19IPvR2wPP/XzpPVQgnnqw/5xFVAPPvZNrUS3UVo4
	 iiKPR3mgaHj1IGSc/jlB9aOBLVOKysJd9edPJH6YqlqcPI/DntbnAeDRaU9NbgAFvN
	 xtAGUhi+gIJLpo5fJxjkj7DBWnC0qtd9dEGKZix6kju9YgW2Z7gGr84Y0k72S5Iehl
	 4UqFKr3qPJnJGMhBd5qWDTGIdSRZJxI3WERkMGM4v8uUYDxNJdQbYoS/py2BiU0Bdr
	 mXfkIzqa4X/6w==
Message-ID: <sashiko-outbox-211884@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/14] xfs: test for realtime and reflink under the
 pNFS locks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-15-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-15-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:02:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A pNFS client can write to blocks that its file shares with another
> file, or that are no part of its file, if a LAYOUTGET races with a clone
> or with FS_IOC_FSSETXATTR.
>=20
> xfs_fs_map_blocks() hands out no layout for a reflinked or a realtime
> inode, since the client writes in place and only knows the data device.
> But it tests for both before it takes the IOLOCK, and both flags are set
> under that lock:
>=20
>     LAYOUTGET                           clone
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D                           =3D=3D=3D=3D=3D
>                                         takes the IOLOCK
>                                         breaks the layouts
>     xfs_fs_map_blocks()
>       sees no reflink flag
> [ ... ]
> The fix used here is to test for both once the locks are held.
>=20
> Fixes: e54b5bf9d7ae ("xfs: recognize the reflink feature bit")
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D14

