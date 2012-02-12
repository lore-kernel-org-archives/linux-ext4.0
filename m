From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix msync() call in fsx.c:domapwrite()
Date: Sun, 12 Feb 2012 18:48:52 -0500
Message-ID: <20120212234852.GB3848@infradead.org>
References: <1328642166-389-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33088
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755932Ab2BLXsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Feb 2012 18:48:53 -0500
Content-Disposition: inline
In-Reply-To: <1328642166-389-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 07, 2012 at 11:16:06AM -0800, Curt Wohlgemuth wrote:
> This explicitly sends MS_SYNC as the flag to msync() in
> fsx.c, in domapwrite().  Without this flag, the memory
> written to the mmap'ed region will not be flushed to disk;
> in fact, on Linux, calling msync() with a '0' or MS_ASYNC
> flag is a no-op.

Looks sensible to me - what exactly msync did has always been grossly
different for different operating systems, including changing meaning
on Linux a few times, so let's be explicit.

Reviewed-by: Christoph Hellwig <hch@lst.de>
