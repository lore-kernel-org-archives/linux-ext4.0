Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80FD372B34
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623555; cv=none; b=NpV34ljeyPupMDgrmxPKAvr4L5m5UNbqsfHjp9Ckx02+lGI+adahycGSTa2hdjHDzPNsj/r9Yk97+xX0QcHMEKsIiCZCjgnX53i0j+tmbpVwYOk04h4+vaZPL43g1qn3eYnFkrW6+sjMGYRnGN553NBzmXyhJuPfxFYOX8foV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623555; c=relaxed/simple;
	bh=D1mwYmnXknXxRl67ZGbCzKxP+qjkAVZMy2CshD1n9hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uop25dI5+falOI022KazlbGHfeiwZ53F0tzE+l0FNjzFi1Zh9Rwc2FyWnAkTv4L71Rm/p3Jeah4tTgMKoR4KU3AfJULumeZ0YKkVFL7TVsGviuhx8WvbL+YZFBrRLdnIRn//fzkhK0F3IMZ67r2MdhCQ2082102bMGpuoLKcQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=i1q9Soda; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="i1q9Soda"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5IoC028725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623521; bh=7aUSve3/VXiQXGnG/36SggaKnjAb8aAI49S/pnfxloY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=i1q9Soda6eSjzG7dUpnptuSoPnDXjTLG++FA7eajQcmwhPYubieRV0aq03K8ooqOz
	 5RqfYW86ZLq7kzK1Kbs/rq8T+v38FF64NU53KvFWqqSWy/kY2/kauMn6Ta04OCYMBE
	 iu0b9P43LoOrrg3O6vVv4x7QTvxZ9Ul3WB5N0Gw7CpAQVgMMrrCucDQ3R+zq5SiBf8
	 Fe8RDZ+GkiX6pOqQDO/nTnw+Ed4wkZcGA8zqjXwzgXlWQOI04hXtQvVOYDgxI+TWm4
	 54rYVTZEiEUGL4AI4/ZKuuCD8cYSwRyjIsIanAzxtd6fhK2cpAgGhygy/RASc9VPI5
	 ww6FyobbW3tdg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 23B192E00E2; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        yizhang089@gmail.com, libaokun1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH -next v3 0/7] ext4: defer unwritten splitting until I/O completion
Date: Wed, 28 Jan 2026 13:05:08 -0500
Message-ID: <176962347635.1138505.711374628761751303.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105014522.1937690-1-yi.zhang@huaweicloud.com>
References: <20260105014522.1937690-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 05 Jan 2026 09:45:15 +0800, Zhang Yi wrote:
> Changes since v2:
>  - Just revise the wording errors in the commit messages of patches 01
>    and 06, no code changes.
> Changes sicne v1:
>  - In patch 03, add a comment explaining how DAX writes to unwritten
>    extents, as Jan suggested.
> 
> [...]

Applied, thanks!

[1/7] ext4: use reserved metadata blocks when splitting extent on endio
      commit: 01942af95ab6c9d98e64ae01fdc243a03e4b973f
[2/7] ext4: don't split extent before submitting I/O
      commit: ea96cb5c4ae3ab9516a78b6b435721a6c701eff4
[3/7] ext4: avoid starting handle when dio writing an unwritten extent
      commit: 5d87c7fca2c1f51537052c791df694dc3c4261cb
[4/7] ext4: remove useless ext4_iomap_overwrite_ops
      commit: 012924f0eeef84f9bdb71896265f8303245065a8
[5/7] ext4: remove unused unwritten parameter in ext4_dio_write_iter()
      commit: 8bd1f257af1c21d34f8758f4e36854970e1dc2f5
[6/7] ext4: simplify the mapping query logic in ext4_iomap_begin()
      commit: 5ca28af074ad506c95a8f86a5d260562f3caa39b
[7/7] ext4: remove EXT4_GET_BLOCKS_IO_CREATE_EXT
      commit: 5f18f60d56c0cedd17826882b66b94f1a52f65ef

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
