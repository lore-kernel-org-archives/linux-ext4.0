Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376589;
	b=fY/wgEPh638FwaXWq8jkFX5NNKSCcsyAL3F8aEs0Rbb+2PTe4BP8FoXgJdiJV3Qlbena
	 zgnIJYnkm4M7b9mq/R6xKk1dWd8qu3gQtBnyii6yDpEl9qO8dXf5E3SBAlN12XOUKMMm+
	 HagXW9GSKE/PMkigp2mApSrN5IYZiVlAQeKqHRTH7ELjHBBpPhDXO0v6PIKwuqHaM5/mz
	 QygDqCp96hmb9BoASkMbGIBHIqDLoVjCC/Ud6OfJ8QiklQVtSR6Np6nb7mID9Bt/bTvF7
	 jYVwH6+g2PvwNYmhyBiFl6mnkJC7WSzQdZGWEOThdaUz9BzwII1Fn+e5aMbhFGbuYQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376589;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=S8Q7RVSu5acLqxFHKZ/r7mZ7VBNu8zQeaQsCz9QNPyY=;
	b=czCfqQ203po5CfF75flFKGBrfv22esDkAfsQxLBDx9NXUfXmPKHgDd+SqAGaXu+0UbZO
	 6mBG1TBHN7R4qVWkwR5TKudPuzEBlp9+H2gDXflECPkF+AOF9hARTL27ywTVUZJ2CtQLv
	 HAUg7AG85XzcHG9C2d89I6YTJewDy/s31URzHX7jbxMZghO3Hi8k9GcTq19QuccQr6W3c
	 JaqwRYcuGv1/sRbU5pz9e4tzxhsdvg1LnkvgOlkSmuTUeSVW7tMvuRmT8tazchBUKPDTb
	 o6sLyroEUsZPlKXK7zEndGzckdSEOAniMuJbdj8bzp6jPhXYZCA7l1s6QoxXjlUkphw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCwPagsu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715B606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCwPagsu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3443C1F000C1;
	Fri, 30 Oct 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376588;
	bh=S8Q7RVSu5acLqxFHKZ/r7mZ7VBNu8zQeaQsCz9QNPyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kCwPagsuFD759YEuTgI3FhIVTYEquBhdx4an9oRlCT8yrMyR39T7fr8nyGqBHucZ+
	 C6hQTvwFpzKtWFP8pMJXiA7gR+YrUXNtblXB3PNbMk4xWMCiPBo9SWUseVea/GpOMm
	 33MtKugINcm+m7gSrh2vE0WFK6DEDlEzvW7QqOqGa83YRX4ii6EysjrMS8GkyNGUic
	 65KiPOzLEDJ4u2YR9wTrhajM1Quea1WcWNl6kzD32gxRVbqeYt5Z/N9LW9253HI+ZS
	 Eeb2TFsoEOBn4Ipmia4tLul5nzA5iKKLdRSSjXoiBQlViLaWp5CUrGTwbAdJHvi2em
	 62uJ75awBELEw==
Message-ID: <sashiko-outbox-191220@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/34] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-1-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-1-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ecryptfs_lookup_interpose() opens the lower file of a regular file to
> read the size from the header. If that fails it marks the inode bad and
> returns, but a new inode is still I_NEW and nobody ever unlocks or puts
> it. So it leaks together with its lower inode, a concurrent lookup
> through another hard link waits for it forever and umount complains
> about busy inodes. The lower open fails e.g. with ETXTBSY while the
> lower file is executed. A cached inode is marked bad for all its other
> users instead.
>=20
> Use iget_failed() for a new inode and iput() for a cached one.
>=20
> Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
> Cc: stable@vger.kernel.org
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: https://lore.kernel.org/r/CA+0ovCgYP920GT68hAJK6Trjyv1kGv2dZAuem4=
LEunycQ=3DPOww@mail.gmail.com
> Acked-by: Tyler Hicks <code@tyhicks.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D1

