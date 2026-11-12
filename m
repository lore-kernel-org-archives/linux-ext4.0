Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794448613;
	b=lGklxeK8l8JICJW0QHX/virY7+gPgMGrErJKNUFBqOgR8jjZq8aqS8gsx7dp50Nnx1QO
	 BiyBGKBhYZQA3O2ro9I8bZ0PoxhUOs1g628msKv9DpS2Z0Jf4KTl0yghrYVRt/ppPBfYL
	 Oi7c9JK3ZL32YBahoGmGPmfJl2sfBVO/B9QB0/UpGaEXxAei2s7xQb9xiXEdTnsYlom54
	 28uPvFG9/YkiyYk8OatIm7QhLnRGlqVafD6eE8i7EvC51uph4Q6l7oMflVymRBzFI66fv
	 9Rl68SyeOgUqLkVi8hiufjZKfEt+CjEnIZKh8KS5CFQeNyyxzCadVe6vkbVF4COPfyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794448613;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=GywMyCpIh5uXKZf5RUzqtR0sdP8s+ioHMmqv99ratlU=;
	b=Z6oqc1xdoNAjVfMccEHqs0pW8lg6QBzwDgk0GyeHMQLHmCswg2DPtKyMKmHB4VajjQRy
	 gcwQSeZEml8x0cN2OFGcuhdZr3l3Ou86m69Izb/UdpFr1vKBb9YhPevqe4Wyjb+sqy0lH
	 +TdXvA7kd2fC01pstc3ySyrnV+CeQYewsP8qvfakye2Lw4OfKnV9MkWLuKb6uKXwmM+Cm
	 UEZHPtr2aenniLvJPkIyjNT+eX7UIwkPCYKIsrsWktdecEZ5cp4L5deBmzx7Sg6AKqgcq
	 2XDDc0SUKa6dpsrJvDFpe0O0XVWXIxGAstfD3uvugYzLJ+XwjG4j5RPxDtyom15CnmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzI6fNH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848B4606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 01:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzI6fNH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1063E1F00A0A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 01:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794448613;
	bh=GywMyCpIh5uXKZf5RUzqtR0sdP8s+ioHMmqv99ratlU=;
	h=Subject:From:Date:To;
	b=OzI6fNH3smORKE4V1CmfMDGgQH28SuKARpicxd7fu13wuC45aUapnKelBnNJ2lVlx
	 A5e4UAvp8+CFi11DZ9RRB1nwUVOFbrQG5FA+6fPj50CpvN4N3RqY0B5tN+XPtJfwqF
	 ESx6ehX3VD6pDWWekDVeD8RNUTYP4aDaLFq1FIvBTWtN0KQlzaEB5tuBOGTavUZuh9
	 y5OMwvTyCqCbJ9PQ5S5gdXwmntP9MBPJOpG/+v5tGzDt/+osCjADgn//BtAPQ3gc94
	 OFhcHvJ19Hzt3k57wk7fQ1WAu2RiAYRbhaUZz99YtTSDtDDwGl/b4FYCwZ2MDexhQ8
	 kPbuj+/NO9Ukw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id DAE00391AFCF
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 01:56:52 +0000 (UTC)
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
 <179444861135.1765492.13721781912592850096.git-patchwork-housekeeping@kernel.org>
Date: Thu, 12 Nov 2026 01:56:51 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v8] reflink and atomic write bugs (2026-11-12T01:02:29)
  Superseding: [v7] reflink and atomic write bugs (2026-11-10T19:04:19):
    [v7,01/11] xfs: don't skip the flush before shifting extents
    [v7,02/11] xfs: flush the shifted range before changing the file
    [v7,03/11] xfs: don't change the block map under a dirty folio
    [v7,04/11] iomap: don't punch delalloc under a dirty EOF block
    [v7,05/11] fs: validate atomic writes after O_APPEND and limits
    [v7,06/11] xfs: recheck direct write alignment after write checks
    [v7,07/11] xfs: test for reflink after the dio write checks
    [v7,08/11] xfs: refuse writes to files racing with realtime inode flag changes
    [v7,09/11] xfs: test for always COW after the dio write checks
    [v7,10/11] xfs: refuse fallocate racing with realtime flag changes
    [v7,11/11] xfs: restart faults racing with realtime flag changes

Checked 35 series in 2.20 seconds.
This project currently has 365 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

