From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: More thoughts about xattrs, journal credits, and their location
Date: Mon, 10 Jul 2017 11:32:59 -0400
Message-ID: <20170710153259.ayeqsl7aacujr76c@thunk.org>
References: <20170706023819.32272-1-tahsin@google.com>
 <20170706023819.32272-2-tahsin@google.com>
 <20170708050900.afuwwia7c4izliir@thunk.org>
 <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
 <CAAeU0aMZjeX6utQfAPa131mhTPK27W4BtWodXYLPT3pss7Tp-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35352 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754369AbdGJPdD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Jul 2017 11:33:03 -0400
Content-Disposition: inline
In-Reply-To: <CAAeU0aMZjeX6utQfAPa131mhTPK27W4BtWodXYLPT3pss7Tp-w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 09, 2017 at 01:01:00PM -0700, Tahsin Erdogan wrote:
> > What we could do is have ext4_new_inode check to see if there are
> > enough credits to do add the xattr's (if necessary) in a single
> > commit.  If not, what we could do is to add the inode to the orphan
> > list, and then set an inode state flag indicating we have done this.
> > At this point, we *can* break the ext4_new_inode() operation into
> > multiple commits, because if we crash in the middle the inode will be
> > cleaned up when we do the orphan list processing.
> 
> This makes sense. Also, we currently add the worst case credit
> estimates of individual set xattr ops and start a journal handle with
> the sum of it. A slight optimization is to do this lazily.
> We can start with enough credits that can get us to a point where it
> is safe to start a new transaction (safe because of orphan addition).

I still am very concerned about the code complexity that this approach
requires.  I am also very concerned about the CPU scalability
bottleneck that adding and removing the inode from the orphan list
would entail.

And if we have to wait for the new commit to start so that we can
start a new handle, that's also a CPU scalability bottleneck and is
guaranteed to add significant latency.

One of the nice things about the xattr priority proposal is that it
would guarantee that the security xattrs would never be in an
ea_inode.  (Since in the inode creation case, the only thing they
would be competing with is the acl's, which are lower priority).  So
this reduces the chances of needing to do a lazy extend/restart in the
first place.

> > The downsides of this approach is that it causes the orphan list to be
> > a bottleneck.  So we would definitely not want to do this all time.
> 
> Yes and I think lazy extend/restart should mitigate this.

It mitigates it so long as we the lazy extent/restart is never/rarely
*used*, since that's when we would incur the orphan list overhead.

One other bit about the lazy extend/restart idea is that we need to
make sure that there are enough credits left for the callers of
ext4_new_inode() before it returns.  Otherwise the complexity of this
approach would infect all of the users of this interface (since they
would have to potentially do the extend/restart of the transaction).

						- Ted
