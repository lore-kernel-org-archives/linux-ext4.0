Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190323;
	b=gb3V2eL5IfNetMaOy3xk8jxY4W/4tvCU/GAXGZYMIkoQ1Euryj5A7Cr80Y191QZGj5zl
	 U33+oeQtAtjKR94y91WYJq6hqN1EcBb/bS1KVIRcxiY5OG1ROl9wGJ0la5uJRSTwIclJM
	 x1DBqGcoetScKXck+V/ejHIbB4WxdJ1kFrJF/DIe4FYCgG2/nYramMqLwnejRvV8YaaAX
	 oNio9oyU+cg4atR1yfRA/oDffxc5Vt2NH6q4b4Q9yuu5lgMgta3KoO5pEOn/p39NrAxGN
	 oIbq2QcPZLe6V7JopA6Ihfn+MFRbiDZaFCKCPMR0tCpiJqVIZyW2kVigMTYy1ClPSVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190323;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mLCSgATdE1mSdt0vHPxGGGo1Yjyf98XNCboWJg8i3lM=;
	b=HjtHlE/fO2kPNhqQQSxdCcrt/7A7X987qi01XcVz41mtQtb/TT3AnW1ERjV2KCXSolgs
	 7+njn8Qda64kA3wwkaz+KBpN/TtvEvZzB4eft56orBHgWosUGiUL9sn2dXrXmmYoQOa7G
	 +wrPFqSAdz0PSWgLEyQQ+EETckPuqVLj9cTBFvhlOiJaUeGztkQ0BZp5G2HcddeKjPw2d
	 eHWGiDeuuYTDQNi9cN4IxeEOz8WLIN9IUTL+3ewLRgaOU3iO6jNGJWQlJic43CiVNYn9N
	 EerVHujlFzSdju8pvxMDCcJnnNuBNl6/DaPScAoL89+LOP/Yd4UNdYVCiL2MgU1T2ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwi1BKrW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB18260A263F
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwi1BKrW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961CA1F000EB;
	Fri, 20 Nov 2026 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190322;
	bh=mLCSgATdE1mSdt0vHPxGGGo1Yjyf98XNCboWJg8i3lM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jwi1BKrW4cxSegCZSAlQxqBdVr1WvW14dmmmdjnEfGz0AL/tcNnIqDa2UavWu11ZH
	 BDgeSGlRT5OlknqJfF2gZaDftymxdnompQzO55tBnWhJu0C9bMS5Pii7JBRnVKMGlf
	 1m/rAWdaEUWbnhVajOH1wlY00P1JFAk/1+bVYQONWoSu8IVrMnzAdMc/ib3hbr5Q7K
	 qeqFtNRemJqaaQxOhu5tPfRcsN/oiGHpL/O85c6QL1OLRDPqzsecyhFKGkPfwbxCFV
	 ny6ZHQOJ3OmgAKZlSRs6XMs+UhwbpeQU2LSbEqMVjzibJ2S07aubnLvWgci39f+JYX
	 QmGDmEcqHjZtg==
Message-ID: <sashiko-outbox-225493@kernel.org>
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
Date: Fri, 20 Nov 2026 15:58:42 +0000
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
46-1-aalbersh@kernel.org?part=3D1

