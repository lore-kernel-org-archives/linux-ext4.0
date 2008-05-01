From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] ext3: move headers out of include/linux
Date: Thu, 1 May 2008 17:30:32 +0200
Message-ID: <20080501153032.GA10754@lst.de>
References: <E1JrZxd-0004c8-7E@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	olaf@aepfle.de
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36279 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYEAPbH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 May 2008 11:31:07 -0400
Content-Disposition: inline
In-Reply-To: <E1JrZxd-0004c8-7E@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2008 at 10:40:37AM -0400, Theodore Ts'o wrote:
> Secondly, Christoph, was there a reason why you didn't unpublish
> ext2_fs.h when you unpublished ext3_fs.h?  Are there a significant
> number of userspace prorams using it?  I don't care, because e2fsprogs
> doesn't use it, and as far as I'm concerned I'd much rather encourage
> people to use ext2fs/ext2_fs.h from e2fsprogs instead.  And this would
> allow us to do a similar patch for fs/ext2; but assume you had found
> some significant number of applications that would break if we
> unexported and moved linux/ext2_fs.h?

ext2_fs.h has been there for much longer, and unlike ext3_fs.h it
actually is useable by userpsace.  Of course everyone should be using
the headers from e2fsprogs by now, but I'm not sure if that's really the
case.

In past cases like that Olaf did greps over the whole OpenSuSE tree,
so maybe he could do it for this aswell?

