From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Thu, 14 May 2009 09:14:29 -0400
Message-ID: <20090514131429.GH11352@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu> <20090512044627.GA6753@skywalker> <4A0B17F8.3000402@redhat.com> <20090514054002.GA7359@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47809 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZENNOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 09:14:53 -0400
Content-Disposition: inline
In-Reply-To: <20090514054002.GA7359@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 11:10:02AM +0530, Aneesh Kumar K.V wrote:
> 
> It should only be set in the !create case. With create == 1, we would
> have already converted the uninitialized extent to initialized one and
> the buffer_head should not be unwritten at all.  My understanding is
> unwritten flag is used to indicate the buffer_head state between a
> write_begin and write_page phase with delayed allocation. ie, when we
> write to fallocate space, since we have delalloc enabled, we  just
> do a block lookup (get_block with create = 0). The buffer_head returned
> in the above case should have unwritten set so that during writepage
> we do the actual block allocation (get_block writh create = 1)
> looking at the flag.

At the moment, ext4_da_get_block_prep(), which is used as a callback
function by ext4_da_write_begin(), checks for buffer_unwritten(), and
if true, set BH_New and BH_Mapped.

So between the time that that write_begin() and the time when the page
is actually written out, BH_Unwritten and BH_Mapped will both be set.
If we end up bailing due to some error of some kind, such that we
don't complete the write(2) operation we *can* have some pages that
are simultaneously have BH_Unwritten and BH_Mapped flags set.  So this
had better be a harmless case, since I think it can happen.

What's confusing then is some of the comments which have been made
about why BH_Unwritten and BH_Mapped simultaneously are a bad.  It may
be bad at some points in time, but at other points in time it's
completely normal operations.  Or am I missing something?

	   	  	       	       - Ted
