From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] ext3: Fix possible deadlock between ext3_truncate()
 and ext3_get_blocks()
Date: Fri, 14 Aug 2009 16:41:05 -0700
Message-ID: <20090814164105.9923f8f8.akpm@linux-foundation.org>
References: <1250252772-13302-1-git-send-email-jack@suse.cz>
	<1250252772-13302-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbZHNXlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2009 19:41:37 -0400
In-Reply-To: <1250252772-13302-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 14 Aug 2009 14:26:10 +0200
Jan Kara <jack@suse.cz> wrote:

> During truncate we are sometimes forced to start a new transaction as the
> amount of blocks to be journaled is both quite large and hard to predict. So
> far we restarted a transaction while holding truncate_mutex and that violates
> lock ordering because truncate_mutex ranks below transaction start (and it
> can lead to a real deadlock with ext3_get_blocks() allocating new blocks
> from ext3_writepage()).
> 
> Luckily, the problem is easy to fix: We just drop the truncate_mutex before
> restarting the transaction and acquire it afterwards. We are safe to do this as
> by the time ext3_truncate() is called, all the page cache for the truncated
> part of the file is dropped and so writepage() cannot come and allocate new
> blocks in the part of the file we are truncating. The rest of writers is
> stopped by us holding i_mutex.

For ext2 we have the comment:

	/*
	 * truncate_mutex is for serialising ext2_truncate() against
	 * ext2_getblock().  It also protects the internals of the inode's
	 * reservation data structures: ext2_reserve_window and
	 * ext2_reserve_window_node.
	 */

does truncate_mutex also protect ext3's reservation data?  If so, is
that impacted by this patch?

