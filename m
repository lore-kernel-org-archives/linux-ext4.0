From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Tue, 20 May 2008 22:14:06 +0200
Message-ID: <20080520201406.GB2512@kernel.dk>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org> <4832F3C6.1050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:29467 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbYETUOO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 16:14:14 -0400
Content-Disposition: inline
In-Reply-To: <4832F3C6.1050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20 2008, Eric Sandeen wrote:
> Jamie Lokier wrote:
> > Theodore Tso wrote:
> >> On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
> >>> To ensure that bits are truly on-disk after an fsync,
> >>> we should call blkdev_issue_flush if barriers are supported.
> >> This patch isn't necessary, and in fact will cause a double flush.
> >> When you call fsync(), it calls ext4_force_commit(), and we do a the
> >> equivalent of a blkdev_issue_flush() today (which is what happenes
> >> when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
> >> set_ordered_mode(bh) ends up causing.
> > 
> > ISTR fsync() on ext3 did not always force a commit, if in-place data
> > writes did not change any metadata.
> 
> I think that might still be true, but I'm still looking through it (in
> the background...)
> 
> I tried blktrace to see what was going on but I'm not sure what an "NB"
> in the RWBS field means, anyone know?

Eric already knows this now, but for the benefit of anyone else that may
be curious - it's an empty (data-less) barrier. 'N' is basically 'no
data' (eg not a read nor a write) and 'B' is barrier.

-- 
Jens Axboe

