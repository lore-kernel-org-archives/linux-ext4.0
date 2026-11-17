Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794893778;
	b=slGQJtVuy/pOm22jFQyYxJT3bOYSGPF4JSPDbpmLSDfPEoX5owpmY2fMikpClq1d7DXq
	 QzjyaEtpTVLf2LmqxogYiZb1l4DwzEztbXpGapYvZPwtqrrW3dr/7OIBfT6tfTGzgK2H/
	 LjSWYplcPIyNJUQHwjykpfvRXQgEj9KpwtEmmD42TNfoW1usOiBBMiOAicrSq4Hkg7Jsz
	 GpFzvBAWA1BQFzoqFrImP8UTWi9JmxSuxsvf6+fH63EAixgiWJ/Dg2pj5WRWHoS9vAXlE
	 igQmEQPqiyGjDC4to9dSXf7A2OTCk57fwfZPcfULwT2aL0D/wTgyKn6CmCeeWhBhIMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794893778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KF34K8JEJYN39fjAOVm5Jue17snwaaefnbreJNuIPxA=;
	b=VW2W5ZuNafx0boB6+kEAvDi+yCBQZczVxi8cA76bLkXBDmO/GX+UsZ5sDnuUc4HcI9rn
	 /mnVCnsXmq9RNfCH02IRioX+pmGUyFtHOhXKfNenFP/+2w8CemXdPpQqcr9FCnoa3JDtH
	 owwD+beiNj3jDY628TLuqq9UNPFHm6HpjGvq8yHAUW39erNRa0QlPa3dlsa21ZaTTXJ99
	 fJQ3bkiCjIYXulmWjeeexVhdtFNi277C/LpkhBIzzefyzoJP0RH/6AvRrHzly3Ljb2LH/
	 a8e+j2MFmOsKgHnNwwbqrMi64OlzATPxL2FSTQSB5yGN8N/RS0bTIxI853rQgV6H0rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ol8JnTMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB52606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 05:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ol8JnTMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229761F000C4;
	Tue, 17 Nov 2026 05:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794893778;
	bh=KF34K8JEJYN39fjAOVm5Jue17snwaaefnbreJNuIPxA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ol8JnTMgcZ/uZ7dLFP72mI/hr7YkkQyV+VzAHkQHW+la+1oqCsnxa2L7cAH0vE1fK
	 aiUelpqK1Bkc2JOisqZhZprUwL0A2yNWKkwlYgs8kXGmOF86+chSpIcMzca6HWsgCd
	 8CqhX09Ylx/KfwFK9festp9coRfH9QDy/hGJ0z2BvoAXk9H++JDmszmFCTs/GmNfrA
	 SHQadZJZV8TuY+fmfpg1tkIsrAqp9kQm8FnY7k3chr4W6xTdTrehfI2OM+CyZKLem0
	 0GcMAiq3M6rBkPRbUsXtdZaY8mbjFyby5AmZTVYTCauyEejjoCF5etzlWkjNSeYGBx
	 GN0vf/d336n4g==
Message-ID: <sashiko-outbox-218215@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] ext4: reserve an orphan credit for inline data
 writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "William Chuang" <founder@logarcheon.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117052750.2955-3-founder@logarcheon.com>
References: <20261117052750.2955-1-founder@logarcheon.com>
 <20261117052750.2955-3-founder@logarcheon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 05:36:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_generic_write_inline_data() starts its handle with one credit.
> ext4_prepare_inline_data() uses it when it creates or grows the inline
> data xattr and dirties the inode table block.
>=20
> If the copy from user space then comes up short, write_end calls
> ext4_write_inline_data_end(), which sees pos + len > i_size and calls
> ext4_orphan_add() under the same handle.  That dirties a second block,
> the orphan file block or the superblock, and the handle has no credit
> left for it:
>=20
>   WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata
>   Call Trace:
>    __ext4_handle_dirty_metadata
>    ext4_orphan_file_add
>    ext4_orphan_add
> [ ... ]
>=20
> Fixes: f19d5870cbf7 ("ext4: add normal write support for inline data")
> Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De8180f5590685cbc9037
> Signed-off-by: William Chuang <founder@logarcheon.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117052750.2955=
-1-founder@logarcheon.com?part=3D2

