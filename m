From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Mon, 20 Jun 2011 16:32:11 -0400
Message-ID: <20110620203211.GA2290@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37460
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab1FTUcP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 16:32:15 -0400
Content-Disposition: inline
In-Reply-To: <20110620201533.847236272@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 04:15:33PM -0400, Christoph Hellwig wrote:
> This series removes it in favour of a simpler counter scheme, thus getting
> rid of the rw_semaphore non-owner APIs as requests by Thomas, while at the
> same time shrinking the size of struct inode by 160 bytes on 64-bit systems.

This should be 160 bits, aka 20 bytes of course, sorry.

