Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221E4C9E10
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543309; cv=none; b=S1LWtujvCr43VNlXu31gt06AlmvbtrG96IaA6lIdZxLtcykyh6We5RkH3gWR98VA7zKgEVqwRp7eu/+Mre+DBrsiG9m31iMxQuaLR/8hcLPWrTwhaoGJ0/5OHckXDbmPPjDG/JOI3eXPRc1b436fb+UK5BOLPib+EEQkGsCovqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543309; c=relaxed/simple;
	bh=cWgkeqIeI6C1Xgr8oqh6INnZAwshUuEN/EgZgGwuuBI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=U1VOw+eKgrbh9TJZIfOCiLyU+1Ka0qqbClzijVS7Nfu6yYzLJbOhIF8slLVsBOHsSGnlmA/rpBpQep+lHi46H4Wrz5WrEkVi1MHjN7wRqCgo4wcLmGtHZLNEzPue7Z8PTarjdOi7g/y7YejvRDSjxVkNUcGhmU1q4UFcHgG20K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijVWKwJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijVWKwJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3852F1F000FF;
	Fri,  9 Oct 2026 10:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543299;
	bh=cWgkeqIeI6C1Xgr8oqh6INnZAwshUuEN/EgZgGwuuBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ijVWKwJlqEC2vGkDNyOAdeFnWTH28JBEfG4TKt3N3oZOpqHutUgB7b1xRQQYnxIgx
	 pP2L9SnzmtdtAC+4+6EMP//JMsknDbj7DEBkgD8Hz7aCoNOmWHkM+T8sjh1sfwZbds
	 H0AD6M5kDf2fEqFhnWheX6PDB2atd36dddrMC5iCzWfugaUGpnvz29uLC7MPZO/6tk
	 kKEJRJli9IJYlaASlqMlAa3A+tIBp2Ujlpx2aO3eGHCylEUTl7hc+h/oU+vejlbVix
	 6+RJbV67m/5UJ25f928ImLSswl3K6YqKAvMiDaHOO2lKjXeiPJhSFYGoLoullf7qAt
	 cGVMNnrqfCRUg==
Message-ID: <sashiko-outbox-165286@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 02/31] ext4: factor out ext4_truncate_[up|down]()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-3-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:54:58 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D2

