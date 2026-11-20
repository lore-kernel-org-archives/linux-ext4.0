Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190281;
	b=muuWhEI+JCd5LZNzVSTaOzzVa7YaLAmSliMFIseX2UmvW8CML5vhMjoLYABE0Ql4QHeK
	 bk1casCr0eaE3FHbKBOT33lSwExi/uzwBewoksFRNcWQ07EObNHsT+XPqKqs+VtuCWROs
	 Z3XHrH9Ud2QRVlQWzO61JGNLxy1DJXpO76qEmrkc0PsUWgY03Lqd2V+lBV4NGjddCMT7o
	 B7Da7QtWKKqXeQNE1IGkJY9Lb9vrdZw/5iliq10tfGA0phALCqUH37mRODlmJXQ4mrjvv
	 kosGlIXCbIFZnW101vIgcb6vQFNx+wt6pkppeI0C269hv77CFyVxeBo8iNLTrvSpZiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190281;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xv57yrV88uOpp6THAUlNPycOSKwD/5nyeUY9RmonD88=;
	b=rNAiciQJ4IFoOhGT0BBmrgwzpzVpVL2Tbo5+vsvz8LiXR3BWX0bdbBcaMOAU4vg3l492
	 BXmdsfmAIRK4EPbhkmnB4VDI28cGfW7fOyKQHO9rTPfAUSTpgbQ4GAKaPe0uQISbwjKHY
	 9gZped5NU8h/np6TN/s/nvVPUt0o1kktY2EBkqRYD5QlXKMoQuevnY/IkGhRuRE+lIPLv
	 JKnooJSafY+/j+gu+1FiAFtkA9FM4IogQlKJrNQ6IQzkzinCcciW5PrtqKOnbXu/dhegE
	 3EmAkbLHLKO1eWP/XmmPuFbjqGP1Xsxal7LOlpUJ2v6byuHiU/N5aaol7VDFiwGcpmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfMDhH8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9B606A32A
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfMDhH8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D383B1F000E1;
	Fri, 20 Nov 2026 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190281;
	bh=xv57yrV88uOpp6THAUlNPycOSKwD/5nyeUY9RmonD88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bfMDhH8r05WwjmxgLDPZo/2Tsw8QZxkvgQmggUmkOD8DAFzgy3PkFc3iUMKLA04cr
	 ZSu9K69LQcNlrsJcSAegk4esjzDdIC7hOIJL6EcWQ+noz4N4eCw2n9zfN/pOuu3LIR
	 8+PvF0RizrN75HdP5rSEOnJmAQ+nFtP1R6LhVlRFsW++7nFaAy+LI6nFd0gDLSzqGb
	 j8ZPrYWOT4BJstZeVZbP3DBKlEzTJas10WIZcSfN9fBAOqizQWfBDvR9dRJ6mKvWXh
	 LL5xYqiwEVgMk6CVQ6qGO3VMArigfPzlpUgh8nyh7FYlMG0B89ktOrzn3zmzKNm9Bf
	 63ZgtLlMuyLOA==
Message-ID: <sashiko-outbox-225487@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/7] fs: constify inode argument of
 inode_state_read_once()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-2-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:58:00 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Constify inode parameter so that callers can pass const inode. Callers
> do not need a change.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D1

