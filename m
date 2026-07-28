Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2F37F312
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 04:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213797; cv=none; b=kQq9yJLcw+MyjF6Xz/z5RcTmpXQHnxDoJWDoDYAruQmtxrn6pW6Zo489YpmoeogL5Z7OecG3jjDXF4CZ2V2pmVADz85rGKWJoDT68SRk10tskTBeitidHuAlaxwyBXP8WDGEKennyh8emHwGesTwJykG+bkvrplSvxUMQ14O8f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213797; c=relaxed/simple;
	bh=jJpszBGoy5FGOyrTjZQKznWbaJbD+UBBe4S38IMy5hI=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=bKGP8q+twMyNRcOpy4i9Af13gyp9oYoNG2x1qUurareziintL6h2jM3GniuGxd7Cf4MI2RMAHzqQaRDd6T/yeXr8pdSkiQh47/DbtWoFCoSHMSYQNyKdt5s5wDGVdveFe3lE7NlEv4pHoUOr8TO1X1JPCUER174PYLb2NRgQj48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsCflSy/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsCflSy/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cad8076b01so42693875ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785213796; x=1785818596; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nUw5BzeKJfn5wcTEAmcbsTWk7Oaq7UZh5ULj7ews2Z0=;
        b=ZsCflSy/C+oge9NjKaEyU+xuohZSnshGxBTfVLUibs7nUId7ELuBIXmrAj9iP4Lt5b
         4xPS/Lc8uFXDujO0oEZ4VILDTkvVxIuB925HSkCLjtKX6YCBXH9nrHO89UURTr7rrOAC
         GT8lPyo8R1+5GFmZ+/ZjGD+7+2s5PGvSE1DKfUNYmZzgN7utxi7uY0No4hU61UQby6Wq
         3Tq2ASm8w6nqvPtLZJv7kLifeCIpSOo5DL/PbR4wVZDqVRoXdPflgV2A9wGLEyZahqDh
         qvfk+BRqCY7vCNSxhvUCjCWqoLPX91PsyKhOTLKnw+OhhK4zZejk4tSK0Y0+U6Fprw2g
         JvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785213796; x=1785818596;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nUw5BzeKJfn5wcTEAmcbsTWk7Oaq7UZh5ULj7ews2Z0=;
        b=jwDkh2x4sozgzyn+j3tupqwGB/Gp91D9jpbyQ9dGbwhq/qN//MVhthn6OY4j3lQi0Q
         1HCjF5tFlnGD/qeIGSzHNrCBD+6gkrZi7pnAZD7iRzGsJbwBHxSavUiEwLS0JHBT7VvS
         gt4bUOPPQvklNYqTdYmup2l8o/gQV5OWz8+WYCNM1JpAs3RU1tUqcQvSCxLi5k7Hogu3
         qWqUR+6UNDIzdyPbf6l+r8uQoK/f+gfwLiak3TiP42SaPkQF3i2EMGthEr+FTDdRz9fE
         aKzYivTbbNEsNcsb7ew0FunG73M5ycLPMFTVlvIDMvfLau9gDTsGjSmIrKILhE2b/bWe
         xkGw==
X-Forwarded-Encrypted: i=1; AHgh+Rqa/FUmgMSRkMdl2hBc9P0BLcn8ObAcS5LcZSygQ9TW26kqSVbpGjmIHmk4L3uEgEwR9RtzW7zZQfMT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmso2kKPYIaaDRtpTPEcN2n7IHrTiedao89ON5o4XlCUEXjOzu
	tWR9uRJbc+yBW5XqpaKwInQNiZOi82nep9UwLhAC9X2oqxs9kXmoIXGx
X-Gm-Gg: AR+sD13YALRaq3Cuzyxi5bQdSVoJCJOaF7WCgUDChTLQOvtf7a5l5iC+ftvxAX5gq9W
	eEnm58dkdOeGQc0UY63PkIVMWaL0NhICndILTny/WXIe2t77jNqcpVj6qQHMuNVx4e32hNzoZoP
	0dQ5XXZIFPGdwu1/o2VCLpR9JP2Sn3k6GT3lFljqLZ9A2dx4NzvrYrgq3vxrlTFrNfh5g9Sjw70
	Zt8L6u8KDu2iPzjUJIl1AhQWeqgfsm5+S2vi6UPwZGap0JQ2KZoFBLOnKWPzM0nFjiHomCqct8K
	ZC8E3JjP95au0nTxY4SaH6sXHhcXWNyzucniTGvIUjqKmgHiXaq5R2eg/Babqp/AKYwYfc/mTUD
	BJnF6IiA0eQhwRN9M2t8sS89/UT/LtmTE0FoLe1w/zr0WthYgfExz265RjnoizyHRnR8zwB/Sy4
	Y9
X-Received: by 2002:a05:6a20:7d8b:b0:3c0:9c1a:893c with SMTP id adf61e73a8af0-3c8ba650afbmr1226800637.68.1785213795815;
        Mon, 27 Jul 2026 21:43:15 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc549b11sm41150994eec.18.2026.07.27.21.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 21:43:14 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jiazi Liu <jiazi.liu1984@gmail.com>, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jiazi Liu <liujiazi@amazon.com>
Subject: Re: [PATCH 1/1] ext4: fix incorrect function call when initializing s_resgid
In-Reply-To: <20260727104103.28916-1-liujiazi@amazon.com>
Date: Tue, 28 Jul 2026 10:10:07 +0530
Message-ID: <cxw7n2vs.ritesh.list@gmail.com>
References: <20260727104103.28916-1-liujiazi@amazon.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Jiazi Liu <jiazi.liu1984@gmail.com> writes:

> In __ext4_fill_super(), s_resgid is initialized by calling
> ext4_get_resuid() instead of ext4_get_resgid(), resulting in the
> reserved GID being set to the same value as the reserved UID rather
> than the value stored in the superblock.
>
> Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid and gid values")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiazi Liu <liujiazi@amazon.com>

yup, that clearly looks like a simple miss. 

Nice catch! Wondering whether this was caught by code review or did you
hit an issue due to this?

Looks good to me. Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

