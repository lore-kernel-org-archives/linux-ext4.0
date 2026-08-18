Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E8432B110
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787061025; cv=none; b=mnp+pknjoLuXn6gAA152qN2qfHu6+j36owGylidJzwnxI/xvq+0wOuuRJDqBJ6s6TugBLhZrYExCTae+jM3DRflXme0TidPtBqbDNvj+6HJYuRkYkIoGYvY6P2UumMKh1eTohAZyHCIvHaxOHximNtAB2cTIr1VRKmBESRSS9ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787061025; c=relaxed/simple;
	bh=B2PuV3/05qk6SjAYqkwKlU6IMqwAkO5wM+QAuBJ3QoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUlqFEw0hgIHJUV4pI2JkgRxqcyB/HtZ2yJrB2FnDIoGq3Zo9HRiLAexgyds3A8EHGhU7u7SbhTC3mw8yxpfmwZ6xmMgTgiVG2VKv/nGBXLczejJ9qnSGQNmuHFQi6prxPTEW0427DdJLphIdhmXsHHyrLrmTX8GcoLWr8hlTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ivHXg04m; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ivHXg04m"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67IDnijA022115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 09:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1787060987; bh=GP5cxkl6hTqE38dp+RDa6yGSkZwY5WXGHiBBV0ZUPYM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=ivHXg04m8AAwtkVwbzPF48pB1AYOLUHjs/H1+CS61mFkDq0ROCwAUbVh9D8g94LNY
	 2FlmN/+Fcs55WWdg+HO5zfKMqRz8Jse322nCbf34JijY+zX2laHbNTCoPnA9jvb9En
	 CjxymqQJ1xW3sq+jj5ZUcj+rObdfxuNXX5ZrImDoMD2EoyvojkhO5eirvcBxSkJsna
	 RxGOIvV6qDmwO6D7mCOGHH58gByl9HZ+I+PZ7rhic0d8DnNdTUklBzwUXns3gCbBXd
	 hpNrhfYxLLJE52on8emUqfo2c2Vl3s6DrO9wUXSxB4tEgbTUN7NNj/4/g157hOt6We
	 8INIadeMG7bew==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9A566F763F5; Tue, 18 Aug 2026 09:48:43 -0400 (EDT)
Date: Tue, 18 Aug 2026 09:48:43 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Guanghui Yang <3497809730@qq.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext4: orphan tracking after a failed truncate
Message-ID: <aoRhIeFzNqHg34jg@mit.edu>
References: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
 <66vcv4ircw5mqadt4eki52hujmykrrsqp2cux4qvn37v6kzvs7@d7ys45emz3dr>
 <1537a281-aa34-49f8-87f1-e5f4fab8eb10@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537a281-aa34-49f8-87f1-e5f4fab8eb10@huaweicloud.com>

On Tue, Aug 18, 2026 at 12:41:57PM -0500, Zhang Yi wrote:
> I think we might want to add a small qualifier here: this is only expected
> behavior under errors=continue. For the remount-ro case, we immediately
> abort the journal to prevent writing out inconsistent metadata after an I/O
> error, which helps contain the damage. So after journal replay, the file
> system should still be able to maintain a consistent state.

Errors={continue,remount-ro,panic} only apply if the ext4_error()
family is called.  The problem is that ext4_ext_remove_space(), which
is called by ext4_ext_truncate() calls read_extent_tree_block() and if
it returns an error, it returns EIO without actually calling
ext4_error().  So the truncate system call will return EIO, with
i_size set to zero, but with blocks beyond EOF still left allocated.

As I menstioned, that's not _fatal_ in that case, since blocks beyond
EOF can happen with fallocate(2) with FALLOC_FL_KEEP_SIZE.  But it
could be a bit surprising, since truncate return an error, but the
file was actually apparently truncated (or partially truncated, in any
case).

We could change it to call ext4_error() which would signal the system
administrator would get a clear signal that she should run fsck, but
in terms of bugs, it's not as serious as if the file system was left
actually corrupted.

Cheers,

					- Ted
