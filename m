Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7F33242BA
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316962; cv=none; b=iLnuGN+6RT+oC/vy/jRp/HJDDGJZbGvEC0bHT7gqpLEwBhKUN4WiFsnMHAtZV8FAa6YntVh+8TmEcNA+u9ulCS/HKax15IMcJWBaol8O3WyE4Kl40mW9j5QN32qnkjrDa/8XxuyConkjmpODk+ugWBxf4LGwJP1hSaS+FUkgcoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316962; c=relaxed/simple;
	bh=CMovuOv1OzcnF9hiARNp3J5VmafDnE8uYbc6rKJ//Lo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BHF1+Bon3Xj0RaFmesePnFi8NFVBY+H5lKiYuyA3EYccZp6dHpjCOkxkHeBZa6FV3Xoxep4OvvCkADrqWEyO0yP2aQnSVDx3Ha7JzeD7GIFTbvlDHg0hRzpkM3RSImhsyhPxhZZVJFNuZubKfJPmGpvWYGDHMRJpxjirRxaaeDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVwWk5Ug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVwWk5Ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61B91F00A3E;
	Wed,  2 Sep 2026 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316959;
	bh=CMovuOv1OzcnF9hiARNp3J5VmafDnE8uYbc6rKJ//Lo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hVwWk5UglEKnAFEbWwombT7iOFZuxZWqZ9q6Q00crDzB1voqYy24ndV6qsq5GOqDX
	 6JXiTIH3xk7gpiwHcYCa/DwMQxxD1lDRbDj2Ee1R1a+ASDRaQQAtAXJjW+qlqo9h81
	 RkHvESxJPJMCC2M41vLKx/b+PUUAQ60s+b02W7i/pLhq3Ai2fqUB8SDk4qY3pVOSQh
	 /HWYcVoLgF5oEC756Ly0sy73lZYlCskUCRDluR90l1weWAUdIFtYiWTxLnmZzv7jdg
	 HTDk7RzXkxPEIl/UsRrzFtQZKJTEL31wi5UnDwI1C8LYlq1ItrXmTAnYDedfUetFx3
	 wXJgn6iKrhsrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/12] net: sched: act_gact: use acquire/release for
 tcfg_ptype
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-11-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-11-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:39 +0000
Message-Id: <20260902024239.B61B91F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on gact->tcfg_ptype.
> tcf_gact_init() publishes tcfg_ptype via release after writing
> tcfg_pval/tcfg_paction; tcf_gact_act() acquires it before
> dispatching to gact_net_rand()/gact_determ(), ensuring the probability
> parameters are visible.
>=20
> No functional change intended.
>=20
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D10

