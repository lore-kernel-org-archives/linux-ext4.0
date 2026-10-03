Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952BF3803F4
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991251; cv=none; b=ahPX8v/oQsi6nuoMzAPiyxWGrIPUEYTJZR3O9UkTG88dPYRCI3vm0YKUpHt8W3zzgPd17Im6dGqBHObfYAqLq4WiJpXIF34x/y3wwbm2FcmGfIaY1iezHANN16aBbfkX3ay+cASv99BeJ1OCeTvak3azesIpvctvq5PDU1tLodo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991251; c=relaxed/simple;
	bh=uUC80bG7rhfVMdNrpLoFnsAT6E4Ur5tXDzalyOnpcAM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BjMf8UWfwbUwK1E2H9X4FtaNDZ/Ex/20jNNUHuVtQVlBIkDLnc4frxqEVvWpHAQ8Gs641J22mX1/kEpJ8JQ+gCAtB+JHE+uOyBmMmW0aeRGzjBhz83FZpaqEvo5oX05RphAZzInPg6QI3boVBs3MHeg94/oUCR5uzwU1X/+VsSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXpf6XQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXpf6XQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6A01F00893;
	Sat,  3 Oct 2026 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991250;
	bh=uUC80bG7rhfVMdNrpLoFnsAT6E4Ur5tXDzalyOnpcAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXpf6XQqzdHWVX+F0UF/nwHK+07cUJ5gCDmpyIYCtKwXq0/nfyrMCkWw7/w82kcD3
	 Nd7vfr+xxfc9AjVAViQ6fswp0VobjDCZqXuaeHU5kI1haEVaTMQsaf9CnJcKJTtrWp
	 5ovSlhj+9ZP7LjaEfSiHMEoNRrmCFCH+DUaA5do3tUkrZ7rJkPI782bgWbzIIE/Geo
	 f2iGISg2Gxpb7UsWmOk4wKBuRrtJcaIy9Eqai8YG/GBrk3+9ykSsiKRDw20Cf7xQoa
	 7uvpN3DtFB1u/27XoRa+ECqRo6QFqM9CiEzuDsqtPKXeJymz7r7gdkp3ZN/mzNI1gO
	 9qVrLW4lKFPpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 05/21] fsverity: don't allow setting DAX file
 attribute on fsverity files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-6-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:09 +0000
Message-Id: <20261003013410.3B6A01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> it checks if file has DAX enabled and fails if that's true. However, the
> opposite case is not checked.
>=20
> Note, that the only other filesystem supporting DAX and fsverity is
> ext4, and ext4 does check for this case.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D5

