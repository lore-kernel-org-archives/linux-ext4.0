Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A204266B2;
	Wed, 26 Aug 2026 09:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738071; cv=none; b=Esa3YUrwkI6NOKMiSEpls/LRzTgqxHTYKsa+PctjDOWYvPHbCKQTVz/q7fTFXJEg7QbKaf2/Qv6/zo88gyCm8YEP8wVIsvY6uZcpWC6rrmDi2kMD4AjI1E3YaOAi3AClJ6AfTRn2/o/+sr8kskTlLbTzSB1xL/THnk70pz2Sfu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738071; c=relaxed/simple;
	bh=9FobH37N3FuxvYE5D68n6TeU4/Fl0rEBu1P4dyTqg8E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SxZqTI6CVxIQ1XCu6ZC70hrlFzynqaUWcKcT1JvyuvxqM3wnKNli5DuF2L1pB8UEWfEKy+NsS7T3R5yos8OGX1W4fgXboHolij8RUjMYqwi8oEkywZcv9h5Bvx+9LRs9+s5Llr6J8jBzhHmP4m1C/ua7d2V431TJhOLeVVV6E3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+h+ToTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+h+ToTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDCF1F00A3D;
	Wed, 26 Aug 2026 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738070;
	bh=9FobH37N3FuxvYE5D68n6TeU4/Fl0rEBu1P4dyTqg8E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m+h+ToTHqpSSLSiAqpxsgyX2RptXBmt4Vj/PIBC/NVMnM3OwtLVq+Nve0KH+TjYMO
	 4bGUkLeWFtbbG4Z2Y9OFG8rYiLQyrq3huobE7PwEWBr54bpZPaRuvBENqG32fZmnBZ
	 Oce4j4RTgUSK7dJdvdWWB6eSNDkG5WB29SotOKY1XsNJrqYsiWdZJRv/ekN0ETKyBP
	 u8exqZbOuW60ZBH8RkIj7hAw7Mii3CqrlrdzEQdYYJFyUfPfTkwSPpWXXPYgPZLlkC
	 L+ESxBowRG4rp6c/4V974jcD/ktdu/Se4gpTsE2UMqVRUwy/EW0bqiIKulzxc9FXaT
	 obmKWFXBFiXdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/11] can: isotp: publish tx.state with
 smp_store_release()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oliver Hartkopp" <socketcan@hartkopp.net>, "Vincent Mailhol" <mailhol@kernel.org>, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org, "Oleksij
 Rempel" <o.rempel@pengutronix.de>, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260825095422.3166067-12-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-12-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:29 +0000
Message-Id: <20260826095430.0FDCF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The writer already pairs with the smp_load_acquire() readers
> in isotp_tx_timeout()/isotp_tx_gen_done(); convert
> the smp_wmb() + WRITE_ONCE() into a release store.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D11

