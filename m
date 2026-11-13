Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794556590;
	b=31/QrPgCIfaAFgXrasMR+DUSLiwGt9gl1JfyWHAJolpxE4F82IXnMoFf2dRXrSbW0ED0
	 MSlM2TCah7gWtR5u5bHujL7CAUWoxeTXu3XA+dsjcBD5PS3mvPuNBmPAD62XXTzV7Lm0w
	 +Jozcbn1Q+wuGoPgtklcgQoeslVB0IC5oc1AUfhtwZc78/PZQaXU9pGfapJvtqSFy9MGI
	 bAap//qWRb3CLrOeXHrEz3IJDYHvxAehvQFsoC0vmSaBSnITsQVb2snX5QCCfVpuARTep
	 4NgbIFVNrN7Muz1zBiuxHoXDXI7V/CVg0mBsXUzi3WxUJyZix3Zb9ERHEJW52e2Tsbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794556590;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=GWlWlz6j0iPDg4hD/59fcLr0XLZMcbz+X3k7/4Pkx2c=;
	b=UOHNjw0D4We1t1mtJIbVHUb0oXcqawm4FUW2skEh0NsTAiGMI6wRPAsiNAGI02hTkFvp
	 xcmYD8zD4cVsVrgpobEyPpAq23C4Zaw6NS5GHMwznZms1wew25Xasen8h4o+QiDrifAEw
	 sBS2bN7Bx3plOILgJb+SuZQuUSeY8jiRYmgCxyYC4lEiBuzxRRWP5GAItQz6XoRD/Wa+S
	 Pg+J+QVCUG7XryTSHCVj5z+tqV5Na4pnt86jgBP7MSr8+M66yBKjZziqA3d5oNHC/OpfI
	 uKTVJmlt6wDGNnej3okTzqBwEt3i26IkaovfhzuhYDmEMO+lfzQEylZb41ahrSudyaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBhxpn1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD268606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBhxpn1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1651F000C4
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794556590;
	bh=GWlWlz6j0iPDg4hD/59fcLr0XLZMcbz+X3k7/4Pkx2c=;
	h=Subject:From:Date:To;
	b=JBhxpn1z2VeRkxri3ReQilEWKc+7hqGW00Wn3Oidl855eSFu71/fMvtfsbgC1JMCU
	 L7bG6fLn4LWpIpuUf1cvlKLu50bXCQlJOXeahl7VxqUqEALo5xZYfCXAYB16lJQ/iy
	 sJlvIZ5TSMpwIPvU/XOG4v5Hk5YexprJRAcK3zYXnUSOe76p/1EToNr73iGGm+H3hr
	 Qy41oiMigAaG2OAH9+2Qu8jTjnOE93n90Kaq0mlyZqOcjeIFXEZIm19BIP8M5mS4lb
	 SJeyYCd5dFAgQQfmbtRbVy0ZJt7vVbR0PLZrxPNm2gQK5naaXy5iXsRivyrJBW/c3r
	 R7Bn271gimFKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 927F03926646
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:56:30 +0000 (UTC)
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
 <179455658929.867541.9965813806738284496.git-patchwork-housekeeping@kernel.org>
Date: Fri, 13 Nov 2026 07:56:29 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v2] ext4: Add dma-buf read/write support (2026-11-13T07:06:13)
  Superseding: [v1] ext4: Add dma-buf read/write support (2026-11-05T06:58:41):
    [RFC,1/6] block: refuse a dma-buf bio that carries a crypto context
    [RFC,2/6] mm/filemap: refuse dmabuf iterators in the generic read/write copy paths
    [RFC,3/6] dax: refuse dmabuf iterators in dax_iomap_rw()
    [RFC,4/6] iomap: refuse dmabuf iterators in iomap_file_buffered_write()
    [RFC,5/6] iomap: refuse dmabuf iterators on contents-encrypted inodes
    [RFC,6/6] ext4: support dma-buf registered buffers for direct I/O

Checked 40 series in 1.43 seconds.
This project currently has 442 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

