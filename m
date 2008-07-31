From: Theodore Tso <tytso@mit.edu>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 12:47:28 -0400
Message-ID: <20080731164728.GF11632@mit.edu>
References: <20080731161058.GA20838@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50791 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbYGaQra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 12:47:30 -0400
Content-Disposition: inline
In-Reply-To: <20080731161058.GA20838@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 09:40:59PM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> I haven't yet looked at whether it is kernel or e2fsck bug.
> But I am having this with the latest patch queue when running
> fsstress. The fsstress have falloc added as a supported operation.
> So it is mostly to do with fallocate. Architecture is x86.

Part of this is definitely an e2fsck bug, because e2fsck isn't
currently checking the EXT2_EXTENT_FLAGS_UNINIT flag.  In line 1715 of
e2fsck/pass1.c:

	start_block = pb->last_block = extent.e_lblk + extent.e_len - 1;

We shouldn't be setting pb->last_block if this is an unitialized
extent.

I suspect this is also related though to the issue you raised in the
"e2fsprogs and blocks outside i_size" thread about two weeks ago.  So
even after we fix this e2fsck bug, we may still have some fsstress
failures until we decide how to deal with that particular issue.

Do you have a quickie program that calls fallocate to preallocate
space for a particular program easily to hand?  If not, I can write
one in about 5-10 minutes, but if you have one written already, it'll
save me the effort.  Thanks!!

						- Ted
