From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Wed, 22 Jun 2011 10:22:35 -0400
Message-ID: <20110622142235.GN32133@thunk.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110621235425.GA24067@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hirofumi@mail.parknet.co.jp, mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36072 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab1FVOXA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2011 10:23:00 -0400
Content-Disposition: inline
In-Reply-To: <20110621235425.GA24067@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 22, 2011 at 01:54:25AM +0200, Jan Kara wrote:
> ext4_page_mkwrite()... Ted, what happened to that patch. Should I resend
> it?

So assuming I fix the refcounting issue in fs/ext4/page_io.c (which I
will do not dropping the page's refcount until after the workqueue
finishes its job), does your patch need changing, or is it a matter of
fixing the commit description?

In any case, this dragged got out, and it's late in -rc cycle for 3.0,
so I was planning on queuing this for the next merge window.  (Sorry
for that, this was mostly due to my not having enough time to really
dive into the issues involved.)

							- Ted
