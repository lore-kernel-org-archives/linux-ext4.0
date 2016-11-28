From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/5] mbcache: correctly handle 'e_referenced' bit
Date: Mon, 28 Nov 2016 09:32:43 -0800
Message-ID: <20161128173243.GA137838@google.com>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <20161128104420.GF2590@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34303 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbcK1Rcr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2016 12:32:47 -0500
Received: by mail-pg0-f54.google.com with SMTP id x23so59103641pgx.1
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2016 09:32:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161128104420.GF2590@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2016 at 11:44:20AM +0100, Jan Kara wrote:
> On Sat 26-11-16 22:17:57, Eric Biggers wrote:
> > mbcache entries have an 'e_referenced' bit which users can set with
> > mb_cache_entry_touch() to indicate that an entry should be given another
> > pass through the LRU list before the shrinker can delete it.  However,
> > mb_cache_shrink() actually would, when seeing an e_referenced entry at
> > the front of the list (the least-recently used end), place it right at
> > the front of the list again.  The next iteration would then remove the
> > entry from the list and delete it.  Consequently, e_referenced had
> > essentially no effect, so ext2/ext4 xattr blocks would sometimes not be
> > reused as often as expected.
> > 
> > Fix this by making the shrinker move e_referenced entries to the back of
> > the list rather than the front.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Bah, good spotting. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW, how did you find out?
> 

Nothing special --- I just happened to notice while reading over the code.

Eric
