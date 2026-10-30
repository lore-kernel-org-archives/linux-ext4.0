Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376595;
	b=XzmcfBzjAj/Ykxfrl6UfKjbZKJDi1Gg0bOwNuMIB33Fl3qElYVy72DYZWGp7FX9VkkuF
	 Aeb9JoovPqN3DDN/hQOag38MYZ8q0bUYgtAmZ7381IMWemZfHvR04w6a43iFGbeLWK3iV
	 Uw9XrJNvDLWhc+/GEJ5VkpH6kEly+YnSg2YvlqaLW84ehoQ0SGTUUF/EbJm3dqluxR0sC
	 nXmNbIz6g+pmjTwa17EnZpSMzBF2eX7CsDR+w9oIjmf6o9RUZI/eDmo1eWyRrZiDoKmFp
	 8Rqw0iV0AzDQs+Rt9ttFlh8zZ+JLKXWfd/BjU4mMxtGCL1HV8IXuvEksuBT8T/qCCuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376595;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IV7e/vABTjnKrw+EXTzRRc7d6rr0Obdl3IvZN87KkDw=;
	b=ytlTWGogMZAujCOqtfTd/T0fETFy/ZAtFqTa1ZgAQvXR+3e4rsIwCm9tyzE4Mns8GAz9
	 2UXikLzXOy4ae0Lyn98zXniEd5bvhM+rFQGp6HFdU8SbdrhVnmtYLPk9xeCcEeDeGdAqx
	 ZfxuWz1TBxO17ItbeFenXmXoIrOUkwP0gxif1v/1hWkKR2DUX21WSyeC6bS96P+XBnmbT
	 JrV7HelX1kz1RuhLIBpNT/kDPHQWICUZeejTmwhtsWyEJl5CoFkUh00Ag1QhCrCWLlPnI
	 TANXB/KTKQJ5wkoQQDj0mKLHUIgUqcPoYh7VBKP7JMS5kG+RfoUuWPJRzDl6pk9kv+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PMLXQEUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D444606A32C
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PMLXQEUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08241F00A1A;
	Fri, 30 Oct 2026 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376595;
	bh=IV7e/vABTjnKrw+EXTzRRc7d6rr0Obdl3IvZN87KkDw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PMLXQEUek/dd4MeDYY3X8NyxBaBtFUoLaOQUvxCh6k36w1rQ/RFlMdr5V8ZZKWYiI
	 De5OZVQhx14M3/f4z/1hlVN9/jdCg1AZsEj+0raZ+hb5bFF6rK9/8q3g2i3LJWK7s9
	 VShplI10NaS5cp/1BYw4GcDU1YDbuZMckayNjdDyHdVPMbTI+D5lcnmxrex4p30fjA
	 Hhq0DUcrB9ZRTDBzBk7JNgy/LtoW7wuq48AQT+nE46J4mImGnYIWyyNutek5SUX3kQ
	 ZwM3N5Zavagmdr+p/LBCaML9OKfc904TeraZ/irh3YWjmP2z8xXc7b46DDhciF9TqP
	 W+USYN8IYDuxw==
Message-ID: <sashiko-outbox-191227@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/34] exfat: keep the current mount options on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-8-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-8-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> exfat_init_fs_context() only inherits uid, gid, fmask and dmask for a
> reconfigure. But exfat_reconfigure() refuses to change iocharset,
> keep_last_dots, sys_tz, time_offset and allow_utime. So every remount
> that doesn't repeat a non-default value for one of them fails with
> EINVAL, including emergency remount (sysrq u) which passes no options at
> all. And an option-less remount silently resets errors=3D, zero_size_dir
> and discard.
>=20
> So start a reconfigure from the current options like gfs2 does. The
> iocharset string stays NULL in the new context because
> ->init_fs_context() runs without s_umount for mount(2) and a concurrent
> remount could free it. It's only compared if the remount names one. A
> shutdown turns discard off for good so exfat_reconfigure() keeps it off.
>=20
> The next patch stops exfat from setting SB_RDONLY after errors. An
> errored exfat then stays read-write and emergency remount would run into
> this as well.
>=20
> Fixes: e6fd5d3a4317 ("exfat: support modifying mount options via remount")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D8

