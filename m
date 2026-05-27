Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BF73B0AF8
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 19:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911401; cv=none; b=RIdlfcsBpGKjHZd4eKSXpaF2TNTDkQJKGGxvVT9YE5ijKQPCNypLbeFV5izuXxt3nwMUNzGdkzkzXlqMHc2NlQG9vWUctAIYZ1EyFOrhzNZI/pWDmtmc3wEv1GDbh3/n+u6BaiYXjnKWhJvzhIg1ml7vQJN4Azsac0soE1p+xJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911401; c=relaxed/simple;
	bh=39tktjVEQd6+zr//5aHm296biAPzFAZF2fjSuZq7Two=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZJuie2w4ZFF+aQGWaWFQkULR599v+LuupcFjzYFc/0YclQJ1bAzcBMNZNQgbKhi1ruY1geaFDLJ3Q7cjGJRcSVcO+kx9P2zN4OjrSBsT49hc6yAmUOOH2soH+IKagr3WaVHcpiTJbMXAe4g2F7tbrfzY9YGHdC52f4ZHOy5cdao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Nb5TEOnR; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Nb5TEOnR"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8419ab3a297so1553116b3a.2
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 12:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1779911400; x=1780516200; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39tktjVEQd6+zr//5aHm296biAPzFAZF2fjSuZq7Two=;
        b=Nb5TEOnRZGhj0er0IE7x3uivwSAfy9B6vjQgjjt01zCv2/T98gPEVCWr+a8jVoPKwV
         R1Pn/O9uEZX9I77V+ZDLIkLAx+AKUhT1l1Nt5dxYybTtOSGfssavmZ4X5kPGwd7+430o
         WyHDktSaaulPpgEe+eWb3kuW90BhryAyzcx4FQwVKskUr1swBLf/qtd/QmrJVWIotDdd
         DZk6A2GCNm/Qs7sGpmeNTo8Si4Qq/6p+gNEdQtO4S27AqG+QbpDhQgWCMqDaMbQtDQdr
         ZYdQwmMkA7aVE2qiVMagdoSP/1KRcO0tcqaB+j5+J5jPGeja1h8t2u6Bly8tddtMvPcW
         0+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779911400; x=1780516200;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=39tktjVEQd6+zr//5aHm296biAPzFAZF2fjSuZq7Two=;
        b=kG9fGnOP0lRZpRxeje1Jhs/ztdet6phX0ZjxC4/5GOzEYIIgGle6Ez1dzIYTa5kqKd
         vtBUKV30EybLZXmg2EeMjXN6t68FAG+oRoprUxSyMA4ALbdOsVnwOxXqHvgP624rJBa9
         NhKAjA5qcuzBIplH/bbbAJTg4g+ulnxNkliWQqKIbPPnk1VGD/P6TitCCSk40L0K4yoN
         C9GLCVlnwdEPyavDWjg1iPwZ5A0gZwuASLKhYcDAYUKshGMfxS0zTQUtd+UiuOGGVt3N
         JQLYTx8J8YtJnnAphK/G003g9lpeFhGr6+22j5B1Q4lK0tUqV1Ft3PMNogq5Jk7jj2Hc
         SV8w==
X-Forwarded-Encrypted: i=1; AFNElJ9HpPPZAGtrvaF5KHMK21Ai2g/A8t3lO/MiZXm4BRZiqKEMJyp0fKDIuoU4WxodDekzEj5L2NMPAhY2@vger.kernel.org
X-Gm-Message-State: AOJu0Yymxtclz9EJ53QZWVh9qXvp9NIALQ5dVIPGDVVCw3pPLWy+fxal
	3Qg2oGrFnGfuXhcCOUWRu8xV+O+J5YscD/qRMGsCzvpjKzmdb051kxfbaM1gNXMzMuY=
X-Gm-Gg: Acq92OHE5NNQOaHMmVUr/aKXCjnjAQY9cIOiYJmGu0ZGJNLQJBD9NJzkPOXmDGQSZRV
	HRdQyCDsdVqGRJsrpBsggNCWwnoifeLD01Y49T5Ab1JvM7lKC8a9YTHdD0fa3gg1MEoz33GRF1g
	NZHKBzHy1zxReeXN5Yv/OIb7ihLGd4QzQ27QgdcberhbBPngqcJ+tf5hGxyNeZmKmKX/Gu2BAuO
	cdnB9gcUCSnRB2wjrii8eBRogQq70oeJ3PCgS39uqPM9ZtlXC8rztphE9xkBAWq+0RZ4muVjBEQ
	S2foA6O1TfqOPBa26KenTPSYI67Qkd5kY0l0F3dysfzItZa5eZDJR/kDnc6krK34thOSdVXcsLM
	OfrgOkLtQU1tjxXozvoua73IA10ZZZVvDI76BRsN5oaZkb4EyCgEa6zwrVWzHtxOTXS78o8cO6E
	YGUKdaZHkXSZ8psQbkCUYik5eFgM8DvzWNjsDpq4xM0yqD5MkwzvaH8iG6fV8jsffwilvVnQH5v
	8l69Wn+YZFlznEw
X-Received: by 2002:a05:6a00:2d90:b0:837:666f:8fcb with SMTP id d2e1a72fcca58-8415f0e2cfcmr24261054b3a.5.1779911399888;
        Wed, 27 May 2026 12:49:59 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6eae727sm3986613b3a.19.2026.05.27.12.49.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2026 12:49:59 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 2/2] ext4: get ext4_group_desc in ext4_mb_prefetch only
 when necessary
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260527090329.2680170-3-bohdan.trach@huaweicloud.com>
Date: Wed, 27 May 2026 13:49:47 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Baokun Li <libaokun@linux.alibaba.com>,
 Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>,
 mchehab+huawei@kernel.org,
 bohdan.trach@huawei.com,
 lilith.oberhauser@huawei.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <560F1E7C-47C0-41D4-856A-ECB9BE4BDC3E@dilger.ca>
References: <20260527090329.2680170-1-bohdan.trach@huaweicloud.com>
 <20260527090329.2680170-3-bohdan.trach@huaweicloud.com>
To: Bohdan Trach <bohdan.trach@huaweicloud.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 27, 2026, at 03:03, Bohdan Trach <bohdan.trach@huaweicloud.com> =
wrote:
>=20
> Getting ext4_group_desc structure can contribute to the cost of
> ext4_mb_prefetch() without any need, as most groups fail the
> !EXT4_MB_GRP_TEST_AND_SET_READ check.
>=20
> Optimize ext4_mb_prefetch by getting the group description only when
> necessary.
>=20
> The result is further increase in performance of fallocate() system =
call
> path that triggers ext4_mb_prefetch() via a linear group scan.
>=20
> Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

This looks reasonable, and is independent of the =
EXT4_MB_GRP_TEST_AND_SET_READ()
micro-optimization in the 1/2 patch.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

Cheers, Andreas





