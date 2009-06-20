From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: basic fallocate boundary tests
Date: Sat, 20 Jun 2009 13:58:24 -0400
Message-ID: <20090620175824.GA3984@infradead.org>
References: <4A370C2C.6030404@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZFTR6W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jun 2009 13:58:22 -0400
Content-Disposition: inline
In-Reply-To: <4A370C2C.6030404@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 15, 2009 at 10:06:20PM -0500, Eric Sandeen wrote:
> This is just like test 072, but using fallocate instead
> of the xfs ioctl.  Just very basic fallocate tests.
> 
> Also adds a "prealloc" group (./check -g prealloc)

Looks good to me, and does the right thing on my 32 bit test VM (notrun)

> +echo $testio | grep -q "not found" && \
> +	_notrun "xfs_io fallocate support is missing"
> +echo $testio | grep -q "Operation not supported" && \
> +	_notrun "xfs_io fallocate command failed (old kernel? wrong fs?)"

Maybe add a _require_fallocate as you need the same check in the next
testcase?

