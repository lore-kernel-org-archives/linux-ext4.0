From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add ext2fs_extent_open2
Date: Thu, 28 May 2009 10:39:30 -0400
Message-ID: <20090528143930.GR26625@mit.edu>
References: <464818.77761.qm@web43508.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48964 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZE1Ojm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 10:39:42 -0400
Content-Disposition: inline
In-Reply-To: <464818.77761.qm@web43508.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2009 at 01:45:33PM -0700, number9652 wrote:
> 
> --- On Tue, 5/19/09, Theodore Tso wrote:
> > Thanks, this patch looks good.  Can I get a
> > "Signed-off-by:" from you?
> 
> I felt like I was forgetting something, just couldn't figure out what.  I included a copy of the patch to make sure it is clear.
> 
> Signed-off-by: Nic Case <number9652@yahoo.com>

Thanks, applied.

BTW, I did some quick tests, and the optimization makes a small (but
measurable) difference for both the total time elapsed and userspace
CPU times.

					- Ted
