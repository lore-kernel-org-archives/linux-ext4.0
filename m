From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 leaking buffer_heads
Date: Tue, 24 Mar 2009 20:46:09 -0400
Message-ID: <20090325004609.GF32307@mit.edu>
References: <49C7E959.4010000@cs.utexas.edu> <49C80685.9060800@redhat.com> <49C961FE.1030704@cs.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Don Porter <porterde@cs.utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33883 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759604AbZCYAqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2009 20:46:24 -0400
Content-Disposition: inline
In-Reply-To: <49C961FE.1030704@cs.utexas.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 24, 2009 at 05:43:10PM -0500, Don Porter wrote:
> Thanks for the tip, Eric.
>
> I spent some time tracing through this in a debugger.
>
> I believe the lingering buffer_heads are allocated by  
> journal_write_commit_record()->journal_get_descriptor_buffer()->__getblk(). 
>  The reference count ends up at zero, but the buffer head is never freed.
>
> As best I can tell, this is correct as long as the associated page is  
> cached, so that the associated buffer_head can be looked up and reused  
> later.
>
> I plan to look into this more, but perhaps the issue is just that the  
> kernel should be more aggressive about freeing cached journal pages?   
> They are highly unlikely to be used again once a committed transaction  
> is completely out on disk, as the journal is roughly an append-only log,  
> right?

The journal is a fixed sized, circular log, so the buffer_head will be
reused eventually.  In the case of memory pressure the unreferenced
buffer_head will be freed, but since we never reference the contents
of the journal, we could be more aggressive about freeing the
buffer_head just to avoid pushing out more valuable memory contents
when we start getting put under memory pressure.

					- Ted
