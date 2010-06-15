From: Christoph Hellwig <hch@infradead.org>
Subject: no buffers in ext4_writepage?
Date: Tue, 15 Jun 2010 12:29:57 -0400
Message-ID: <20100615162957.GA14500@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab0FOQ36 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jun 2010 12:29:58 -0400
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat Linux))
	id 1OOZ1R-0004Ls-Nm
	for linux-ext4@vger.kernel.org; Tue, 15 Jun 2010 16:29:57 +0000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_writepage currently has a and else case after the
page_has_buffers() check where it does I/O if there are no buffers
attached.  But given how ext4 uses a write_begin method that always
creates buffer, the normal set_page_dirty which creates buffers
and a ->page_mkwrite that creates buffers I just can't see how that case
can happen at all.
