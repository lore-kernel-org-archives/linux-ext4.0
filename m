From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ext3: enable cache flush in ext3_sync_file
Date: Tue, 8 Sep 2009 15:10:06 +0200
Message-ID: <20090908131006.GA25208@lst.de>
References: <20090831193712.GB2672@lst.de> <4A9D66C5.4060806@redhat.com> <20090908130438.GA2528@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57426 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZIHNKQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 09:10:16 -0400
Content-Disposition: inline
In-Reply-To: <20090908130438.GA2528@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 03:04:38PM +0200, Jan Kara wrote:
> > Acked-by: Eric Sandeen <sandeen@redhat.com>
>   But would the patch below be better? When we force a transaction
> commit we don't have to flush caches again. Or am I missing something?

If you know that you really did issue a barrier for sure you don't have
to flush the cache again.  I don't know extN enough to easily figure out
how, but if this patch ensures that it's good.  Same scheme should also
apply to ext4.
