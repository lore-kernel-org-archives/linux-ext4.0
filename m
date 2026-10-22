Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639058;
	b=qrtOqhr+1fxUftV7DE0VYTMXKwGx+wpzSh2vI9qMpYW60ogAnyRj07/pEx34UCb6AdXO
	 7Maa4Q1xyHxLvjpBGB1VBpyH9eEx9P1LmMQcX5BUsWgmAtaucplTpzfdJlGFfLClUOuPS
	 bTDLrkr/IpQ4iv6QH1I0dmuPki0mEiJ3jpjeRp7FxsqTCpou106MzEDAxGZ4RoZy1/PX2
	 bp2OH2rb8SO2V1WNqFJ6C5+LDRCR/BR7w/pHcqCqbh3JkGCpBT4G/vu2/r380jFE8U9we
	 K5YDeIx2eOg8HS0IVwvxut4BUI3FDYr1KdOviQwr3IpnwRXl8F1FvviFLRr+YBdgk9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639058;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3DLjZC9RVEQw/Lfj2qnizwZTDjba2UgIdd0EBjAjdDk=;
	b=pJGhNNoRczENAPTuZnn+qA8YLNP7N1AGqJNPTrQYIxuqTS6nu0PDeSIdHxjgmzdv6XYw
	 F6aDEvSaiifjcvPZZSmKakkRffDL7JQNNIB2ECXIwMJk1FjWDD6n4yZMxHwHnEUAR5aYz
	 AydArcDG1MoQiZIGWblBSlN0TydT04DVdfXNR8iECjpXDRsItMgQUQrozs+JI6ZlThOmH
	 A6vEHe1a1qX8OhIZ+qIPoNr9znHBvGEfOM051i5OALH5GYAZZCxqeWtV2O+hm6OVb3GAh
	 ESdjw2+BrTBGRynp/J6GE805gIbvxZLoUtE/BqE7gXvegZNweKu+3Bc0jKXmp0RP1DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqdKVUhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3AE60A382A;
	Thu, 22 Oct 2026 03:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqdKVUhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546311F00ADB;
	Thu, 22 Oct 2026 03:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639057;
	bh=3DLjZC9RVEQw/Lfj2qnizwZTDjba2UgIdd0EBjAjdDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CqdKVUhQOdOXegFyK6pjFXVCnHmyIP8DvLeFJQV1KE/I/JH8h99Ots71szi6A/xsT
	 joSDeLLpOd9DSeAjlubUg5YBbqnoF170xvzw9hRooDW+x/qnuQpN6uw+R+J+hAkBIY
	 IfDVMH/rU3C67K92FrclJoQCNw9wdqJoNXNkG7GNzff8wCgfeM5dOGITDeJE8a6DRU
	 vidaGqOY2PY4RK1FJkHciTb8uq58KVJVtwlkwWksy1dILWtHQAo0Jo8V3tKGPiXhDk
	 FSQog2LydeCTr1usJ6AyJJEEodrPyftKQFIy3kC50pp61XGMegQaqlXDTXET5XLfy9
	 Fdl/hViQOR2eQ==
Message-ID: <sashiko-outbox-180914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 13/41] ublk: refuse unprivileged devices to UUID
 and GUID users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <f9cecad11d5acce30303f25861d7e9f25daecc88.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <f9cecad11d5acce30303f25861d7e9f25daecc88.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The owner of an unprivileged ublk device is recorded in 32 bit fields of
> struct ublksrv_ctrl_dev_info, and only the owner may open the disk. A
> UUID or GUID user comes out as -1 there, like every other one, so they
> could open each other's devices.
>=20
> Fail the creation of unprivileged devices by such users with
> -EOVERFLOW, and never let such a user pass the owner check.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D13

