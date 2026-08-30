Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647EE632
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788063951; cv=none; b=Ynf0zQjIAq31moMDvLXyF0xQ86E/1md5Cnck07u45UfLsZR6u/K5ifG/CIJGrMkjkPAEvwbCgvJq3H3YTvjxZ2MOWBKC4LWfxgu2X30zqCq7WySkqQ6liRyEaH+eOvb+xDnamTyUf+rSFBh69w1aUpMc+d55co4vBoyRrF/Foy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788063951; c=relaxed/simple;
	bh=neBvR5iW6k9Ucg0/7MEXd2UtljeLEyYZIIbgQ5Dlcas=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t2aifTiuWCzX9MgXQcgtiXCPwGueY5zH6OuMlqjo4jKZ3L+bS9BUamU9DI0LP1mw1yBRg4DXuMSMQaqe+vsCvNOUsGS1BnMORVsX6HTm9buHa0ML2g5Nk10fO7buk8hkK2c2xlcyUcfjp6jQfNMNcCRHOlHhSG3r9RUGnaNXJPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzKdBGH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzKdBGH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C561F000E9;
	Sun, 30 Aug 2026 04:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063950;
	bh=neBvR5iW6k9Ucg0/7MEXd2UtljeLEyYZIIbgQ5Dlcas=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nzKdBGH53Py3yBFCjEuHefMXLfm0f72vkHsqKyH2lbOQAzDWvuwdEDeQWaVNZvGQN
	 O1VgCTCasEa4ODpZWAkwHVrQNfXewrH6YM9lsAjLtDQG05RijEXYgT7SQay+iXAxzC
	 2gnl4ijOjzkQRMWJCXm5htvaAl2YkhUWOLP9MiGvjy6Xj53OEebxz6cqKBAGNMx8l4
	 1RauVTlpcavuY3aOF06upCck1ansHDEZ1aCYmqKSK63tnAZEIw0Utj30tB2GGskT3f
	 2qKLNXu7/NdfRR94pzWn3h2WPt1HrnpzvqeHF0umI7wE3ZsCKHJEJ3cjfxKf5SK1Oj
	 2xQpkaYdvgbig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] filemap: Remove redundant FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, "Anna Schumaker" <anna@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Chuck Lever" <cel@kernel.org>
In-Reply-To: <20260830041901.2668-9-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-9-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:25:49 +0000
Message-Id: <20260830042549.94C561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D8

