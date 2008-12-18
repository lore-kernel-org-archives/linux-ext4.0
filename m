From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
	can be used by file systems
Date: Thu, 18 Dec 2008 14:12:34 +0100
Message-ID: <20081218131222.GB13580@duck.suse.cz>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu> <20081217153940.GA6495@atrey.karlin.mff.cuni.cz> <4949DC6D.3050908@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54519 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762AbYLRNMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 08:12:36 -0500
Content-Disposition: inline
In-Reply-To: <4949DC6D.3050908@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 18-12-08 14:15:25, Toshiyuki Okajima wrote:
> > > > From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> > > >
> > > > Implement blkdev_releasepage() to release the buffer_heads and page
> > > > after we release private data which belongs to a client of the block
> > > > device, such as a filesystem.
> > > >
> > > > blkdev_releasepage() call the client's releasepage() which is
> > > > registered by blkdev_register_client_releasepage() to release its
> > > > private data.
> >   Yes, this is IMO the right fix. I'm just wondering about the fact that we
> > can't block in the client_releasepage(). That seems to be caused by the fact
> > that we need to be protected against client_releasepage() callback changes
> > which essentially means umount, right? I'm not saying I have a better solution
> > but introducing such limitation seems stupid just because of umount...
> >
> Difference between v2 and v3 in blkdev_releasepage:
> <		ret = (*ei->client_releasepage)(ei->client, page, wait);
> <	else
> --
> >		/*
> >		 * Since we are holding a spinlock (ei->client_lock),
> >		 * make sure the client_releasepage function
> >		 * understands that it must not block.
> >		 */
> >		ret = (*ei->client_releasepage)(ei->client, page,
> >						wait & ~__GFP_WAIT);
> >	else
>
> Ask for clarification.
  Yes, my question was more about the original design of the patch than
about the particular fix. Sorry for the confusion.

> Which of the following do you mean:
> 1) If using a spinlock in client_releasepage() is only for mount/umount,
>  this implementation is not wise.
> 2) There is the fact that a spinlock is necessary for blkdev_releasepage().
> This fact prevents us from making various implementations of
> client_releasepage().
> (Without a spinlock, we can implement a client_releasepage() which can release
> the buffers with a sleep. As a result, it may enable more buffers release than
> before.)
>
> There is the fact that a filesystem can be mounted on several places,
> and the lock mechanism is absolutely necessary for this fact.
  This is the thing I was wondering about. Why exactly is the spinlock
necessary for blkdev_releasepage()? I understand we have to protect
reading client_releasepage() pointer because it could change but my point
was that it changes only during mount / umount.

> I also think we are sad that we cannot implement various implementations for
> client_releasepage(). But now I cannot imagine what to do for
> a client_releasepage() which can sleep, too...

							Regards
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
