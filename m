Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376615;
	b=LrlRHtrBb/aHJZ4SQbSu2Sa33TmUkuB/yhXXog1m7Z/D+KqVgpRPEnUkHRBDD2ZDmsE9
	 bZikGONWQOJQexuYqDV3b2VNaOe5v3a/4sBrWErWztY8ecFYI4Ck1foUonDvd407yAcnM
	 b5Mv4sJAB1zj3pQNeMsYzbIU7DCvbzhu00hO3VRdYwY5aM/wf3HlUhJJPDzcuMbRgUlfl
	 6e2pKGwInNLUFyiJkbZb271tpoLEMksRldqnuaQHnWxTZpfR5GMqJgzyvAXLx/F+m5bEW
	 4SOe0qMzBKkjcuF7cLioAgOgP4g18d8oB+vPWJcPeEocPAuTtwba6qT4t2WctvyNJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=M5b1PDc3er7qrU9I0sx0BJmolozyxnjv33GIVYhcYRE=;
	b=2O0ah7xGmReD+pTFa6xzlGBDQJoMhBob83r/xzuLU3yYqJpLff+WV7cx6ySryqTJF0Qq
	 MCsPFPRoRvJ5vVdxImegcYAD5buGfrar1xVxG/vwr+HNDLc0VVgM+SXV7LvWVZ9gWKEsK
	 nX0wXyMHMRIqkyCl2KzYc7qmfQy+yPux4S1wxblWVhfKWzwqfmYGxVxtRNLneCEVAY+4+
	 Vqlo9HLhoHB1uzjqwDJuESvyNUwHgGtRArr7XeeCAKQ4yi+GKmlXOT9KwFbh3LVpiQWeh
	 SP6Sp6tSBkwfKW2rwJXFdhqYXyP7GxNPsMzxg9tOQUMfsr9gugDD+u/grUsMYTncEGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjy9s+1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A2B60A2609
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjy9s+1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D4D1F00A15;
	Fri, 30 Oct 2026 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376614;
	bh=M5b1PDc3er7qrU9I0sx0BJmolozyxnjv33GIVYhcYRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kjy9s+1nDS+hAZGMZ9dwrTnBHeNhOaqEzD8+bHX7WqQesi1mNo/abpzB2C7AQPUk2
	 gO/d67loTR3PpPVepZ+0L9oRzKY8VcQpjMIXI9ehxwccf4dyvm1dR4pJsMh5pdGGjI
	 XRDp4MrnkmIGjNo4De8305C7MnTco6aP9AQC724k8hh5MNhAx+HkVlb0jeYBy05A3E
	 IZWSKnBspQU3hnWpLQ9aFdRpYh8OYGdEUBL4ZNRHjx/pyopg1Dt9Iqd46GTrgC3rwN
	 1SLoK3OAO4Xx1A6YieEOfqG6Efc1OrVm6W0R0uR4WOibJPBeMufyng7UZ3KoKgq0An
	 dMgC8RNFac2lA==
Message-ID: <sashiko-outbox-191249@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 30/34] ext4: allow remounting read-only in the
 emergency state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-30-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-30-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:13 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __ext4_remount() refuses any change of the read-only state with EROFS
> while ext4_emergency_state() is set, i.e. after a shutdown or an error.
> Neither sets SB_RDONLY anymore, so a remount to read-only fails and the
> filesystem stays read-write. Emergency remount (sysrq u) asks with
> SB_FORCE and reconfigure_super() WARNs, a panic with panic_on_warn:
>=20
>   forced remount of a ext4 fs returned -30
>=20
> Becoming read-only doesn't need to write anything. So allow it and skip
> everything in that branch that would touch the disk: sync_filesystem(),
> dquot_suspend(), the s_state update, ext4_mark_recovery_complete() and
> the superblock commit without a journal. Going read-write is still
> refused.
>=20
> Note that ext4_emergency_state() only exists since v6.15. Older stable
> trees need ext4_forced_shutdown() instead.
>=20
> Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
> Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D30

