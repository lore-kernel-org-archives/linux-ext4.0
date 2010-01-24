From: tytso@mit.edu
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when
 allocating blocks via fallocate
Date: Sun, 24 Jan 2010 13:24:46 -0500
Message-ID: <20100124182445.GA4372@thunk.org>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <4B4F4DB7.1070501@redhat.com>
 <87wrzklesd.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37566 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0AXSry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jan 2010 13:47:54 -0500
Content-Disposition: inline
In-Reply-To: <87wrzklesd.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 12:00:58AM +0530, Aneesh Kumar K. V wrote:
> From 947ca1e49381bd76b85b44a1d41336a105e421ad Mon Sep 17 00:00:00 2001
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: Thu, 7 Jan 2010 00:48:12 +0530
> Subject: [PATCH] ext4: unmap the underlying metadata when allocating blocks via fallocate
> 
> This become important when we are running with nojournal mode. We
> may end up allocating recently freed metablocks for fallocate. We
> want to make sure we unmap the old mapping so that when we convert
> the fallocated uninitialized extent to initialized extent we don't
> have the old mapping around. Leaving the old mapping can cause
> file system corruption
> 
> Now that we unmap old metadata blocks we need not return blocks
> allocated from fallocate area as new.

Is this patch still strictly necessary given commit 515f41c?  This
clears the blocks when we convert the extent from uninitialized to
initialized.   

Hmmm, or is the problem that this fixes the problem only for the
zero'ed out blocks, but we can still get burned on the write path?  
No, we fix that up in mpage_da_map_blocks.

So do we need this patch?  It seems more efficient to clear it when we
actually write or zero out the blocks; I thought that was the
conclusion we came to when we were discussing curtw's patch (515f41c
above).

If we now decide that we need call unmap_underlying_blocks() at
fallocate time, maybe we should revert 515f41c?  No point doing the
work twice; we probably have better uses for the CPU.  :-)

     	       		     	    	     	  - Ted
