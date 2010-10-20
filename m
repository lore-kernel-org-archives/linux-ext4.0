From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] writeback: sync quota after inodes writeback
Date: Wed, 20 Oct 2010 11:11:37 -0400
Message-ID: <20101020151137.GA17793@infradead.org>
References: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
 <20101008170806.GA23129@infradead.org>
 <20101020122552.GB3335@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@gmail.com>, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0JTPLl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Oct 2010 11:11:41 -0400
Content-Disposition: inline
In-Reply-To: <20101020122552.GB3335@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 20, 2010 at 02:25:52PM +0200, Jan Kara wrote:
>   Yes, that would make sense but then we have to change quotactl(Q_SYNC,
> ...) to result in calling ->sync_fs() as it does now. Because we have
> to get quota data to disk in response to this call.

That's a callout from the quoatactl code, which we use the quotactl ops
for, so keeping it sounds fine at least from the highlevel design
perspective.

