Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF5E33343C
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715959; cv=none; b=GyWu+QLpQBRskJ7Oq2pVCrjhZ6Wm6i4adCC4TVPhV5o4ikD9PsD0eA9A9loccyYbsQ1m0YUkqhBnsvo+hxexuEqm4rW30NlHlnO7w8btFjcV7cCzGR4cFfeLG7Z3CSAkemM/dsMEWGyhkgXFEOciWhzs7VrdOvD30pZnwx6CWEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715959; c=relaxed/simple;
	bh=wST78Ly7/LkpzOQRxTy+uIbiDS71NCh7O9c2wHZlgMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7XeHFkOVgrdBq1K9wj4RjMlnLPnjl34hKEiBDuO92haYT59XN+EbDR9bY1G6g9XoZ8lLKtoy5CYoEmO9rVpNHCZ7M5u566ypk8nZK0VgwneYvr93MzxzeLF9bEa0CLRaBLIn/vxoBG8OskJN5igVh4jzy1jrof9Tuen6vPjbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=f17o5pXy; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="f17o5pXy"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67EDwXMP008307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 09:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786715917; bh=K31BguCwD33Oh1Lu5x0xSenQtORdIAfuCIkKeeU60tc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=f17o5pXyvWvJ0WEZeUClGSc2QdJgoy8mHpEmtbkHGTGKI8VsfaaIHCZeQITZhujfo
	 sO9VnzJKfgtnemxoiMNn+i9EAtue+Pa4N2yCMJ2QQ/ecRuZenZdTCT02hvevDN4nh0
	 0iOSzlzEXs/e0ideB3Mi9x0IjrhyBn/A1HNotpPR319D0gwX/3JLIa6CSUZj8Lomux
	 ZGVtd/aNaWZPVLh2ZenctPABnJi/lhJQfotlo7HySMmzJCHP8QUQ+hkWrnbfP/eRpR
	 b8QBFP2QzTpmzzBE6HUiiifWgHltnHIcHwx1LXu7Hxtt8erypmPlBMUGAN5A+v/voJ
	 tLuTzVDE1jnRA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 2D93DEF3FB6; Fri, 14 Aug 2026 09:57:33 -0400 (EDT)
Date: Fri, 14 Aug 2026 09:57:33 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: shuo chen <1289151713@qq.com>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Message-ID: <an8ejrZ4Q-xLShzo@mit.edu>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
 <an5_shcksPF6uIaW@mit.edu>
 <tencent_9121249A3171F5A424EC25B7912A3C794805@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_9121249A3171F5A424EC25B7912A3C794805@qq.com>

On Fri, Aug 14, 2026 at 04:40:02PM -0500, shuo chen wrote:
> Because ext4_convert_inline_data_nolock() has already called
> ext4_destroy_inline_data_nolock(), the inode is no longer in the inline
> state. So we need ext4_create_inline_data() to rebuild the inline state.

There are other ways to restore the inline state than calling ext4_create_inline_data().

Cheers,

					- Ted
