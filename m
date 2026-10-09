Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629763B71B6;
	Fri,  9 Oct 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791565843; cv=none; b=o6l4LxJMjq/qssteb1RzlxWgHG++4KliefoQE/RZ3NgHJHVvDhQ7oHoChZouSZKx6IMK/m8r/0AzDy09u1HeKVfgZYFvqoooPFCcbYn35b4e76XPdz3iuC/IoZEwM9+TRUjyUTPS49E3N0xzeuwCRK5E/MbKs44Ms3HEiDsKYzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791565843; c=relaxed/simple;
	bh=vY6L4NTvm/on6IWMnloYlwQJX0aRNJuGQuYsvtVGC40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXbyUzz4LkOEQE6RrSIA7QZMRMIUcGodFCHxYfT6PhCM3CtewIbG9yQF46LEGxQrLtJJAG6kSpD1eOKxv3vcU3XJy7DIWbk8ZEkhdyIikfDvWtXAcfng7uxAKYYzcyIl9cZS2tDMeM7H3Ni4+fHiSbqdj0rb8M9vhHmMe6WerN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PosRt671; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PosRt671"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853281F0089B;
	Fri,  9 Oct 2026 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565842;
	bh=dmxj2lj4Q4GvWHDzZDgnLPWqXygKdSJybIHJoEn8ViA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PosRt671yum93/RjAxCUxjrD4T+y+BFZiqE8on/hd8I/OAmdBxySz6Bs4NV5I4Pks
	 n1+te3syZLbEQuewEM211lREAIOjptmXMza7/EEty4Q0ndx8zwG4YOckZ7tzR9S7Ep
	 Wct4VSkpUyZAHBrotIv2CpCI1CVsboT0SD6MzHeH/K+VXWAMH19uFz9XDQDNNyKW5l
	 Y8A0iiE3HcO7athvIuUymcT5sIQ/4cIuF8vi4wshFStv1HqLbPPAiu7BUUeh46HxD4
	 vpA/kGaUZfsO7/Qx1X8OKrSjNItyZ99MJjAr6DIA/R3GsX6OdEpmyvoHKUZuThlt0B
	 hOQNjbmBX2LKQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
Date: Fri,  9 Oct 2026 13:09:49 -0400
Message-ID: <2026-10-09-1-daily-reply-0012-jbd2-checkpoint-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008192048.98833-1-artem@trailofbits.com>
References: <20261008192048.98833-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could you please consider this series for 6.6.y?

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
