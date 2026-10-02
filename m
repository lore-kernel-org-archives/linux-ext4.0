Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C784734E5
	for <linux-ext4@vger.kernel.org>; Fri,  2 Oct 2026 09:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932468; cv=none; b=W7In6yyr/mxiq96WxN9lMDwrTqlEsiKPXaIfJKTSyyXsUIR9N5p6cEiCvH4a/2ZG2lBEkrZG/ro0w1joyqarVuBwiWD4D6STyOSBKn2Lb+ab0XrTW9FJxWqSsqUmAvsbSLjjU5MFxwH9MGH2OFtIi2lWTz/3EgcOKCWZc/W85J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932468; c=relaxed/simple;
	bh=j3LaD+DpLMNZN3DuT8UIkD0qU1q4l5yesAc3YGfva7Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qDU1OURR938zVVX+KcdSRl1P6lWzUPNhanWvXymu4DJEPiMGNFmwH0mj3+qzu0w/VHRy8whZ/MVhHXdCH8o6dkAb8DNC9+Ex+t6sFMGPiqYe3KssBr1lRmw2uoIpuZVsxQ43Om0DE9zDhtW+ySCFZROZccgIDOdrSxpTNQQdbHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/zjNVUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/zjNVUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5971F00899;
	Fri,  2 Oct 2026 09:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932467;
	bh=oAQ6F9F0vM3LTZwyguzeUc5l/jGA1U6rRAxc5wFxUvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U/zjNVUArmQxD9hwADs/zS4/C712kT8aiwBtVRJMB8iMEndE+0W8wZ7v/HF3oZqXl
	 yab7x7c6w9esUKufyvHLZb2ZIaxJekXGChqqpG4twBVwfM4cLt0uv7TvR7xM1xkaoB
	 AoGnbM8kgsTwwQNrz7FniKMKh+ML7rujdBW4YsUiCu/5+LGqqkQJdEG302HOxKjTFr
	 7GSwDrCPpYaa5OJZj/w2EquZqoF3h59ySJw3cehpytieNL785E8zez+cZN6bFocuVb
	 f02iTuWz5rtsdNNu4BWIjXVSRNyDocnRNx7qVVSQDok6B0TWEswmgzsY+Q+TU+Lqvy
	 ly0UI+4f0umLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: wipe moved dirents with their real length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Adriano Cordova" <adrianox@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261002004127.1332310-1-adrianox@gmail.com>
References: <20261002004127.1332310-1-adrianox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:14:26 +0000
Message-Id: <20261002091426.CA5971F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> After copying a dirent to the new block, dx_move_dirents() wipes the
> source entry using the on-disk rec_len.  Use the length already
> computed for the copy instead because the on-disk rec_len is untrusted
> and a corrupt value makes the memset() run out of bounds.
>=20
> Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D09bec78ee77613a3efdd
> Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Signed-off-by: Adriano Cordova <adrianox@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002004127.1332=
310-1-adrianox@gmail.com?part=3D1

