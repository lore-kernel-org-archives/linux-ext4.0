From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite
 time
Date: Mon, 2 May 2011 14:12:30 -0700
Message-ID: <20110502141230.4a7640f9.akpm@linux-foundation.org>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
	<1304369816-14545-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab1EBVNB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 17:13:01 -0400
In-Reply-To: <1304369816-14545-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon,  2 May 2011 22:56:56 +0200
Jan Kara <jack@suse.cz> wrote:

> So far, ext3 was allocating necessary blocks for mmapped writes when
> writepage() was called. There are several issues with this. The worst
> being that user is allowed to arbitrarily exceed disk quotas because
> writepage() is called from flusher thread context (which is root) and thus
> quota limits are ignored. Another bad consequence is that data is just lost
> if we find there's no space on the filesystem during ->writepage() time.
> 
> We solve these issues by implementing block reservation in page_mkwrite()
> callback. We don't want to really allocate blocks on page_mkwrite() time
> because for random writes via mmap (as seen for example with applications using
> BerkeleyDB) it results in much more fragmented files and thus much worse
> performance. So we allocate indirect blocks and reserve space for data block in
> page_mkwrite() and do the allocation of data block from writepage().

Yes, instantiating the metadata and accounting the data is a good
approach.  The file layout will be a bit suboptimal, but surely that
will be a minor thing.

But boy, it's a complicated patch!  Are we really sure that we want to
make changes this extensive to our antiquated old fs?  Or do we just
say "yeah, it's broken with quotas - use ext4"?

