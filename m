From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Date: Mon, 21 Apr 2014 23:28:16 -0700
Message-ID: <20140422062816.GB31337@infradead.org>
References: <20140421204023.GB960@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaDVG2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 02:28:19 -0400
Content-Disposition: inline
In-Reply-To: <20140421204023.GB960@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +# check that xfs_io, kernel, and filesystem all support fallocate with zero
> +# range
> +_require_xfs_io_falloc_zero()
> +{
> +	_require_xfs_io_command "fzero"
> +}

I'd rather remove all the wrappers around _require_xfs_io_command, they
don't actually add any value.

