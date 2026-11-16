Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840989;
	b=Qubr6ScIAD77BkaBkN+7halVYXGB6HGYii9djuQ6loOOTVpAnbbuyfvN+zKjXkucaLt2
	 Zws8KCseiWJp7DFSE27ygz1pUCfM61exqTSmahuHl8fKdFmGgPiuFdu+VnRXeUOHhpwFH
	 L8u1WJG882NvYof04wO2b8Sl6bMowR4JoqJicYG7+zwKnymjY5pWBl706fL/Cfg3Krz/Y
	 TCEOR74rI3o49g+z3B5UUMc6ew2eXHtEZuoLUYBucan5fIv1/mR32T0MIY8NbjcUUPvY4
	 slSnBpvcc7NJy4L+zKZktCuE17cp3ZQu+8QZOphfUTAQSuhsK7jzPUFLChPCqdno7fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840989;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=T3Nr3gQUTYNs0vrXZt181Nga5cT2dcwfv5mUJGH+KM8=;
	b=OioPd3V7kvgxuSmLSQF+yEShkVltf5IRwVSV+a0AxOcRDYLMBEDHnj2m2Vgpy7XhsudO
	 QXh15m0Zsctg32PIYC2StVtJMprZ+iAQXqkVfndFQ0qPm7g0otuXUMXJ9LFKMazVuiekQ
	 vVo+S3NbACP/fz5yxlMPlFvlyHGmG/oxaz5GcQ1csaFlWwZeUAmgA+kmqEynfzFsUifCM
	 aV6f+qYWx/ea/F5zXOi286H6f+2FVH4p0XpIl3mEpD7UIRl66jtnKCv9fmeVNEb5kwfq+
	 5uKvoMXZt2AFJAvAwfw7V4na1WjlbbdwB5k/+i5w0Pv6ciuJUgOJ4p8RtMcgeAN7fUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZynM6reF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806FE606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZynM6reF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077ED1F000C4
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840989;
	bh=T3Nr3gQUTYNs0vrXZt181Nga5cT2dcwfv5mUJGH+KM8=;
	h=Subject:From:Date:To;
	b=ZynM6reF2gcjadBNCpTJBbm8HfU5MCT/Y2UgQLULJ+Y7P6SbiC0XEcwJA0b4Z/0Xs
	 Wznx/giSv+W+6B8RK9uMfb8wm09mZUvmxMQbplm6f2gfZvVjyVkWaRN5B+BpbZH9St
	 UMlGIL/Xsy78yXZDTbKB1dQeeC1OknGp7dnmk09jR0zVp0oYkhQo5P9qwB90+CFihj
	 4FEKTdW7mOu68z/va3cZZhXuagASz1SJhNHFs5Nv09D6qsqzOljlin3I0pNHcIwYmM
	 SqmKKY8hXKUZUru5VubTkkVETTSmHSGb22hqhKRKXlCsOP4tZPTdPXG/gb3aC7bMCL
	 L2ZGUgLlVbH+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F13F3380046E
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 14:56:28 +0000 (UTC)
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
 <179484098761.3693569.18295534382085483518.git-patchwork-housekeeping@kernel.org>
Date: Mon, 16 Nov 2026 14:56:27 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v2] e2fsck: set the encrypt feature if the filesystem has encrypted inodes (2026-11-16T14:28:11)
  Superseding: [v1] e2fsck: set the encrypt feature if the filesystem has encrypted inodes (2026-11-13T16:21:41):
    e2fsck: set the encrypt feature if the filesystem has encrypted inodes

Checked 51 series in 0.86 seconds.
This project currently has 501 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

