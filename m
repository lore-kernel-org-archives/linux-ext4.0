Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401045;
	b=pmV9jRZy8IDwi6QwAT14U/MVpb15UMGJg1b6eOvZtzkdMIlPllQYaXwaUXo4bOJdoSlM
	 LNiYassbRstcfZXTCmzu495SkAqbM7lUGBfgjFl5rx+I5eUVETK54Ch34Bzk1snwQzJ/y
	 GpQn/GeMqwRE1hbDfxkpmkOv7RVKuPka4S5wh8ZMupubv+d7Z8PdgprjIhrOtjdbP2DpI
	 226bxiKjIf9a3nsM5q4Tmj6VsoeZo7Y2nynQMJM84CF3gA1gLO9StQtlpDL9izgGT5BhF
	 CQ+8WcYYft6hEQpktIKEH3TTTpJWyuHOS9dxtxIa/GWjTsaz8G+FTu6cazIpAc2eWVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CoUBwN5yiURx6ryzG1qTHIdx515lzXI5AhFJdt+bQpM=;
	b=x8rBc4zJxCv+EMBE/mzWX++YZnW1b7P2dJF19rHQtKhRzgcPVWylRELF7cSm1cQTGE1/
	 Dt1n4ErmgN2j9q5am0cmFxDnqxL03yNgE+dfSIEOtBV0eY8Ic6gzcj/R/viMRXrOMf6ry
	 9HJqYbH21dj0AFJ2Wz4nSHSF7bQ8HZGobpfdk+z8GrNFoPosjg8pKWLwASUCvCdFP0/DB
	 co5iyRNZjY6Mb9wth6u7AsUiKB5EEwVoug+biTBRyCfovv1q9zBKxCGij0nurqZQ4dd8C
	 cm41BInKKKx/1wgYFtpppdhc+jsK4botTik22Mj8WYDZ+E53C8NdeS1Zy+qrr7iROmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eH5fuz6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4C606A321
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eH5fuz6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC101F00A06;
	Wed, 11 Nov 2026 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401044;
	bh=CoUBwN5yiURx6ryzG1qTHIdx515lzXI5AhFJdt+bQpM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eH5fuz6qtKpTKhmGniivjpvIVpXz5ciPFq484aThyWYRm3c1tQBxuMrqJ0UyXGYnE
	 vuFhbMujN7YzB3xqYcoaKGUV51DdkEjhQb7jyt3HRKq9N/HryT9UN/kw3Wr9ZK3Ekq
	 uDQLpB/KNCyObcyLJYVCPz17SIFqph6QsjRNH6mpyKlK3hJLZWWJme+Jh6W6JWuzrZ
	 +xql253olwQj2ouyr/TQbeKeRTRdX6xjX826F5bfyNokBQJ6MQHqyVObhoyB/i+77L
	 OsKa7SQpF4gKAB8fSwpA1MJWn39rAqydygRdyBbR9PFGFoFwC8qH4un9M5k+5qRUpT
	 Xg8oSp9Sd2+AA==
Message-ID: <sashiko-outbox-209002@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] block: make bdev_freeze() mutex waits killable
Reply-To: sashiko-reviews@lists.linux.dev
To: diasyzhangqing@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111123530.871952-1-diasyzhangqing@gmail.com>
References: <20261110132118.11265-1-diasyzhangqing@gmail.com>
 <20261111123530.871952-1-diasyzhangqing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:44:03 +0000
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
> Concurrent bdev_freeze() callers may wait a long time on
> bd_fsfreeze_mutex while another caller freezes and syncs the filesystem.
> Use mutex_lock_killable() to allow fatal signals to interrupt this wait.
>=20
> An interrupted wait returns -EINTR before bd_fsfreeze_count is
> incremented, so no freeze reference needs to be dropped. This does not
> make the filesystem freeze operation itself killable.
>=20
> Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd4ecb9a1e5b3dcf8baec
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111123530.8719=
52-1-diasyzhangqing@gmail.com?part=3D1

