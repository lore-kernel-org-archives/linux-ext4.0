From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Thu, 31 Jul 2014 09:03:32 -0400
Message-ID: <20140731130332.GB1566@thunk.org>
References: <20140707211349.GA12478@kvack.org>
 <20140708001655.GI8254@thunk.org>
 <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca>
 <20140730144928.GA10295@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38278 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaGaNDj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 09:03:39 -0400
Content-Disposition: inline
In-Reply-To: <20140730144928.GA10295@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 30, 2014 at 10:49:28AM -0400, Benjamin LaHaise wrote:
> This seems like a pretty serious regression relative to ext3.  Why can't 
> ext4's mballoc pick better block groups to attempt allocating from based 
> on the free block counts in the block group summaries?

Allocation algorithms are *always* tradeoffs.  So I don't think
regression is necessarily the best way to think about things.
Unfortuntaely, your use case really doesn't work well with how we have
set things up with ext4 now.  Sure, if you your specific use case is
one where you are mostly allocating 8MB files, then we can add a
special case where if you are allocating 32768 blocks, we should
search for block groups that have 32768 blocks free.  And if that's
what you are asking for, we can certainly do that.

The problem is that free block counts don't work well in general.  If
I see that the free block count is 2048 blocks, that doesn't tell me
the free blocks are in a contiguous single chunk of 2048 blocks, or
2048 single block items.  (We do actually pay attention to free
blocks, by the way, but it's in a nuanced way.)

If the only goal you have is fast block allocation after fail over,
you can always use the VFAT block allocation --- i.e., use the first
free block in the file system.  Unfortunately, it will result in a
very badly fragmented file system, as Microsoft and its users
discovered.

I'm sure that are things we could do that would make things better for
your workload (if you want to tell us in great detail exactly what the
file/block allocation patterns are for your workload), and perhaps
even better in general, but the challenge is making sure we don't
regress for other workloads --- and this includes long-term
fragmentation resistance.  This is a hard problem.  Kvetching about
how it's so horrible just for you isn't really helpful for solving it.

(BTW, one of the problems is that ext4_mb_normalize_request caps large
allocations so that we use the same goal length for multiple passes as
we search for good block groups.  We might want to use the original
goal length --- so long as it is less than 32768 blocks --- for the
first scan, or at least for goal lengths which are powers of two.  So
if your application is regularly allocating files which are exactly
8MB, there are probably some optimizations that we could apply.  But
if they aren't exactly 8MB, life gets a bit trickier.)

Regards,

						- Ted
