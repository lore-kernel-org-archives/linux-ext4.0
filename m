From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Tue, 4 Apr 2017 09:12:47 -0700
Message-ID: <20170404161247.GJ30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
 <20170403191602.GF30811@bombadil.infradead.org>
 <1491250577.2673.20.camel@redhat.com>
 <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
 <1491308268.20445.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37733 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdDDQMv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Apr 2017 12:12:51 -0400
Content-Disposition: inline
In-Reply-To: <1491308268.20445.4.camel@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 04, 2017 at 08:17:48AM -0400, Jeff Layton wrote:
> Agreed that we should focus on POSIX compliance. I'll also note that
> POSIX states:
> 
> "If more than one error occurs in processing a function call, any one
> of the possible errors may be returned, as the order of
> detection is undefined."
> 
>     http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_03
> 
> So, I'd like to push back on this idea that we need to prefer reporting
> -EIO over other errors. POSIX certainly doesn't mandate that. 

I honestly wonder if we need to support ENOSPC from writeback at all.
Looking at our history, the AS_EIO / AS_ENOSPC came from this patch
in 2003:

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=fcad2b42fc2e15a94ba1a1ba8535681a735bfd16

That seems to come from here:
http://lkml.iu.edu/hypermail/linux/kernel/0308.0/0205.html
which is marked as a resend, but I can't find the original.

It's a little misleading because the immediately preceding patch
introduced mapping->error, so there's no precedent here to speak of.
It looks like we used to just silently lose writeback errors (*cough*).

I'd like to suggest that maybe we don't need to support multiple errors
at all.  That all errors, including ENOSPC, get collapsed into EIO.
POSIX already tells us to do that for close() and permits us to do that
for fsync().
