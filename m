From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Add no_nrwrite_update and no_index_update
	writeback control flags
Date: Tue, 14 Oct 2008 09:22:39 -0400
Message-ID: <20081014132239.GA13960@infradead.org>
References: <1223966008-6656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223966008-6656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223966008-6656-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223966008-6656-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223966008-6656-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYJNNW5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 09:22:57 -0400
Content-Disposition: inline
In-Reply-To: <1223966008-6656-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2008 at 12:03:26PM +0530, Aneesh Kumar K.V wrote:
> If no_nrwrite_update is set we don't update nr_to_write in
> write_cache_pages. Similarly if no_index_update is we don't
> update address space writeback_index. These changes enable a
> file system to skip these updates in write_cache_pages and do
> them in the writepages() callback. This patch will be followed
> by an ext4 patch that make use of these new flags.

I looked over this and discussed it a little with Ted and it looks good
to me.

> +	/* write_cache_pages() control */
> +	unsigned no_nrwrite_update:1;	/* don't update nr_to_write */
> +	unsigned no_index_update:1;	/* don't update writeback_index */

But thinking about it I suspect we don't want to different flags for
this, but just one.   This is done because the writepage callback may
write back more pages than the one requested, nad becase of that both
indices don't need to be updated.  Adding this rational to the flag
description might also be rally helpful.

> +	if (!wbc->no_index_update &&
> +		(wbc->range_cyclic || (range_whole && nr_to_write > 0))) {

Might be a little too nitpicky, but can you follow normal indentation?
Shouldn't matter anyway if the two flags are merged into one and this is
split into two nested if conditions.

