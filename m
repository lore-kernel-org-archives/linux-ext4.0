Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052874AA560
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440987; cv=none; b=fO6VKo8V6e8gaS3Qs0CL3syBDhLnoWOv9jgxRMdsaJbpYqrMGDWCRESCB74PIDncb6yDne+Si9pR9+LBE3dvW79gPsMB1uUyrYsuJOrEgTHqiso6k4BPFY4T7ha+GLqFnE3Rd1XKsq65jdZoLabQHtKWL0YcR67ILWn+KBBvtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440987; c=relaxed/simple;
	bh=3hUpEe2U8VJI2Zj4qoooEHh/30Y3wkS8nGZeMV0g69M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k5qh5bIEDkxuRSzhEzWd4DCFOHsEmRh0w9XQMclovPZCdzsR8gFb+NOEo6voIwV1VJaZUIThKqyLNVGMkcL2m/VPs3+omsAo46wWunfM4Z77ftYQ14QJ16MD2Puik2AvxWZSoivHOQfyD37FmzQ22svAA9uJFJq5jjPsWvem4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohyt2Hny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohyt2Hny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46191F000E9;
	Thu,  3 Sep 2026 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440964;
	bh=3hUpEe2U8VJI2Zj4qoooEHh/30Y3wkS8nGZeMV0g69M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ohyt2HnysiZzGzjxJfVBz480UiySCtabYjvXho8Z4hYzyvEkxERKuaHmIAu8V7QBd
	 uvlLziDxAX7+DV75NUlsygisX99D28NdB75oBkI4z4hiOfeX3oQip0LI4kA85PltVn
	 CkksI0bv4cJuDQqxhD2wt/Lm2Ek9yVLwEqpOOOctncPlYvhjkkpDNxiN53wmMx3t1m
	 /1QEFLfDSbKDzwWFgxGaGMBrVciTgei6UTlsQwJ07brjw78F8h6U7cDJWfdQtAhAhE
	 EhC0KGKWgnRkld+oiYxVk1k9iTnklP4gMjvdccc1fvF0JTp984bV13PmBFZgePmlYl
	 LDapyDeosQrLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/31] ext4: factor out ext4_truncate_[up|down]()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-3-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:09:23 +0000
Message-Id: <20260903130923.B46191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Refactor ext4_setattr() by introducing two helper functions,
> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
> current ATTR_SIZE processing consolidates checks for both shrinking and
> non-shrinking cases, leading to cluttered code. Separating the
> truncation paths improves readability.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D2

