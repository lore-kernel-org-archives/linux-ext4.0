Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A733E00A5
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701744; cv=none; b=ITRAX+1kkJQyl06Lf/wHE2zDfcMqhwJETItP+r4uV1zNNwiLiJ8Heaf6HSCy74uc0Z198IEs/udzwNxRJvTBWcNF5WIbApSFsQBLoQYtrnkZZGo/gXarwnjeGeU9edyMBnYII5U3ZEsSYY/7qnxZEB0lgy53sy+5RYvBMpcJftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701744; c=relaxed/simple;
	bh=UnYqvJ9MWEHB80yRbbMfNwn0EHJK6/ov0jMiUs4pgPU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FUerY+kAXInHOqKdqION/2Uy9MXkuurJgHyeFX1ir0FMPln8SPNa+Mk+mCSlnw4BypuGD8hBx8zAac+vIBstny1bLd35PU7yPp7u47mUe2ogPDDlMCBi31OdUyQLPNOOiIQ1RW9Xk1O8wIUBcII53Rq0Wsfto0ANUgQZkXVK4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTUjMNc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTUjMNc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAD61F000E9;
	Fri, 14 Aug 2026 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786701740;
	bh=UnYqvJ9MWEHB80yRbbMfNwn0EHJK6/ov0jMiUs4pgPU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KTUjMNc+BINj7xzKQKwg5HlDTrZCSOCh/GgmZvZddDey4nv7K8xRR8kMd7UqVPiC+
	 ZvIGFloSLFbAQBuPbWKY0ARxWJWvdgqlYoI0ajzIwZi60GugV8Aj9Zqt1x2HNr0Fnn
	 xltgWR9XTg0X5Rm6x7V1y80kDWNrit6VFfP0tZHomHy837/UoQF0UF6CdSnO2x9IhT
	 eMqZJGyfiKThPVof1n1zqDVXQDpY+oYcKycvdXX/y4oAAsTw6dcH8hRSc5LzZ1yPy3
	 dqBGPh1rHX3gI3HWaMyPnKlFCG8ZHhtHMXG6lLv0dmquseiUg7xYCu50H92s19xrst
	 U2o+x4ZS7HF7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 01/32] ext4: simplify size updating in
 ext4_setattr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-2-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:02:19 +0000
Message-Id: <20260814100220.5CAD61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The logic for updating the file size in ext4_setattr() is currently
> somewhat messy. By directly entering the error-handling path after
> failing to add an orphan inode, the unnecessary recovery process
> involving old_disksize and the file size can be avoided.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D1

