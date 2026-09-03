Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE6A4AEBF2
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441594; cv=none; b=JhPWWEAqygMT2tYZAQs2nxSrzzbv/ujnpdk7K9467NsMEDXiKtsZpDx74Cy2pTLKJZx6WVAVl10YkSI3v0N3LKmVSzF1YRpwFs2pjV70vdNlwkCwzFOmdVQgJHtxrfnZ/WUJP4SRpi5kPBm3J0U604++w8Z4CT4OWPII2nxagJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441594; c=relaxed/simple;
	bh=iClME/6KYRmd5UuJ8d6r4+1Q9Ejj97SEKfZtAqMPlCg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FdshSnEEVNOikt04q7PBBgagPEuzOzToATWhLrjaQ5pO11jzt+He2NBjE4VhGWuASLWFRx0Io6KIgv58yLDliEMPBJzUeNhEsQnOdTct0lb9AS3buTre8+NNTW3MqtMYl+MGSRgotuhGrt0yzcG37IzRCsdpikNtMEM/8EPivj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFg5M3Yg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFg5M3Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744041F00A3D;
	Thu,  3 Sep 2026 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441576;
	bh=iClME/6KYRmd5UuJ8d6r4+1Q9Ejj97SEKfZtAqMPlCg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LFg5M3YgnVTwK393KKgP8ug346vf946WCeaBjW7G+QBCBBew1NrztmxCvrdWGk/nZ
	 w3QdKvYb7G4323mPVxg/dw/caJJTkxkgnZZtVAE7g7djd23nj5qcBOiaLnvhz2Pa2U
	 jCvmtz+ewjpfvo8rnPpHI8D3ZbNfC/uZdnTWfDeKWyiFggHhS1Ts2wa0nDthXQ5llX
	 6kCohOhqYjZ1VxbnoeJ1Q0M0BXUsVYsMjjDgQP5u/7wJq1iqhtWLsNRtvEKaY6FhON
	 fX4Ll6WjNo4wU5/gD57qEPQLnG5PlqBE3rlbZFLi3AtUOTp1KHi7lls49xr4SUzRqm
	 zEBotmN13xd+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 19/31] ext4: add block mapping tracepoints for iomap
 buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-20-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-20-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:19:36 +0000
Message-Id: <20260903131936.744041F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add tracepoints for iomap buffered read, write, partial block zeroing,
> and writeback operations to help debug the iomap buffered I/O path.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D19

