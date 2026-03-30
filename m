Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE4D3822B7;
	Mon, 30 Mar 2026 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774850057; cv=none; b=j1rtV01Td7MTMsqCSKRRHNIZBr7saa4s2AF6z76NXluEaurqcEzbj01Y56QzZz8RX2+c+vFsOJ8wcRw11qOIfvNp5JxPqY5ewG/0+dFFx39zdb/icMfEJcgCN5+yGdKYs8ecoj7kTLb5gM5Z0/Tr8R1rINHK9s/BELo+Cm3KHKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774850057; c=relaxed/simple;
	bh=NHWPgqV1btByZ8njy+xCE6DkjybPkhDIcaQOUutjxLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ij4tWae+9ezqO5wsVpGMQY5MpCBJGfrTLEzOiegbYez1YjUxE0tZw1PN9c15GustmfWL1wIxAQolTMwmWy0v4xprwoeVUpzXZ5rlRgHHa1jMtd7Y6yC+opIrKoCiJtLlzTzt+OfPw9LGI37BoRDZ8Fwc4m7FCnO+Efi53eyNWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ps7a8/6j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ps7a8/6j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u+tB+tGqHbUR2XbDZ+9FZ2AtR3hlrKUVkjTatYkvfrI=; b=Ps7a8/6j+LxeNHrOOVUBchTkfT
	u/e88TPStACBI942r6SARmhAkqhdW71uRrrmb8+ebVl94o66nlA7n4+hyIQ48pK9v99n6vp8xGvnW
	koUePpmUJhbkUut7Pfjb8b59QulIpyYUiNzvOafhNZl4pOz8wXphE8gBcgB/YWxfyohDkvWoQqoJl
	gMQ6YyZ6TEuY9PhBbV4c57N90SGjNkeESyTg/qarzjS3Jm0UlAR+4yWFv1R5QtaY3N8li0sh/2KhE
	phv9eE1v3q0i98lPXFuu8wgfbPMVHN8VTgG0AW+dMuEj28jvc1H7TBYnHDJFOP0ADiJfnkTBJ8mlE
	5R3LOjJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75Zk-0000000AelF-3jfF;
	Mon, 30 Mar 2026 05:54:12 +0000
Date: Sun, 29 Mar 2026 22:54:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: axboe@kernel.dk, tytso@mit.edu, dvyukov@google.com,
	adilger.kernel@dilger.ca, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: [PATCH] loop: block loop reconfiguration of offset/sizelimit on
 mounted device
Message-ID: <acoQBLwdc1PqIb0m@infradead.org>
References: <20260330044334.373480-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330044334.373480-1-kartikey406@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 30, 2026 at 10:13:34AM +0530, Deepanshu Kartikey wrote:
> LOOP_SET_STATUS{64} allows changing lo_offset and lo_sizelimit while
> a filesystem is mounted on the loop device. This effectively mutates
> the data visible to the mounted filesystem, which is equivalent to
> writing directly to the block device.

Increasing the size certainly does not do that.

> Export bdev_writes_blocked() so it can be used from the loop driver.

I'm not sure exporting this is a good idea.  Besides the growing the
device part above, if someone insist on changing the size, they could
do this just fine with a remove block device, so prohibiting it locally
just because we can seems odd.  And exporting a helper with obscure
usage for a strange use case without documenting that is rarely a
good idea.

> -static bool bdev_writes_blocked(struct block_device *bdev)
> +bool bdev_writes_blocked(struct block_device *bdev)
>  {
>  	return bdev->bd_writers < 0;
>  }
> +EXPORT_SYMBOL_GPL(bdev_writes_blocked);
> +
>  
>  static void bdev_block_writes(struct block_device *bdev)

... and if we were to make it public it should be inline, and in a
separate patch.

And if not this would still add a spurious empty line.

