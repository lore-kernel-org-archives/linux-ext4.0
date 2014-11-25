From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix potential use after free issue while
 fsresize
Date: Tue, 25 Nov 2014 13:27:22 -0500
Message-ID: <20141125182722.GE11648@thunk.org>
References: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
 <1415958040-4393-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaKYS13 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 13:27:29 -0500
Content-Disposition: inline
In-Reply-To: <1415958040-4393-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 01:40:40PM +0400, Dmitry Monakhov wrote:
> We need some sort of synchronization while updating ->s_group_desc because there
> are a lot of users which can access old ->s_group_desc array after it was released.
> It is reasonable to use lightweight seqcount_t here instead of RCU.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I'm curious --- under what circumstances did you manage to hit this,
or was this something that you noticed?

> +	do {
> +		seq = read_seqcount_begin(&sbi->s_group_desc_seq);
> +		gd_bh = sbi->s_group_desc[group_desc];
> +	} while (unlikely(read_seqcount_retry(&sbi->s_group_desc_seq, seq)));

The problem is that s_group_desc is allocated using ext4_kvmalloc(),
which means it's possible that it was allocated using vmalloc().
Which means that it is possible (although unlikely) that the old
s_group_desc address could become invalidated after the call to
ext4_kvfree(o_group_desc).

This will only happen on 32-bit platforms if we get unlucky and the
kmap region gets recycled right after the vfree(); but we would only
see the bug in practice if the memory gets kfree'ed gets reused
immeidately afterwards, and we've been living with this with ext3 for
a long time.  Don't get me wrong; I'm not saying we should ignore this
bug, since I certainly agree with you that it is truly a bug.  But if
we are going to fix it, we should probably fix it all the way, which I
suspect means we may have to use RCU here.

OTOH, if you are hitting this in live production workloads, then we
can do the partial fix now, and then fix it all the way up later.  Is
the RCU mechanism really going to be that ugly?  It's not like we are
resizing all the time, so we don't need to worry about it being
heavyweight from a performance point of view, no?

	    	   	       	     	- Ted
