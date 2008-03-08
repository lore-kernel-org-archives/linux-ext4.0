From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if
	block
Date: Sat, 8 Mar 2008 10:02:29 -0500
Message-ID: <20080308150229.GA22430@infradead.org>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com> <20080307212336.GE1881@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYCHPCb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 10:02:31 -0500
Content-Disposition: inline
In-Reply-To: <20080307212336.GE1881@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 02:23:36PM -0700, Andreas Dilger wrote:
> It would probably be prudent to verify that these caches are initialized
> at journal_load() time and either re-try to create the cache, and/or report
> an error in that case and refuse to continue mounting.

That doesn't make any sense.  They're initialized in module_init and
destoryed in module_exit.  They can never be zero at journal_load time
unless you get random memory corruption overwriting exactly that pointer
with zero.

