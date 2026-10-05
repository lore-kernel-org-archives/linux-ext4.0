Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2312543C058
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 09:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791192293; cv=none; b=An0iZHwYIg9/YVXWDdiut8idyvy0T0wogKt9QulNc5c8y+zC+Y3v+jLuvVzKbxl3HpNgpx45rMMpF7gJuPUlJ/yWhUdDxz8dj464YWUtIHLDJkm+nvoUXUROtZ8C7Fev6HGrRlcut24OKiNcvxDtUEu2If5v5EhC0/+ss3QN69c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791192293; c=relaxed/simple;
	bh=1fVnP2VPrFhD4is/yUTqDxpgbtHb6zWEju2Fw2t7dE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmHmoeRR5SGJ9Y6yBWOI/Eko6+LPGNGmPOwW5XnfUnL3kJFUfaq73wgXwQMmkuDfdQtocJm4f8hLPQn0XqIhs7bAn2fhy99xdsx+2pEyKBlfCMBd6s6khFlpcy9gNJutB8MYuxdg3ZRQ9tqCl+8ophGV/2vcKmZlZkzxCGLAE00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HT7vDx2Y; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HT7vDx2Y"
Received: from macsyma.thunk.org ([151.240.45.26])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6959NVCI010944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 05:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791192222; bh=LfR/ecHbJryzXbl3NJYXU0egVbqlkkMIxT7emsQJ6xo=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HT7vDx2Y24glFhfkBZal0F7B6KH+KVYLpbxTjgrp1ydux5mAu4LEE+gyQPCO6x4kc
	 hx+QSh+VkK8Wh7ipA2X1Q10H3Q5vuMHaQ6v2LpO50DXCkqdibzKWU4QAsdkVDf2+dE
	 KxSxVulF1vlswQHP8CitO7J3tXkoOI2UxONmyrvUIElMFItakBepZxr8UHcFTxFq3U
	 vOndOqy78yMiM7AFWKQ6Emdkk0if49FK286jks4BNQHAtWUVo3fvl/FA5CL+bYeWDL
	 DqdmK6a3InoEyxPr/pyYqK/x4wz/hKdJmTWexGzdfqQFERmndxIc3wnM+MoE7ZNgZX
	 8FlPybNT+bXog==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 2FF3F1F100E8; Mon,  5 Oct 2026 05:23:31 -0400 (EDT)
Date: Mon, 5 Oct 2026 05:23:31 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
        yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, wangkefeng.wang@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v6 11/31] ext4: implement buffered read path using iomap
Message-ID: <asNrmCSW8UjpyfRv@mit.edu>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-12-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903123543.2302999-12-yi.zhang@huaweicloud.com>

I tried running "git am" on your patch series, and after resolving a
patch conflict manually, I ran a build check to make sure things were
still building, and I ran into a couple of issues that caused the
build to fail:

On Thu, Sep 03, 2026 at 08:35:23PM -0500, Zhang Yi wrote:
> +static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
> +			      ext4_iomap_buffered_read_begin);

/usr/projects/linux/ext4/fs/ext4/inode.c:4016:8: error: type defaults to ‘int’ in declaration of ‘DEFINE_IOMAP_ITER_NEXT’ [-Wimplicit-int]
 4016 | static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
       |        ^~~~~~~~~~~~~~~~~~~~~~
       /usr/projects/linux/ext4/fs/ext4/inode.c:4017:31: error: parameter names (without types) in function declaration [-Wdeclaration-missing-parameter-type]
        4017 |                               ext4_iomap_buffered_read_begin);
	      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

> +
> +const struct iomap_ops ext4_iomap_buffered_read_ops = {
> +	.iomap_next = ext4_iomap_buffered_read_next,
> +};

/usr/projects/linux/ext4/fs/ext4/inode.c:4020:10: error: ‘const struct iomap_ops’ has no member named ‘iomap_next’; did you mean ‘iomap_end’?
 4020 |         .iomap_next = ext4_iomap_buffered_read_next,
      |          ^~~~~~~~~~
      |          iomap_end
/usr/projects/linux/ext4/fs/ext4/inode.c:4020:23: error: ‘ext4_iomap_buffered_read_next’ undeclared here (not in a function); did you mean ‘ext4_iomap_buffered_read_ops’?
 4020 |         .iomap_next = ext4_iomap_buffered_read_next,
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                       ext4_iomap_buffered_read_ops

I'm going to assume these issues got resolved later in the patch set,
but I wanted to point this out since this can make it harder to bisect
the kernel in the future.

Thanks,

						- Ted
