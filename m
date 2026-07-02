Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C7F26056C;
	Thu,  2 Jul 2026 00:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952723; cv=none; b=j4yNOZaIPpMdfZp6lQB/qkPTs4dmjEt6o8iNVMRfOsP4+rSRqtaLrTZumULz+qjBJEneEWBT57fywAKlzbNJyyNAf713tAeYWv3l/xJP6w1d58dJtDQbEdvDe6eYxhWfUqyYLMQKyqa0+bMMPlTMgVjlza2MByVn3Rr0gfdAs+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952723; c=relaxed/simple;
	bh=KVBH37kHK2Qz1ppns2binekf7nxXneGxiYGJArf39Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGBc7KTo7dLdnp2zaejW7CuImo7h2XpoZjMn6RdMBKVzMokg8WX008gz38Va0iVgCUy3jsfv8pkNYhKT63e74aHCVX7JN6l0rz8Mj6+FjbGg1DI1KogynW6Vq3hk7VRsE1xRSUntJ+SQUdPbWcRrkNMdTvuDMyoPNd8hceSmsHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGdRa5Fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGdRa5Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F581F00A3E;
	Thu,  2 Jul 2026 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782952722;
	bh=FwU9jtKSUKMl/sbUhVAEup6JZyGjMrOu416Td6SVJyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGdRa5Fw6zDSubA5nRRSS2gvL9dZT9p5OFlItsA+FyYVWSQupSKq3Xood4+zCZwZX
	 gvhroc8TXpsyPinXAS+EzSubi5y5yGNSro/c8IQkfwW2ogwOonAXHMmHiMPv55Sz7m
	 sWT6T/yW9cWEb8YfuPm8pA3YW4Cu9ATDBnPqMCfItTzvoQSV69vcLCXjYvAjufM0VY
	 qHJyDOUnqtr4c333xWgOiCWNqb6dBMkhqFFpGdHCvJwEpDMr85p9iBHeqFabFGC6pK
	 f033sYw9wom96yTqAkOFmrV7b05a03NsF/EwQGLZrBLPFZcKH0fOsPzj5/mNU8Qy2l
	 J6cPKiYnviZYQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuto Ohnuki <ytohnuki@amazon.com>
Subject: Re: [PATCH 5.10.y] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Wed,  1 Jul 2026 20:38:26 -0400
Message-ID: <stable-reply-ext4-inline-510-20260701193800@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630164255.51218-2-ytohnuki@amazon.com>
References: <20260630164255.51218-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Add a bounds check after computing len, returning -EFSCORRUPTED if the
> value exceeds PAGE_SIZE.
>
> The upstream commit replaced a BUG_ON(len > PAGE_SIZE) in
> ext4_read_inline_folio(). In 6.1 and earlier, the function is still named
> ext4_read_inline_page() and the BUG_ON was never present, so this patch
> adds the bounds check directly.

Queued for 5.10.y, thanks.

-- 
Thanks,
Sasha
