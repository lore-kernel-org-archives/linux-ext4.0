From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sat, 17 May 2008 16:44:37 -0400
Message-ID: <20080517204437.GB16496@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <20080517134344.GA7411@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51760 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758100AbYEQUox (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 16:44:53 -0400
Content-Disposition: inline
In-Reply-To: <20080517134344.GA7411@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 17, 2008 at 09:43:44AM -0400, Theodore Tso wrote:
> Another question is whether we can do better in our implementation of
> a barrier, and the way the jbd layer uses barriers.  The way we do it
> in the jbd layer is actually pretty bad:
> 
> This means that while we are waiting for commit record to be written
> out, any other writes that are happening via buffer heads (which
> includes directory operations) are getting done with strict ordering.
> All set_buffer_ordered() does is change make the submit_bh() done in
> sync_dirty_buffer() actually be submitted with WRITE_BARRIER instead
> of WRITE.  

Never mind, I was confused when I wrote this; I somehow thought we
were setting ordered mode on a per queue basis, instead of on a
per-buffer-head basis.

Also, looking more closely on the jbd2 implementation, it looks like
using the async_commit option, which relies on the checksum for more
efficient commit, completely disables any barrier support.  That's
because the only place we go into ordered more is if we are writing a
synchronous journal commit.  If async journal commit is enabled, then
we don't write a barrier at all, which leaves us in potential trouble
with if data blocks end up getting reordered with respect to the
journal commit in data=ordered more.

I *think* what we need to do is to issue an empty barrier request
between the data blocks and the journal writes in data=ordered mode,
and still issue a WRITE_BARRIER request when writing the commit block,
but to not actually wait for the write to complete.  I think if we do
that, we should be safe, and hopefully by not waiting for the commit
block to complete, the performance hit shouldn't be as bad as
previously reported.

						- Ted
