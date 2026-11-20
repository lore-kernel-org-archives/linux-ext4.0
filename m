Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207211;
	b=mN3klvaCMzHTr/Phx08Z+FNuK2hDtDWPF3sfeckhxkE//FrrdfdQndPMglT8m9xNqsRK
	 r4tU4T9cdbi3El0isiaFg2+pALOXvF5wwMdl59pj4mKeUAiAsNB5EJ6c3e6vl35+NWpGc
	 ya0RC3bPMAcx1Yw2yEAcFcB25Ajtg+ltbqtRL0b27nO8usx8ZC7clM58FnteUAI+7nwKX
	 L897/AD5bDcvSvZCU4mdYuFkyhvJ5eTj/UeQ7vVfdEB/Y4ItoOc5BAT1M6IGpZM8WC3YI
	 WH0oPQqPpqdFax2twtd6Ib71J7NS7RO7XA8YqIqWsmlfiuis9dyZMRy9QV0108NZd2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iuOAnFf7djN6MJm0xu/DSFJ+ZW3QNY44Rcjtb1OjLzk=;
	b=R8fmuxeC+vr5wp8pKgswHue3u8y5TvcdB+98B/6vbn36y3eOGgIDQv0CVH4FYfH7hmeu
	 8wFy6wC9nvEvUj+wb21/zyQhgQEl8vtf1yy3zukEFw2ezBPAYVBs+Cb+d0ssSYYoioYBa
	 PVILxu42DxvsVkaVV2arV8N6OJY3XwfKanKfPwr3b7/UDQBUF1tGqMiHqUDgLqWC/3JUT
	 Kkry+UtVd8aP07kDT80/2WTwlQQygPufV8hktgkshzHv2T46e+M8wlE7pp4amPLZkIl5g
	 p0LDuoRwE37fWpqZOtSrAoTmz7kJ6CEPBML0h0wShSDCo/Sc4I8bfbDtMUnhHYg7OEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTqbOTMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C7A606A6F8;
	Fri, 20 Nov 2026 20:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTqbOTMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66AB1F000C6;
	Fri, 20 Nov 2026 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207211;
	bh=iuOAnFf7djN6MJm0xu/DSFJ+ZW3QNY44Rcjtb1OjLzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTqbOTMgTIuk770jPL+Nut6OqaGrfpSSrSX1EnAXdx+kFkHt7nk6z2FsZ5t3XATMR
	 AVHybLaMXRN/n77mzIpEqYMKH9b92WwMtYs5JakGoM2M2f24wA29xwSGv884xrc+nx
	 A7MOufooYaYpTp2wjOT1XDLrg/Xztu4w1mgC9unLUbxwW1MC30BKiTCUlzCLNSQevu
	 AQJVAaIve6D/m/KMLrczuTlYGX12WmXCz/C0XwOqkLnG6UlLlxjRrbtjfxdMpOdSPa
	 LAWI85mZS5DBehN6NtrNgD1N7kPKJ7wzPVPR2H9YFNKPPyrV4R0rjeZEyWkIL8cokJ
	 AgsRUBfrZTZ7A==
From: Sasha Levin <sashal@kernel.org>
To: linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	"Safe-Lock.NET Dawid Partyka" <internet.jejkowice@gmail.com>
Subject: Re: [REGRESSION] 6.1.192: NULL deref in ext4_mb_load_buddy_gfp() after, dropping page cache (__filemap_get_folio() returns NULL, callers check IS_ERR())
Date: Fri, 20 Nov 2026 15:39:18 -0500
Message-ID: <2026-11-20-1-daily-reply-0029@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <81b3f525-0d62-4a46-a0f3-77d54b11d847@gmail.com>
References: <81b3f525-0d62-4a46-a0f3-77d54b11d847@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> After updating from 6.1.190 to 6.1.192 I get a reproducible NULL pointer
> dereference in ext4_mb_load_buddy_gfp() whenever the buddy/bitmap pages of
> an ext4 group are not in the page cache.

The fix, "ext4: fix NULL folio dereference in mballoc", is queued and is in
6.1.193-rc2.

-- 
Thanks,
Sasha
