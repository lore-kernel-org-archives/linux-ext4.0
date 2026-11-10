Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337016;
	b=bGAK0qEx9RrjLbKbIR0eOeoAcEFYRQEw5Cqs+R+WieMCNkmK6Mt6kakoSFK7o5gFxwtI
	 AfB4Qhyr7gQsi2hSVlJdLjz9ylAqW1nAdr77PHtd6H8TaTr3rLiyaqtPdkbg3+OOji442
	 831KixEd37iGDVIYjkEnINCfQDYsRHhcljAX28p9yblclSU9QRiqg9YlM6UKoBK430h/e
	 g+cyIsMzERL+EDMF8YvykbkC8ZNrrzxHck43/Nl0eZaRQnKQvAbz1Z31tHQndd1K8ECZo
	 8OJTrksgRl+V/ldjTWtUDm1GUMfAkcd2khO0ALR2fEOcG0lSQv47gSA6wVGArVT0xgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337016;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=g/Qpl9vnqDXRViiPkWy6CwZ5+WnRp7N3FJhlcT6/Tp0=;
	b=V1tB/YkEnkfwkHWCJOFttqAQ8io+TxpxdveySOh/Jz8oie8ByhU3JoRMEaZHxSCCA3ir
	 AZik4q3IidpWagXxupgYBXV2H/LrPL+IMCZdeZmb+ebSdd9+CSqy3VVLyP8wiyxDZm1E0
	 LBwFWqlhdKQbPGFokdqZSmmBqJxdrYZckSDv6b3XOyncGxBBb1xLHAkgjMeVkLNkRvk3o
	 ZO7ypH6UtpntaVXzRDENBS154GXb45hQmvuvMAjIn58lLeOWOWNjyWXd2M00vDU3SKkgd
	 NdbkC3TB8MW6PBYeUZ9UXWCg5C/o5X/yEpc+/XkInoc5QDmRjh3PewczG8WPtWDyvKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3M+2KyJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B446606A323
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3M+2KyJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31D01F008A1
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337015;
	bh=g/Qpl9vnqDXRViiPkWy6CwZ5+WnRp7N3FJhlcT6/Tp0=;
	h=Subject:From:Date:To;
	b=h3M+2KyJz+WXbdA6vEH0HMCkg/uXQjVWhi9WTfHqsjNNlFdhS87Z8M47Ankwboj06
	 ynVGwZ0BoauAGtXOp9XaZzX/AGBtvJQOOWFEcIQwUGmrrY+HMjUU8Z8Uw+AYHhdQah
	 5MPQZf5vG8Hc+9PWs+cvdaV6OTxSxt5FDZiU0ORiMyyKYzZYLBNOFJPzusYoEvrdlC
	 OyYsL4a79eONeNy6cAMATOMd9m/1wIhXqnRBnLXtVDSXfRfKkebP5Sng7mTKLYykwP
	 XuTHZohPxoOEzreeRl23tyNGIsEyUWtWv/dDLRdqRq6WOq87zXMM0gdNc1OS9uZ20f
	 tQdOXIJSbyx3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B2DC39D6099
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:56:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Patchwork housekeeping for: ext4
From: patchwork-bot+linux-ext4@kernel.org
Message-Id: 
 <179433701419.1507.18377756670050828135.git-patchwork-housekeeping@kernel.org>
Date: Tue, 10 Nov 2026 18:56:54 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v3] ext4: test reserved GID block allocation (2026-11-10T18:20:40)
  Superseding: [v2] ext4: test reserved GID block allocation (2026-11-07T19:30:50):
    [v2] ext4: test reserved GID block allocation

Checked 27 series in 0.94 seconds.
This project currently has 328 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

