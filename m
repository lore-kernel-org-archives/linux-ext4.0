From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] mark several more functions in mballoc.c as noinline
Date: Sun, 5 Jul 2009 22:23:29 -0400
Message-ID: <20090706022329.GC6706@mit.edu>
References: <4A425E57.3090109@redhat.com> <4A43AF60.70200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57663 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZGFCXa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 22:23:30 -0400
Content-Disposition: inline
In-Reply-To: <4A43AF60.70200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2009 at 12:09:52PM -0500, Eric Sandeen wrote:
> Ted noticed a stack-deep callchain through
> writepages->ext4_mb_regular_allocator->ext4_mb_init_cache->submit_bh ...

Thanks, added to the ext4 patch queue.

						- Ted
