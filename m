From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Fix aio completion vs unwritten extents
Date: Fri, 16 Jul 2010 02:04:05 -0400
Message-ID: <20100716060405.GA32712@infradead.org>
References: <20100622122144.302857146@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0GPGEH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jul 2010 02:04:07 -0400
Content-Disposition: inline
In-Reply-To: <20100622122144.302857146@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Given that this still hasn't been picked up in any other tree would
people mind if we push patches 1 and 2 through the XFS tree?

I some more changes that sit ontop of this, and it would make my
life a lot easier.

