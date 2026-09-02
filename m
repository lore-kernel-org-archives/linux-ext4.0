Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083DD33DED1
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316967; cv=none; b=dAChrnBJ2WPH8SLc6vEbe6uVAFk6e6rNEteEqQhlXuljU3NDgpQe705zi7rR8LKrStuI87dd6l8/R0a0/BwO+EP3Kw2NSD1PBqaELJmXiacvAyJO1s15jpJPUDazPX0C+P/n05Y0akLNVvLRrwLJ/eg06E5KphsFppy9WkBdWEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316967; c=relaxed/simple;
	bh=1/Z0vf23FIUi/eCj1N3sH9GNrsMM5BBQSgFMomjYZ8A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DD3VnbUXlwUVvwcoksNOXjGnRksNlgxC8gFLU4cl/r1Q5cP++iiZ/QkIVTB43Nd4gMyCj9IQtlEMvAnZ7MDyx3Uu9ftyZ0XLUiBsWy39sxuyE83I4Lh19g9BwHkmDh64rjER4aw2S0+I3BWZ4p5nYeCvXIZw/2fDPKuN+fDGIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HI+zLo8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HI+zLo8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB39B1F00ACA;
	Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316962;
	bh=1/Z0vf23FIUi/eCj1N3sH9GNrsMM5BBQSgFMomjYZ8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HI+zLo8UnIDFHgaVaYFo00CxrlD8E/lapUxrn8iqr/vGsPegZ1jJ5nsRy6M2Dh0wo
	 QKdmIkjGl1UR40lp/wHAOE0Jo61TzCWXD/ntkHDFYnW4BM+tw9aU+JTJeTv3vDV1ax
	 4vgV7/K+qqn4xy92mrKHjQOzalJwKUEMmW4TJDMWhA0Iaj9qwxIWReNwSmWB1PiYS7
	 yzLbMEIRRlQqf7EZ7cuJ0Kq4V8QSl9wldFRc6F8/QkJ3i6X/NgS37GYZURF+iCLUzS
	 grMOATRPnu+rnHt/QYOBAb8EBqHdgDkKayDk2o+uORpp9A4IRdA02IYCodHHxI73yZ
	 d8CNLC+WmD75Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/12] soreuseport: publish num_socks with
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260901024234.135119-10-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-10-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:41 +0000
Message-Id: <20260902024241.DB39B1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on reuse->num_socks.
> Writers publish socks[] updates via release before incrementing
> or decrementing the count; readers acquire the count before
> accessing socks[], ensuring they observe a consistent view.
>=20
> The detach path gains proper ordering between the socks[] write and
> the decrement, which was previously unordered.
>=20
> No functional change intended.
>=20
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Simon Horman <horms@kernel.org>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D9

