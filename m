Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E6B330B0E
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505816; cv=none; b=dpAdZKkcZIn4HUomXyQtEiqyjAnfeTdP7wQKUKVzhDFgZATKQ4NWJ0rfyXl6Vg+KJjfd5A/H7V/frcwCX9oMRE735CJCSQBkXB+40nvfVpXUR2Uw4AHPv2ZvrB7ahKM4tXBKCJB+ev5uoAU32fZEOfUvvHjp4Kd0tSrAqH284xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505816; c=relaxed/simple;
	bh=Ts6qJf4JXQV08YaQ2QMGPNP/uPS48eajEBNIkx24AWg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RZj0bL375bmp0z7vW6a/6k+5ZK1PfGxCSC0Yerc5EEnRMNHoBF/Tzyujodzm5Vye7b7mi7O+GjlL5RvllNU2hZRsePaTpaPdoSfJwsr+SvT2r3XlvYE9bCt79w03frs7INZKfCCJTxXBHu0FPYaAthFo/gdUScnJbCLcwk6IzDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQai/QHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQai/QHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4AF1F00A3D;
	Fri,  4 Sep 2026 07:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505815;
	bh=Ts6qJf4JXQV08YaQ2QMGPNP/uPS48eajEBNIkx24AWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZQai/QHU9AKF5dWSyzViw7HaGUykMxu/t/jQwozvjCwkSWyW/wwE7tTAiWISvfPJ7
	 AiZB2ZWOqNsJxuE+xrHxmhRFRZGNFvJtEf8/rm4qJn8xCs/fxsTjceyk4hDmZR+xcA
	 g8r7/jx0PpwKa+WVMRvvujOQgjBz6kCB7tfK1xUGOqSdGioCuYopZlS8uGP/9ukx+L
	 3KlxGLZBAdKtdBCfQdXYYhtLX6uylv6RV3SS7Zj1FTG7spkunusFLzUcrv7CqVFFTS
	 uI4sjWG9LZkRLko+j4XOrCr3m3fmZoLOz+dUQG+HDxSW/C7NGOp71bSmjIxPnD5Za5
	 rCx1mPQmi+6rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: shut down error report timer on failed mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260904065648.4048108-1-runyu.xiao@seu.edu.cn>
References: <20260904065648.4048108-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 07:10:14 +0000
Message-Id: <20260904071014.CA4AF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __ext4_fill_super() arms s_err_report when the on-disk error count is
> nonzero. If a later mount step fails, the failed-mount cleanup path uses
> timer_delete_sync() before freeing sbi.
>=20
> print_daily_error_info() rearms the timer when s_err_report_sec is nonzer=
o,
> so timer_delete_sync() does not prevent the timer from being queued again.
> The rearmed callback can then access sbi after the failed mount has freed
> it.
>=20
> Use timer_shutdown_sync() for failed-mount cleanup. This matches the norm=
al
> unmount path and prevents the timer from being rearmed before sbi is free=
d.
>=20
> Fixes: 66e61a9e9504 ("ext4: Once a day, printk file system error informat=
ion to dmesg")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:GPT-5
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904065648.4048=
108-1-runyu.xiao@seu.edu.cn?part=3D1

