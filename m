Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909083;
	b=L6idBuA+DDztU3RqLvdOXrMhlQpcVWl6L7tl0ik5Ycmdg68JNqkVHTHa8tNJMcAyDEIT
	 hpoxNtwPajNxFjmEJazuVgeEnitfL6Wn/5xCiYqN7e+6joilQrh9vhhGHnoyXYjNcr+in
	 0N0Tyf3Z7qSEHM4Ts04sH9yrSUvS0kW0oAl4LMqyYYrzddc4N3hSFsFCn9UWq8E+VyHbl
	 W1FCNiaMojh4O0+FPA3394PQp9pzeskRIPgqozDqNnP9zhIBVUnO6t21bUbqG6ClQBpMV
	 fbmA5u6n4+EancNDeXpf7sGlvGw6hHICOsmB9NFG+hUAt37yCwaAMiC7I+sHmSsl0Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909083;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IgWorztv2BHlor1T6Axd/Nq2sNHTNA8oBQHQSlfJdi4=;
	b=3F7WdL6SB7NJ9WYngMACTUgQOLqvj+7sPLZIoz7aPURDlH0fkHQ7kMQjZIEyn0ibW1WG
	 MSG3guxpEdGH+tmzx0RVrTf4N9k4i+P5VPsTv+cnanlip3UdDRmw2S2EUF7UXkhn8uO7N
	 lTuEckbhku2YfsAYwApzp/H9T+jfG1OjFM0MJwJQa0pVwTkhEa3WnXcz1FqUCChAgZR3B
	 FkFwjXrhd26pznYQk33Gk5f26mMSxV25eHiQUfMoKv4fphp/7cT0foxUZ4nXuGLougRYN
	 3eDYJZiIARjnSKXvkbLaOYe9/L4q9iH+v//5CtqpKYwqUr564jIU1u3p1rKol8oSrfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ammEKiKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC639606A333;
	Tue, 17 Nov 2026 09:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ammEKiKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9C81F000C4;
	Tue, 17 Nov 2026 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909082;
	bh=IgWorztv2BHlor1T6Axd/Nq2sNHTNA8oBQHQSlfJdi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ammEKiKCdIdyCVZgC/j7JtdKyM6HDM47RW0+62Wq+RK1zS5F7otycEtBFf6a8b7GL
	 T8OFTwYhAT+rtnMSu4E4U2HOoFCrBq4YNpbs2byR8wgY0ul+t5h5uTPwotJ/pIJHJU
	 ZXc0vTVYbaSRx/nmmS9B3WwiJE7bzy+OmUITRwFeddJEwqg9ejhbZEbJOZBV1z8byG
	 tx2nM8Qy17jXG6sYjCTOH7SngDREzscNaNbgEhoirAzPZWru3N5P82mcN6Z673HN8q
	 4kD3T7R/SSAGgkoahMLNDdtftjITuqlozGsERONYZF8d1fAOaliy0JLkeBol/A8VOt
	 rZqE/leZAHe4A==
Message-ID: <sashiko-outbox-218535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] exfat: keep the volume marked dirty after a
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
 <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:51:21 +0000
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
- [Low] exfat: Fixes trailer cites f761fcdd289d instead of 46a557694b46
--

commit a1d3dffdfc2b9385cf2e9ba0e7b99bd916f22ffa
Author: Christian Brauner <brauner@kernel.org>

> exfat: keep the volume marked dirty after a shutdown
>
> After a shutdown exfat_write_inode() and exfat_writepages() drop
> whatever is still dirty. But exfat_put_super() and a remount to
> read-only still clear VOLUME_DIRTY through exfat_set_vol_flags() which
> only leaves the boot sector alone on a read-only superblock. So after a
> shutdown with EXFAT_GOING_DOWN_NOSYNC the volume ends up marked clean
> although it may be inconsistent. Leave the boot sector alone after a
> shutdown too.
>
> Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

[Severity: Low]
Should the Fixes tag reference 46a557694b46 ("exfat: do not clear volume
dirty flag during sync") instead?

In f761fcdd289d ("exfat: Implement sops->shutdown and ioctl"),
exfat_clear_volume_dirty() was only called from exfat_sync_fs(), which
returned early on exfat_forced_shutdown(sb).  It was 46a557694b46
("exfat: do not clear volume dirty flag during sync") that removed
exfat_sync_fs() along with its shutdown check and moved the
exfat_clear_volume_dirty() calls into exfat_put_super() and
exfat_reconfigure().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-sb=
_rdonly-fixes-v1-0-95a25ce917ad@kernel.org?part=3D2
