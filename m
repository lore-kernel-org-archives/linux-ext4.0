Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907436;
	b=wkFOoJyiMLnKCrKyXs3VOSFxFYbk0nUMAxmr/KZmXD76SMpTX36p0MVWEKunfdJU4mAw
	 II40bSIM8OMZ/sZ4flRfrvpmHGGHl7FgNOoYpMAO6hldc/db79bsDxAKltTjRDgSQj20s
	 ROS6R1OlkyP/1X0Gz+Fjvht3RrE4UdQQljrdbAVcqQkPHBs6QfWRSHFaQ6AgAQFVoRrcR
	 7SzgIfsaAGLXWDdUhFaivcLtzYiR9zYHN16ye6nasSnXJFyrBrHnwqsWQL6h2ezlz7vAZ
	 pKXzl7+KiMLif9vLxdgq1l0itceQ2IuoIswQhCg6H88UmI7oYUvYYgU6c3+ZtNPYZyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907436;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GvGxBPNznTQhNJhiDy0biRaRG3WDPYJZtNYeq5vV0Dg=;
	b=TepTON2AOYmaHGObYmTyD23wo1KAhfcm9iFWJv5M5pb3gYn12UV8UWCXSfT5z7xVLfPL
	 7Vl45S83zMdVrWoXp/j57yLXsUgD4p9ftvyTfJXb7jktga4v7os+A8BSoj4f/Oz2YgN3l
	 2xnunS3aHpreQNO09sWc3SLJVXj4G676jWK82I2iZ1cOX0akdwAXEn1eruL1s8Ob3VxBT
	 bHF+JHABl+JMavCd0vIKlKBY67czuS7mafbL05xMaBodTHTZuagIM87yKTlVL3+VV8456
	 4ZLLpOgVkLaToYHq8xRkbHJqLeY4syBGtu4bdo34rUvxXjSNW6flK1f9Qsvcl3h74QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXQ69URB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC7C606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 09:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXQ69URB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AFA1F000C4;
	Tue, 17 Nov 2026 09:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794907435;
	bh=GvGxBPNznTQhNJhiDy0biRaRG3WDPYJZtNYeq5vV0Dg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eXQ69URBV7bkP7KR4FSlfQYh6uXYlFTq6Nsx3zYzrTuI38SAjWw7SIxQ6p9GYri20
	 V7R/5IvqS1gS1GDRwdmGoeyHSkxSSWwuwpvJ1CFHG2s0PjzjBRwl5SUgk0aLvNtXo/
	 QVKzzmh7DD8s20QwKg10Gy5eywo6E/anxtHVlIidj7VHws5O38obSszOzR8FllIJuo
	 ViDbs1BgyqKv2+2WFLZIBNWKDHQthZ6T801vhm6jp5C6lAvJckSW+SaXqNHgyEXwEO
	 3p57DZdszx4cpcXo6mKujDETmQUXvvsfbXhO3wlEMIQW+d0UgjiJbCVBqAbk0RJQ6G
	 SBn6c7glaZCVw==
Message-ID: <sashiko-outbox-218477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: validate in-inode xattrs before listing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoli Zhang" <26031212468@stu.xidian.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117090147.3950327-1-26031212468@stu.xidian.edu.cn>
References: <20261117090147.3950327-1-26031212468@stu.xidian.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:23:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ext4: missing Fixes trailer for commit 5701875f9609 in commit
  message
--

commit 26f87c9d23ca6ed689130ab579bf0e8089b835d5
Author: Haoli Zhang <26031212468@stu.xidian.edu.cn>

> ext4: validate in-inode xattrs before listing
>=20
> ext4_iget() validates in-inode xattrs when it reads an inode. However,
> ext4_xattr_ibody_list() fetches the inode-table data again with
> ext4_get_inode_loc() and passes the entries to ext4_xattr_list_entries()
> without validating this read. If the re-read data contains a malformed
> xattr entry, the listing loop can advance beyond the valid in-inode xattr
> area and read invalid memory.
>=20
> Validate the in-inode xattrs from this read with xattr_check_inode()
> before listing them. If validation fails, skip the listing and return the
> error after releasing the inode-table buffer.
>=20
> Reported-by: syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=3D3fbf2337de43f5581aec
> Co-developed-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
> Signed-off-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
> Co-developed-by: Bin Yu <byu@xidian.edu.cn>
> Signed-off-by: Bin Yu <byu@xidian.edu.cn>
> Signed-off-by: Haoli Zhang <26031212468@stu.xidian.edu.cn>

[Severity: Low]
5701875f9609 ("ext4: fix out-of-bound read in
ext4_xattr_inode_dec_ref_all()") moved xattr_check_inode() into
ext4_iget_extra_inode() and removed it from ext4_xattr_ibody_list().
Should this include:

  Fixes: 5701875f9609 ("ext4: fix out-of-bound read in ext4_xattr_inode_dec=
_ref_all()")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117090147.3950=
327-1-26031212468@stu.xidian.edu.cn?part=3D1
