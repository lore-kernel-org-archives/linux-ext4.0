Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144A73C1996
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777032527; cv=none; b=bm4OwLeFl5OSkAcoTvxhtr+o2ptuvnOR1q+Y3f42xntbkDfOLSLYD3vVPFFUF4kONPJQIGdGdlY7VAbfPAahlKMBny+83TpgRfe1CkTwGAO5A6GByTiNhLhrITj6pthaqAz0hB+12JClHrwQxPnOvXO1RDK8r93phIKnTOtgEeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777032527; c=relaxed/simple;
	bh=w4lmsQXoC/1qOByU0TCBKPJTxy5uagZ1FeFlRykfQD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSYFtUhPgInTypfFTGzAjgNKPG9AbVZcgxmbsGkQP0BWRiyG6hYLU5e0ZmVWv9H5G7MfzPoHWkc3RQYFk4xQqIAw00NwU0P1E8TrU+otA4W22Lp41qqVtQ6Ft4BUEXAVUdvqGGl9LrFMfXSnPIVrzgf+hGmWCtqreaugAixm6UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=kXcoI1Gz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="kXcoI1Gz"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63OC83np029927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 08:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777032487; bh=siS+ZkVoVtC+efYqlUke6xPwPLnUCCfkCOM5vSG3nTc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=kXcoI1GzLsfYDgrACAEtc2c954EmLSMnoVK1N6j8hj5Mm5S3af8owpeNcwRN2s6Tp
	 bXvlbVxTBp5VkBa4Jxh2FgWxv5R14dtYe0n8R1KLAFn1ih/LQkbPLeMwEn31FbMBDz
	 37Wr6uGcM+LUxYb+79ChvtdE8Yx+O8vqkenSstD6YwvjI++ubWq3NIJWAprTdh/Yry
	 pfUZ59/sSQmKmxUpbRGoHOCT05eMlH2J7HTccwSrZ3Z6YsXKjxK/CaiwwACZLcheHr
	 I+V8SPN3WUdUPrerrSPoE+anbSjvaBcuniluua15v1hk59OMUc5tT88sjA+1aMbd62
	 pf5D4qhCFs+Dw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 80A7764E1BF4; Fri, 24 Apr 2026 08:07:02 -0400 (EDT)
Date: Fri, 24 Apr 2026 08:07:02 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: liubaolin <liubaolin12138@163.com>
Cc: libaokun@linux.alibaba.com, adilger.kernel@dilger.ca,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangguanyu@vivo.com, Baolin Liu <liubaolin@kylinos.cn>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
Message-ID: <20260424120702.GD11127@macsyma-wired.lan>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
 <20260423161947.GB68318@macsyma-wired.lan>
 <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592456a9-ce45-4967-a7c4-4ed80e908bac@163.com>

On Fri, Apr 24, 2026 at 04:09:31PM +0800, liubaolin wrote:
> 
>    2. Do not delete the `/sys/fs/.../mb_stats` node for now; implement the
> same write control logic.
> 	* Write 0 to `/sys/fs/.../mb_stats` to disable statistics collection.
> 	* Write 1 to `/sys/fs/.../mb_stats` to enable statistics collection.
> 	* Write 2 to `/sys/fs/.../mb_stats` to clear statistics counters.

We could do that, but note that currently writing to
/sys/fs/.../mb_stats just sets an unsigned integer in
EXT4(sb)->s_mb_stats.  There is no ext4-specific function that runs
when /sys/fs/.../mb_stats is updated.

So either you have to add some check in fs/ext4/mballoc.c which gets
called every single time a block allocation happens --- and consider
the race condition where two CPU's are checking s_mb_stats at the same
time, and the desireability of adding a spinlock that would need to be
taken every single time a block allocation happens ---- or you have
add an ext4-specific function in fs/ext4/sysfs.c.

>    Compared to your suggestion, I recommend using the value 2 for the clear
> operation because s_mb_stats is an unsigned int variable, and using -1
> requires changing the variable type.

Well, since you have introduced an ext4-specific function which gets
called when writing to the procfs file, that function can clear the
statistics counter when -1 is written to the file --- and then set
s_mbi_stats to 1.

Cheers,

						- Ted
