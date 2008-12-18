From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
	can be used by file systems
Date: Thu, 18 Dec 2008 17:38:22 +0100
Message-ID: <20081218163822.GD13580@duck.suse.cz>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu> <20081217153940.GA6495@atrey.karlin.mff.cuni.cz> <4949DC6D.3050908@jp.fujitsu.com> <20081218131222.GB13580@duck.suse.cz> <20081218145359.GD9871@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37952 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751672AbYLRQiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 11:38:24 -0500
Content-Disposition: inline
In-Reply-To: <20081218145359.GD9871@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-12-08 09:54:00, Theodore Tso wrote:
> On Thu, Dec 18, 2008 at 02:12:34PM +0100, Jan Kara wrote:
> >   This is the thing I was wondering about. Why exactly is the spinlock
> > necessary for blkdev_releasepage()? I understand we have to protect
> > reading client_releasepage() pointer because it could change but my point
> > was that it changes only during mount / umount.
> 
> Hmm.... I suppose we could use RCU, but then we'd have to worry about
> the race condition where client_releasepage() gets called after the
> umount has happened.
  Yes. Actually, I'm not so much against spinlock for obtaining the
function pointer but you needn't hold it when you actually call the
function. Except that you have to care about those umount races, I agree.

> > > I also think we are sad that we cannot implement various
> > > implementations for client_releasepage(). But now I cannot imagine
> > > what to do for a client_releasepage() which can sleep, too...
> 
> My suggestion is that we not worry about making changes to
> fs/block_dev.c to allow client_releasepage() to sleep until we have
> filesystems that really need client_releasepage() to sleep.  It
> probably is possible, with appropriate atomic bit sets for flags to
> indicate an unmount in progress, and client_releasepage in progress,
> and use of RCU, we could allow client_releasepage.  But it might not
> be worth it unless there is a filesystem that really needs it.
  OK. Actually, there is a possibility when ext3/4 might want wait - if
someone does direct IO on the block device, it might fail with EIO because
the page is pinned by JBD and we have to wait for it. But OTOH doing dio
on a block device with a mounted filesystem is *really* a stupid thing to do
so I agree we don't care.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
