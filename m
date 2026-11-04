Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822519;
	b=Ir4CcxsZm3Im0KVU5zF3c3N1w+47uc8Eg6AA8eNfewOuOXnJ+V+VqRlBpDDkoGeW+N/U
	 v8bfot3zyl7WLn7lo/GydyFECQoWXQgaJyuEDIBu8dU5ROcBtaXNBeNSPv51XPh3yadkG
	 imrHNUuda+iQOWu8uixU7h+CxTaOSr0V4Mrr6/DRj5ZqcRNMreE+gOwMRX3zo4q18cfQX
	 xoAMsrZquKM2u8cCSyJcJM+vnUjEe4d+BXjqGHde2yfJG9Hl/CwOCeWmL+CHqwhLUfPI9
	 RAPYrw5esGWC5Yw7r59iH8R9coY3pm4Q3Ia4CwwpDMsSLzngoWE6kYjZtu/FZQn2jrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822519;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d0pXAU8BwWdgY48Orx/+5fZEeMOkq5+VjUHv0hu/kgU=;
	b=WhZZN8vUoWvaf9fdDW5GAPuN7Rkecn2b94eBQPFEw6iM5BbSCgLy/WLtIHkb8BmaKi/C
	 KuNt2ikKMs6JiUIoB1YXZxI7D/JtQXTN2+ECrEyUSVzj7p2pCBlDBNnX8WVWBYhI+k2iQ
	 rHHY4oA/RL5oDaVwE7p4gd9ejblWNv/HJeovo6H6JbEevE/XJRpHm2OuHjvKDtD4Uw/kX
	 6e5kqLsNxAYhooHz9timdRzEIovqqZy9obEO8NLr60cB3MnIrugM3/UboIdd2MP2x3vOi
	 YsrFETcs6PwVjxKatmlSyM02KUYvtwx+jcssugj9IHAMQeBuPi/t9ZOeP9laghHqaEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSu+0E4A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DBD606E80E
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSu+0E4A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11AF1F000C1;
	Wed,  4 Nov 2026 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822519;
	bh=d0pXAU8BwWdgY48Orx/+5fZEeMOkq5+VjUHv0hu/kgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VSu+0E4AylY+X/HS8eIm5dgdL+RXjYGTOfMhctQT3iE2eH+F951JHlVqQZiN4cM4V
	 fwSxRhSnv6LQkFyFixrltJb0l+VrTtuFS0ca7+PqhgHgsWIlcTYpmrlnKRfwdKBmUq
	 IAmDBLkjHkLF36l6zBN/pFcn1PThyCCyoeodCPK5DgAXXjgJalCgZGlGe5bt4d8pyF
	 JSbGwmWSqhE9FXssZ2lE/mSBbVMtQd6+raLktSiV0xxJpx6ggDYfeuxJUJa/5PTBaZ
	 VsilIOiNpWEUtrPXFf3Lj8QDBiXt+CgTIhoD/0db89AbxnYx8oKUSmTFC5zSeFJGBR
	 KubnSaxNsjMNw==
Message-ID: <sashiko-outbox-197986@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] ext4: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261104194618.103332-5-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 20:01:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the per-filesystem runtime flags that
> duplicated this state.
>=20
> Replace ext4 own helper ext4_verity_in_progress() with
> fsverity_is_building(), and remove the EXT4_STATE_VERITY_IN_PROGRESS
> flags. The IS_ENABLED() guard is fine to remove now as
> fsverity_is_building() has stub for disabled fsverity.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104194618.1033=
32-1-aalbersh@kernel.org?part=3D4

