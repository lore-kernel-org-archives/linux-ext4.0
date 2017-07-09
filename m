From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: More thoughts about xattrs, journal credits, and their location
Date: Sun, 9 Jul 2017 13:01:00 -0700
Message-ID: <CAAeU0aMZjeX6utQfAPa131mhTPK27W4BtWodXYLPT3pss7Tp-w@mail.gmail.com>
References: <20170706023819.32272-1-tahsin@google.com> <20170706023819.32272-2-tahsin@google.com>
 <20170708050900.afuwwia7c4izliir@thunk.org> <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:35539 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752539AbdGIUBC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Jul 2017 16:01:02 -0400
Received: by mail-yb0-f174.google.com with SMTP id p207so22655874yba.2
        for <linux-ext4@vger.kernel.org>; Sun, 09 Jul 2017 13:01:02 -0700 (PDT)
In-Reply-To: <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> What we could do is have ext4_new_inode check to see if there are
> enough credits to do add the xattr's (if necessary) in a single
> commit.  If not, what we could do is to add the inode to the orphan
> list, and then set an inode state flag indicating we have done this.
> At this point, we *can* break the ext4_new_inode() operation into
> multiple commits, because if we crash in the middle the inode will be
> cleaned up when we do the orphan list processing.

This makes sense. Also, we currently add the worst case credit
estimates of individual set xattr ops and start a journal handle with
the sum of it. A slight optimization is to do this lazily.
We can start with enough credits that can get us to a point where it
is safe to start a new transaction (safe because of orphan addition).
Then opportunistically extend the credits to get us to the next safe
point, if that doesn't work, do the orphan add operation and start a
new transaction. This should handle the worst case scenario and also
optimize for common case. Also this should in general reduce the
amount of allocated-but-unused credits which helps parallelism.

> The downsides of this approach is that it causes the orphan list to be
> a bottleneck.  So we would definitely not want to do this all time.

Yes and I think lazy extend/restart should mitigate this.
