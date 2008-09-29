From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 10:13:26 -0400
Message-ID: <20080929141326.GA31781@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYI2ONk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 10:13:40 -0400
Content-Disposition: inline
In-Reply-To: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
> I think that your concern is that the freezer cannot recognize the occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.

What timeout should happen?  the freeze ioctl must not return until the
filesystem is a clean state and all writes are blocked.

