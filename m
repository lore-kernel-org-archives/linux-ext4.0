Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF522439F90
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812168; cv=none; b=tWCIwOeCyMbQSZ2BdIw+sf9D1lZ/uVAybHtlDRK/VcX3ssvRfQrC2f+CtNSv+EVZOH0h7ouxPZkvLldbjuTYcQ3mYMcy2TpooLsG3cqKVTXkZz1kxT+8co9ccM12Ub7cKUiMMp+nz2blP+uVpS6k2t4k4YyH99SZ6K1aa7I12Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812168; c=relaxed/simple;
	bh=2WW+2y2v1ZVhu+elD4tK82Feo+erZF/GwRx8FBzPmPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2sGmUZ97giPDp/noAnStz+xT+uelfdKm+DsPOkW1h3ip0KOFEWkHo2ueP+E8QJykp0W5gPCfCpJSdy7CdUZLSOdWSjqdG9Ktj1225Ga62iPPVZWYNi7i5VhrHdSQ24GvP8xibG5cx/0cvVgxbDe/OP1KqV7onPdQxdIaNMJWb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=EXno2DNm; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="EXno2DNm"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND94pY017992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812147; bh=LKVxr0xTQzKjaXQU8ZiYg2fjficBWHYOpDWMAGTS8FI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=EXno2DNmXd9lQ7e9IQkghun5zV2gGHEfPJ99POBqeCjBaqM5NAW24uTem8UAmnXZr
	 qcnHEvAIAOE/mOoAN1UsVpzj1Vbb/45W4EqCgGkfb8AYBFjdbHWFgO1r/ymLXQCIwW
	 +iZBYdVcjFRJXoVqa4Oo2CxA8dFwrfAZLcZJHWbTq6xug6AhHSqO8cXrFpnziSgMSx
	 Ru7DRS+Pn3TIKQdOSmMo7LVhRRVVE6LFfYVaQxALZ8/SeN6moLGtbW2afgPeboP7sY
	 3D4RQoGNoSbyPQHMBgih7BWkMaesEhW4wtIa7n/UHgsWdArHenW2YGHFJ5LrPlHGOj
	 C/7Vqg+i9Nbjg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E4D772E3F26; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ebiggers@google.com, Yun Zhou <yun.zhou@windriver.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Thu, 23 Jul 2026 09:08:54 -0400
Message-ID: <178481171723.796182.8994536002589226058.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612005330.1930804-1-yun.zhou@windriver.com>
References: <20260612005330.1930804-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 12 Jun 2026 08:53:30 +0800, Yun Zhou wrote:
> Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
> circular lock dependency between s_writepages_rwsem and sb_internal
> (freeze protection).
> 
> The deadlock scenario:
> 
>   CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
>   ----                           ----
>   ext4_ext_migrate()
>     ext4_writepages_down_write()
>       s_writepages_rwsem (write)
>                                  ext4_evict_inode()
>                                    sb_start_intwrite()   [sb_internal]
>                                    ...
>                                      ext4_writepages()
>                                        s_writepages_rwsem (read) [BLOCKED]
>     iput(tmp_inode)
>       ext4_evict_inode()
>         sb_start_intwrite()         [BLOCKED]
> 
> [...]

Applied, thanks!

[1/1] ext4: fix circular lock dependency in ext4_ext_migrate
      commit: a897682793eba5de51ee6f3152760374afa629cf

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
