Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA623B61B;
	Thu,  2 Jul 2026 00:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952721; cv=none; b=dDyg6hR3WxH8LxncgkHBy0OBYf1hV6X8lHAdEsHbevodg8Z11vXQOcbJPWZdb0w0+FTkPurMMP1kuFe5+EcEA9qOHzeMx+qT2Pz0I9fWjZtyjg2AfUXZFiISvyKyClxZH1wtdVT6F6vw758wHPCCubnTnTaanZ962dKLDGb4T7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952721; c=relaxed/simple;
	bh=aRG4O+I6jK55hPDMKWhHXFa1eKpsXzBYh+ww3EGsXDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCVtQArmHIXaCn9XugJxfM/0jVgomJpKUibLAQhLO3N68qpA8XmeT/ioUMMOJBSaJFCFIoGDN0VYNLLe3hXbCliCt5rUel8flXq16qUx6VNFM21KVq7hb4LPZ5XlHrMVqegCE8vrHbjJzVE0nBdYemWofJVxuffXSC5hZuMUmrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JN0GB4kO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JN0GB4kO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BD91F000E9;
	Thu,  2 Jul 2026 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782952719;
	bh=2VNvMz/Bancvl/GRZoT7uvBoPMV/wa1vgslEmo+Ns9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JN0GB4kOScBsJWjNpGt6HqG3zHqO8Q6IQIjxH0bX3Ryzz0V2jTQQXqoPldPHyTLsU
	 nbx9o4oYzBODC5ZFkFllBvS1ZW0WdiBu8x/72q11fR6MXSV2H+T6CZl/fgi9RTODaq
	 Fewdztl+dMOUwYu3eY90CDtTRUB0N6hasJeQswSDmcM8U2IeWQ4GkSwl/DAZTcupKm
	 +W388wuXBGXVfqTSSxnGS2z14yQ9axm52ofJrFQZyThgAT97qmJFJc6U8vJqqTebkE
	 tU5nmdG+fN+d/6htWbCCpbkP+Okt9He8Mq6PnJTEw2Ia8yizHBgpguu8V5o1j657j/
	 Gmlv/9hBCoHDA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuto Ohnuki <ytohnuki@amazon.com>
Subject: Re: [PATCH 6.1.y] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Wed,  1 Jul 2026 20:38:24 -0400
Message-ID: <stable-reply-ext4-inline-61-20260701193800@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630163552.47781-2-ytohnuki@amazon.com>
References: <20260630163552.47781-2-ytohnuki@amazon.com>
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

Queued for 6.1.y, thanks.

-- 
Thanks,
Sasha
