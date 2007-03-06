From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Tue, 6 Mar 2007 07:28:50 +0000
Message-ID: <20070306072850.GA23081@infradead.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	nscott@aconex.com, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59495 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbXCFH3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2007 02:29:23 -0500
Content-Disposition: inline
In-Reply-To: <45EC7773.7020603@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 05, 2007 at 12:02:59PM -0800, Mingming Cao wrote:
> Yep, I think it makes sense to use preallocation for defragmentation.
> After all both preallocation and defragmentation shall call underlying 
> filesystem multiple block allocator to try to allocate a chunk of 
> contiguous blocks on disk. ext4 online defrag implementation by Takashi 
> already support to choose a "goal" allocation block to guide the ext4 
> block allocator to place the defraged file is a specific location.
> 
> Passing a little bit more hint to sys_fallocate() (i.e, goal block, 
> and/or whether the goal block is important over the size of prealloc 
> extent), might make it more useful for the orginial goal (get contigous 
> and guranteed blocks) and for defragmentation.

fallocate with the whence argument and flags is already quite complicated,
I'd rather have another call for placement decisions, that would
be called on an fd to do placement decissions for any further allocations
(prealloc, write, etc)
