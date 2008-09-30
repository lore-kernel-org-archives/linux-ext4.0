From: Theodore Tso <tytso@mit.edu>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn
	commit
Date: Tue, 30 Sep 2008 09:02:47 -0400
Message-ID: <20080930130247.GM10831@mit.edu>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com> <20080929205712.GH10831@mit.edu> <48E1AC89.6050803@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44722 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbYI3NCu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 09:02:50 -0400
Content-Disposition: inline
In-Reply-To: <48E1AC89.6050803@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2008 at 08:35:21AM +0400, Alex Tomas wrote:
> why we need a tree? at least for the purpose of keeping blocks unavailable
> we'd need just a list as at commit we free them all.

For ext4, the only reason to use a tree would be to allow us to merge
deleted extents.  This might not be worth the complexity, though, I
admit it.

For ext3, we could use it to replace the the use of
bh->b_committed_data --- in which case, we would need to use a rbtree
so we can quickly look up to see which blocks can't be allocated yet.


>> The other thing which I should check is that if we are using this
>> scheme, I think we shouldn't need to keep the shadow copy of the block
>> bitmap buffers any more.  I would imagine we still need them for the
>> inode bitmaps, for the same reason, though.
>
> shadow copy holds preallocated blocks

Are we talking about the same thing?  I was referring to the
jh->b_committed_data, which isn't used by mballoc at all.

		      	    	       	  	     - Ted
