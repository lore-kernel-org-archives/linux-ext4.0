From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 04:50:57 -0400
Message-ID: <20110826085057.GA13311@infradead.org>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
 <20110826073507.GZ3162@dastard>
 <20110826084403.GA3162@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jiaying Zhang <jiayingz@google.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45796
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab1HZIvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 04:51:00 -0400
Content-Disposition: inline
In-Reply-To: <20110826084403.GA3162@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 06:44:03PM +1000, Dave Chinner wrote:
> While the lockdep report is false positive, I agree that your
> change is the right fix to make - the IO completions are already
> queued on the workqueue, so they don't need to be flushed to get
> them to complete. All that needs to be done is call
> ext4_ioend_wait() for them to complete, and that gets rid of the
> i_mutex altogether. (*)

The really correct fix is to stop using the ioend wait like I did
in my pending series for XFS.  The only thing preventing ext4 from
doing that is that it marks pages uptodate from irq context,
before finishing the ioends.  This has a lot of nasty implications
as the the page might be marked uptodate without actually having
that state on disk.

