Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DFA4EA383
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789555637; cv=none; b=enJdhSaCmDR8aQwK7/I6RCQkpcgriEVIvjpVlvGpcF1rKTRT2fRHkADT5IAnZBZYo4Y4ebKz2pVDbE1V0a6rngUiWeR3gQ143+gPrFAp5hXBLjI7gupjdBizN6Z/QPPDpwuWhD+4jbpNig/lSvlHJdZij8TlTiR/F4R/ox+LEGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789555637; c=relaxed/simple;
	bh=qJ2sP9H0SaQOQgysrzHtDzKhyVn9+z60O+8+4BJvOTM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fAcrxta7MP8BcJvv1MyerlgOnwb8etiEXQRFdtZ0nvhHFfZL01TPo8dPDg4QYxEzI0mto+x/jq2yf1ytrK4v/3Oat+IghU8vTzsi+RcWq6rRfID2LyPN/h+5ODfs5ftDgy7SfclQBxjLGMGRz6zXZiUyxBYHVc3GLjp2JwT4jCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LevJ7Kfz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LevJ7Kfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501221F000FF;
	Wed, 16 Sep 2026 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789555622;
	bh=qJ2sP9H0SaQOQgysrzHtDzKhyVn9+z60O+8+4BJvOTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LevJ7KfzYg1y0pfy/III8FnvL7UfWCJH88eev7/Yf6SqZhym5zh5XAziu15job2w6
	 v+iyp1/PGnilzYI3WxSgKSoBp8rWsbzSqz+tvbj+EZct+616Pa6YQXKbOyR7Jr0xO+
	 VqGWdrzz+YBzahdeXeZeQ5SrSitP0oY94CSPUBoybhWEYYXyna2qOSOFWfnMrP4seM
	 mUtaHmsxsmEmurS9cS+Er3gM1Ei/fLa8AYlfhQLDVNxUrDRdKGzu/w7qMFGa3OD/NB
	 VPIgdoJMfRG6H57uSl3R53Wurf+KHR/UJKvZoyk2q/VAb2tTagYvfOUtLQLA0tTt7a
	 vKT3EU35bj/LA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4, doc: remove unnecessary bracket
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manuel Ebner" <manuelebnerli@mailbox.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260916104251.296148-3-manuelebnerli@mailbox.org>
References: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 10:47:01 +0000
Message-Id: <20260916104702.501221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Fix sentence structure to improve readability
>=20
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916104251.2961=
48-3-manuelebnerli@mailbox.org?part=3D1

