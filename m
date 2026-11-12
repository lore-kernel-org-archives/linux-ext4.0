Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520585;
	b=GZNT864//qdtHot5Zn4UhGblPvIqAqEbs3S0uJXaoVA0BO8Qn/wRZ1/6kUZsndhSmjHL
	 0a5otpbh2Jg5qHAW0GcvrRexH2iG5BwJmFtj0m8RxQ4K0buPJ8Yhk6jhgkwQQiswokgXf
	 PXJDXm1fyKHlFTucE5S8CXq6AHwqu6b+XLmq2hwuDFyPM8qFlJmHJ/HaCiS8s87zhoqSH
	 6mmItQuswt92H/qO3IqAa/aJvDgZ+ZXULOnqPj4diXqmiVwJvnTDpaZZiDReSfvmW6TgL
	 S143+yaPPP2cbYdFLE2+/1Myzt7WiBrUkHyINT8bkAReTmw/ZnD5ejQk5BXSMhwOIAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520585;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=auPGYgQC9XHyx+ZsYcCGJqtkye6wBIi1wHZOKS0mVLk=;
	b=RvoXBsSiQxcSjP+8ogy2FRuPKqoY2Xm+S+OM27zd1jRjoim4RmWbKtLXBVj07vZU9Cyl
	 nA/tuSZF29w5w2KGgMIwV+z7zyAddOf73GRbWcSWM/Cy1O/sNpw3A6/DV/34V2WgspGAU
	 r5CEICx97tAj8/FGe8ZpOREeGuBBThGXc4dm2fYAGf8oitOY/0vBSWsewHtVlJyzI+CQk
	 sWlQ+FuA4F/hMTXz7q06IJ3IG2+NUF1K4HZ7n0Kj87bX4rbBMPLEBi2cY3geyrP6U99qW
	 FXBNqINytzXtGWxsENx6YjOHAuyii0KWRq02RLdSTwY4+wSibBUDSpbdeVkdp6xbP0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsk5ZyJ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD8606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsk5ZyJ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814CB1F000C4
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520585;
	bh=auPGYgQC9XHyx+ZsYcCGJqtkye6wBIi1wHZOKS0mVLk=;
	h=Subject:From:Date:To;
	b=gsk5ZyJ++oBi03skzsUC6uFkFceDc4GvkevW1EFVlCZUjp2J6R5tOO97KAByQGo6N
	 c5VX7zPdU4mIRPWQg5hFEHhXWihQ2TO5GfYP17D/PCPO59+UnbdBtNwwOVqfUdPgNY
	 ZfhvCX3FUAWYYenkmNhzKKO+91RnA1GZpGZoeUsMpmExBpnnxacjviZDSo2tOWXZNX
	 jAMRZO2LzETyImRSJmrjLi9PT+WgYSG1fhKNnTH8/z3dmtM5zZMcbE87PuD9vAtrUy
	 Gwq+1Z5OUOGsjBc73QoewVVpUTcz2O6pPzEjRYzy1n1gV+/5TV17iF3hOHAp2Cpsay
	 BUrQbEPasUoug==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775E8392626A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:56:25 +0000 (UTC)
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
 <179452058419.668222.4324479456692872781.git-patchwork-housekeeping@kernel.org>
Date: Thu, 12 Nov 2026 21:56:24 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v9] reflink and atomic write bugs (2026-11-12T21:46:05)
  Superseding: [v8] reflink and atomic write bugs (2026-11-12T01:02:29):
    [v8,01/15] xfs: don't skip the flush before shifting extents
    [v8,02/15] xfs: flush the shifted range before changing the file
    [v8,03/15] xfs: don't change the block map under a dirty folio
    [v8,04/15] iomap: don't punch delalloc under a dirty EOF block
    [v8,05/15] fs: validate atomic writes after O_APPEND and limits
    [v8,06/15] xfs: recheck direct write alignment after write checks
    [v8,07/15] xfs: test for reflink after the dio write checks
    [v8,08/15] xfs: refuse writes to files racing with realtime inode flag changes
    [v8,09/15] xfs: test for always COW after the dio write checks
    [v8,10/15] xfs: refuse fallocate racing with realtime flag changes
    [v8,11/15] xfs: restart faults racing with realtime flag changes
    [v8,12/15] xfs: test for an extsize hint again under the ILOCK
    [v8,13/15] xfs: resample the extsize hint after taking the ILOCK
    [v8,14/15] xfs: resample the COW extsize hint after cycling ILOCK
    [v8,15/15] xfs: don't enable DAX on zoned inodes

Checked 39 series in 2.43 seconds.
This project currently has 431 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

