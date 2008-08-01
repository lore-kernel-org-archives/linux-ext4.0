From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Thu, 31 Jul 2008 23:08:25 -0400
Message-ID: <20080801030825.GD8736@mit.edu>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55883 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890AbYHADIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 23:08:42 -0400
Content-Disposition: inline
In-Reply-To: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:03:25PM +0530, Aneesh Kumar K.V wrote:
> With the below changes we reserve credit needed to insert only one extent
> resulting from a call to single get_block. That make sure we don't take
> too much journal credits during writeout. We also don't limit the pages
> to write. That means we loop through the dirty pages building largest
> possible contiguous block request. Then we issue a single get_block request.
> We may get less block that we requested. If so we would end up not mapping
> some of the buffer_heads. That means those buffer_heads are still marked delay.
> Later in the writepage callback via __mpage_writepage we redirty those pages.

If you're only redirtying the pages in the callback, that means they
are left clean but with the delayed flag set; is that going to be
enough to keep the mm from dropping the pages because they are clean?
Or is the mechanism which prevents this is that you've kept the
refcount on the pages bumped until after the callback?

	    	      	     	   	     - Ted
