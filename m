Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205510;
	b=CAe1AKjzeZMZSeZrgLaJRhpSm48KqVNobC7rFOzYxDv90hTt4ysdLgpRE+VP0AYB2u4y
	 mnYEEXzH6QvbKAW35xPauc6nJSdya8a09g8IVoW6BFVQF89pLAyOrpMwpaNZGtbugfnwi
	 G6i0HIFtuvY9eTr/s/Mg0GtYDs9Mif2NRe0FsfdlfI9XY5ijxUzx9yKd3er+XqlniKMFP
	 iWUibHchn47X4yP6YBQeRSifGUqHxYQl8OuISlz5vya2TeTPsFVDZdJ7xmGvugt8dOByQ
	 RPvOwDCSHeG6wxvXERDf/sb18fu4fpBP4l4M09DTJbYikngQF6MQCrl0uqxUJwD+22Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205510;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f3qW5ontsu2zJ7+zOBGK4XZyivitp6lAJ6IBQwassL0=;
	b=vSsUGSw87tpeeGgEpGfGv3HnKVQbcRv/Jjz2mzDH186jtU+soG4smE0iA5hNj2XdVD/2
	 WjU74OQfLldWOaLBMqdHedyXcPSrawICpVFnZTnJaeXWzo8g08N/9pMhufLvYC8kiVMps
	 Dc7Mm0roDFQ5uHSFsp+k/P287wHZ8XcoOemaIyMZtkLrbR6SX7aRz+x/7CqvCWVbR12/+
	 A+jgiKS2mECRJWYEu8Tlwa2kLCkwKnPmP1oGeuOEg9xLGQ2TmJ0WQNnARI5ikX+vjACgG
	 cvkI4VytHslgA8/6Yhwu6iFh0DtEno06rbDUowTZfzO0+oRRdsTFlmCa99//1guHGLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=du3+80nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C359060A260B
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 20:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=du3+80nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33031F000CF;
	Fri, 20 Nov 2026 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795205510;
	bh=f3qW5ontsu2zJ7+zOBGK4XZyivitp6lAJ6IBQwassL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=du3+80nrhNQUjYAQozfGco/CetwMLKFq0J492UMyPeMOY8kdhpYvsV0WG1UPDcLVl
	 Ew/gkHmQGUuE3Gm9yCRICD5SRNotFXcIof2FPSICyR4llXg0lo8ow+wlM47xsnlBQm
	 Ja/NnaTEY2t1lTQJefve6KKvDQI+NtDzRFgLjgNlCFpw5cUnH4KFDCGmgEpaIqOOui
	 UU44VSTjKJUcl3rT6OR1Mcdl6lcmZPNC39P9aGf+pt8ynKINmBziq/ArCzNnZKcNfv
	 YHrFRbDBGqcQThKX51ewhghQWuQqtfEERDrao2TY0c0Z288pzRneJJhGAigDS2664n
	 6l8LCcb5sDI6A==
Message-ID: <sashiko-outbox-226012@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 20:11:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 5-patch series:

- Patches 1, 3, and 4: no issues found.
- Patch 2 ("mm/huge_memory: fix filemap_release_folio() interact..."): 1
  potential issue (1 Low)
- Patch 5 ("mm/filemap: refuse releasing maybe_dma_pinned folios"): 3
  potential issues (1 High, 2 Medium)

Detailed reviews have been sent as separate replies to patches 2 and 5.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-gup-dirty-=
what-v1-0-236d69f25c24@suse.de
