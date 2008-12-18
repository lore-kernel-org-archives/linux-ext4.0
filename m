From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
	can be used by file systems
Date: Thu, 18 Dec 2008 09:54:00 -0500
Message-ID: <20081218145359.GD9871@mit.edu>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu> <20081217153940.GA6495@atrey.karlin.mff.cuni.cz> <4949DC6D.3050908@jp.fujitsu.com> <20081218131222.GB13580@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43537 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115AbYLROyI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 09:54:08 -0500
Content-Disposition: inline
In-Reply-To: <20081218131222.GB13580@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 18, 2008 at 02:12:34PM +0100, Jan Kara wrote:
>   This is the thing I was wondering about. Why exactly is the spinlock
> necessary for blkdev_releasepage()? I understand we have to protect
> reading client_releasepage() pointer because it could change but my point
> was that it changes only during mount / umount.

Hmm.... I suppose we could use RCU, but then we'd have to worry about
the race condition where client_releasepage() gets called after the
umount has happened.

> > I also think we are sad that we cannot implement various
> > implementations for client_releasepage(). But now I cannot imagine
> > what to do for a client_releasepage() which can sleep, too...

My suggestion is that we not worry about making changes to
fs/block_dev.c to allow client_releasepage() to sleep until we have
filesystems that really need client_releasepage() to sleep.  It
probably is possible, with appropriate atomic bit sets for flags to
indicate an unmount in progress, and client_releasepage in progress,
and use of RCU, we could allow client_releasepage.  But it might not
be worth it unless there is a filesystem that really needs it.

   	    	   	      		      	  - Ted


