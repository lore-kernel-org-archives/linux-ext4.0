From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Bug in extent zeroout: blocks not marked as new
Date: Mon, 23 Nov 2009 13:17:23 -0800
Message-ID: <1259011043.25937.29.camel@bobble.smo.corp.google.com>
References: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
	 <20091123195049.GD2183@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:23318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZKWVR1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 16:17:27 -0500
In-Reply-To: <20091123195049.GD2183@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-11-23 at 14:50 -0500, tytso@mit.edu wrote:
> However, that doesn't explaining the corruption which you are seeing,
> which is zero blocks showing up where they shouldn't --- since the
> freed dirty metadata blocks that we would be zapping with
> unmap_underlying_metadata() are highly unlikely to be all zero's.
> 
> Am I missing something?

I think the missing bit of information here is that this is happening on
converted ext2 partitions.  Older non-extent-based files are being
gradually removed while new extent-based files are being created.  Last
week, Curt found that in certain cases newly-reallocated metadata blocks
are being hit; these metadata blocks just happen to be newly-emptied
indirect blocks (freed by a recent delete), which just happen to have
been filled with zeroes as they were emptied.  As I recall, Curt found
that these were pretty clearly the source of the blocks being written in
this case.

To elaborate (per Curt), we're seeing these dirty metadata writes from
freed indirect-block inodes because ext4_free_branches() calls
ext4_handle_dirty_metadata() on an indirect block after freeing (some or
all of) its data blocks.  We do the same thing in ext3_free_branches()
but ext2_free_branches() DOES NOT mark the metadata block as dirty, so
there will be a lot more dirty metadata floating about in ext[34] than
in ext2 and hence a lot more chance for the race we've been seeing.

Finally, we have a question about the zero-out path:  Is there any
known, concrete improvement given by doing the zero-out as opposed to
just continuing to split the extents?  At the moment, by the way, there
is one definite problem: Since it doesn't try to do a merge left (which
it should) it invariably leaves a 14-block extent fragment, thus
increasing fragmentation of the file.  It's not a huge problem (since
the extents are in fact contiguous) but it's there.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

