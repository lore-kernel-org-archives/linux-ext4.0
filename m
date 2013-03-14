From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Thu, 14 Mar 2013 08:56:55 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com>
References: <20130313095640.GC29730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3CNH5o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 03:57:44 -0400
In-Reply-To: <20130313095640.GC29730@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 13 Mar 2013, Jan Kara wrote:

> Date: Wed, 13 Mar 2013 10:56:40 +0100
> From: Jan Kara <jack@suse.cz>
> To: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> Subject: Unwritten extent zeroing beyond i_size
> 
>   Hello Dmitry,
> 
>   I'm tracking down failure in xfstests test 274 (fallocate + ENOSPC
> testing). The problem I found (and that's really unrelated to the question
> I want to ask) is that if write beyond i_size fails, we truncate the file
> to i_size to remove any blocks that may have been allocated under the page
> by the write before it failed (think of blocksize < pagesize config).
> 
> Now in this test the write fails because it needs to split unwritten extent
> and there's no space for that and zeroing out is impossible because we are
> beyond i_size. And here comes my question: You disallowed zeroing of
> extents beyond i_size because fsck complains about those. Won't it be
> better to just add inode flag saying "this inode has blocks preallocated
> beyond i_size" and make fsck not complain about such blocks? IMHO that
> would catch 99% of corruptions as well and would let us solve the problem
> with ENOSPC on writes to preallocated space (plus it would simplify the
> kernel code).
> 
> 								Honza

Unfortunately this will not solve the real issue that writing into
preallocated space should _not_ fail at all, because it is
preallocated.

The problem right now is that we simply do not have block to
allocate metadata, and there is no way for us to reserve metadata
blocks in advance as we might try to do in delalloc.

I've proposed the solution for this in the recent email with subject
"Metadata reservation for unwritten extent conversion". Basically
the idea is to have reserved pool of blocks which could be used for
exactly this (and other) cases. Note that xfs actually have the same
thing for exactly the same reasons.

I'll send the patch implementing this soon.

-Lukas
