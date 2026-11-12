Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794485516;
	b=WQUHg72bcg+SiawYDSITYomRnYcusA3oo8Vbouy1+1yD0aDBZn9wwOD5EmZHq3x8t0Lf
	 zZLBgrrXiGPlsJxAiYIZGuEn5yqBvE0o5LytRBJgEkxyt9N4T9HkhhKKxsZO6sxt3erpb
	 zI3UUpwqsJfjLk2QaY20rsV0O0Qps/w0VCrjIa3YZP52XZX5teLjf+kiZyPKW3tHjj7ns
	 ERZlLc00nR2ORW6txDzxhc3PAzhI39G8SxapBLPydUXOwsYrPD+iIVCJEgJk0KMgIN/Q4
	 ZFeP0UkcN5bmfP3COrottv1aZVw4wRP2X1snQt1jJDVJfVKP58JLwpzpJdlbwYUJqJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794485516;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6O7hLi7zy9rCI36HpITBClTKuiJ/OZPk9kCbuhwmtf0=;
	b=k4zoOP/0xRKz10jvYRWok55r0WqSvHdc+8uzP9x7KEyz3fwvOs4GzeQMU7vIHjxJ5Fes
	 CWiDfxw57yvCmIJqo5JH1XclmjNihYNRR4Z4VNGzy5E2x9GQnIf69umtXd2KMqqKAlHFA
	 2E1ZLh/3ueKH9B/d53JO3QuhB3LiOIDIXSg+5yDWw7xRPCGekqyn2Fyzm7gHZmofGy4eZ
	 m5A1132H6W2E2lfHQIJRFTh3pySVzwkez9t18r7TXo1QbQrGPN2E37a7YANpUQxXIhgUa
	 qR4eQavciATX44lr5g5KS3X8Ptx3iLFFwJwtb8jiEXn2UKRsETVk+bNp9nRYM6bmHPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgFf4M9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2450606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgFf4M9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1191F00A05;
	Thu, 12 Nov 2026 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485515;
	bh=6O7hLi7zy9rCI36HpITBClTKuiJ/OZPk9kCbuhwmtf0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XgFf4M9syUwNjzDCFO4kwLKAGvRXNXQYxLuvW0aYK8zOYVjAk4GiDHgj2K12y9MIt
	 PXqpoKQRiw23V7fZwLaCnG2n/n7kUiQG0PWpM1WTeWYX6qHmbvDNzZ/15AnLn9c1x0
	 9FjLDpggXsTEEPFMIIcExSyaTY05ea2egXyDG177jrQ/UHYM3LRHu8ZgsWJYSfD/rg
	 CYetr7N0fKckpLtdXbP90s5mIi0gz090uWZLejjnowWHU5Dp+spYBJGJ0CqxiBSlQy
	 HmiqcdOabvGAE/HkWuU3IbFhmX8gnJo/lt80JSqesTvlKvADEY3b8tPMmt/hHjVYuo
	 vkDp9vbFztSnQ==
Message-ID: <sashiko-outbox-211072@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: wait for tail page commit before truncating a
 failed write
Reply-To: sashiko-reviews@lists.linux.dev
To: diasyzhangqing@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261112115906.17915-1-diasyzhangqing@gmail.com>
References: <20261112115906.17915-1-diasyzhangqing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 12:11:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Qing Zhang <diasyzhang@tencent.com>
>=20
> In data=3Djournal mode, a failed extending write can leave buffers beyond
> i_size attached to the committing transaction. When blocksize < PAGE_SIZE,
> invalidating these buffers in the partial tail folio returns -EBUSY,
> triggering a warning in ext4_journalled_invalidate_folio() and leaving
> invalidation incomplete.
>=20
> Call ext4_wait_for_tail_page_commit() before truncating the page cache
> in ext4_truncate_failed_write(), as is already done when shrinking a file
> via ext4_setattr(). The helper releases the folio lock before waiting
> for the commit to finish, then retries invalidation.
>=20
> Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
> Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
> Closes: https://syzbot.appspot.com/bug?extid=3Df111db4cb2acd44eb2f4
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112115906.1791=
5-1-diasyzhangqing@gmail.com?part=3D1

