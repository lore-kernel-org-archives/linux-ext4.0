From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 2/4] ext4: Add generic writepage callback
Date: Thu, 4 Jun 2009 08:05:30 -0400
Message-ID: <20090604120530.GD21314@mit.edu>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33696 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947AbZFDMFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 08:05:41 -0400
Content-Disposition: inline
In-Reply-To: <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2009 at 11:40:03AM +0530, Aneesh Kumar K.V wrote:
> Even with changes to make pages writeprotect on truncate/i_size update we
> can still see buffer_heads which are not mapped in the writepage
> callback.

Which changes were you referring to here?  Do you mean Jan's patch
page_mkwrite()'s changes, or something else?


Also it seems like:

ext4: Merge ext4_{journalled,normal,da}_writepage() into ext4_writepage()

might be a better patch title, do you agree?

> 1) truncate(f, 1024)
> 2) mmap(f, 0, 4096)
> 3) a[0] = 'a'
> 4) truncate(f, 4096)
> 5) writepage(...)
> 
> Now if we get a writepage callback immediately after (4) and before an
> attempt to write at any other offset via mmap address (which implies we
> are yet to get a pagefault and do a get_block) what we would have is the
> page which is dirty have first block allocated and the other three
> buffer_heads unmapped.

The first two paragraps of this description are the same as the
previous patch; so really what's happening here is this fixes the same
issue as the previous patch, but for the the case where delayed
allocation is not enabled, is that correct?

						- Ted
