From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Sat, 5 Apr 2014 07:53:28 +0100
Message-ID: <20140405065328.GU18016@ZenIV.linux.org.uk>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
 <20140404025558.GB2525@thunk.org>
 <20140404061107.GS18016@ZenIV.linux.org.uk>
 <20140405031507.GA18456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42189 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaDEGxa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Apr 2014 02:53:30 -0400
Content-Disposition: inline
In-Reply-To: <20140405031507.GA18456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2014 at 11:15:07PM -0400, Theodore Ts'o wrote:

> Right, but Eric's scneario was talking about unaligned *blocks* not
> *pages*.
> 
> So his scenario was one where the block size was 4k, and the write was
> unaligned with respect to the 4k block size.  For example, if with a
> 4k block size, we had one write starting at offset 0 with a size 512,
> and at the same time another write starting at offset 2048 with a size
> 1024 bytes.  The problem is that we were doing two writes inside the
> same *block*, and so if dio_zero_block() tried to operate on the same
> block at the same time, bad things would happen.
> 
> Does that make sense?

Make the first write take the following iovec array:
	{{good_pointer, 512}, {unmapped_pointer, 4096 - 512}}
and you'll get exact same scenario.   writev() on that iovec is the
same as write(fd, good_pointer, 512).  It certainly should not overwrite
the data at offsets greater than 512.

That's the whole point - it's possible to sneak an equivalent of what
ext4 considers an unaligned write (unaligned wrt fs blocks) past the
check in ext4_unaligned_aio().  You can pad a 512-byte write with
additional iovec segment that will *not* be written (->iov_base points
to something we'd just munmapped), so that the total iovec length looks
good, but passing that to writev()/pwritev()/AIO_PWRITEV will end up
with a short write.
