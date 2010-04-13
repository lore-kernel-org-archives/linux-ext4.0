From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Ping.
Date: Tue, 13 Apr 2010 14:14:50 -0400
Message-ID: <20100413181450.GA5720@infradead.org>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org> <87ljd1vtth.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, adilger@sun.com, hch@infradead.org, jack@suse.cz,
	david@fromorbit.com, viro@ZenIV.linux.org.uk, xemul@openvz.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab0DMSOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 14:14:50 -0400
Content-Disposition: inline
In-Reply-To: <87ljd1vtth.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 06, 2010 at 01:00:58PM +0400, Dmitry Monakhov wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > This is 6'th version of extened inode owner patch-set.
> > Please review it tell me what do you think about all this.
> >  Are you agree with this approach?
> >  Are you worry about some implementation details?
> >  Is it ready for merge to some devel's tree?
> Ping. I haven't got response about the patchset, just small note about
> xattr-name from Andreas.
> Please clarify what do you think about whole idea and
> current patch-set state. What do i have to do to make a progress?

As long as you still have the awkward ifdefs and different semantics for
"isolation" vs "not"  there's still a NACK from me.  But in the end Al
will have to decide if he wants to take your patches or not.

